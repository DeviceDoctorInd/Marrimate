
class Booster{
  int id;
  String boosterName;
  int weight;
  double price;
  String icon;

  Booster.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      boosterName = json['name'];
      weight = int.tryParse(json['weight'].toString())??0;
      price = double.tryParse(json['price'].toString())??0.00;
      icon = json['icon'];
    }catch(e){
      print("Booster.fromJson: " + e.toString());
    }
  }
}