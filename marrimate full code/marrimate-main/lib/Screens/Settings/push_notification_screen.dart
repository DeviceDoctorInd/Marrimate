import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/LoginRegistration/sexual_orientation_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';

class PushNotificationScreen extends StatefulWidget {
  const PushNotificationScreen({Key key}) : super(key: key);

  @override
  State<PushNotificationScreen> createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  bool isTrue = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.06;
    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        appBar: CustomSimpleAppBar(
          text: "Push Notification",
          isBack: true,
          height: size.height * 0.085,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              SizedBox(height: size.height * 0.03),
              VariableText(
                text: "Enable Notification",
                fontFamily: fontSemiBold,
                fontcolor: primaryColor1,
                fontsize: size.height * 0.036,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: VariableText(
                  text:
                      "Get push notification when you get the its match or receive messages",
                  fontFamily: fontMedium,
                  fontcolor: textColorG,
                  fontsize: size.height * 0.018,
                  textAlign: TextAlign.center,
                  max_lines: 2,
                  line_spacing: size.height * 0.0017,
                ),
              ),
              SizedBox(height: size.height * 0.07),
              Padding(
                padding: EdgeInsets.all(padding * 1.2),
                child: Image.asset(
                  "assets/images/notification.png",
                  height: size.height * 0.3,
                ),
              ),
              SizedBox(height: size.height * 0.07),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding * 4),
                child: MyButton(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     SwipeLeftAnimationRoute(
                    //       widget: SexualOrientationScreen(),
                    //     ));
                  },
                  btnTxt: "I want to be notified",
                  borderColor: primaryColor2,
                  btnColor: primaryColor2,
                  txtColor: textColorW,
                  btnRadius: 25,
                  btnWidth: size.width * 0.75,
                  btnHeight: 50,
                  fontSize: size.height * 0.020,
                  weight: FontWeight.w700,
                  fontFamily: fontSemiBold,
                ),
              ),
              // SizedBox(height: size.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
