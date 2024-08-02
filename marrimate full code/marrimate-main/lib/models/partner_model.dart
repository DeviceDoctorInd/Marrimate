import 'package:flutter/material.dart';
import 'package:marrimate/models/user_model.dart';

class Partner extends ChangeNotifier{
  List<UserModel> partners = [];


  Partner({this.partners});

  initialize(){
    partners = [];
    notifyListeners();
  }

  loadPartners(Map<String, dynamic> json){
    partners = [];
    for(var item in json['data']){
      partners.add(UserModel.fromPartnerJson(item));
    }
    notifyListeners();
  }

  addPartner(UserModel partner){
    partners.add(partner);
    notifyListeners();
  }

  List<UserModel> getRadarPartner(){
    List<UserModel> tempPartners = [];
    for(var item in partners){
      if(item.userPrivacy.showLocation){
        tempPartners.add(item);
      }
    }
    return tempPartners;
  }

  removePartner(int partnerID){
    partners.removeWhere((element) => element.id == partnerID);
    notifyListeners();
  }
}