import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/LoginRegistration/login_screen.dart';
import 'package:marrimate/Screens/splash_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';

class DescriptionScreen extends StatelessWidget {
  const DescriptionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: textColorW,
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.12),
            VariableText(
              text: tr("Online Dating App"),
              fontFamily: fontMatchMaker,
              fontcolor: primaryColor2,
              fontsize: size.height * 0.038,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.05),
            VariableText(
              text: tr("Find Your Best Match"),
              fontFamily: fontSemiBold,
              fontcolor: primaryColor1,
              fontsize: size.height * 0.033,
              textAlign: TextAlign.center,
              fontStyle: FontStyle.italic,
            ),
            SizedBox(height: size.height * 0.02),
            Image.asset(
              "assets/images/description.png",
              width: size.height * 0.38,
            ),
            SizedBox(height: size.height * 0.03),
            VariableText(
              text: tr("Join today and get the best matches"),
              fontFamily: fontMatchMaker,
              fontcolor: primaryColor2,
              fontsize: size.height * 0.028,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.06),
            MyButton(
              onTap: () {
                Navigator.push(
                    context,
                    SwipeLeftAnimationRoute(
                      widget: LoginScreen(),
                    ));
              },
              btnTxt: tr("Start Dating"),
              btnColor: primaryColor1,
              txtColor: textColorW,
              btnRadius: 25,
              btnWidth: size.width * 0.48,
              btnHeight: 50,
              fontSize: size.height * 0.020,
              weight: FontWeight.w700,
              fontFamily: fontSemiBold,
            ),
          ],
        ),
      ),
    );
  }
}
