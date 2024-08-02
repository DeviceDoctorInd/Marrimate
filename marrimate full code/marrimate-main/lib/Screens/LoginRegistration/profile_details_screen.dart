// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'gender_screen.dart';

class ProfileDetailsScreen extends StatefulWidget {
  ProfileDetailsScreen({Key key}) : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  DateFormat dobFormatter = DateFormat("yyyy-MM-dd");
  bool invalidUsername = false;
  bool hidePassword = true;
  bool isLoading = false;
  bool fromSocial = false;
  PickedFile profilePicture;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  sourceDialog(var size){
    AwesomeDialog(
      context: context,
      animType: AnimType.SCALE,
      dialogType: DialogType.NO_HEADER,
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                VariableText(
                  text: 'Choose Source:',
                  fontsize: 17,
                  fontcolor: textColorB,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MyButton(
                  btnTxt: "Camera",
                  btnColor: primaryColor1,
                  txtColor: textColorW,
                  btnRadius: 25,
                  btnWidth: size.width * 0.45,
                  btnHeight: 50,
                  fontSize: size.height * 0.020,
                  weight: FontWeight.w700,
                  fontFamily: fontSemiBold,
                  onTap: () {
                    Navigator.pop(context);
                    uploadProfilePicture(true);
                  }),
            ),
            MyButton(
                btnTxt: "Gallery",
                btnColor: primaryColor1,
                txtColor: textColorW,
                btnRadius: 25,
                btnWidth: size.width * 0.45,
                btnHeight: 50,
                fontSize: size.height * 0.020,
                weight: FontWeight.w700,
                fontFamily: fontSemiBold,
                onTap: () {
                  Navigator.pop(context);
                  uploadProfilePicture(false);
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MyButton(
                  btnTxt: "Cancel",
                  borderColor: primaryColor1,
                  btnColor: textColorW,
                  txtColor: primaryColor1,
                  btnRadius: 25,
                  btnWidth: size.width * 0.45,
                  btnHeight: 50,
                  fontSize: size.height * 0.020,
                  weight: FontWeight.w700,
                  fontFamily: fontSemiBold,
                  onTap: () {
                    Navigator.pop(context);
                    //uploadPetPicture(true);
                  }),
            ),
          ],
        ),
      ),
      //btnCancelOnPress: (){}
    ).show();
  }

  uploadProfilePicture(bool fromCamera) async {
    String imageName;
    if(fromCamera){
      profilePicture = await _imgFromCamera();
      setState(() {});
    }else{
      profilePicture = await _imgFromGallery();
      setState(() {});
    }
  }

  Future _imgFromGallery() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(image != null) {
      ImageCropper cropper = new ImageCropper();
      File croppedFile = await cropper.cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.rectangle,
          maxHeight: 900,
          maxWidth: 1300,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            //CropAspectRatioPreset.ratio3x2,
            //CropAspectRatioPreset.original,
            //CropAspectRatioPreset.ratio4x3,
            //CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Edit image',
              toolbarColor: primaryColor1,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );
      if(croppedFile != null){
        setState(() {
          image = PickedFile(croppedFile.path);
        });
        return image;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

  Future _imgFromCamera() async {
    var image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      ImageCropper cropper = new ImageCropper();
      File croppedFile = await cropper.cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.rectangle,
          maxHeight: 900,
          maxWidth: 1300,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            //CropAspectRatioPreset.ratio3x2,
            //CropAspectRatioPreset.original,
            //CropAspectRatioPreset.ratio4x3,
            //CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Edit image',
              toolbarColor: primaryColor1,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )
      );
      if(croppedFile != null){
        setState(() {
          image = PickedFile(croppedFile.path);
        });
        return image;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }

  validate(){
    bool isOkay = false;
    if(nameController.text.isNotEmpty){
      if(usernameController.text.isNotEmpty){
        if(dobController.text.isNotEmpty){
          if(passwordController.text.isNotEmpty || fromSocial){
            if(profilePicture != null){
              isOkay = true;
            }else{
              Fluttertoast.showToast(
                  msg: "Please upload profile picture",
                  toastLength: Toast.LENGTH_SHORT);
            }
          }else{
            Fluttertoast.showToast(
                msg: "Please enter password",
                toastLength: Toast.LENGTH_SHORT);
          }
        }else{
          Fluttertoast.showToast(
              msg: "Please select DOB",
              toastLength: Toast.LENGTH_SHORT);
        }
      }else{
        Fluttertoast.showToast(
            msg: "Please enter username",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      Fluttertoast.showToast(
          msg: "Please enter full name",
          toastLength: Toast.LENGTH_SHORT);
    }
    return isOkay;
  }

  Future validateUsername()async{
    setLoading(true);
    var response = await API.checkUserName(usernameController.text);
    if(response != null){
      if(response){
        setState(() {
          invalidUsername = false;
        });
        setLoading(false);
        return true;
      }else{
        setLoading(false);
        setState(() {
          invalidUsername = true;
        });
        return false;
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
  }

  proceed(UserModel userDetails)async{
    if(validate()){
      FocusScope.of(context).unfocus();
      var response = await validateUsername();
      if(response){
       userDetails.name = nameController.text;
       userDetails.username = usernameController.text;
       userDetails.dob = dobController.text;
       userDetails.profilePicture = profilePicture.path;
       userDetails.password = passwordController.text;
       userDetails.hobbies = [];
        Navigator.push(
            context,
            SwipeLeftAnimationRoute(
              widget: GenderScreen(),
            ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var checkUser = Provider.of<UserModel>(context, listen: false);
    if(checkUser.providerID != null){
      fromSocial = true;
      initializeDetails(checkUser);
    }
  }

  initializeDetails(UserModel userDetails)async{
    setLoading(true);
    var response = await http.get(Uri.parse(userDetails.profilePicture));
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    File file = File(p.join(documentDirectory.path, 'socialImage.png'));
    file.writeAsBytesSync(response.bodyBytes);
    setState(() {
      nameController.text = userDetails.name;
      profilePicture = PickedFile(file.path);
    });
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context, listen: true);
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.20;
    return Scaffold(
      backgroundColor: textColorW,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Image.asset(
                  "assets/images/social_login_header.png",
                  width: size.height * 0.30,
                ),
              ),
              Positioned(
                top: size.height * 0.06,
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: size.height * 0.05,
                    width: size.width * 0.10,
                    padding: EdgeInsets.all(12),
                    child: Image.asset(
                      "assets/icons/ic_back.png",
                      color: Colors.black,
                      //height: size.height * 0.005,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.12),
                    Image.asset(
                      "assets/images/merrimate_logo.png",
                      width: size.height * 0.27,
                    ),
                    SizedBox(height: size.height * 0.08),
                    VariableText(
                      text: tr("Profile Details"),
                      fontFamily: fontMatchMaker,
                      fontcolor: primaryColor2,
                      fontsize: size.height * 0.044,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.016),
                    VariableText(
                      text: tr("Fill up the following details"),
                      fontFamily: fontMedium,
                      fontcolor: textColorG,
                      fontsize: size.height * 0.019,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.04),
                    profilePicture != null ? Container(
                      height: size.height * 0.12,
                      width: size.height * 0.12,
                      decoration: BoxDecoration(
                        //color: Colors.red,
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                              child: Image.file(File(profilePicture.path), fit: BoxFit.fill)
                          ),
                          InkWell(
                            onTap: (){
                              sourceDialog(size);
                            },
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                  height: size.height * 0.03,
                                  width: size.height * 0.03,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(55),
                                      border: Border.all(color: primaryColor1)
                                ),
                                child: Center(
                                  child: Icon(Icons.camera_alt_sharp, size: size.height * 0.019, color: primaryColor1)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ) :
                    InkWell(
                      onTap: (){
                        sourceDialog(size);
                      },
                      child: Image.asset(
                        "assets/images/profile_details.png",
                        width: size.height * 0.11,
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Container(
                      width: size.width,
                      height: size.height * 0.055,
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: TextFormField(
                        controller: nameController,
                        style: TextStyle(
                          fontFamily: fontRegular,
                          color: textColor1,
                          fontSize: size.height * 0.02,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Image.asset(
                              "assets/icons/ic_profile_name.png",
                              scale: 2.1,
                            ),
                            hintText: tr("Full Name"),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.0),
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 8, right: 8, bottom: 0)),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      width: size.width,
                      height: size.height * 0.055,
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: TextFormField(
                        controller: usernameController,
                        style: TextStyle(
                          fontFamily: fontRegular,
                          color: textColor1,
                          fontSize: size.height * 0.02,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Image.asset(
                              "assets/icons/ic_profile_name.png",
                              scale: 2.1,
                            ),
                            hintText: "Username",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: borderColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: borderColor, width: 1.0),
                            ),
                            contentPadding:
                            EdgeInsets.only(left: 8, right: 8, bottom: 0)),
                      ),
                    ),
                    if(invalidUsername)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              VariableText(
                                text: 'Username already taken!',
                                fontcolor: Colors.red,
                                fontsize: size.height * 0.016,
                              ),
                            ],
                          ),
                        ),
                      ),
                    invalidUsername ? SizedBox(height: size.height * 0.015) :
                    SizedBox(height: size.height * 0.02),
                    Container(
                      width: size.width,
                      height: size.height * 0.055,
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: TextFormField(
                        controller: dobController,
                        readOnly: true,
                        onTap: () async {
                          DateTime pickedDate = await showDatePicker(
                              context: context, //context of current state
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  1800), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(pickedDate);
                            setState(() {
                              dobController.text = dobFormatter.format(pickedDate);
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                        style: TextStyle(
                          fontFamily: fontRegular,
                          color: textColor1,
                          fontSize: size.height * 0.02,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Image.asset(
                              "assets/icons/ic_profile_name.png",
                              scale: 2.1,
                            ),
                            hintText: "DOB",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.0),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: borderColor, width: 1.0),
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              right: 8,
                            )),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    if(!fromSocial)
                      Container(
                      width: size.width,
                      height: size.height * 0.055,
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: hidePassword,
                        style: TextStyle(
                          fontFamily: fontRegular,
                          color: textColor1,
                          fontSize: size.height * 0.02,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Image.asset(
                              "assets/icons/ic_password2.png",
                              scale: 2.1,
                            ),
                            suffixIcon: InkWell(
                              onTap: (){
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              child: Image.asset(
                                "assets/icons/ic_password_show.png",
                                scale: 2.1,
                              ),
                            ),
                            hintText: "Password",
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: borderColor, width: 1.0),
                            ),
                            contentPadding: EdgeInsets.only(
                              left: 8,
                              right: 8,
                            )),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    MyButton(
                      onTap: () {
                        proceed(userDetails);
                      },
                      btnTxt: tr("CONTINUE"),
                      borderColor: primaryColor1,
                      btnColor: textColorW,
                      txtColor: primaryColor1,
                      btnRadius: 25,
                      btnWidth: size.width * 0.45,
                      btnHeight: 50,
                      fontSize: size.height * 0.020,
                      weight: FontWeight.w700,
                      fontFamily: fontSemiBold,
                    ),
                    // SizedBox(height: size.height * 0.01),
                  ],
                ),
              ),
              if(isLoading) ProcessLoadingLight()
            ],
          ),
        ),
      ),
    );
  }
}
