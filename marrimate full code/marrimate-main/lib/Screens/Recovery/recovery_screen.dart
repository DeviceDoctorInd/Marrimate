// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Recovery/recovery_otp_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/services/api.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({Key key}) : super(key: key);

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  TextEditingController contactController = TextEditingController();
  String selectedCode = "+1";
  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  sendOtp()async{
      FirebaseAuth _auth = FirebaseAuth.instance;
          _auth.verifyPhoneNumber(
              phoneNumber: selectedCode+contactController.text.trim(),
              timeout: Duration(seconds: 10),
              verificationCompleted: (AuthCredential credential) async {
                print("User Verified!!!!!!!!!!!!!!!");
              },
              verificationFailed: (var exception) {
                setLoading(false);
                print("OTP failed!!!!!!!!!!!!!!!");
                Fluttertoast.showToast(
                    msg: "OTP failed, Try again later",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.black87,
                    textColor: Colors.white,
                    fontSize: 16.0);
                print(exception);
              },
              codeSent: (String verificationId, [int forceResendingToken]) {
                setLoading(false);
                Navigator.push(
                    context,
                    SwipeLeftAnimationRoute(
                      widget: RecoveryOtpScreen(
                        verificationID: verificationId,
                        resendToken: forceResendingToken,
                        contactNumber: selectedCode+contactController.text.trim(),
                      ),
                    ));
              },
              codeAutoRetrievalTimeout: (value){
                //print("codeAutoRetrievalTimeout: " + value);
              });
  }

  checkUser()async{
    if(validate()){
      FocusScope.of(context).unfocus();
      setLoading(true);
      var response = await API.checkUserExist(selectedCode + contactController.text);
      if(response != null){
        if(!response){
          sendOtp();
        }else{
          setLoading(false);
          Fluttertoast.showToast(
              msg: "Account does not exist!",
              toastLength: Toast.LENGTH_SHORT);
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
    if(contactController.text.isNotEmpty){
      if(contactController.text.length == 10){
        isOkay = true;
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.15;

    return Stack(
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
                          width: size.height * 0.09,
                        ),
                        SizedBox(height: size.height * 0.028),
                        VariableText(
                          text: tr("What's your contact number"),
                          fontFamily: fontMatchMaker,
                          fontcolor: primaryColor2,
                          fontsize: size.height * 0.036,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.015),
                        VariableText(
                          text: tr("We'll send code to verify your credentials"),
                          fontFamily: fontMedium,
                          fontcolor: textColorB,
                          fontsize: size.height * 0.017,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                          child: Row(
                            children: [
                              Container(
                                width: size.width * 0.25,
                                height: size.height * 0.05,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: primaryColor2, width: 1.0),
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
                                    textInputAction: TextInputAction.done,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor2, width: 1.0),
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
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.width * 0.10),
                          child: MyButton(
                            onTap: () {
                              checkUser();
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
    );
  }
}
