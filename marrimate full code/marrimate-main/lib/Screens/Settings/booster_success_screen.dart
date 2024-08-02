import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/boosters_model.dart';

class BoosterSuccessScreen extends StatefulWidget {
  Booster boosterDetails;
  BoosterSuccessScreen({Key key, this.boosterDetails}) : super(key: key);

  @override
  State<BoosterSuccessScreen> createState() => _BoosterSuccessScreenState();
}

class _BoosterSuccessScreenState extends State<BoosterSuccessScreen> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.15;

    return WillPopScope(
      onWillPop: ()=> Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: textColorW,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.12),
                    Image.asset(
                      "assets/images/merrimate_logo.png",
                      width: size.height * 0.27,
                    ),
                    SizedBox(height: size.height * 0.08),

                    Image.asset(
                      "assets/images/success_logo.png",
                      width: size.height * 0.27,
                    ),
                    SizedBox(height: size.height * 0.01),
                    VariableText(
                      text: "Profile Booster Updated",
                      fontFamily: fontMatchMaker,
                      fontcolor: primaryColor2,
                      fontsize: size.height * 0.040,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.02),
                    VariableText(
                      text: "Your Profile has been upgraded\nto '${widget.boosterDetails.boosterName}' successfully",
                      fontFamily: fontBold,
                      fontcolor: textColorG,
                      fontsize: size.height * 0.018,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: size.height * 0.006),
                    VariableText(
                      text: "Enjoy features of Boosted Profile",
                      fontFamily: fontBold,
                      fontcolor: textColorG,
                      fontsize: size.height * 0.018,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: size.height * 0.05),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: MyButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        btnTxt: "Continue",
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
    );
  }
}
