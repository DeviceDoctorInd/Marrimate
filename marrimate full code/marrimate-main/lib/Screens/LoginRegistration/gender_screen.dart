import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/LoginRegistration/hobbies_screen.dart';
import 'package:marrimate/Screens/LoginRegistration/sexual_orientation_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:provider/provider.dart';

class GenderScreen extends StatefulWidget {
  GenderScreen({Key key}) : super(key: key);

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  int selectedIndex;

  List<Map<String, dynamic>> data = [
    {
      "gender": "Woman",
    },
    {
      "gender": "Man",
    },
    {
      "gender": "Other",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context, listen: true);
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.20;

    onSelectedIndex(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    return Scaffold(
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
                  SizedBox(height: size.height * 0.18),
                  VariableText(
                    text: tr("I am a ..."),
                    fontFamily: fontMatchMaker,
                    fontcolor: primaryColor2,
                    fontsize: size.height * 0.040,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: size.height * 0.007),
                  Flexible(
                      child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemCount: data.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, int index) {
                            return Column(
                              children: [
                                SizedBox(height: size.height * 0.02),
                                Container(
                                    width: size.width,
                                    height: size.height * 0.05,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding),
                                    child: MyButton(
                                      onTap: () {
                                        onSelectedIndex(index);
                                        userDetails.gender = data[selectedIndex]['gender'];
                                        Future.delayed(Duration(milliseconds: 200)).then((value){
                                          Navigator.push(
                                              context,
                                              SwipeLeftAnimationRoute(
                                                widget: HobbiesScreen(),
                                              ));
                                        });
                                      },
                                      btnTxt: data[index]['gender'],
                                      borderColor: index == selectedIndex
                                          ? primaryColor1
                                          : borderColor,
                                      btnColor: index == selectedIndex
                                          ? primaryColor1
                                          : textColorW,
                                      txtColor: index == selectedIndex
                                          ? textColorW
                                          : textColorG,
                                      btnRadius: 4,
                                      btnWidth: size.width * 0.45,
                                      btnHeight: 50,
                                      fontSize: size.height * 0.020,
                                      weight: FontWeight.bold,
                                    )),
                              ],
                            );
                          })),
                  // SizedBox(height: size.height * 0.05),

                  // SizedBox(height: size.height * 0.01),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
