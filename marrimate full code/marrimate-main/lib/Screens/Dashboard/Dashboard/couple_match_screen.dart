import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/Dashboard/Chat/chatting_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CoupleMatchScreen extends StatelessWidget {
  UserModel partnerDetails;
  CoupleMatchScreen({Key key, this.partnerDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        body: Container(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                child: Image.asset(
                  "assets/images/match_background.png",
                  fit: BoxFit.cover,
                  height: size.height * 0.6,
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.09),
                    VariableText(
                      text: tr("Congratulations!"),
                      fontFamily: fontBold,
                      fontcolor: primaryColor1,
                      fontsize: size.height * 0.040,
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(height: size.height * 0.01),
                    Container(
                      height: size.height * 0.45,
                      width: double.infinity,
                      //color: Colors.redAccent,
                      child: Stack(
                        children: [
                          Transform.rotate(
                            angle: -4 / 12,
                            child: Container(
                              height: size.height * 0.28,
                              width: size.width * 0.35,
                              margin: EdgeInsets.only(
                                  left: size.width * 0.13,
                                  top: size.height * 0.08
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: userDetails.profilePicture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Transform.rotate(
                            angle: 2 / 15,
                            child: Container(
                              height: size.height * 0.28,
                              width: size.width * 0.35,
                              margin: EdgeInsets.only(
                                  left: size.width * 0.51,
                                  top: size.height * 0.09
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: partnerDetails.profilePicture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Image.asset(
                                "assets/icons/ic_matched_heart.png",
                                scale: 2
                              //width: size.height * 0.45,
                              //fit: BoxFit.cover,
                            ),
                          )
                        ]
                      )
                    ),
                    VariableText(
                      text: tr("It's a Match!"),
                      fontFamily: fontBold,
                      fontcolor: primaryColor1,
                      fontsize: size.height * 0.035,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.05),
                    MyButton(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            SwipeLeftAnimationRoute(
                              widget: ChattingScreen(
                                partner: partnerDetails,
                              ),
                            ));
                      },
                      btnTxt: tr("Send Message"),
                      btnColor: primaryColor1,
                      txtColor: textColorW,
                      btnRadius: 0,
                      btnWidth: size.width * 0.7,
                      btnHeight: 50,
                      fontSize: size.height * 0.020,
                      weight: FontWeight.w700,
                      fontFamily: fontSemiBold,
                    ),
                    SizedBox(height: size.height * 0.01),
                    MyButton(
                      onTap: () {
                        Navigator.of(context).pop();
                        },
                      btnTxt: tr("Keep Connecting"),
                      borderColor: primaryColor1,
                      btnColor: textColorW,
                      txtColor: primaryColor1,
                      btnRadius: 0,
                      btnWidth: size.width * 0.70,
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
    );
  }
}
