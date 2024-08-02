
class Leaderboard{
  int id;
  String quizID;
  String userID;
  String performerID;
  String name;
  String profileImage;
  String score;

  Leaderboard.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      quizID = json['quiz_id'].toString();
      userID = json['user_id'].toString();
      performerID = json['performed_by'];
      name = json['name'];
      profileImage = json['profile_img'];
      score = json['score'];
    }catch(e, stack){
      print("Leaderboard.fromJson: " + stack.toString());
    }
  }
}