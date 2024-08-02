import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/LoginRegistration/profile_details_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/login_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Future<bool> onWillPop() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to start again?'),
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
                Provider.of<UserModel>(context,listen: false).userLogout();
                Navigator.pushAndRemoveUntil(context,
                    SwipeRightAnimationRoute(widget: const LoginScreen(), milliseconds: 300),
                        (route) => route.isCurrent);
              },
            )
          ],
        );
      },
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                Positioned.fill(
                  child: Container(
                    color: textColorBlue.withOpacity(0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.12),
                        Image.asset(
                          "assets/images/merrimate_logo.png",
                          width: size.height * 0.27,
                        ),
                        SizedBox(height: size.height * 0.2),
                        Image.asset(
                          "assets/images/welcome_logo.png",
                          width: size.height * 0.38,
                        ),
                        SizedBox(height: size.height * 0.14),
                        MyButton(
                          onTap: () {
                            /*Provider.of<UserModel>(context, listen: false).setNewUser(
                                UserModel(contactNumber: "+923456186504")
                            );*/
                            Navigator.push(
                                context,
                                SwipeLeftAnimationRoute(
                                  widget: ProfileDetailsScreen(),
                                ));
                          },
                          btnTxt: tr("Welcome"),
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
                        TextButton(
                          onPressed: onWillPop,
                          child: Text( tr("Start Over"),
                              style: TextStyle(
                                fontSize: size.height * 0.020,
                                decoration: TextDecoration.underline,
                                color: textColorG,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
