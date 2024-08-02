
class Order{
  String userID;
  String firstName;
  String lastName;
  String email;
  String contact;
  String country;
  String city;
  String address;
  String zipCode;
  String note;
  String giftID;
  String variant;
  String quantity;
  String price;

  Order({this.userID, this.firstName, this.lastName, this.email, this.contact,
  this.country, this.city, this.address, this.zipCode, this.note, this.giftID,
  this.variant, this.quantity, this.price});

  Map<String, double> toCreateOrder(){
    Map<String, dynamic> data = Map<String, dynamic>();
  }
  Map<String, dynamic> toJsonUpload(Order orderDetails) {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = orderDetails.userID;
    data['first_name'] = orderDetails.firstName;
    data['last_name'] = orderDetails.lastName;
    data['email'] = orderDetails.email;
    data['phone'] = orderDetails.contact;
    data['country'] = orderDetails.country;
    data['city'] = orderDetails.city;
    data['address'] = orderDetails.address;
    data['zip_code'] = orderDetails.zipCode;
    data['note'] = orderDetails.note;
    data['gift_id'] = orderDetails.giftID;
    data['variant'] = orderDetails.variant;
    data['quantity'] = orderDetails.quantity;
    data['price'] = orderDetails.price;
    return data;
  }
}