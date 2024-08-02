import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:marrimate/Screens/Dashboard/main_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/login_screen.dart';
import 'package:marrimate/Screens/splash_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/orientation_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

import 'enable_location_screen.dart';

class SexualOrientationScreen extends StatefulWidget {
  const SexualOrientationScreen({Key key}) : super(key: key);

  @override
  State<SexualOrientationScreen> createState() =>
      _SexualOrientationScreenState();
}

class _SexualOrientationScreenState extends State<SexualOrientationScreen> {
  bool isLoading = false;
  bool isLoadingMain = false;
  List<SOrientation> orientations = [];

  bool isTrue = false;
  int selectedIndex = -1;

  Location location = Location();
  FirebaseMessaging fbMessaging = FirebaseMessaging.instance;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }
  setLoadingMain(bool loading){
    setState(() {
      isLoadingMain = loading;
    });
  }
  onSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  getOrientations()async{
    setLoading(true);
    var response = await API.getAllOrientations();
    if(response != null){
      for(var item in response){
        orientations.add(SOrientation.fromJson(item));
      }
      setLoading(false);
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  createUserProfile(UserModel userDetails) async{
    var response = await API.createProfile(userDetails);
    if(response['status'] == true){
      //Provider.of<UserModel>(context, listen: false).userSignIn(response['data']);
      //SplashScreen.sp.setString('userAuth', response['data']['access_token']);
      //SplashScreen.sp.setString('fcmToken', response['data']['fcm_token']);
      SplashScreen.sp.setBool('firstTime', false);
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: "Profile Created Successfully",
          toastLength: Toast.LENGTH_LONG);
      Navigator.pushAndRemoveUntil(context,
          SwipeRightAnimationRoute(widget: LoginScreen()),
          (route) => route.isCurrent
      );
    }else{
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: response['msg'],
          toastLength: Toast.LENGTH_LONG);
    }
  }
  checkLocation(UserModel userDetails) async{
    Navigator.push(
        context,
        SwipeLeftAnimationRoute(
          widget: EnableLocationScreen(),
        )).then((value)async{
          if(value){
            setLoadingMain(true);
            bool locationService = await location.serviceEnabled();
            if(locationService){
              print("Fetching location!!");
              var loc = await location.getLocation().timeout(
                  const Duration(seconds: 4),
                  onTimeout: (){
                    setLoadingMain(false);
                    checkLocation(userDetails);
                  }
              );
              print("lat: ${loc.latitude}, long: ${loc.longitude}");
              userDetails.lat = loc.latitude.toString();
              userDetails.long = loc.longitude.toString();
              String token = await fbMessaging.getToken();
              //print("fb Token: $token");
              userDetails.fcmToken = token;
              userDetails.showOrientation = isTrue;
              createUserProfile(userDetails);
            }else{
              setLoadingMain(false);
            }

          }else{
            print("No Access");
          }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrientations();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context, listen: true);

    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.06;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: textColorW,
          body: Container(
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
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.085),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 4.4),
                      child: Image.asset(
                        "assets/images/merrimate_logo.png",
                        // width: size.height * 0.27,
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 2.5),
                      child: VariableText(
                        text: tr("My Sexual Orientation is ..."),
                        fontFamily: fontMatchMaker,
                        fontcolor: primaryColor2,
                        fontsize: size.height * 0.040,
                        textAlign: TextAlign.center,
                        max_lines: 2,
                        line_spacing: size.height * 0.0017,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    isLoading ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProcessLoadingWhite()
                        ],
                      ),
                    ) :
                    Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: padding * 1.5),
                          itemCount: orientations.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, int index) {
                            return Column(
                              children: [
                                SizedBox(height: size.height * 0.02),
                                Container(
                                    width: size.width,
                                    height: size.height * 0.05,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: padding),
                                    child: MyButton(
                                      onTap: () {
                                        onSelectedIndex(index);
                                      },
                                      btnTxt: orientations[index].name,
                                      borderColor: index == selectedIndex
                                          ? primaryColor1
                                          : borderColor,
                                      btnColor: index == selectedIndex
                                          ? primaryColor1
                                          : textColorW,
                                      txtColor: index == selectedIndex
                                          ? textColorW
                                          : textColorG,
                                      btnRadius: 4,
                                      btnWidth: size.width * 0.45,
                                      btnHeight: 50,
                                      fontSize: size.height * 0.020,
                                      weight: FontWeight.bold,
                                    )),
                              ],
                            );
                          }),
                    ),
                    if(!isLoading)
                      Padding(
                      padding: EdgeInsets.only(
                          left: padding * 1.85, top: padding * 0.3),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isTrue = !isTrue;
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: isTrue,
                              onChanged: (val) {
                                setState(() {
                                  isTrue = val;
                                });
                              },
                            ),
                            VariableText(
                              text: tr("Show my orientation on my profile"),
                              fontFamily: fontMedium,
                              fontcolor: textColorG,
                              fontsize: size.height * 0.018,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(!isLoading)
                      SizedBox(height: size.height * 0.014),
                    if(!isLoading)
                      Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding * 4),
                      child: MyButton(
                        onTap: () {
                          if(selectedIndex >= 0){
                            userDetails.orientation = orientations[selectedIndex];
                            checkLocation(userDetails);
                          }else{
                            Fluttertoast.showToast(
                                msg: "Please select your orientation",
                                toastLength: Toast.LENGTH_SHORT);
                          }
                        },
                        btnTxt: tr("Submit"),
                        borderColor: primaryColor1,
                        btnColor: textColorW,
                        txtColor: primaryColor1,
                        btnRadius: 25,
                        btnWidth: size.width * 0.45,
                        btnHeight: 50,
                        fontSize: size.height * 0.020,
                        weight: FontWeight.w700,
                        fontFamily: fontSemiBold,
                        // fontFamily: fontSemiBold,
                      ),
                    ),
                    if(!isLoading)
                      SizedBox(height: size.height * 0.01),
                  ],
                ),
              ],
            ),
          ),
        ),
        if(isLoadingMain) ProcessLoadingLight()
      ],
    );
  }
}
