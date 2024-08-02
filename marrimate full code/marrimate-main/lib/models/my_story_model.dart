import 'package:flutter/material.dart';

class MyStories extends ChangeNotifier{
  List<MyStory> myStories = [];

  loadMyStories(Map<String, dynamic> json){
    myStories.clear();
    for(var item in json['data']){
      if(DateTime.parse(item['created_at']).isBefore(DateTime.now().subtract(Duration(hours: 24)))){
        continue;
      }else{
        myStories.add(MyStory.fromJson(item));
      }
    }
    notifyListeners();
  }

}

class MyStory{
  int id;
  String image;
  String seenBy;
  String createdAt;

  MyStory.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      image = json['image'];
      seenBy = "3";
      createdAt = json['created_at'];
    }catch(e, stack){
      print("MyStory.fromJson: " + stack.toString());
    }
  }
}