
class UserImage{
  int id;
  String imageUrl;

  UserImage({this.id, this.imageUrl});

  UserImage.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      imageUrl = json['u_images'];
    }catch(e, stack){
      print("UserImage.fromJson: " + stack.toString());
    }
  }
}

class UserVideo{
  int id;
  String videoUrl;

  UserVideo({this.id, this.videoUrl});

  UserVideo.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      videoUrl = json['u_videos'];
    }catch(e, stack){
      print("UserVideo.fromJson: " + stack.toString());
    }
  }
}