import 'package:flutter/material.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/user_profile_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/login_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';

class PremiumAlertScreen extends StatelessWidget {
  const PremiumAlertScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.2),
              Image.asset(
                "assets/images/social_login_logo.png",
                width: size.height * 0.3,
              ),
              SizedBox(height: size.height * 0.04),
              VariableText(
                text: "Hello Friends",
                fontFamily: fontMatchMaker,
                fontcolor: primaryColor2,
                fontsize: size.height * 0.04,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.04),
                child: VariableText(
                  text:
                      "To Continue with this option please choose a subscription plan that suits you and get the most out of the app",
                  fontFamily: fontRegular,
                  fontcolor: textColorG,
                  fontsize: size.height * 0.0185,
                  textAlign: TextAlign.center,
                  weight: FontWeight.w600,
                  max_lines: 5,
                  line_spacing: 1.3,
                ),
              ),
              SizedBox(height: size.height * 0.07),
              MyButton(
                onTap: () {
                  Navigator.push(
                      context,
                      SwipeLeftAnimationRoute(
                        widget: UserProfileScreen(),
                      ));
                },
                btnTxt: "View Plans",
                btnColor: primaryColor1,
                txtColor: textColorW,
                btnRadius: 0,
                btnWidth: size.width * 0.75,
                btnHeight: 50,
                fontSize: size.height * 0.020,
                weight: FontWeight.w700,
                fontFamily: fontSemiBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
