
class Hobby{
  int id;
  String name;
  String icon;

  Hobby({this.id, this.name, this.icon});

  Hobby.fromJson(Map<String , dynamic> json){
    try{
      id = json['id'];
      name = json['hobbies'];
      icon = json['hobbies_icon'];
    }catch(e, stack){
      print("Hobby.fromJson: " + stack.toString());
    }
  }

  Hobby.fromUserJson(Map<String , dynamic> json){
    try{
      id = json['hobbies']['id'];
      name = json['hobbies']['hobbies'];
      icon = json['hobbies']['hobbies_icon'];
    }catch(e, stack){
      print("Hobby.fromUserJson: " + stack.toString());
    }
  }
}