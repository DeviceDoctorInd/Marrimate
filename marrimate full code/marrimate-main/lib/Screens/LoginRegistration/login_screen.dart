// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marrimate/Screens/Dashboard/main_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/phone_no_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/user_activate_screen.dart';
import 'package:marrimate/Screens/Recovery/recovery_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/constants.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/partner_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/models/match_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

import '../../models/filters_model.dart';
import '../splash_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController contactController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  String selectedCode = "+1";
  bool isLoading = false;
  FirebaseMessaging fbMessaging = FirebaseMessaging.instance;

  setLoading(bool loading){
   setState(() {
     isLoading = loading;
   });
  }

  Future<bool> onWillPop() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes', style: TextStyle(color: Colors.red)),
              onPressed: () {
                exit(0);
              },
            )
          ],
        );
      },
    ) ??
        false;
  }

  userLogin()async{
    if(validate()){
      FocusScope.of(context).unfocus();
      setLoading(true);
      try{
        var response = await API.userLogin(
            contact: selectedCode + contactController.text,
            password: passwordController.text
        );
        if(response != null){
          if(response['status']){
            String token = await fbMessaging.getToken();
            if(response['data']['fcm_token'] != token){
              print("Updating FCM Token");
              var tokenResponse = await API.updateFcmToken(
                  accessToken: response['data']['access_token'],
                fcmToken: token
              );
            }
            Provider.of<UserModel>(context, listen: false).userSignIn(response['data']);
            SplashScreen.sp.setString('userAuth', response['data']['access_token']);
            SplashScreen.sp.setBool('firstTime', false);
            var userDetails = Provider.of<UserModel>(context, listen: false);
            var myFilters = Provider.of<Filters>(context, listen: false);
            if(userDetails.userPlanDetails.planID != 4){
              if(DateTime.parse(userDetails.likeLimit.startDate).add(Duration(days: Constants.getDaysLimit(userDetails.userPlanDetails.planID))).isBefore(DateTime.now())){
                print("### Reset Count");
                var responseReset = await API.resetLikeCount(userDetails.accessToken);
                Provider.of<UserModel>(context, listen: false).resetLikeCount();
              }
            }
            var responseCandidate = await API.getCandidates(response['data']['access_token']);
            if(responseCandidate != null){
              Provider.of<Match>(context, listen: false).loadCandidates(responseCandidate, userDetails, myFilters);
              var responsePartners = await API.getMatchedPartners(response['data']['access_token']);
              if(responsePartners != null){
                Provider.of<Partner>(context, listen: false).loadPartners(responsePartners);
              }else{
                Provider.of<Partner>(context, listen: false).initialize();
              }
              setLoading(false);
              if(userDetails.isActive){
                Navigator.push(
                    context,
                    SwipeLeftAnimationRoute(
                      widget: MainScreen(),
                    ));
              }else{
                Navigator.push(
                    context,
                    SwipeLeftAnimationRoute(
                      widget: ActivateScreen(),
                    ));
              }
            }else{
              setLoading(false);
            }
          }else{
            setLoading(false);
            Fluttertoast.showToast(
                msg: response['msg'],
                toastLength: Toast.LENGTH_LONG);
          }
        }else{
          setLoading(false);
          Fluttertoast.showToast(
              msg: "Try again later",
              toastLength: Toast.LENGTH_SHORT);
        }
      }catch(e, stack){
        print("userLogin: " + stack.toString());
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT);
      }
    }
  }

  validate(){
    bool isOkay = false;
    if(contactController.text.isNotEmpty){
      if(contactController.text.length == 10){
        if(passwordController.text.isNotEmpty){
          isOkay = true;
        }else{
          Fluttertoast.showToast(
              msg: "Please enter password",
              toastLength: Toast.LENGTH_SHORT);
        }
      }else{
        Fluttertoast.showToast(
            msg: "Please enter valid contact",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      Fluttertoast.showToast(
          msg: "Please enter contact number",
          toastLength: Toast.LENGTH_SHORT);
    }
    return isOkay;
  }

  signInWithFacebook() async{
    Provider.of<UserModel>(context,listen: false).userLogout();
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        setLoading(true);
        print("Logged In");
        final token = result.accessToken.token;
        final graphResponse = await API.getFacebookLogin(token);
        final userData = jsonDecode(graphResponse.body);
        print(userData.toString());
        var response = await API.checkSocialUser(userData['id'].toString());
        if(response != null){
          if(response['status']){
            String token = await fbMessaging.getToken();
            if(response['data']['fcm_token'] != token){
              print("Updating FCM Token");
              var tokenResponse = await API.updateFcmToken(
                  accessToken: response['data']['access_token'],
                  fcmToken: token
              );
            }
            ///login
            Provider.of<UserModel>(context, listen: false).userSignIn(response['data']);
            SplashScreen.sp.setString('userAuth', response['data']['access_token']);
            SplashScreen.sp.setBool('firstTime', false);
            var userDetails = Provider.of<UserModel>(context, listen: false);
            var myFilters = Provider.of<Filters>(context, listen: false);
            if(userDetails.userPlanDetails.planID != 4){
              if(DateTime.parse(userDetails.likeLimit.startDate).add(Duration(days: Constants.getDaysLimit(userDetails.userPlanDetails.planID))).isBefore(DateTime.now())){
                print("### Reset Count");
                var responseReset = await API.resetLikeCount(userDetails.accessToken);
                Provider.of<UserModel>(context, listen: false).resetLikeCount();
              }
            }
            var responseCandidate = await API.getCandidates(response['data']['access_token']);
            if(responseCandidate != null){
              Provider.of<Match>(context, listen: false).loadCandidates(responseCandidate, userDetails, myFilters);
              var responsePartners = await API.getMatchedPartners(response['data']['access_token']);
              if(responsePartners != null){
                Provider.of<Partner>(context, listen: false).loadPartners(responsePartners);
              }else{
                Provider.of<Partner>(context, listen: false).initialize();
              }
              setLoading(false);
              if(userDetails.isActive){
                Navigator.push(
                    context,
                    SwipeLeftAnimationRoute(
                      widget: MainScreen(),
                    ));
              }else{
                Navigator.push(
                    context,
                    SwipeLeftAnimationRoute(
                      widget: ActivateScreen(),
                    ));
              }
            }else{
              setLoading(false);
            }
          }else{
            Provider.of<UserModel>(context, listen: false).setNewUser(
                UserModel(
                    name: userData['name'],
                    email: userData['email'],
                    provider: "facebook",
                    providerID: userData['id'],
                    providerToken: token,
                    profilePicture: userData['picture']['data']['url']
                )
            );
            setLoading(false);
            Navigator.push(
                context,
                SwipeLeftAnimationRoute(
                  widget: PhoneNoScreen(),
                ));
          }
        }else{
          setLoading(false);
          Fluttertoast.showToast(
              msg: "Try again later",
              toastLength: Toast.LENGTH_SHORT);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");

        //_showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        print("Error:" + result.errorMessage);
        Fluttertoast.showToast(
            msg: "Account not valid! \n Reason: ${result.errorMessage}",
            toastLength: Toast.LENGTH_SHORT);
        //_showErrorOnUI(result.errorMessage);
        break;
    }
  }

  signInWithGoogle() async {
    Provider.of<UserModel>(context,listen: false).userLogout();
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    setLoading(true);
    print("google sign in googleUser: "+googleUser.email.toString());
    print("google sign in googleUser: "+googleUser.displayName.toString());
    print("google sign in googleUser: "+googleUser.id.toString());
    String imagePath = googleUser.photoUrl.toString();
    print("google sign in googleUser: "+imagePath.substring(0, imagePath.indexOf("=")));

    var response = await API.checkSocialUser(googleUser.id.toString());
    if(response != null){
      if(response['status']){
        String token = await fbMessaging.getToken();
        if(response['data']['fcm_token'] != token){
          print("Updating FCM Token");
          var tokenResponse = await API.updateFcmToken(
              accessToken: response['data']['access_token'],
              fcmToken: token
          );
        }
        ///login
        Provider.of<UserModel>(context, listen: false).userSignIn(response['data']);
        SplashScreen.sp.setString('userAuth', response['data']['access_token']);
        SplashScreen.sp.setBool('firstTime', false);
        var userDetails = Provider.of<UserModel>(context, listen: false);
        var myFilters = Provider.of<Filters>(context, listen: false);
        if(userDetails.userPlanDetails.planID != 4){
          if(DateTime.parse(userDetails.likeLimit.startDate).add(Duration(days: Constants.getDaysLimit(userDetails.userPlanDetails.planID))).isBefore(DateTime.now())){
            print("### Reset Count");
            var responseReset = await API.resetLikeCount(userDetails.accessToken);
            Provider.of<UserModel>(context, listen: false).resetLikeCount();
          }
        }
        var responseCandidate = await API.getCandidates(response['data']['access_token']);
        if(responseCandidate != null){
          Provider.of<Match>(context, listen: false).loadCandidates(responseCandidate, userDetails, myFilters);
          var responsePartners = await API.getMatchedPartners(response['data']['access_token']);
          if(responsePartners != null){
            Provider.of<Partner>(context, listen: false).loadPartners(responsePartners);
          }else{
            Provider.of<Partner>(context, listen: false).initialize();
          }
          setLoading(false);
          if(userDetails.isActive){
            Navigator.push(
                context,
                SwipeLeftAnimationRoute(
                  widget: MainScreen(),
                ));
          }else{
            Navigator.push(
                context,
                SwipeLeftAnimationRoute(
                  widget: ActivateScreen(),
                ));
          }
        }else{
          setLoading(false);
        }
      }else{
        Provider.of<UserModel>(context, listen: false).setNewUser(
            UserModel(
                name: googleUser.displayName.toString(),
                email: googleUser.email.toString(),
                provider: "google",
                providerID: googleUser.id.toString(),
                providerToken: "",
                profilePicture: imagePath
            )
        );
        setLoading(false);
        Navigator.push(
            context,
            SwipeLeftAnimationRoute(
              widget: PhoneNoScreen(),
            ));
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: textColorW,
            resizeToAvoidBottomInset: true,
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
                  Positioned.fill(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.08),
                          Image.asset(
                            "assets/images/merrimate_logo.png",
                            width: size.height * 0.27,
                          ),
                          SizedBox(height: size.height * 0.02),
                          Image.asset(
                            "assets/images/social_login_logo.png",
                            width: size.height * 0.25,
                          ),
                          SizedBox(height: size.height * 0.025),
                          VariableText(
                            text: tr("Login Account"),
                            fontFamily: fontMatchMaker,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.040,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.01),
                          VariableText(
                            text: tr("Login with your contact and password"),
                            fontFamily: fontMedium,
                            fontcolor: textColor1,
                            fontsize: size.height * 0.018,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.02),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.25,
                                  height: size.height * 0.05,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: primaryColor1, width: 1.0),
                                  ),
                                  child: CountryCodePicker(
                                    onChanged: (value){
                                      selectedCode = value.dialCode;
                                      print(value.dialCode);
                                    },
                                    initialSelection: 'CA',
                                    favorite: ["+91", "+1", "+92"],
                                    showCountryOnly: false,
                                    //comparator: (a, b) => b.name.compareTo(a.name),
                                    padding: EdgeInsets.all(0),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.03),
                                Expanded(
                                  child: Container(
                                    height: size.height * 0.05,
                                    child: TextFormField(
                                      controller: contactController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      decoration: InputDecoration(
                                        hintText: "111 111 1111",
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: primaryColor1, width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: borderColor, width: 1.0),
                                          ),
                                          contentPadding: EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    //width: double.infinity,
                                    height: size.height * 0.055,
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
                                          hintText: tr("Password"),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            BorderSide(color: primaryColor1, width: 1.0),
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
                                ),
                              ],
                            ),
                          ),
                          //SizedBox(height: size.height * 0.01),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        SwipeUpAnimationRoute(
                                          widget: RecoveryScreen(),
                                        ));
                                  },
                                  child: Text(
                                      tr("Trouble logging in?"),
                                      style: TextStyle(
                                          color: primaryColor1,
                                          fontSize: size.height * 0.018,
                                          decoration: TextDecoration.underline)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.015),
                          MyButton(
                            onTap: () {
                              userLogin();
                            },
                            btnTxt: tr("Login"),
                            btnColor: primaryColor1,
                            txtColor: textColorW,
                            btnRadius: 25,
                            btnWidth: size.width * 0.45,
                            btnHeight: 50,
                            fontSize: size.height * 0.020,
                            weight: FontWeight.w700,
                            fontFamily: fontSemiBold,
                          ),
                          SizedBox(height: size.height * 0.02),
                          VariableText(
                            text: tr("or continue with"),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                  signInWithFacebook();
                                },
                                  child: Image.asset("assets/icons/facebook.png", scale: 1.3)),
                              SizedBox(width: size.width * 0.08),
                              InkWell(
                                onTap: (){
                                  signInWithGoogle();
                                },
                                  child: Image.asset("assets/icons/google.png", scale: 1.3))
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VariableText(
                      text: tr("Don't have an account?") + " ",
                      fontsize: size.height * 0.020,
                      fontcolor: textColorG,
                    ),
                    InkWell(
                      onTap: (){
                        Provider.of<UserModel>(context,listen: false).userLogout();
                        Navigator.push(
                            context,
                            SwipeLeftAnimationRoute(
                              widget: PhoneNoScreen(),
                            ));
                      },
                      child: VariableText(
                        text: tr("Sign up"),
                        fontsize: size.height * 0.020,
                        fontcolor: primaryColor2,
                        fontFamily: fontBold,
                      ),
                    )
                  ],
                )
            ),
          ),
          if(isLoading) ProcessLoadingLight()
        ],
      ),
    );
  }
}
