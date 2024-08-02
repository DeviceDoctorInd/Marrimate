import 'package:flutter/material.dart';
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/models/call_model.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:agora_uikit/agora_uikit.dart';

import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:provider/provider.dart';

import '../../../Widgets/constants.dart';
import '../../../models/user_model.dart';
import '../../../services/api.dart';
import '../../call_alert.dart';

class VideoCallScreen extends StatefulWidget {
  CallModel callDetails;
  VideoCallScreen({Key key, this.callDetails}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int _remoteUid;
  bool _localUserJoined = false;
  RtcEngine _engine;

  Timer _timer;
  final interval = const Duration(seconds: 3);

  bool muteVideo = false;
  bool muteAudio = false;

  @override
  void initState() {
    super.initState();
    CallAlert.isShowing = true;
    if(widget.callDetails.type == "voice"){
      muteVideo = true;
    }
    startTimer();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    _engine = await RtcEngine.create(Constants.appId);
    await _engine.enableVideo();
    _engine.setVideoEncoderConfiguration(VideoEncoderConfiguration(
      dimensions: VideoDimensions(width: 1920, height: 1080),
      frameRate: VideoFrameRate.Fps30,
    ));

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
          setState(() {
            _remoteUid = null;
          });
          CallAlert.isShowing = false;
          _timer.cancel();
          Fluttertoast.showToast(
              msg: "Call Cancelled",
              toastLength: Toast.LENGTH_LONG);
          Navigator.of(context).pop();
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
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()=> Future.value(false),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: _remoteVideo(),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Container(
                    width: 100,
                    height: 150,
                    color: Colors.white,
                    child: Center(
                      child: _localUserJoined
                          ? Stack(
                            children: [
                              RtcLocalView.SurfaceView(),
                              if(muteVideo) Positioned.fill(
                                child: Container(
                                  color: Colors.black54,
                                  child: Center(
                                    child: VariableText(
                                      text: "Paused",
                                      fontFamily: fontMedium,
                                      fontcolor: textColorW,
                                      fontsize: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                          : CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
             /* CustomVideoAppBar(
                isBack: true,
                actionImage: "assets/icons/ic_more_option.png",
                height: size.height * 0.085,
              ),*/
            ],
          ),
          bottomNavigationBar: Container(
            color: textColorB,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _engine.switchCamera();
                  },
                  icon: Image.asset(
                    "assets/icons/ic_camera_rotate.png",
                    scale: 2.5,
                  ),
                ),
                muteVideo ?
                IconButton(
                  onPressed: () {
                    _engine.enableLocalVideo(true);
                    _engine.muteLocalVideoStream(false);
                    setState(() {
                      muteVideo = false;
                    });
                  },
                  icon: Image.asset(
                    "assets/icons/ic_video_on.png",
                    scale: 2.5,
                  ),
                ) :
                IconButton(
                  onPressed: () {
                    _engine.enableLocalVideo(false);
                    _engine.muteLocalVideoStream(true);
                    setState(() {
                      muteVideo = true;
                    });
                  },
                  icon: Image.asset(
                    "assets/icons/ic_video_off.png",
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

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid,
        channelId: widget.callDetails.channelName,
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
