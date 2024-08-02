
class Privacy{
  int id;
  bool showEmail;
  bool showDob;
  bool showContact;
  bool showLocation;
  bool showBio;
  String preferredGender;
  String ageRange;
  int whoSeeYou;

  Privacy({this.id, this.showDob, this.whoSeeYou, this.ageRange, this.showBio,
  this.preferredGender, this.showLocation, this.showContact, this.showEmail});

  Privacy.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      showEmail = json['email'] == "1" ? true : false;
      showDob = json['dob'] == "1" ? true : false;
      showContact = json['phone'] == "1" ? true : false;
      showBio = json['bio'] == "1" ? true : false;
      showLocation = json['location'] == "1" ? true : false;
      preferredGender = json['gender'];
      ageRange = json['age_range'];
      whoSeeYou = int.tryParse(json['privacy_list_id'].toString());
    }catch(e){
      print("Privacy.fromJson: " + e.toString());
    }
  }

  Map<String, dynamic> toUpdate(Privacy privacyDetails){
    Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = privacyDetails.showEmail;
    data['phone'] = privacyDetails.showContact;
    data['bio'] = privacyDetails.showBio;
    data['location'] = privacyDetails.showLocation;
    data['dob'] = privacyDetails.showDob;
    data['gender'] = privacyDetails.preferredGender;
    data['age_range'] = privacyDetails.ageRange;
    data['privacy_list_id'] = privacyDetails.whoSeeYou;
    return data;
  }

  Privacy toUpdateModel(Privacy privacyDetails){
    Privacy privacyDetailsTemp = Privacy(
        showEmail: privacyDetails.showEmail,
        showContact: privacyDetails.showContact,
        showDob: privacyDetails.showDob,
        showLocation: privacyDetails.showLocation,
        showBio: privacyDetails.showBio,
        preferredGender: privacyDetails.preferredGender,
        ageRange: privacyDetails.ageRange,
        whoSeeYou: privacyDetails.whoSeeYou
    );
    return privacyDetailsTemp;
  }
}

class PrivacyList{
  int id;
  String name;

  PrivacyList.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['list_name'];
  }
}