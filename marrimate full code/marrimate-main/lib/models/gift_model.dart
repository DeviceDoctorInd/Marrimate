
class Gift{
  int id;
  String name;
  String description;
  String price;
  String mainImage;
  String quantity;
  List<String> images = [];
  List<String> variants = [];

  Gift.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      description = json['description'];
      price = json['price'];
      mainImage = json['main_img'];
      quantity = json['quantity'];
      images.add(mainImage);
      for(var item in json['images']){
        images.add(item['images']);
      }
      for(var item in json['variant']){
        variants.add(item['variants']);
      }
    }catch(e, stack){
      print("Gift.fromJson: " + stack.toString());
    }
  }
}