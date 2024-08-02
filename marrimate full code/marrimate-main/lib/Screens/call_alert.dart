import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:marrimate/Screens/Dashboard/Chat/voice_call_screen.dart';

import '../Widgets/common.dart';
import '../Widgets/styles.dart';
import '../models/call_model.dart';
import '../services/api.dart';
import 'Dashboard/Chat/video_call_screen.dart';

class CallAlert{
  static BuildContext cContext;
  static bool isShowing = false;

  static bool appActive = true;

  static cancelCall(int callId)async{
    var response = await API.updateVideoCallRequest(callID: callId);
    isShowing = false;
  }

  static Future<Widget> showAlert(BuildContext context, CallModel callDetails) async{
    var size = MediaQuery.of(context).size;
    isShowing = true;
    FlutterRingtonePlayer.playRingtone();
    showDialog(
        barrierDismissible: false,
        barrierLabel: "call",
        context: context,
        builder: (BuildContext context,){
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.14,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  VariableText(
                    text: callDetails.senderName,
                    fontFamily: fontSemiBold,
                    fontcolor: textColorB,
                    fontsize: size.height * 0.025,
                  ),
                  ClipRRect(
                      borderRadius:
                      BorderRadius.circular(size.height * 0.1),
                      child: CachedNetworkImage(
                        imageUrl: callDetails.senderProfile,
                        height: size.height * 0.045,
                        width: size.height * 0.045,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: CircularProgressIndicator(value: downloadProgress.progress, color: primaryColor2),
                            ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      )
                  ),
                ],
              ),
              VariableText(
                text: "Incoming ${callDetails.type} call",
                fontFamily: fontSemiBold,
                fontcolor: textColorB,
                fontsize: size.height * 0.018,
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                  children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      FlutterRingtonePlayer.stop();
                      cancelCall(callDetails.id);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        height: size.height * 0.045,
                        //width: MediaQuery.of(context).size.width*0.3,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF00000),
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        child: Center(
                            child: VariableText(
                              text: "Decline",
                              fontFamily: fontSemiBold,
                              fontcolor: textColorW,
                              fontsize: 18,
                              textAlign: TextAlign.center,
                            ))),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      FlutterRingtonePlayer.stop();
                      Navigator.pushReplacement(
                          context,
                          SwipeLeftAnimationRoute(
                            widget: callDetails.type == "video" ?
                            VideoCallScreen(
                                callDetails: callDetails
                            ) :
                            VoiceCallScreen(
                                callDetails: callDetails
                            ),
                          ));
                    },
                    child: Container(
                        height: size.height * 0.045,
                        //width: MediaQuery.of(context).size.width*0.3,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                        child: Center(
                            child: VariableText(
                              text: "Accept",
                              fontFamily: fontSemiBold,
                              fontcolor: textColorW,
                              fontsize: 18,
                              textAlign: TextAlign.center,
                            ),)),
                  ),
                ),
              ]
              ),
            ],
          ),
        ),
      );

    });
  }

  static hideAlert(){
    FlutterRingtonePlayer.stop();
  }

}