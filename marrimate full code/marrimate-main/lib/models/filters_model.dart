
import 'package:flutter/cupertino.dart';

class Filters with ChangeNotifier{
  String gender;
  String ageRange;
  String language;
  String distanceRange;

  initialize(){
    gender = "All";
    ageRange = "All";
    language = "English";
    distanceRange = "25";
    notifyListeners();
  }

  setFilters({String selectedGender, String selectedAge, String selectedLanguage,
    String selectedRange}){
    gender = selectedGender;
    ageRange = selectedAge;
    language = selectedLanguage;
    distanceRange = selectedRange;
    notifyListeners();
  }

}