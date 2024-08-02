
import 'package:marrimate/models/quiz_model.dart';
import 'package:marrimate/models/user_model.dart';

class ChatModel{
  int id;
  UserModel receiverDetails;
  String senderID;
  String type;
  String content;
  String dateTime;
  bool isSeen;
  Quiz quizDetails;

  ChatModel({this.id, this.receiverDetails, this.senderID, this.type,
    this.content, this.dateTime, this.isSeen=true, this.quizDetails});

  ChatModel.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      receiverDetails = UserModel.fromChatJson(json['user']);
      senderID = json['sender_id'];
      type = json['chatdetail']['type'];
      content = json['chatdetail']['content'];
      dateTime = json['chatdetail']['created_at'];
      isSeen = json['chatdetail']['is_seen'] == '0' ? false : true;
      if(type == 'quiz' && json['quiz'] != null){
        quizDetails = Quiz.fromJson(json['quiz']);
      }
    }catch(e, stack){
      print("ChatModel.fromJson: " + stack.toString());
    }
  }
}