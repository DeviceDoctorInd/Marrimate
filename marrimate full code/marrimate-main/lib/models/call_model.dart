

import 'package:flutter/cupertino.dart';

class ActiveCall with ChangeNotifier{
  CallModel call;

  setCalls(CallModel activeCall){
    call = activeCall;
    notifyListeners();
  }
}

class CallModel{
  int id;
  int senderID;
  String senderName;
  String senderProfile;
  String channelName;
  String type;
  String status;

  CallModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    senderID = json['sender_id'];
    senderName = json['name'];
    senderProfile = json['profile_img'];
    channelName = json['channel_name'];
    type = json['type'];
    status = json['status'];
  }

}