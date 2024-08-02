import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:marrimate/models/new_quiz_model.dart';
import 'package:marrimate/models/notification_model.dart';
import 'package:marrimate/models/order_model.dart';
import 'package:marrimate/models/quiz_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/models/user_privacy_model.dart';

class API{
  //static String baseUrl = "https://merrimate.innova8ors.com/api/";
  static String baseUrl = "https://merrimate.com/api/";

  ///Signup/Login
  static Future<dynamic> checkUserExist(String contactNumber) async {
    String url = baseUrl + 'checkUserPhone';
    print(url);
    print(contactNumber);
    var postData = {
      "phone": contactNumber,
    };
    try {
      var response = await http.post(
        Uri.parse(url),
        body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data['status'];
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("checkUserExist Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> checkUserName(String username) async {
    String url = baseUrl + 'checkUserName';
    print(url);
    print(username);
   var postData = {
      "username": username,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['status'];
      }else{
        return null;
      }
    } catch (e) {
      print("checkUserName Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getAllHobbies() async {
    String url = baseUrl + 'getHobbies';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['data'];
      }else{
        return null;
      }
    } catch (e) {
      print("getAllHobbies Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getAllOrientations() async {
    String url = baseUrl + 'getSexual';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['data'];
      }else{
        return null;
      }
    } catch (e) {
      print("getAllOrientations Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> createProfile(UserModel userDetails) async {
    String url = baseUrl + 'createProfile';
    print(url);
    File tempFile = File(userDetails.profilePicture);
    var image = await MultipartFile.fromFile(tempFile.path,
        filename: tempFile.path.split('/').last,
        contentType: MediaType('image', 'jpg'));
    FormData postData = FormData.fromMap({
      "name": userDetails.name,
      "username": userDetails.username,
      "phone": userDetails.contactNumber,
      "email": userDetails.email,
      "date_of_birth": userDetails.dob,
      "gender": userDetails.gender,
      "sexual_id": userDetails.orientation.id,
      "provider": userDetails.provider,
      "provider_id": userDetails.providerID,
      "latitude": userDetails.lat,
      "longitude": userDetails.long,
      "fcm_token": userDetails.fcmToken,
      "show_orientation": userDetails.showOrientation ? "1": "0"
    });
    if(userDetails.providerID == null){
      postData.fields.add(MapEntry("password", userDetails.password));
    }
    for(int i=0; i < userDetails.hobbies.length; i++){
      postData.fields.add(MapEntry("hobbies_id[$i]", userDetails.hobbies[i].id.toString()));
    }

    postData.files.add(MapEntry("profile_img", image));

    try {
      Dio dio = new Dio();
      var response = await dio.post(url,
          data: postData,
          options: Options(
              contentType: 'multipart/form-data; boundary=1000',
              headers: <String, String>{"Content-Type": "application/json",
                "Accept": "application/json"}
          ));
      print(response.statusCode.toString());
      return response.data;
    } catch (e) {
      print("CreateProfile Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      print("CreateProfile Exception: " + e.toString());
      return data;
    }
  }
  static Future<dynamic> userLogin({String contact, String password}) async {
    String url = baseUrl + 'userLogin';
    print(url);
    print(contact +" "+ password);
    var postData = {
      "phone": contact,
      "password": password
    };

    try {
      var response = await http.post(
          Uri.parse(url),
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("userLogin Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getSingleUser(String accessToken) async {
    String url = baseUrl + 'profile/getSingleUser';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getSingleUser Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getFacebookLogin(String token) async {
    String url = 'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture.width(640),email&access_token=$token';
    print(url.toString());
    try {
      var response = await http.get(Uri.parse(url));
     print(response.statusCode.toString());
      return response;
    } catch (e, stack) {
      print("getFacebookLogin: " + e.toString());
    }
  }
  static Future<dynamic> checkSocialUser(String providerID) async {
    String url = baseUrl + 'social/socialLogin';
    print(url);
    print(providerID);
    var postData = {
      "provider_id": providerID,
    };

    try {
      var response = await http.post(
          Uri.parse(url),
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("checkSocialUser Exception: " + e.toString());
      return null;
    }
  }

  ///Recovery
  static Future<dynamic> resetPassword({String contactNumber, String password}) async {
    String url = baseUrl + 'resetPassword';
    print(url);
    print(contactNumber);
    var postData = {
      "phone": contactNumber,
      "password": password
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("resetPassword Exception: " + e.toString());
      return null;
    }
  }


  ///User Profile
  static Future<dynamic> editProfile({UserModel userDetails, bool newImage}) async {
    String url = baseUrl + 'profile/editProfile';
    print(url);
    FormData postData = FormData.fromMap({
      "new_img": newImage.toString(),
    });
    if(newImage){
       File tempFile = File(userDetails.profilePicture);
        var image = await MultipartFile.fromFile(tempFile.path,
        filename: tempFile.path.split('/').last,
        contentType: MediaType('image', 'jpg'));
      postData.files.add(MapEntry("profile_img", image));
    }else{
      postData.fields.add(MapEntry("name", userDetails.name));
      postData.fields.add(MapEntry("short_bio", userDetails.shortBio.isEmpty ? "" : userDetails.shortBio));
      if(userDetails.email != null){
        postData.fields.add(MapEntry("email", userDetails.email));
      }
      for(int i=0; i < userDetails.hobbies.length; i++){
        postData.fields.add(MapEntry("hobbies_id[$i]", userDetails.hobbies[i].id.toString()));
      }
    }

    print(postData.fields.toString());
    print(postData.files.toString());
    try {
      Dio dio = new Dio();
      var response = await dio.post(url,
          data: postData,
          options: Options(
              contentType: 'multipart/form-data; boundary=1000',
              headers: <String, String>{"Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization":"Bearer " + userDetails.accessToken
              }
          ));
      print(response.statusCode.toString());
      return response.data;
    } catch (e) {
      print("editProfile Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      print("editProfile Exception: " + e.toString());
      return data;
    }
  }
  static Future<dynamic> updateFcmToken({String accessToken, String fcmToken}) async {
    String url = baseUrl + 'profile/updateFcmToken';
    print(url);
    var postData = {
      "fcm_token": fcmToken
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("updateFcmToken Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> uploadUserImage({String imagePath, UserModel userDetails}) async {
    String url = baseUrl + 'profile/uploadUserImg';
    print(url);

    File tempFile = File(imagePath);
    var image = await MultipartFile.fromFile(tempFile.path,
        filename: tempFile.path.split('/').last,
        contentType: MediaType('image', 'jpg'));
    FormData postData = FormData.fromMap({
      "u_images": image,
    });

    try {
      Dio dio = new Dio();
      var response = await dio.post(url,
          data: postData,
          options: Options(
              contentType: 'multipart/form-data; boundary=1000',
              headers: <String, String>{"Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization":"Bearer " + userDetails.accessToken
              }
          ));
      print(response.statusCode.toString());
      return response.data;
    } catch (e) {
      print("uploadUserImage Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      print("uploadUserImage Exception: " + e.toString());
      return data;
    }
  }
  static Future<dynamic> deleteUserImage(int imgID, String accessToken) async {
    String url = baseUrl + 'profile/deleteUserImg/${imgID.toString()}';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }
    } catch (e) {
      print("deleteUserImage Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      return data;
    }
  }
  static Future<dynamic> uploadUserVideo({File video, UserModel userDetails}) async {
    String url = baseUrl + 'profile/uploadUserVid';
    print(url);

    //File tempFile = File(videoPath);
    MultipartFile image = await MultipartFile.fromFile(video.path,
        filename: video.path.split('/').last,
        contentType: MediaType('video', 'mp4'));
    FormData postData = FormData.fromMap({
      "u_videos": image,
    });
    try {
      Dio dio = new Dio();
      var response = await dio.post(url,
          data: postData,
          options: Options(
              contentType: 'multipart/form-data; boundary=2000',
              headers: <String, String>{"Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization":"Bearer " + userDetails.accessToken
              }
          ));
      print(response.statusCode.toString());
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print("uploadUserVideo Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      print("uploadUserVideo Exception: " + e.toString());
      return data;
    }
  }
  static Future<dynamic> deleteUserVideo(int videoID, String accessToken) async {
    String url = baseUrl + 'profile/deleteUserVid/${videoID.toString()}';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }
    } catch (e) {
      print("deleteUserVideo Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      return data;
    }
  }
  static Future<dynamic> deactivateAccount(UserModel userDetails) async {
    String url = baseUrl + 'privacy/accountStatus';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },

      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("deactivateAccount Exception: " + e.toString());
      return null;
    }
  }

  ///Stories
  static Future<dynamic> getMyStories(String accessToken) async {
    String url = baseUrl + 'getStory';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getMatchedStories Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getMatchedStories(String accessToken) async {
    String url = baseUrl + 'getMatchedStory';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getMatchedStories Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> uploadStory({File storyImage, UserModel userDetails}) async {
    String url = baseUrl + 'uploadStory';
    print(url);
    FormData postData = FormData.fromMap({});
    var image = await MultipartFile.fromFile(storyImage.path,
        filename: storyImage.path.split('/').last,
        contentType: MediaType('image', 'jpg'));

    postData.files.add(MapEntry("image", image));

    print(postData.files.toString());
    try {
      Dio dio = new Dio();
      var response = await dio.post(url,
          data: postData,
          options: Options(
              contentType: 'multipart/form-data; boundary=1000',
              headers: <String, String>{"Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization":"Bearer " + userDetails.accessToken
              }
          ));
      print(response.statusCode.toString());
      return response.data;
    } catch (e) {
      print("uploadStory Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      print("uploadStory Exception: " + e.toString());
      return data;
    }
  }
  static Future<dynamic> updateStorySeen(UserModel userDetails, {int storyID}) async {
    String url = baseUrl + 'sceneStory';
    print(url);
    print(storyID.toString());
    var postData = {
      "story_id": storyID.toString(),
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        //print(data.toString());
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("updateStorySeen Exception: " + e.toString());
      return null;
    }
  }

  ///Match
  static Future<dynamic> getCandidates(String accessToken) async {
    String url = baseUrl + 'getPartners';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getCandidates Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getSinglePartner(int userID, String accessToken) async {
    String url = baseUrl + 'getSinglePartner/${userID}';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getSinglePartner Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> partnerAction(UserModel userDetails, {int partnerID, String type}) async {
    String url = baseUrl + 'userLikes';
    print(url);
    print(partnerID.toString());
    var postData = {
      "user_like": partnerID.toString(),
      "type": type
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("partnerAction Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getMatchedPartners(String accessToken) async {
    String url = baseUrl + 'getMatchedPartners';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getMatchedPartners Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getMyLiked(String accessToken) async {
    String url = baseUrl + 'getYouLiked';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getMyLiked Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getLikedBy(String accessToken) async {
    String url = baseUrl + 'getLikedBy';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getLikedBy Exception: " + e.toString());
      return null;
    }
  }

  ///Radar
  static Future<dynamic> getAllUsers(String accessToken) async {
    String url = baseUrl + 'getAllUsers';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getAllUsers Exception: " + e.toString());
      return null;
    }
  }

  ///Block
  static Future<dynamic> getBlockedUser(String accessToken) async {
    String url = baseUrl + 'getBlockUser';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getBlockedUser Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> blockUser(int userID, UserModel userDetails) async {
    String url = baseUrl + 'blockUser';
    print(url);
    print(userID.toString());
    var postData = {
      "blocked": userID.toString()
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("blockUser Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> unBlockUser(int userID, String accessToken) async {
    String url = baseUrl + 'unblockUser/${userID.toString()}';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("unBlockUser Exception: " + e.toString());
      return null;
    }
  }

  ///Chat
  static Future<dynamic> getChatList(String accessToken) async {
    String url = baseUrl + 'chat/getMessageList';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getChatList Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getAllMessages(int userID, String accessToken) async {
    String url = baseUrl + 'chat/getChatHistory/$userID';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getAllMessages Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> uploadImage({File uploadedImage, UserModel userDetails}) async {
    String url = baseUrl + 'chat/uploadImage';
    print(url);
    FormData postData = FormData.fromMap({});
    var image = await MultipartFile.fromFile(uploadedImage.path,
        filename: uploadedImage.path.split('/').last,
        contentType: MediaType('image', 'jpg'));

    postData.files.add(MapEntry("image", image));

    print(postData.files.toString());
    try {
      Dio dio = new Dio();
      var response = await dio.post(url,
          data: postData,
          options: Options(
              contentType: 'multipart/form-data; boundary=1000',
              headers: <String, String>{"Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization":"Bearer " + userDetails.accessToken
              }
          ));
      print(response.statusCode.toString());
      return response.data;
    } catch (e) {
      print("uploadImage Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      print("uploadImage Exception: " + e.toString());
      return data;
    }
  }
  static Future<dynamic> uploadVoiceNote({File voiceNote, UserModel userDetails}) async {
    String url = baseUrl + 'chat/uploadImage';
    print(url);
    FormData postData = FormData.fromMap({});
    var image = await MultipartFile.fromFile(voiceNote.path,
        filename: voiceNote.path.split('/').last,
        contentType: MediaType('music', 'mp3'));

    postData.files.add(MapEntry("image", image));

    print(postData.files.toString());
    try {
      Dio dio = new Dio();
      var response = await dio.post(url,
          data: postData,
          options: Options(
              contentType: 'multipart/form-data; boundary=1000',
              headers: <String, String>{"Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization":"Bearer " + userDetails.accessToken
              }
          ));
      print(response.statusCode.toString());
      return response.data;
    } catch (e) {
      print("uploadVoiceNote Exception: " + e.toString());
      var data = jsonDecode(e.response.toString());
      print(data.toString());
      print("uploadVoiceNote Exception: " + e.toString());
      return data;
    }
  }
  static Future<dynamic> sendMessage({int userID, String content, String type, String accessToken}) async {
    String url = baseUrl + 'chat/sendMessage';
    print(url);
    var postData = {
      "user_id": userID.toString(),
      "content": content,
      "type": type
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("sendMessage Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> seenMessage({int senderID, String accessToken}) async {
    String url = baseUrl + 'chat/seenMessage';
    print(url);
    var postData = {
      "sender_id": senderID.toString()
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        print(response.body);
        return null;
      }
    } catch (e) {
      print("seenMessage Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> sendCallRequest({int receiverID, String channel, String type, String accessToken}) async {
    String url = baseUrl + 'requestChannel';
    print(url);
    var postData = {
      "receiver_id": receiverID.toString(),
      "channel_name": channel,
      "type": type,
      "status": "active",
      "token": "123"
    };
    print(postData.toString());
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        print(response.body);
        return null;
      }
    } catch (e) {
      print("seenVideoCallRequest Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> updateVideoCallRequest({int callID}) async {
    String url = baseUrl + 'updateChannelStatus';
    print(url);
    var postData = {
      "id": callID.toString()
    };
    print(postData.toString());
    try {
      var response = await http.post(
          Uri.parse(url),
          body: postData
      );
      if (response.statusCode == 200) {
        var data = response.body;
        return data;
      }else{
        print(response.body);
        return null;
      }
    } catch (e, stack) {
      print("updateVideoCallRequest Exception: " + stack.toString());
      return null;
    }
  }
  static Future<dynamic> getCallChannels(String accessToken) async {
    String url = baseUrl + 'getUserChannel';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getCallChannels Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getSingleCallChannel(int callID, String accessToken) async {
    String url = baseUrl + 'getSingleChannel/${callID}';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + accessToken}
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getSingleCallChannel Exception: " + e.toString());
      return null;
    }
  }



  ///Gifts
  static Future<dynamic> getAllGifts() async {
    String url = baseUrl + 'gift/getAllGift';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url)
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getAllGifts Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> createOrder({Order orderDetails}) async {
    String url = baseUrl + 'gift/createGiftOrder';
    print(url);

    try {
      var response = await http.post(
          Uri.parse(url),
          body: orderDetails.toJsonUpload(orderDetails)
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("createOrder Exception: " + e.toString());
      return null;
    }
  }

  ///Coins
  static Future<dynamic> claimCoins(String coins, UserModel userDetails) async {
    String url = baseUrl + 'coin/dailyCheckIn';
    print(url);
    var postData = {
      "coins": coins
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("claimCoins Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> sendCoins(String coins, UserModel partnerDetails, UserModel userDetails) async {
    String url = baseUrl + 'coin/sendCoin';
    print(url);
    var postData = {
      "send_to": partnerDetails.id.toString(),
      "coins_send": coins
    };
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("sendCoins Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getCoinsHistory(UserModel userDetails) async {
    String url = baseUrl + 'coin/coinHistory';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getCoinsHistory Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getCoinPackages() async {
    String url = baseUrl + 'coin/getCoinPackages';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getCoinPackages Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> buyCoins(
      {String totalCoins, String transactionID, UserModel userDetails}) async {
    String url = baseUrl + 'coin/buyCoinPackage';
    print(url);
    try {
      Map<String, dynamic> postData = {
        "total_coins": totalCoins,
        "transaction_id": transactionID,
      };
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: jsonEncode(postData)
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("updateSubscription Exception: " + e.toString());
      return null;
    }
  }

  ///Quiz
  static Future<dynamic> getAllQuiz(UserModel userDetails) async {
    String url = baseUrl + 'quiz/getUserQuiz';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getAllQuiz Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getSingleQuiz(int quizID, UserModel userDetails) async {
    String url = baseUrl + 'quiz/getSingleQuiz/$quizID';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getSingleQuiz Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> createQuiz(NewQuiz quizDetails, UserModel userDetails) async {
    String url = baseUrl + 'quiz/creteQuiz';
    print(url);
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":"Bearer " + userDetails.accessToken
        },
        body: jsonEncode(quizDetails.toCreateJson(quizDetails.quiz))
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("createQuiz Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> checkQuiz(int quizID, UserModel userDetails) async {
    String url = baseUrl + 'quiz/checkQuiz';
    print(url);
    try {
      Map<String, dynamic> postData = {
        "quiz_id": quizID.toString(),
        "performed_by": userDetails.id.toString()
      };
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
        body: postData
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("checkQuiz Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> publishResult(Quiz quizDetails, String result, UserModel userDetails) async {
    String url = baseUrl + 'quiz/publishResult';
    print(url);
    try {
      Map<String, dynamic> postData = {
        "quiz_id": quizDetails.id,
        "user_id": quizDetails.creatorDetails.id,
        "performed_by": userDetails.id,
        "score": result
      };
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: jsonEncode(postData)
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("publishResult Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> getLeaderboard(UserModel userDetails) async {
    String url = baseUrl + 'quiz/getLeaderboard';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getLeaderboard Exception: " + e.toString());
      return null;
    }
  }

  ///Notifications
  static Future<dynamic> getAllNotifications(UserModel userDetails) async {
    String url = baseUrl + 'getNotification';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getAllNotifications Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> readNotification(int notificationID, UserModel userDetails) async {
    String url = baseUrl + 'updateNotification/$notificationID';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("readNotification Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> addNotification(MyNotification notificationDetails, UserModel userDetails) async {
    String url = baseUrl + 'sendNotification';
    print(url);
    try {
      Map<String, dynamic> postData = {
        "notification_to": notificationDetails.userID,
        "title": notificationDetails.title,
        "content": notificationDetails.content
      };
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: jsonEncode(postData)
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("addNotification Exception: " + e.toString());
      return null;
    }
  }

  ///Subscription
  static Future<dynamic> getAllSubscription(UserModel userDetails) async {
    String url = baseUrl + 'plan/getSubscriptionPlan';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getAllSubscription Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> resetLikeCount(String userToken) async {
    String url = baseUrl + 'profile/resetLikeCount';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("resetLikeCount Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> updateSubscription(
      {int planID, String transactionID, UserModel userDetails}) async {
    String url = baseUrl + 'plan/updateSubscriptionPlan';
    print(url);
    try {
      Map<String, dynamic> postData = {
        "plan_id": planID,
        "transaction_id": transactionID,
      };
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: jsonEncode(postData)
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("updateSubscription Exception: " + e.toString());
      return null;
    }
  }

  ///Profile Boosters
  static Future<dynamic> getAllBoosters(UserModel userDetails) async {
    String url = baseUrl + 'plan/getBooster';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getAllBoosters Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> updateBooster(
      {int boosterID, String transactionID, UserModel userDetails}) async {
    String url = baseUrl + 'plan/updateBooster';
    print(url);
    try {
      Map<String, dynamic> postData = {
        "booster_id": boosterID,
        "transaction_id": transactionID,
      };
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: jsonEncode(postData)
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data.toString());
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("updateBooster Exception: " + e.toString());
      return null;
    }
  }

  ///Privacy
  static Future<dynamic> getPrivacyList(UserModel userDetails) async {
    String url = baseUrl + 'privacy/getPrivacyList';
    print(url);
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          "Authorization":"Bearer " + userDetails.accessToken
        },
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        return null;
      }
    } catch (e) {
      print("getPrivacyList Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> updatePrivacyList(Privacy privacyDetails, UserModel userDetails) async {
    String url = baseUrl + 'privacy/updatePrivacy';
    print(url);
    try {
      var response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization":"Bearer " + userDetails.accessToken
          },
          body: jsonEncode(privacyDetails.toUpdate(privacyDetails))
      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("updatePrivacyList Exception: " + e.toString());
      return null;
    }
  }
  static Future<dynamic> toggleHolidayMode(UserModel userDetails) async {
    String url = baseUrl + 'privacy/updateHoliday';
    print(url);
    try {
      var response = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            "Authorization":"Bearer " + userDetails.accessToken
          },

      );
      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        return data;
      }else{
        print(response.body.toString());
        return null;
      }
    } catch (e) {
      print("toggleHolidayMode Exception: " + e.toString());
      return null;
    }
  }
}