
class Plan{
  int id;
  String planName;
  String description;
  String price;
  String icon;

  Plan.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      planName = json['plan_name'];
      description = json['plan_description'];
      price = json['plan_price'];
      icon = json['plan_icon'];
    }catch(e, stack){
      print("Plan.fromJson: " + stack.toString());
    }
  }
}