import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/user_profile_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/login_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/api.dart';
import '../Dashboard/main_screen.dart';
import '../splash_screen.dart';

class ActivateScreen extends StatefulWidget {
  const ActivateScreen({Key key}) : super(key: key);

  @override
  State<ActivateScreen> createState() => _ActivateScreenState();
}

class _ActivateScreenState extends State<ActivateScreen> {

  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: ()=> Future.value(false),
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: textColorW,
              body: Container(
                height: size.height,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.12),
                    Image.asset(
                      "assets/images/social_login_logo.png",
                      width: size.width * 0.65,
                    ),
                    SizedBox(height: size.height * 0.04),
                    VariableText(
                      text: tr("Account Deactivated"),
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
                            tr("To Continue activate your account now and get the most out of the app"),
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
                      onTap: ()async{
                        setLoading(true);
                        var userDetails = Provider.of<UserModel>(context, listen: false);
                        var response = await API.deactivateAccount(userDetails);
                        if(response != null){
                          if(response['status']){
                            setLoading(false);
                            Fluttertoast.showToast(
                                msg: "Account activated successfully",
                                toastLength: Toast.LENGTH_LONG);
                            Navigator.push(
                                context,
                                SwipeLeftAnimationRoute(
                                  widget: MainScreen(),
                                ));
                          }else{
                            setLoading(false);
                            Fluttertoast.showToast(
                                msg: "Try again later",
                                toastLength: Toast.LENGTH_SHORT);
                          }
                        }else{
                          setLoading(false);
                          Fluttertoast.showToast(
                              msg: "Try again later: 500",
                              toastLength: Toast.LENGTH_SHORT);
                        }
                      },
                      btnTxt: tr("Activate"),
                      btnColor: primaryColor1,
                      txtColor: textColorW,
                      btnRadius: 0,
                      btnWidth: size.width * 0.75,
                      btnHeight: 50,
                      fontSize: size.height * 0.020,
                      weight: FontWeight.w700,
                      fontFamily: fontSemiBold,
                    ),
                    SizedBox(height: size.height * 0.02),
                    MyButton(
                      onTap: () {
                        SplashScreen.sp.remove('userAuth');
                        Navigator.pushAndRemoveUntil(context,
                            SwipeRightAnimationRoute(widget: const LoginScreen(), milliseconds: 300),
                                (route) => route.isCurrent);
                      },
                      btnTxt: tr("Logout"),
                      btnColor: textColorW,
                      txtColor: primaryColor1,
                      borderColor: primaryColor1,
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
            if(isLoading) ProcessLoadingLight()
          ],
        ),
      ),
    );
  }
}
