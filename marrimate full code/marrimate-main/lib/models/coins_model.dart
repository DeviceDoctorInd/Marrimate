
class Coins{
  int id;
  String totalCoins;

  Coins({this.id, this.totalCoins});

  Coins.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      totalCoins = json['total_coins'];
    }catch(e, stack){
      print("Coins.fromJson: " + stack.toString());
    }
  }
}

class BuyCoin{
  int id;
  String coins;
  double price;

  BuyCoin.fromJson(Map<String, dynamic> json){
    try {
      id = json['id'];
      coins = json['coins'];
      price = double.tryParse(json['price']);
    } catch (e, stack) {
      print("BuyCoin.fromJson: " + stack.toString());
    }
  }
}