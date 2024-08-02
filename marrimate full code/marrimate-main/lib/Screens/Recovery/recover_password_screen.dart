import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Recovery/recovery_otp_screen.dart';
import 'package:marrimate/Screens/Recovery/recovery_success_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/services/api.dart';

class RecoverPasswordScreen extends StatefulWidget {
  String contactNumber;
  RecoverPasswordScreen({Key key, this.contactNumber}) : super(key: key);

  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  changePassword()async{
    if(validate()){
      FocusScope.of(context).unfocus();
      setLoading(true);
      var response = await API.resetPassword(
        contactNumber: widget.contactNumber,
        password: passController.text
      );
      if(response != null){
        if(response['status']){
          setLoading(false);
          Navigator.push(
              context,
              SwipeLeftAnimationRoute(
                widget: RecoverySuccessScreen(),
              ));
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
    }
  }

  validate(){
    bool isOkay = false;
    if(passController.text.isNotEmpty){
      if(confirmPassController.text.isNotEmpty){
        if(passController.text == confirmPassController.text){
          isOkay = true;
        }else{
          Fluttertoast.showToast(
              msg: "Passwords does not match!",
              toastLength: Toast.LENGTH_SHORT);
        }
      }else{
        Fluttertoast.showToast(
            msg: "Please enter confirm password",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      Fluttertoast.showToast(
          msg: "Please enter new password",
          toastLength: Toast.LENGTH_SHORT);
    }
    return isOkay;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.15;

    return WillPopScope(
      onWillPop: ()=> Future.value(false),
      child: Stack(
        children: [
          Scaffold(
            // resizeToAvoidBottomInset: false,
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
                          SizedBox(height: size.height * 0.13),

                          Image.asset(
                            "assets/images/recovery_logo.png",
                            width: size.height * 0.07,
                          ),
                          SizedBox(height: size.height * 0.06),
                          VariableText(
                            text: tr("Reset Password"),
                            fontFamily: fontMatchMaker,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.040,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.015),
                          VariableText(
                            text: tr("Enter your new password"),
                            fontFamily: fontMedium,
                            fontcolor: textColorB,
                            fontsize: size.height * 0.020,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.03),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: padding, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                VariableText(
                                  text: tr("New Password"),
                                  fontFamily: fontBold,
                                  fontcolor: textColorB,
                                  fontsize: size.height * 0.015,
                                  // textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: size.height * 0.055,
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: TextFormField(
                              controller: passController,
                              obscureText: true,
                              style: TextStyle(
                                fontFamily: fontRegular,
                                color: textColor1,
                                fontSize: size.height * 0.0185,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                    "assets/icons/ic_password.png",
                                    scale: 1.8,
                                  ),
                                  hintText: tr("New Password"),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: textColorG, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: textColorG, width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  )),
                            ),
                          ),

                          SizedBox(height: size.height * 0.013),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: padding, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                VariableText(
                                  text: tr("Re-Enter New Password"),
                                  fontFamily: fontBold,
                                  fontcolor: textColorB,
                                  fontsize: size.height * 0.015,
                                  // textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: size.width,
                            height: size.height * 0.055,
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: TextFormField(
                              controller: confirmPassController,
                              obscureText: true,
                              style: TextStyle(
                                fontFamily: fontRegular,
                                color: textColor1,
                                fontSize: size.height * 0.0185,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Image.asset(
                                    "assets/icons/ic_password.png",
                                    scale: 1.8,
                                  ),
                                  hintText: tr("Confirm password"),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: textColorG, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: textColorG, width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                    left: 8,
                                    right: 8,
                                  )),
                            ),
                          ),

                          SizedBox(height: size.height * 0.03),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: padding),
                            child: MyButton(
                              onTap: () {
                                changePassword();
                              },
                              btnTxt: tr("Continue"),
                              borderColor: primaryColor2,
                              btnColor: primaryColor2,
                              txtColor: textColorW,
                              btnRadius: 4,
                              btnWidth: size.width,
                              btnHeight: 50,
                              fontSize: size.height * 0.022,
                              weight: FontWeight.w700,
                              fontFamily: fontSemiBold,
                            ),
                          ),
                          // SizedBox(height: size.height * 0.01),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(isLoading) ProcessLoadingLight()
        ],
      ),
    );
  }
}
