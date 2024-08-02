
import 'package:flutter/material.dart';
import 'package:marrimate/models/user_model.dart';

class MatchedStories extends ChangeNotifier{
  List<Story> userStories = [];

  loadMatchedStories(Map<String, dynamic> json){
    userStories.clear();
    for(var item in json['data']){
      if(item['userstory'].isNotEmpty){
        userStories.add(Story.fromJson(item));
        if(Story.fromJson(item).userStories.isEmpty){
          userStories.removeLast();
        }
      }
    }
    notifyListeners();
  }

  updateIsSeen(int userID, int storyID){
    int userIndex = userStories.indexWhere((element) => element.userDetails.id == userID);
    int storyIndex = userStories[userIndex].userStories.indexWhere((element) => element.id == storyID);
    userStories[userIndex].userStories[storyIndex].isSeen = true;
    //userStories[userIndex].updateIsSeen();
    userStories[userIndex].isSeen = true;
    for(var item in userStories[userIndex].userStories){
      if(item.isSeen == false){
        userStories[userIndex].isSeen = false;
        break;
      }
    }
    notifyListeners();
  }

}

class Story{
  UserModel userDetails;
  List<Stories> userStories = [];
  bool isSeen;

  Story.fromJson(Map<String, dynamic> json){
    isSeen = true;
    userDetails = UserModel.fromStoryJson(json);
    for(var item in json['userstory']){
      if(DateTime.parse(item['created_at']).isBefore(DateTime.now().subtract(Duration(hours: 24)))){
        continue;
      }else{
        userStories.add(Stories.fromJson(item));
      }
    }
    for(var item in userStories){
      if(!item.isSeen){
        isSeen = false;
        break;
      }
    }
  }

  updateIsSeen(){
    for(var item in userStories){
      if(!item.isSeen){
        isSeen = false;
        break;
      }
    }
  }
}

class Stories{
  int id;
  String image;
  bool isSeen;
  String createdAt;

  Stories.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      image = json['image'];
      isSeen = json['is_seen'];
      createdAt = json['created_at'];
    }catch(e, stack){
      print("Stories.fromJson: " + stack.toString());
    }
  }
}