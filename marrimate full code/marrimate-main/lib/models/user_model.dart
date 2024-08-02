
import 'package:flutter/material.dart';
import 'package:marrimate/models/coins_model.dart';
import 'package:marrimate/models/hobbies_model.dart';
import 'package:marrimate/models/orientation_model.dart';
import 'package:marrimate/models/plan_model.dart';
import 'package:marrimate/models/user_image_videos_model.dart';

import 'boosters_model.dart';
import 'user_privacy_model.dart';

class UserModel extends ChangeNotifier{
  int id;
  String name;
  String username;
  String email;
  String password;
  String contactNumber;
  String profilePicture;
  String shortBio;
  String dob;
  String gender;
  List<UserImage> userImages = [];
  List<UserVideo> userVideos = [];
  SOrientation orientation;
  List<Hobby> hobbies = [];
  Coins coins;
  String provider;
  String providerID;
  String providerToken;
  String accessToken;
  String lat;
  String long;
  String fcmToken;
  bool showOrientation;
  String createdAt;
  Privacy userPrivacy;
  bool onHoliday;
  LikeCount likeLimit;
  UserPlan userPlanDetails;
  UserBooster userBooster;
  bool isActive;

  UserModel({this.id, this.name, this.username, this.profilePicture, this.email,
    this.contactNumber, this.lat, this.long, this.dob, this.gender, this.orientation, this.password,
    this.hobbies, this.provider, this.userImages, this.userVideos, this.providerID, this.providerToken,
    this.accessToken, this.showOrientation, this.fcmToken, this.createdAt, this.coins,
    this.shortBio, this.userPrivacy, this.onHoliday, this.likeLimit, this.userPlanDetails,
    this.userBooster, this.isActive});

  userSignIn(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      username = json['username'];
      email = json['email'];
      contactNumber = json['phone'];
      profilePicture = json['profile_img'];
      shortBio = json['short_bio'];
      dob = json['date_of_birth'];
      gender = json['gender'];
      orientation = SOrientation.fromJson(json['sexual']);
      coins = Coins.fromJson(json['coin']);
      provider = json['provider'];
      providerID = json['provider_id'];
      providerToken = json['provider_token'];
      accessToken = json['access_token'];
      createdAt = json['created_at'];
      lat = json['latitude'];
      long = json['longitude'];
      fcmToken = json['fcm_token'];
      showOrientation = int.parse(json['show_orientation'].toString()) == 0 ? false : true;
      userPrivacy = Privacy.fromJson(json['userprivacy']);
      onHoliday = json['is_holiday'].toString() == "0" ? false : true;
      isActive = json['is_active'].toString() == "0" ? false : true;
      likeLimit = LikeCount.fromJson(json['likecount']);
      userPlanDetails = UserPlan.fromJson(json['userplan']);
      if(json['userbooster'] != null){
        userBooster = UserBooster.fromJson(json['userbooster']);
      }
      hobbies = [];
      userImages = [];
      userVideos = [];
      for(var item in json['userimages']){
        userImages.add(UserImage.fromJson(item));
      }
      for(var item in json['uservideos']){
        userVideos.add(UserVideo.fromJson(item));
      }
      for(var item in json['userhobby']){
        hobbies.add(Hobby.fromUserJson(item));
      }
      notifyListeners();
    }catch(e, stack){
      print("userSignIn: "+ stack.toString());
    }
  }

  UserModel.fromJson(Map<String, dynamic> json){
    try{
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    contactNumber = json['phone'];
    profilePicture = json['profile_img'];
    shortBio = json['short_bio'];
    dob = json['date_of_birth'];
    gender = json['gender'];
    orientation = SOrientation.fromJson(json['sexual']);
    provider = json['provider'];
    providerID = json['provider_id'];
    providerToken = json['provider_token'];
    accessToken = json['access_token'];
    createdAt = json['created_at'];
    lat = json['latitude'];
    long = json['longitude'];
    fcmToken = json['fcm_token'];
    showOrientation = int.parse(json['show_orientation'].toString()) == 0 ? false : true;
    userPrivacy = Privacy.fromJson(json['userprivacy']);
    onHoliday = json['is_holiday'].toString() == "0" ? false : true;
    isActive = json['is_active'].toString() == "0" ? false : true;
    if(json['userbooster'] != null){
      userBooster = UserBooster.fromJson(json['userbooster']);
    }
    //likeLimit = LikeCount.fromJson(json['likecount']);
    //userPlanDetails = UserPlan.fromJson(json['userplan']);
    hobbies = [];
    userImages = [];
    userVideos = [];
    for(var item in json['userimages']){
      userImages.add(UserImage.fromJson(item));
    }
    for(var item in json['uservideos']){
      userVideos.add(UserVideo.fromJson(item));
    }
    for(var item in json['userhobby']){
      hobbies.add(Hobby.fromUserJson(item));
      }
    }catch(e, stack){
      print("UserModel.fromJson: "+ stack.toString());
    }
  }
  UserModel.fromModel(UserModel userDetails){
    id = userDetails.id;
    name = userDetails.name;
    username = userDetails.username;
    email = userDetails.email;
    password = userDetails.password;
    contactNumber = userDetails.contactNumber;
    profilePicture = userDetails.profilePicture;
    dob = userDetails.dob;
    gender = userDetails.gender;
    orientation = userDetails.orientation;
    coins = userDetails.coins;
    userImages = userDetails.userImages;
    userVideos = userDetails.userVideos;
    hobbies = userDetails.hobbies;
    provider = userDetails.provider;
    providerID = userDetails.providerID;
    providerToken = userDetails.providerToken;
    lat = userDetails.lat;
    long = userDetails.long;
    fcmToken = userDetails.fcmToken;
    showOrientation = userDetails.showOrientation;
    userPrivacy = userDetails.userPrivacy;
    onHoliday = userDetails.onHoliday;
    isActive = userDetails.isActive;
    likeLimit = userDetails.likeLimit;
    userPlanDetails = userDetails.userPlanDetails;
    userBooster = userDetails.userBooster;
  }
  UserModel.fromMatchedJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      profilePicture = json['profile_img'];
    }catch(e, stack){
      print("fromMatchedJson: "+ stack.toString());
    }
  }
  UserModel.fromPartnerJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      username = json['username'];
      email = json['email'];
      contactNumber = json['phone'];
      profilePicture = json['profile_img'];
      shortBio = json['short_bio'];
      dob = json['date_of_birth'];
      gender = json['gender'];
      provider = json['provider'];
      providerID = json['provider_id'];
      providerToken = json['provider_token'];
      accessToken = json['access_token'];
      createdAt = json['created_at'];
      lat = json['latitude'];
      long = json['longitude'];
      fcmToken = json['fcm_token'];
      showOrientation = int.parse(json['show_orientation'].toString()) == 0 ? false : true;
      if(json['userprivacy'] != null){
        userPrivacy = Privacy.fromJson(json['userprivacy']);
      }
      onHoliday = json['is_holiday'].toString() == "0" ? false : true;
      isActive = json['is_active'].toString() == "0" ? false : true;
      hobbies = [];
      userImages = [];
      userVideos = [];
    }catch(e, stack){
      print("UserModel.fromPartnerJson: "+ stack.toString());
    }
  }
  UserModel.fromQuizJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      username = json['username'];
      email = json['email'];
      contactNumber = json['phone'];
      profilePicture = json['profile_img'];
      shortBio = json['short_bio'];
      dob = json['date_of_birth'];
      gender = json['gender'];
      provider = json['provider'];
      providerID = json['provider_id'];
      providerToken = json['provider_token'];
      accessToken = json['access_token'];
      createdAt = json['created_at'];
      lat = json['latitude'];
      long = json['longitude'];
      fcmToken = json['fcm_token'];
      hobbies = [];
      userImages = [];
      userVideos = [];
    }catch(e, stack){
      print("UserModel.fromQuizJson: "+ stack.toString());
    }
  }
  UserModel.fromChatJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      username = json['username'];
      profilePicture = json['profile_img'];
      fcmToken = json['fcm_token'];
      onHoliday = json['is_holiday'].toString() == "0" ? false : true;
    }catch(e, stack){
      print("fromChatJson: "+ stack.toString());
    }
  }
  UserModel.fromStoryJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      username = json['username'];
      email = json['email'];
      contactNumber = json['phone'];
      profilePicture = json['profile_img'];
      shortBio = json['short_bio'];
      dob = json['date_of_birth'];
      gender = json['gender'];
      provider = json['provider'];
      providerID = json['provider_id'];
      providerToken = json['provider_token'];
      accessToken = json['access_token'];
      createdAt = json['created_at'];
      lat = json['latitude'];
      long = json['longitude'];
      fcmToken = json['fcm_token'];
      showOrientation = int.parse(json['show_orientation'].toString()) == 0 ? false : true;
      hobbies = [];
      userImages = [];
      userVideos = [];
    }catch(e, stack){
      print("UserModel.fromStoryJson: "+ stack.toString());
    }
  }
  UserModel.fromLikes(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      username = json['username'];
      email = json['email'];
      contactNumber = json['phone'];
      profilePicture = json['profile_img'];
      shortBio = json['short_bio'];
      dob = json['date_of_birth'];
      gender = json['gender'];
      provider = json['provider'];
      providerID = json['provider_id'];
      providerToken = json['provider_token'];
      accessToken = json['access_token'];
      createdAt = json['created_at'];
      lat = json['latitude'];
      long = json['longitude'];
      fcmToken = json['fcm_token'];
      showOrientation = int.parse(json['show_orientation'].toString()) == 0 ? false : true;
      onHoliday = json['is_holiday'].toString() == "0" ? false : true;
      isActive = json['is_active'].toString() == "0" ? false : true;
      if(json['userbooster'] != null){
        userBooster = UserBooster.fromJson(json['userbooster']);
      }
      userImages = [];
      userVideos = [];
      for(var item in json['userimages']){
        userImages.add(UserImage.fromJson(item));
      }
      for(var item in json['uservideos']){
        userVideos.add(UserVideo.fromJson(item));
      }
    }catch(e, stack){
      print("UserModel.fromLikes: "+ stack.toString());
    }
  }
  UserModel.fromRadar(Map<String, dynamic> json){
    try{
      id = json['id'];
      name = json['name'];
      username = json['username'];
      email = json['email'];
      contactNumber = json['phone'];
      profilePicture = json['profile_img'];
      shortBio = json['short_bio'];
      dob = json['date_of_birth'];
      gender = json['gender'];
      orientation = SOrientation.fromJson(json['sexual']);
      provider = json['provider'];
      providerID = json['provider_id'];
      providerToken = json['provider_token'];
      accessToken = json['access_token'];
      createdAt = json['created_at'];
      lat = json['latitude'];
      long = json['longitude'];
      fcmToken = json['fcm_token'];
      showOrientation = int.parse(json['show_orientation'].toString()) == 0 ? false : true;
      userPrivacy = Privacy.fromJson(json['userprivacy']);
      onHoliday = json['is_holiday'].toString() == "0" ? false : true;
      isActive = json['is_active'].toString() == "0" ? false : true;
      hobbies = [];
      userImages = [];
      userVideos = [];
      for(var item in json['userimages']){
        userImages.add(UserImage.fromJson(item));
      }
      for(var item in json['uservideos']){
        userVideos.add(UserVideo.fromJson(item));
      }
      for(var item in json['userhobby']){
        hobbies.add(Hobby.fromUserJson(item));
      }
    }catch(e, stack){
      print("UserModel.fromRadar: "+ stack.toString());
    }
  }

  userLogout(){
    //try{
    id = null;
    name = null;
    username = null;
    email = null;
    contactNumber = null;
    profilePicture = null;
    shortBio = null;
    dob = null;
    gender = null;
    coins = null;
    userImages = [];
    userVideos = [];
    orientation = null;
    provider = null;
    providerID = null;
    providerToken = null;
    lat = null;
    long = null;
    fcmToken = null;
    showOrientation = null;
    userPrivacy = null;
    likeLimit = null;
    userPlanDetails = null;
    userBooster = null;
    accessToken = null;
    createdAt = null;
    hobbies = [];
      //}
      notifyListeners();
      //}catch(e){
      //print("userSignIn: "+e.toString());
    }

  setNewUser(UserModel userDetails){
    id = userDetails.id;
    name = userDetails.name;
    username = userDetails.username;
    email = userDetails.email;
    password = userDetails.password;
    contactNumber = userDetails.contactNumber;
    profilePicture = userDetails.profilePicture;
    dob = userDetails.dob;
    gender = userDetails.gender;
    lat = userDetails.lat;
    long = userDetails.long;
    fcmToken = userDetails.fcmToken;
    showOrientation = userDetails.showOrientation;
    onHoliday = userDetails.onHoliday;
    isActive = userDetails.isActive;
    orientation = userDetails.orientation;
    coins = userDetails.coins;
    userPrivacy = userDetails.userPrivacy;
    userImages = userDetails.userImages;
    userVideos = userDetails.userVideos;
    hobbies = userDetails.hobbies;
    provider = userDetails.provider;
    providerID = userDetails.providerID;
    providerToken = userDetails.providerToken;
    likeLimit = userDetails.likeLimit;
    userPlanDetails = userDetails.userPlanDetails;
    userBooster = userDetails.userBooster;
    notifyListeners();
  }

  updateUser(UserModel userDetails){
    name = userDetails.name;
    shortBio = userDetails.shortBio;
    email = userDetails.email;
    notifyListeners();
  }
  updateUserProfile(String userImage){
    profilePicture = userImage;
    notifyListeners();
  }
  updateUserImage(var userImage){
    userImages.add(UserImage.fromJson(userImage));
    notifyListeners();
  }
  updateUserVideo(var userVideo){
    userVideos.add(UserVideo.fromJson(userVideo));
    notifyListeners();
  }
  deleteUserImage(int imgID){
    userImages.removeWhere((element) => element.id == imgID);
    notifyListeners();
  }
  deleteUserVideo(int videoID){
    userVideos.removeWhere((element) => element.id == videoID);
    notifyListeners();
  }

  removeHobby(int id){
    hobbies.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  updateCoins(String updatedCoins){
    coins.totalCoins = updatedCoins;
    notifyListeners();
  }

  updatePrivacyOptions(Privacy privacyDetails){
    userPrivacy = privacyDetails.toUpdateModel(privacyDetails);
    notifyListeners();
  }

  updateUserPlan(Plan planDetails, String updateDate){
    userPlanDetails.planID = planDetails.id;
    userPlanDetails.dateTime = updateDate;
    notifyListeners();
  }

  updateUserBooster(Booster boosterDetails, String updateDate){
    userBooster.boosterID = boosterDetails.id;
    userBooster.dateTime = updateDate;
    userBooster.weight = boosterDetails.weight;
    notifyListeners();
  }

  incrementLikeCount(){
    likeLimit.totalLikes++;
    notifyListeners();
  }

  resetLikeCount(){
    likeLimit.totalLikes = 0;
    notifyListeners();
  }

}

class LikeCount{
  int totalLikes;
  String startDate;
  
  LikeCount.fromJson(Map<String, dynamic> json){
    try{
      totalLikes = int.parse(json['total_likes'].toString());
      startDate = json['created_at'];
    }catch(e, stack){
      print("LikeCount.fromJson: " + stack.toString());
    }
  }
}
class UserPlan{
  int planID;
  String dateTime;

  UserPlan.fromJson(Map<String, dynamic> json){
    try{
      planID = int.tryParse(json['subscription_plan_id'].toString());
      dateTime = json['updated_at'];
    }catch(e, stack){
      print("UserPlan.fromJson: " + stack.toString());
    }
  }
}
class UserBooster{
  int boosterID;
  int weight;
  String dateTime;

  UserBooster.fromJson(Map<String, dynamic> json){
    try{
      if(json['booster_id'] != null){
        boosterID = int.tryParse(json['booster_id'].toString());
        weight = int.tryParse(json['booster']['weight'].toString());
        dateTime = json['updated_at'];
      }else{
        boosterID = null;
        weight = null;
        dateTime = null;
      }
    }catch(e, stack){
      print("UserBooster.fromJson: " + stack.toString());
    }
  }
}

