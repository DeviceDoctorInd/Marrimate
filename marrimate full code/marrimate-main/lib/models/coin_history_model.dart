
class CoinHistory{
  int id;
  String userID;
  String sendTo;
  String coinsSent;
  String name;
  String profilePicture;

  CoinHistory.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      userID = json['user_id'].toString();
      sendTo = json['send_to'].toString();
      coinsSent = json['coins_send'];
      name = json['name'];
      profilePicture = json['profile_img'];
    }catch(e, stack){
      print("CoinHistory.fromJson: " + stack.toString());
    }
  }
}