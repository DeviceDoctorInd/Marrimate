
import 'package:marrimate/models/user_model.dart';

class RadarUser{
  UserModel userDetails;
  bool isLiked;
  bool isMatched;

  RadarUser.fromJson({Map<String, dynamic> user, bool matched}){
    userDetails = UserModel.fromRadar(user);
    isLiked = user['like'];
    isMatched = matched;
  }
}