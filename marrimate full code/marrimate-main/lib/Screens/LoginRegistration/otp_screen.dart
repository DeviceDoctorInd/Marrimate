// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/LoginRegistration/welcome_page.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';

class OtpScreen extends StatefulWidget {
  UserModel userDetails;
  String verificationID;
  int resendToken;
  OtpScreen({Key key, this.userDetails, this.verificationID, this.resendToken}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController txt1 = TextEditingController();
  TextEditingController txt2 = TextEditingController();
  TextEditingController txt3 = TextEditingController();
  TextEditingController txt4 = TextEditingController();
  TextEditingController txt5 = TextEditingController();
  TextEditingController txt6 = TextEditingController();

  String enteredPin="";
  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  bool validate(){
    if(enteredPin.length == 6){
      return true;
    }else{
      return false;
    }
  }

  void verifyOTP()async{
    print(enteredPin);
    if(validate()){
      setLoading(true);
      FirebaseAuth _auth = FirebaseAuth.instance;
      try{
        AuthCredential credential =
        PhoneAuthProvider.credential(verificationId: widget.verificationID, smsCode: enteredPin);
        UserCredential result = await _auth.signInWithCredential(credential);
        User user = result.user;
        if(user != null){
          var userCheck = Provider.of<UserModel>(context, listen: false);
          if(userCheck != null){
            userCheck.contactNumber = widget.userDetails.contactNumber;
          }else{
            Provider.of<UserModel>(context, listen: false).setNewUser(
                UserModel(contactNumber: widget.userDetails.contactNumber)
            );
          }
          setLoading(false);
          Navigator.push(
              context,
              SwipeLeftAnimationRoute(
                widget: WelcomeScreen(),
              ));
        }else{
          setLoading(false);
          Fluttertoast.showToast(
              msg: 'Invalid OTP, Try again',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }catch(e, stack){
        setLoading(false);
        Fluttertoast.showToast(
            msg: 'Invalid OTP',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print(stack.toString());
      }
    }else{
      Fluttertoast.showToast(
          msg: 'Enter complete OTP',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  void resendOTP(){
    FocusScope.of(context).unfocus();
    setLoading(true);
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: widget.userDetails.contactNumber,
        forceResendingToken: widget.resendToken,
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
          txt1.clear();
          txt2.clear();
          txt3.clear();
          txt4.clear();
          txt5.clear();
          txt6.clear();
          setLoading(false);
          widget.verificationID = verificationId;
          widget.resendToken = forceResendingToken;
          Fluttertoast.showToast(
              msg: "OTP sent again",
              toastLength: Toast.LENGTH_SHORT);
        },
        codeAutoRetrievalTimeout: (value){
          //print("codeAutoRetrievalTimeout: " + value);
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.06;

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
                    top: size.height * 0.08,
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
                        VariableText(
                          text: tr("Verify"),
                          fontFamily: fontMatchMaker,
                          fontcolor: primaryColor2,
                          fontsize: size.height * 0.044,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.03),

                        // SizedBox(height: size.height * 0.0040),
                        RichText(
                          text: TextSpan(
                            text: tr("Please enter the"),
                            children: [
                              TextSpan(
                                text: " " + tr("6-digit code"),
                                style: TextStyle(
                                  fontFamily: fontBold,
                                  fontSize: size.height * 0.020,
                                  color: textColor1,
                                ),
                              ),
                              TextSpan(
                                text: "\n",
                                style: TextStyle(
                                  fontFamily: fontBold,
                                  fontSize: size.height * 0.020,
                                  color: textColor1,
                                ),
                              ),
                              TextSpan(text: tr("send to your number")),
                            ],
                            style: TextStyle(
                              fontFamily: fontMedium,
                              fontSize: size.height * 0.020,
                              color: textColorG,
                              height: size.height * 0.0017,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.05),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: Row(
                            children: [
                              createCodeField(txt1, txt2),
                              SizedBox(width: 10),
                              createCodeField(txt2, txt3),
                              SizedBox(width: 10),
                              createCodeField(txt3, txt4),
                              SizedBox(width: 10),
                              createCodeField(txt4, txt5),
                              SizedBox(width: 10),
                              createCodeField(txt5, txt6),
                              SizedBox(width: 10),
                              createCodeField(txt6, null),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        MyButton(
                          onTap: () {
                            verifyOTP();
                          },
                          btnTxt: tr("Submit"),
                          borderColor: primaryColor1,
                          btnColor: textColorW,
                          txtColor: primaryColor1,
                          btnRadius: 25,
                          btnWidth: size.width * 0.45,
                          btnHeight: 50,
                          fontSize: size.height * 0.022,
                          weight: FontWeight.w700,
                          fontFamily: fontSemiBold,
                        ),
                        SizedBox(height: size.height * 0.01),
                        TextButton(
                          onPressed: () {
                            resendOTP();
                          },
                          child: Text( tr("Resend OTP?"),
                              style: TextStyle(
                                fontSize: size.height * 0.020,
                                decoration: TextDecoration.underline,
                                color: textColorG,
                              )),
                        ),
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

  Widget createCodeField(
      TextEditingController cont, TextEditingController next_cont) {
    return Expanded(
        child: CodeField(
      cont: cont,
      next_cont: next_cont,
      onComplete: (value) {
        setState(() {
          enteredPin = txt1.text + txt2.text + txt3.text + txt4.text + txt5.text + txt6.text;
        });
        print(enteredPin);
      },
    ));
  }
}
