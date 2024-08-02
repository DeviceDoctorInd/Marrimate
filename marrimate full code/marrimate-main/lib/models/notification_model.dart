
class MyNotification{
  int id;
  String content;
  String title;
  int userID;
  String profileImage;
  bool isRead;

  MyNotification({this.userID, this.title, this.content});

  MyNotification.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      content = json['content'];
      title = json['title'];
      userID = int.tryParse(json['notification_from']);
      profileImage = json['profile_img'];
      if(json['is_read'] == "0"){
        isRead = false;
      }else{
        isRead = true;
      }
    }catch(e, stack){
      print("MyNotification.fromJson: " + stack.toString());
    }
  }
}