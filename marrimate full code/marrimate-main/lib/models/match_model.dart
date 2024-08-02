import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marrimate/models/user_model.dart';

import 'filters_model.dart';

class Match extends ChangeNotifier{
  List<UserModel> candidates = [];
  List<bool> marked = [];

  Match({this.candidates});

  loadCandidates(Map<String, dynamic> json, UserModel userDetails, Filters myFilters){
    candidates = [];
    marked = [];
    for(var item in json['data']){
      UserModel tempCandidate = UserModel.fromJson(item);
      int userAge = int.parse(getAge(userDetails.dob));
      int candidateAge = int.parse(getAge(tempCandidate.dob));
      var distance = Geolocator.distanceBetween(
          double.parse(userDetails.lat), double.parse(userDetails.long),
          double.parse(tempCandidate.lat), double.parse(tempCandidate.long)
      );
      double partnerDistance = (distance / 1000);

      ///Filters
      if(myFilters.gender == "All"){

      }else if(myFilters.gender != tempCandidate.gender){
        continue;
      }
      if(myFilters.ageRange == "All"){

      }else if(candidateAge < getAgeMin(myFilters.ageRange)
        || candidateAge > getAgeMax(myFilters.ageRange)){
        continue;
      }
      if(partnerDistance > double.parse(myFilters.distanceRange)){
        continue;
      }

      ///Privacies
      if(tempCandidate.userPrivacy.ageRange == "All"){
      }else if(userAge < getAgeMin(tempCandidate.userPrivacy.ageRange)
        || userAge > getAgeMax(tempCandidate.userPrivacy.ageRange)){

        continue;
      }
      if(tempCandidate.userPrivacy.preferredGender == "All"){

      }else if(tempCandidate.userPrivacy.preferredGender != userDetails.gender){
        continue;
      }
      print(item['id'].toString());
      print(partnerDistance.toString() + " KM");
      candidates.add(UserModel.fromJson(item));
      marked.add(false);
    }
    sortOnWeight();
    notifyListeners();
  }

  sortOnWeight(){
    List<UserModel> temp = [];
    for(int i=0; i < candidates.length; i++){
      if(candidates[i].userBooster.boosterID != null){
        temp.add(candidates[i]);
      }
    }
    ///bubble sort
    for (int i = 0; i < temp.length; i++) {
      for (int j = 0; j < temp.length - 1; j++) {
        if (temp[j].userBooster.weight < temp[j + 1].userBooster.weight) {
          UserModel tempUser = temp[j];
          temp[j] = temp[j + 1];
          temp[j + 1] = tempUser;
        }
      }
    }

    for(int i=0; i < candidates.length; i++){
      if(candidates[i].userBooster.boosterID == null){
        temp.add(candidates[i]);
      }
    }
    candidates = temp;
    notifyListeners();
  }

  markCandidate(int candidateID){
    try{
      for(int i=0; i < candidates.length; i++){
        if(candidates[i].id == candidateID){
          marked[i] = true;
          break;
        }
      }
    }catch(e){
      print("likeCandidate: "+e.toString());
    }
    notifyListeners();
  }

  getAgeMin(String ageRange){
    String minAge;
    minAge = ageRange.split("-").first.trim();
    return int.parse(minAge);
  }
  getAgeMax(String ageRange){
    String minAge;
    minAge = ageRange.split("-").last.trim();
    return int.parse(minAge);
  }

  getAge(String givenDob){
    String dob;
    int year = (DateTime.now().year - DateTime.parse(givenDob).year);
    if(year < 1){
      int month = (DateTime.now().month - DateTime.parse(givenDob).month);
      dob = month.toString();
    }else{
      dob = year.toString();
    }
    return dob;
  }
}