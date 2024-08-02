import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:marrimate/Screens/Competition/start_quiz_screen.dart';
import 'package:marrimate/Screens/Dashboard/Chat/video_call_screen.dart';
import 'package:marrimate/Screens/Dashboard/Chat/voice_call_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/call_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer/audioplayer.dart';
//import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import '../../../models/chat_model.dart';
import '../../../models/partner_model.dart';
import '../../../services/api.dart';
import '../../../services/notifications.dart';
import '../Dashboard/user_profile_screen.dart';
import 'gallery_upload_screen.dart';


class ChattingScreen extends StatefulWidget {
  UserModel partner;
  bool shareQuiz;
  int quizID;

  ChattingScreen({Key key, this.partner, this.shareQuiz=false, this.quizID}) : super(key: key);

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {

  ScrollController _scrollController;
  TextEditingController _messageController = TextEditingController();
  List<ChatModel> allMessages = [];
  List<bool> voiceNoteLoading = [];
  List<bool> voiceNotePlaying = [];
  int activeNoteIndex = -1;
  //List<bool> sendingMessage = [];
  //List<bool> sendingFailed = [];
  DateFormat chatTimeFormatter = DateFormat("hh:mm");
  bool isLoading = true;
  bool isMessageSending = false;
  bool isRecording = false;
  bool isLoadingCall = false;
  //bool showingSticker = true;

  Timer _timer;
  Timer _voiceNoteTimer;

  final interval = const Duration(seconds: 5);
  final voiceNoteInterval = const Duration(seconds: 1);
  final record = Record();

  int timerMaxSeconds = 120;
  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';


  Duration duration;
  Duration position;
  AudioPlayer audioPlayer;
  String localFilePath;
  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;
  get durationText =>
      duration != null ? duration.toString().split('.').first : '';
  get positionText =>
      position != null ? position.toString().split('.').first : '';
  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  Future play(String url, int index) async {
    await audioPlayer.play(url);
    setState(() {
      playerState = PlayerState.playing;
    });
  }
  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }
  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }
  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }
  void onComplete() {
    setState(() {
      voiceNotePlaying[activeNoteIndex] = false;
    });
    setState(() => playerState = PlayerState.stopped);
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
          if (s == AudioPlayerState.PLAYING) {
            print(audioPlayer.duration.toString());
            setState(() => duration = audioPlayer.duration);
          } else if (s == AudioPlayerState.STOPPED) {
            onComplete();
            setState(() {
              position = duration;
            });
          }
        }, onError: (msg) {
          setState(() {
            playerState = PlayerState.stopped;
            duration = Duration(seconds: 0);
            position = Duration(seconds: 0);
          });
        });
  }

  startVoiceNoteTimer([int milliseconds]) {
    currentSeconds = 0;
    timerMaxSeconds = 120;
    var duration = voiceNoteInterval;
    _voiceNoteTimer = Timer.periodic(duration, (timer) {
      if(mounted){
        setState(() {
          currentSeconds = timer.tick;
          if (timer.tick >= timerMaxSeconds){
            timer.cancel();
          }
        });
      }
    });
  }

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }
  setLoadingRecording(bool loading){
    setState(() {
      isRecording = loading;
    });
  }
  setMessageSending(bool loading){
    setState(() {
      isMessageSending = loading;
    });
  }
  setLoadingCall(bool loading){
    setState(() {
      isLoadingCall = loading;
    });
  }

  startTimer([int milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      if(mounted){
        updateChat();
      }
    });
  }

  updateChat()async{
    print("update");
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getAllMessages(widget.partner.id, userDetails.accessToken);
    if(response != null){
      List<ChatModel> newMessages = [];
      if(response['status']){
        for(var item in response['data']){
          newMessages.add(ChatModel.fromJson(item));
        }
        for(var item in newMessages){
          bool add = false;
          for(var item2 in allMessages){
            if(item2.id == item.id){
              add = false;
              break;
            }else{
              add = true;
            }
          }
          if(allMessages.isEmpty){
            add = true;
          }
          if(add){
            seeAllMessages();
            setState(() {
              allMessages.add(item);
              voiceNoteLoading.add(false);
              voiceNotePlaying.add(false);
            });
            scrollToBottom();
          }
        }
      }
    }
  }

  Future sendImage(File image)async{
    setMessageSending(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.uploadImage(uploadedImage: image, userDetails: userDetails);
    if(response['status']){
      sendMessage(
        content: response['data'],
        type: "image"
      );
    }else{
      return null;
    }
  }

  sendMessage({String content, String type})async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    setMessageSending(true);
    //scrollToBottom();
    var response = await API.sendMessage(
      userID: widget.partner.id,
      content: content,
      type: type,
      accessToken: userDetails.accessToken
    );
    if(response != null){
      if(response['status']){
        updateChat();
        if(!widget.partner.onHoliday){
          NotificationServices.postNotification(
              title: 'New Message',
              body: 'You got message from ${userDetails.name}',
              partnerID: widget.partner.id.toString(),
              purpose: 'chat',
              receiverToken: widget.partner.fcmToken
          );
        }
        if(widget.partner.onHoliday){
          renderOfficeMode();
        }
        _messageController.clear();
        setMessageSending(false);
      }else{
        setMessageSending(false);
        Fluttertoast.showToast(
            msg: "Message not sent",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      setMessageSending(false);
      Fluttertoast.showToast(
          msg: "Try again",
          toastLength: Toast.LENGTH_SHORT);
    }
  }
  sendQuiz({String content, String type})async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.sendMessage(
        userID: widget.partner.id,
        content: content,
        type: type,
        accessToken: userDetails.accessToken
    );
    if(response != null){
      if(response['status']){
        getAllMessages();
      }else{
        Fluttertoast.showToast(
            msg: "Quiz not sent",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(context).pop();
      }
    }else{
      Fluttertoast.showToast(
          msg: "Try again",
          toastLength: Toast.LENGTH_SHORT);
      Navigator.of(context).pop();
    }
  }

  addMessage({String senderID, String content, String type, String dateTime}){
    allMessages.add(ChatModel(
      senderID: senderID,
      content: content,
      type: type,
      dateTime: dateTime
    ));
  }

  getAllMessages()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getAllMessages(widget.partner.id, userDetails.accessToken);
    if(response != null){
      allMessages.clear();
      if(response['status']){
        for(var item in response['data']){
          allMessages.add(ChatModel.fromJson(item));
          voiceNoteLoading.add(false);
          voiceNotePlaying.add(false);
        }
      }
      setLoading(false);
      seeAllMessages();
      startTimer();
    }else{
      allMessages.clear();
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
    Future.delayed(Duration(milliseconds: 200)).then((value){
      scrollToBottom();
    });
  }

  seeAllMessages()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.seenMessage(
        senderID: widget.partner.id,
        accessToken: userDetails.accessToken);
  }

  blockUser(UserModel userDetails)async{
    setLoading(true);
    var response = await API.blockUser(widget.partner.id, userDetails);
    if(response != null){
      setLoading(false);
      if(response['status']){
        Provider.of<Partner>(context, listen: false).removePartner(widget.partner.id);
        Fluttertoast.showToast(
            msg: "Blocked Successfully",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(context).pop();
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  String voicePath;
  recordNote()async{
    bool isRecording = await record.isRecording();
    if(!isRecording){
      print("Recording");
      if (await record.hasPermission()) {
        voicePath = (await getTemporaryDirectory()).path;
        voicePath += "/${DateTime.now().millisecondsSinceEpoch}.mp3";
        await record.start(
          path: voicePath,
          encoder: AudioEncoder.AAC, // by default
          bitRate: 128000, // by default
          samplingRate: 44100, // by default
        );
        setLoadingRecording(true);
        startVoiceNoteTimer();
      }
    }else{
      print("Already recording");
      await record.stop();
      _voiceNoteTimer.cancel();
    }
  }

  uploadVoiceNote()async{
    setMessageSending(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.uploadVoiceNote(voiceNote: File(voicePath), userDetails: userDetails);
    if(response['status']){
      sendMessage(
          content: response['data'],
          type: "voice"
      );
    }else{
      return null;
    }
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      final bottomOffset = _scrollController.position.maxScrollExtent;
      print(bottomOffset.toString());
      _scrollController.animateTo(
        bottomOffset + 500,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }else{
      print("No Scroll client");
    }
  }

  renderVoiceNote(String url){
    var size = MediaQuery.of(context).size;
    showGeneralDialog(
      barrierLabel: "voice",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return Material(
          color: Colors.transparent,
          child: StatefulBuilder(
              builder: (context, setState) {
                return _buildPlayer(url, size);
              }
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          //position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  sendCallRequest(bool isVideo)async{
    _timer.cancel();
    setLoadingCall(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.sendCallRequest(
      receiverID: widget.partner.id,
      channel: DateTime.now().millisecondsSinceEpoch.toString(),
      type: isVideo ? "video" : "voice",
      accessToken: userDetails.accessToken
    );
    if(response != null){
      if(response['status']){
        CallModel callDetails = CallModel.fromJson(response['data']);
        setLoadingCall(false);
        Navigator.push(
            context,
            SwipeLeftAnimationRoute(
              widget: isVideo ?
              VideoCallScreen(
                  callDetails: callDetails
              ) :
              VoiceCallScreen(
                callDetails: callDetails,
                partnerDetails: widget.partner,
              ),
            )).then((value){
          startTimer();
        });
      }else{
        startTimer();
        setLoadingCall(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      startTimer();
      setLoadingCall(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  renderOfficeMode() {
    Future.delayed(const Duration(milliseconds: 200)).then((value){
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: "success",
        builder: (context) {
          var size = MediaQuery.of(context).size;

          return WillPopScope(
            onWillPop: ()=> Future.value(false),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: textColorW,
                    borderRadius: BorderRadius.circular(size.height * 0.02)),
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.1, vertical: size.height * 0.35),
                padding: EdgeInsets.symmetric(
                    horizontal: size.height * 0.02, vertical: size.height * 0.01),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/limit_reached.png",
                            height: size.height * 0.08,
                          ),
                          SizedBox(height: size.height * 0.01),
                          VariableText(
                            text: "Holiday/Office Mode ON",
                            fontFamily: fontBold,
                            fontsize: size.height * 0.022,
                            fontcolor: primaryColor2,
                            textAlign: TextAlign.center,
                          ),
                          VariableText(
                            text: "User has turned on\nHoliday/Office mode",
                            fontFamily: fontMedium,
                            fontsize: size.height * 0.018,
                            fontcolor: textColorG,
                            textAlign: TextAlign.center,
                            max_lines: 3,
                          ),
                          SizedBox(height: size.height * 0.01),
                          MyButton(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            btnTxt: "Okay",
                            borderColor: primaryColor1,
                            btnColor: primaryColor1,
                            txtColor: textColorW,
                            btnRadius: 5,
                            btnWidth: size.width * 0.60,
                            btnHeight: 40,
                            fontSize: size.height * 0.020,
                            weight: FontWeight.w700,
                            fontFamily: fontSemiBold,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.clear, color: textColorB, size: 18)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  openImage(String imageUrl){
    Image _img = Image.network(imageUrl);
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: true ? Colors.black : Colors.white,
        pageBuilder: (BuildContext context, _, __) {
          return FullScreenImage(
            child: _img,
            dark: true,
            hasDelete: false,
          );
        },
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.partner.onHoliday.toString());
    _scrollController = ScrollController();
    if(widget.shareQuiz){
      sendQuiz(content: "${widget.quizID}", type: "quiz");
    }else{
      getAllMessages();
    }
    initAudioPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _timer.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: textColorW,
            appBar: CustomAppBar(
              text: "@${widget.partner.username}",
              isBack: true,
              actionImage: "assets/icons/ic_more_option.png",
              height: size.height * 0.085,
              actionOnTap: PopupMenuButton(
                icon: Icon(Icons.more_vert_sharp),
                color: textColorW,
                padding: EdgeInsets.all(0),
                elevation: 5,
                offset: Offset(-30, size.height * 0.085),
                itemBuilder: (context) => [
                  /*PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 23,
                          child: Icon(
                            Icons.person,
                            size: 23,
                            color: primaryColor2,
                          ),
                        ),
                        SizedBox(width: 8),
                        VariableText(
                          text: "View Profile",
                          fontFamily: fontMedium,
                          fontcolor: primaryColor2,
                          fontsize: size.height * 0.019,
                        ),
                      ],
                    ),
                    value: 1,
                    onTap: (){
                      print("@@@");
                      _timer.cancel();
                      Navigator.push(
                          context,
                          SwipeLeftAnimationRoute(
                            widget: UserProfileScreen(
                              userID: widget.partner.id,
                            ),
                          )).then((value){
                            startTimer();
                      });
                    },
                  ),*/
                  /*PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 23,
                          child: Icon(
                            Icons.delete_forever,
                            size: 23,
                            color: primaryColor2,
                          ),
                        ),
                        SizedBox(width: 8),
                        VariableText(
                          text: "Delete Chat",
                          fontFamily: fontMedium,
                          fontcolor: textColorB,
                          fontsize: size.height * 0.019,
                        ),
                      ],
                    ),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 23,
                          child: Icon(
                            Icons.clear,
                            size: 23,
                            color: primaryColor2,
                          ),
                        ),
                        SizedBox(width: 8),
                        VariableText(
                          text: "Clear History",
                          fontFamily: fontMedium,
                          fontcolor: textColorB,
                          fontsize: size.height * 0.019,
                        ),
                      ],
                    ),
                    value: 3,
                  ),*/
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 23,
                          child: Image.asset(
                            "assets/icons/ic_call.png",
                            scale: 2.2,
                          ),
                        ),
                        SizedBox(width: 8),
                        VariableText(
                          text: tr("Voice Call"),
                          fontFamily: fontMedium,
                          fontcolor: textColorB,
                          fontsize: size.height * 0.019,
                        ),
                      ],
                    ),
                    value: 3,
                    onTap: (){
                      sendCallRequest(false);
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 23,
                          child: Image.asset(
                            "assets/icons/ic_video_call.png",
                            scale: 2.2,
                          ),
                        ),
                        SizedBox(width: 8),
                        VariableText(
                          text: tr("Video Call"),
                          fontFamily: fontMedium,
                          fontcolor: textColorB,
                          fontsize: size.height * 0.019,
                        ),
                      ],
                    ),
                    value: 4,
                    onTap: (){
                      sendCallRequest(true);
                    },
                  ),
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 23,
                          child: Image.asset(
                            "assets/icons/ic_block_user.png",
                            scale: 2.2,
                          ),
                        ),
                        SizedBox(width: 8),
                        VariableText(
                          text: tr("Block User"),
                          fontFamily: fontMedium,
                          fontcolor: textColorB,
                          fontsize: size.height * 0.019,
                        ),
                      ],
                    ),
                    value: 5,
                    onTap: (){
                      blockUser(userDetails);
                    },
                  ),
                ],
              ),
            ),
            body: isLoading ?
            Stack(
              children: [
                ProcessLoadingWhite()
              ],
            ) :
            Container(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  Expanded(
                    // height: size.height * 0.76,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.03),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(size.height * 0.1),
                            child: CachedNetworkImage(
                              imageUrl: widget.partner.profilePicture,
                              fit: BoxFit.cover,
                              height: size.height * 0.15,
                              width: size.height * 0.15,
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: padding - 7,
                                left: padding - 6,
                                right: padding - 6),
                            child: VariableText(
                              text: widget.partner.name,
                              fontFamily: fontSemiBold,
                              fontcolor: primaryColor2,
                              fontsize: size.height * 0.028,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  sendCallRequest(false);
                                },
                                icon: Image.asset(
                                  "assets/icons/ic_call.png",
                                  scale: 2.2,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  sendCallRequest(true);
                                },
                                icon: Image.asset(
                                  "assets/icons/ic_video_call.png",
                                  scale: 2.2,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: size.height * 0.03,
                            width: size.width,
                            margin: EdgeInsets.only(
                              top: padding - 9,
                            ),
                            child: Stack(
                              children: [
                                Divider(
                                  color: borderColor,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: primaryColor2,
                                      ),
                                      child: VariableText(
                                        text: "Today",
                                        fontFamily: fontSemiBold,
                                        fontcolor: textColorW,
                                        fontsize: size.height * 0.013,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            itemCount: allMessages.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return allMessages[index].senderID != userDetails.id.toString() ?
                                Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFEFF9FF),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                margin: EdgeInsets.only(
                                    left: 15, right: size.width * 0.32, bottom: 15),
                                padding: EdgeInsets.all(10),
                                // height: size.height * 0.12,
                                //width: 80,
                                child: allMessages[index].type == "quiz" ?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/icons/ic_quiz2.png",
                                      height: size.height * 0.06,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: VariableText(
                                            text: allMessages[index].quizDetails.name,
                                            fontFamily: fontBold,
                                            fontsize: size.height * 0.019,
                                            fontcolor: textColorB,
                                            max_lines: 2,
                                            textAlign: TextAlign.left,
                                            line_spacing: size.height * 0.0017,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: VariableText(
                                            text: allMessages[index].quizDetails.description,
                                            fontFamily: fontSemiBold,
                                            fontsize: size.height * 0.015,
                                            fontcolor: textColorBlue,
                                            max_lines: 3,
                                            textAlign: TextAlign.left,
                                            line_spacing: size.height * 0.0017,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            // horizontal: padding * 2,
                                            vertical: padding / 2,
                                          ),
                                          child: MyButton(
                                            onTap: () {
                                              _timer.cancel();
                                              Navigator.push(
                                                  context,
                                                  SwipeLeftAnimationRoute(
                                                      widget: StartQuizScreen(
                                                        quizID: allMessages[index].quizDetails.id,
                                                      ))).then((value){
                                                 startTimer();
                                              });
                                            },
                                            btnTxt: "Start",
                                            borderColor: primaryColor1,
                                            btnColor: primaryColor1,
                                            txtColor: textColorW,
                                            btnRadius: 5,
                                            btnWidth: size.width * 0.3,
                                            btnHeight: 30,
                                            fontSize: size.height * 0.020,
                                            weight: FontWeight.w700,
                                            fontFamily: fontSemiBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ) :
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        VariableText(
                                          text: widget.partner.name,
                                          fontFamily: fontSemiBold,
                                          fontcolor: primaryColor1,
                                          fontsize: size.height * 0.019,
                                        ),
                                        VariableText(
                                          text: chatTimeFormatter.format(DateTime.parse(allMessages[index].dateTime)),
                                          fontFamily: fontRegular,
                                          fontcolor: textColor1,
                                          fontsize: size.height * 0.017,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.004),
                                    if(allMessages[index].type == 'text')
                                      VariableText(
                                        text: allMessages[index].content,
                                        fontFamily: fontRegular,
                                        fontcolor: textColor1,
                                        fontsize: size.height * 0.017,
                                        max_lines: 50,
                                      ),
                                    if(allMessages[index].type == 'image')
                                      Container(
                                        height: size.height * 0.30,
                                        child: Center(
                                          child: InkWell(
                                            onTap: (){
                                              openImage(allMessages[index].content);
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: allMessages[index].content,
                                              fit: BoxFit.fill,
                                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                                                    child: CircularProgressIndicator(
                                                        value: downloadProgress.totalSize != null ?
                                                        downloadProgress.downloaded / downloadProgress.totalSize
                                                            : null,
                                                        color: primaryColor2),
                                                  ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if(allMessages[index].type == 'voice')
                                      Row(
                                        children: [
                                          if(voiceNoteLoading[index])
                                            const SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: CircularProgressIndicator(color: primaryColor1, strokeWidth: 2)
                                            ),
                                          if(voiceNotePlaying[index] && !voiceNoteLoading[index])
                                            InkWell(
                                                onTap: (){
                                                  activeNoteIndex = index;
                                                  pause();
                                                  setState(() {
                                                    voiceNotePlaying[index] = false;
                                                  });
                                                },
                                                child: Icon(Icons.pause, color: primaryColor1, size: 35)
                                            ),
                                          if(!voiceNotePlaying[index] && !voiceNoteLoading[index])
                                            InkWell(
                                                onTap: (){
                                                  activeNoteIndex = index;
                                                  setState(() {
                                                    voiceNoteLoading[index] = true;
                                                  });
                                                  play(allMessages[index].content, index).whenComplete((){
                                                    setState(() {
                                                      voiceNoteLoading[index] = false;
                                                      voiceNotePlaying[index] = true;
                                                    });
                                                  });
                                                },
                                                child: Icon(Icons.play_arrow_rounded, color: primaryColor1, size: 35)
                                            ),
                                          /*isVoicePlaying ?
                                          InkWell(
                                            onTap: (){
                                              pause();
                                              setState(() {
                                                isVoicePlaying = false;
                                              });
                                            },
                                              child: Icon(Icons.pause, color: primaryColor1, size: 35)
                                          ) :
                                          InkWell(
                                            onTap: (){
                                              play(allMessages[index].content, index).whenComplete((){
                                                setState(() {
                                                  isVoicePlaying = true;
                                                });
                                              });
                                            },
                                              child: Icon(Icons.play_arrow_rounded, color: primaryColor1, size: 35)
                                          ),*/
                                          SizedBox(width: 8),
                                          VariableText(
                                            text: "Voice Note",
                                            fontFamily: fontSemiBold,
                                            fontcolor: primaryColor1,
                                            fontsize: size.height * 0.017,
                                            max_lines: 1,
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ) :
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffFEE8EF),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(0),
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                margin: EdgeInsets.only(
                                    left: size.width * 0.32, right: 15, bottom: 15),
                                padding: EdgeInsets.all(10),
                                child: allMessages[index].type == "quiz" ?
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/icons/ic_quiz2.png",
                                      height: size.height * 0.06,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: VariableText(
                                            text: allMessages[index].quizDetails.name,
                                            fontFamily: fontBold,
                                            fontsize: size.height * 0.019,
                                            fontcolor: textColorB,
                                            max_lines: 2,
                                            textAlign: TextAlign.left,
                                            line_spacing: size.height * 0.0017,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: VariableText(
                                            text: allMessages[index].quizDetails.description,
                                            fontFamily: fontSemiBold,
                                            fontsize: size.height * 0.015,
                                            fontcolor: textColorBlue,
                                            max_lines: 3,
                                            textAlign: TextAlign.left,
                                            line_spacing: size.height * 0.0017,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ) :
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        VariableText(
                                          text: "You",
                                          fontFamily: fontSemiBold,
                                          fontcolor: textColor1,
                                          fontsize: size.height * 0.019,
                                        ),
                                        VariableText(
                                          text: chatTimeFormatter.format(DateTime.parse(allMessages[index].dateTime)),
                                          fontFamily: fontRegular,
                                          fontcolor: textColor1,
                                          fontsize: size.height * 0.017,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.004),
                                    if(allMessages[index].type == 'text')
                                      VariableText(
                                        text: allMessages[index].content,
                                        fontFamily: fontRegular,
                                        fontcolor: textColor1,
                                        fontsize: size.height * 0.017,
                                        max_lines: 50,
                                      ),
                                    if(allMessages[index].type == 'image')
                                      Container(
                                        height: size.height * 0.30,
                                        child: Center(
                                          child: InkWell(
                                            onTap: (){
                                              openImage(allMessages[index].content);
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: allMessages[index].content,
                                              fit: BoxFit.fill,
                                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                                                    child: CircularProgressIndicator(
                                                        value: downloadProgress.totalSize != null ?
                                                        downloadProgress.downloaded / downloadProgress.totalSize
                                                            : null,
                                                        color: primaryColor2),
                                                  ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                    if(allMessages[index].type == 'voice')
                                      Row(
                                        children: [
                                          if(voiceNoteLoading[index])
                                            const SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: CircularProgressIndicator(color: primaryColor1, strokeWidth: 2)
                                            ),
                                          if(voiceNotePlaying[index] && !voiceNoteLoading[index])
                                            InkWell(
                                                onTap: (){
                                                  activeNoteIndex = index;
                                                  pause();
                                                  setState(() {
                                                    voiceNotePlaying[index] = false;
                                                  });
                                                },
                                                child: Icon(Icons.pause, color: primaryColor1, size: 35)
                                            ),
                                          if(!voiceNotePlaying[index] && !voiceNoteLoading[index])
                                            InkWell(
                                                onTap: (){
                                                  activeNoteIndex = index;
                                                  setState(() {
                                                    voiceNoteLoading[index] = true;
                                                  });
                                                  play(allMessages[index].content, index).whenComplete((){
                                                    setState(() {
                                                      voiceNoteLoading[index] = false;
                                                      voiceNotePlaying[index] = true;
                                                    });
                                                  });
                                                },
                                                child: Icon(Icons.play_arrow_rounded, color: primaryColor1, size: 35)
                                            ),
                                          /*isVoicePlaying ?
                                          InkWell(
                                            onTap: (){
                                              pause();
                                              setState(() {
                                                isVoicePlaying = false;
                                              });
                                            },
                                              child: Icon(Icons.pause, color: primaryColor1, size: 35)
                                          ) :
                                          InkWell(
                                            onTap: (){
                                              play(allMessages[index].content, index).whenComplete((){
                                                setState(() {
                                                  isVoicePlaying = true;
                                                });
                                              });
                                            },
                                              child: Icon(Icons.play_arrow_rounded, color: primaryColor1, size: 35)
                                          ),*/
                                          SizedBox(width: 8),
                                          VariableText(
                                            text: "Voice Note",
                                            fontFamily: fontSemiBold,
                                            fontcolor: primaryColor1,
                                            fontsize: size.height * 0.017,
                                            max_lines: 1,
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: borderLightColor,
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: borderLightColor),
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            isMessageSending ?
                            Container(
                              height: 25,
                              width: size.width * 0.06,
                              //color: Colors.yellow,
                              child: CircularProgressIndicator(color: Colors.red, strokeWidth: 3),
                            ) :
                            InkWell(
                              onTap: () {
                                if(_messageController.text.isNotEmpty){
                                  sendMessage(
                                      content: _messageController.text.trim(),
                                      type: "text"
                                  );
                                }
                              },
                              child: Image.asset(
                                "assets/icons/ic_send.png",
                                scale: 2.2,
                              ),
                            ),
                            /*InkWell(
                              onTap: () {},
                              child: Image.asset(
                                "assets/icons/ic_emoji.png",
                                scale: 2.2,
                              ),
                            ),*/
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    SwipeLeftAnimationRoute(
                                        widget: MessageGalleryScreen()
                                    )
                                ).then((value){
                                  if(value != null){
                                    sendImage(value);
                                  }
                                });
                              },
                              child: Image.asset(
                                "assets/icons/ic_attach.png",
                                scale: 2.2,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                recordNote();
                              },
                              child: Image.asset(
                                "assets/icons/ic_microphone.png",
                                scale: 2.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  /*if(showingSticker)
                    EmojiPicker(
                      onEmojiSelected: (category, emoji) {
                        // Do something when emoji is tapped (optional)
                      },
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                      },
                      //textEditingController: textEditionController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        progressIndicatorColor: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    )*/
                ],
              ),
            ),
          ),
          if(isRecording) Material(
            color: Colors.transparent,
            child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                child: Center(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          VariableText(
                            text: timerText,
                            fontFamily: fontBold,
                            fontsize: size.height * 0.024,
                            fontcolor: textColorW,
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.height * 0.015,
                                height: size.height * 0.015,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                    borderRadius: BorderRadius.circular(200),
                                    border: Border.all(color: Colors.red)
                                ),
                              ),
                              SizedBox(width: 5),
                              VariableText(
                                text: "Recording...",
                                fontFamily: fontBold,
                                fontsize: size.height * 0.024,
                                fontcolor: textColorW,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              bool isRecording = await record.isRecording();
                              if(isRecording){
                                await record.stop();
                                _voiceNoteTimer.cancel();
                                uploadVoiceNote();
                                setLoadingRecording(false);
                              }
                            },
                            child: Container(
                                width: size.height * 0.08,
                                height: size.height * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  border: Border.all(color: textColorB)
                                ),
                                child: Icon(Icons.stop, size: size.height * 0.05)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          if(isLoadingCall) ProcessLoadingLight()
        ],
      ),
    );
  }
  Widget _buildPlayer(String url, Size size) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.32, horizontal: size.width * 0.04),
        child: Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
    ),
    padding: EdgeInsets.all(16.0),
    child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              //onPressed: isPlaying ? null : () => play(url),
              iconSize: 64.0,
              icon: Icon(Icons.play_arrow),
              color: Colors.cyan,
            ),
            IconButton(
              onPressed: isPlaying ? () => pause() : null,
              iconSize: 64.0,
              icon: Icon(Icons.pause),
              color: Colors.cyan,
            ),
            IconButton(
              onPressed: isPlaying || isPaused ? () => stop() : null,
              iconSize: 64.0,
              icon: Icon(Icons.stop),
              color: Colors.cyan,
            ),
          ]),
          if (duration != null)
            Slider(
                value: position.inMilliseconds.toDouble() ?? 0.0,
                onChanged: (double value) {
                  return audioPlayer.seek((value / 1000).roundToDouble());
                },
                min: 0.0,
                max: duration.inMilliseconds.toDouble()),
          //if (position != null) _buildMuteButtons(),
          if (position != null) _buildProgressView()
        ],
    ),
  ),
      );
  Row _buildProgressView() => Row(mainAxisSize: MainAxisSize.min, children: [
    Padding(
      padding: EdgeInsets.all(12.0),
      child: CircularProgressIndicator(
        value: position != null && position.inMilliseconds > 0
            ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
            (duration?.inMilliseconds?.toDouble() ?? 0.0)
            : 0.0,
        valueColor: AlwaysStoppedAnimation(Colors.cyan),
        backgroundColor: Colors.grey.shade400,
      ),
    ),
    Text(
      position != null
          ? "${positionText ?? ''} / ${durationText ?? ''}"
          : duration != null ? durationText : '',
      style: TextStyle(fontSize: 24.0),
    )
  ]);
  Row _buildMuteButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        if (!isMuted)
          FlatButton.icon(
            onPressed: () => mute(true),
            icon: Icon(
              Icons.headset_off,
              color: Colors.cyan,
            ),
            label: Text('Mute', style: TextStyle(color: Colors.cyan)),
          ),
        if (isMuted)
          FlatButton.icon(
            onPressed: () => mute(false),
            icon: Icon(Icons.headset, color: Colors.cyan),
            label: Text('Unmute', style: TextStyle(color: Colors.cyan)),
          ),
      ],
    );
  }
}
enum PlayerState { stopped, playing, paused }
