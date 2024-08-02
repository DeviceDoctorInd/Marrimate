import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/common.dart';
import '../../../Widgets/constants.dart';
import '../../../Widgets/styles.dart';
import '../../../models/call_model.dart';
import '../../../models/user_model.dart';
import '../../../services/api.dart';
import '../../call_alert.dart';

class VoiceCallScreen extends StatefulWidget {
  CallModel callDetails;
  UserModel partnerDetails;
  VoiceCallScreen({Key key, this.callDetails, this.partnerDetails}) : super(key: key);

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  int _remoteUid;
  bool _localUserJoined = false;
  RtcEngine _engine;

  Timer _timer;
  final interval = const Duration(seconds: 3);

  bool muteAudio = false;
  bool onSpeaker = false;

  @override
  void initState() {
    super.initState();
    CallAlert.isShowing = true;
    startTimer();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    _engine = await RtcEngine.create(Constants.appId);
    await _engine.disableVideo();

    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("local user $uid joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        userJoined: (int uid, int elapsed) {
          print("remote user $uid joined");
          _timer.cancel();
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("remote user $uid left channel");
          cancelCall();
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(null, widget.callDetails.channelName, null, 0);
  }

  cancelCall()async{
    var response = await API.updateVideoCallRequest(
        callID: widget.callDetails.id
    );
    if(response != null){
      CallAlert.isShowing = false;
      _timer.cancel();
      Navigator.of(context).pop();
    }
  }

  startTimer([int milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      statusCheck();
    });
  }

  statusCheck()async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getSingleCallChannel(widget.callDetails.id, userDetails.accessToken);
    if(response != null){
      if(response['status']){
        CallModel tempDetails;
        tempDetails = CallModel.fromJson(response['data']);
        if(tempDetails.status == "deactive"){
          CallAlert.isShowing = false;
          _timer.cancel();
          Fluttertoast.showToast(
              msg: "Call declined",
              toastLength: Toast.LENGTH_SHORT);

          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  void dispose() {
    cancelCall();
    _engine.destroy();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> Future.value(false),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: _remoteAudio(),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: textColorB,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                onSpeaker ?
                IconButton(
                  onPressed: () {
                    _engine.setEnableSpeakerphone(false);
                    setState(() {
                      onSpeaker = false;
                    });
                  },
                  icon: Image.asset(
                    "assets/icons/ic_speaker_on.png",
                    color: Colors.red,
                    scale: 2.5,
                  ),
                ) :
                IconButton(
                  onPressed: () {
                    _engine.setEnableSpeakerphone(true);
                    setState(() {
                      onSpeaker = true;
                    });
                  },
                  icon: Image.asset(
                    "assets/icons/ic_speaker_on.png",
                    scale: 2.5,
                  ),
                ),
                muteAudio ?
                IconButton(
                  onPressed: () {
                    _engine.muteLocalAudioStream(false);
                    setState(() {
                      muteAudio = false;
                    });
                  },
                  icon: Image.asset(
                    "assets/icons/ic_voice_on.png",
                    scale: 2.7,
                  ),
                ) :
                IconButton(
                  onPressed: () {
                    _engine.muteLocalAudioStream(true);
                    setState(() {
                      muteAudio = true;
                    });
                  },
                  icon: Image.asset(
                    "assets/icons/ic_mute.png",
                    scale: 2.7,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _engine.destroy();
                    cancelCall();
                  },
                  icon: Image.asset(
                    "assets/icons/ic_end_call.png",
                    scale: 2.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _remoteAudio() {
    var size = MediaQuery.of(context).size;
    var userDetails = Provider.of<UserModel>(context, listen: false);

    if (_remoteUid != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.callDetails.senderID == userDetails.id ?
          VariableText(
            text: widget.partnerDetails.name,
            fontFamily: fontMedium,
            fontcolor: textColorW,
            fontsize: 28,
          ) :
          VariableText(
            text: widget.callDetails.senderName,
            fontFamily: fontMedium,
            fontcolor: textColorW,
            fontsize: 28,
          ),
          SizedBox(height: 10),
          widget.callDetails.senderID == userDetails.id ?
          ClipRRect(
            borderRadius: BorderRadius.circular(size.height * 0.2),
            child: CachedNetworkImage(
              imageUrl: widget.partnerDetails.profilePicture,
              fit: BoxFit.fill,
              height: size.height * 0.35,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                    child: CircularProgressIndicator(
                        value: downloadProgress.totalSize != null ?
                        downloadProgress.downloaded / downloadProgress.totalSize
                            : null,
                        color: primaryColor2),
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white,),
            ),
          ) :
          ClipRRect(
            borderRadius: BorderRadius.circular(size.height * 0.2),
            child: CachedNetworkImage(
              imageUrl: widget.callDetails.senderProfile,
              fit: BoxFit.fill,
              height: size.height * 0.35,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                    child: CircularProgressIndicator(
                        value: downloadProgress.totalSize != null ?
                        downloadProgress.downloaded / downloadProgress.totalSize
                            : null,
                        color: primaryColor2),
                  ),
              errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white,),
            ),
          ),
        ],
      );
    } else {
      return VariableText(
        text: "Connecting...",
        fontFamily: fontMedium,
        fontcolor: textColorW,
        fontsize: 18,
      );
    }
  }
}
