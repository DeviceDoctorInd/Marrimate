
class SOrientation{
  int id;
  String name;

  SOrientation({this.id, this.name});

  SOrientation.fromJson(Map<String , dynamic> json){
    try{
      id = json['id'];
      name = json['sexual_orientations'];
    }catch(e, stack){
      print("SOrientation.fromJson: " + stack.toString());
    }
  }
}