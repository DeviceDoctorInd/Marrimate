// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/LoginRegistration/otp_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class PhoneNoScreen extends StatefulWidget {
  const PhoneNoScreen({Key key}) : super(key: key);

  @override
  State<PhoneNoScreen> createState() => _PhoneNoScreenState();
}

class _PhoneNoScreenState extends State<PhoneNoScreen> {
  TextEditingController contactController = TextEditingController();
  bool isLoading = false;
  String selectedCode = "+1";

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  sendOtp()async{
    if(validate()){
      FocusScope.of(context).unfocus();
      setLoading(true);
      FirebaseAuth _auth = FirebaseAuth.instance;
      var response = await API.checkUserExist(selectedCode+contactController.text.trim());
      if(response != null){
        if(response){
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
                UserModel userDetails = UserModel(contactNumber: selectedCode+contactController.text.trim());
                setLoading(false);
                Navigator.push(
                    context,
                    SwipeLeftAnimationRoute(
                      widget: OtpScreen(userDetails: userDetails, verificationID: verificationId, resendToken: forceResendingToken),
                    ));
              },
              codeAutoRetrievalTimeout: (value){
                //print("codeAutoRetrievalTimeout: " + value);
              });
        }else{
          setLoading(false);
          Fluttertoast.showToast(
              msg: 'Mobile Number is already Registered!',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      }else{
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
  }

  bool validate(){
    bool isOkay = false;
    if(contactController.text.trim().isNotEmpty){
      if(contactController.text.trim().length == 10){
       isOkay = true;
      }else{
        Fluttertoast.showToast(
            msg: "Please enter valid contact number",
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

    return Stack(
      children: [
        Scaffold(
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
                        SizedBox(height: size.height * 0.14),
                        VariableText(
                          text: tr("My Mobile"),
                          fontFamily: fontMatchMaker,
                          fontcolor: primaryColor2,
                          fontsize: size.height * 0.044,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.04),
                        VariableText(
                          text: tr("Please enter your valid phone number"),
                          fontFamily: fontMedium,
                          fontcolor: textColorG,
                          fontsize: size.height * 0.020,
                          textAlign: TextAlign.center,
                        ),
                        // SizedBox(height: size.height * 0.0040),
                        RichText(
                          text: TextSpan(
                            text: tr("We will send you a"),
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
                              TextSpan(text: tr("to verify your account.")),
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
                          padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor1, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: primaryColor1, width: 1.0),
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
                        SizedBox(height: size.height * 0.05),
                        MyButton(
                          onTap: () {
                            sendOtp();
                          },
                          btnTxt: tr("Continue"),
                          btnColor: primaryColor1,
                          txtColor: textColorW,
                          btnRadius: 25,
                          btnWidth: size.width * 0.45,
                          btnHeight: 50,
                          fontSize: size.height * 0.020,
                          weight: FontWeight.w700,
                          fontFamily: fontSemiBold,
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
}
