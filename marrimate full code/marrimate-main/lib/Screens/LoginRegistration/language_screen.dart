import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/LoginRegistration/description_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';

class LanguageScreen extends StatefulWidget {
  String activeLocale;
  LanguageScreen({Key key, this.activeLocale}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int selectedValueIndex = 0;

  List<Map<String, dynamic>> data = [
    {
      "icon": "assets/icons/ic_eng.png",
      "language": "English",
      "code": "en",
      "isTrue": 0,
    },
    {
      "icon": "assets/icons/ic_hindi.png",
      "language": "Hindi",
      "code": "hi",
      "isTrue": 0,
    },
    {
      "icon": "assets/icons/ic_china.png",
      "language": "Chinese",
      "code": "zh",
      "isTrue": 0,
    },
    {
      "icon": "assets/icons/ic_italian.png",
      "language": "Italian",
      "code": "it",
      "isTrue": 0,
    },
    {
      "icon": "assets/icons/ic_portuguese.png",
      "language": "Portuguese",
      "code": "pt",
      "isTrue": 0,
    },
    {
      "icon": "assets/icons/ic_korean.png",
      "language": "Korean",
      "code": "ko",
      "isTrue": 0,
    },
    {
      "icon": "assets/icons/ic_french.png",
      "language": "French",
      "code": "fr",
      "isTrue": 0,
    },
  ];

  onSelectedIndex(int index) {
    setState(() {
      selectedValueIndex = index;
      context.setLocale(Locale(data[selectedValueIndex]['code']));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    for(int i=0; i < data.length; i++){
      if(data[i]['code'] == widget.activeLocale){
        selectedValueIndex = i;
        break;
      }
    }
    super.initState();
  }

  Future<bool> onWillPop() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to exit the app?'),
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
                exit(0);
                //Navigator.of(context).pop(true); //Will exit the App
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
    double padding = size.width * 0.08;

    return WillPopScope(
      onWillPop: onWillPop,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.12),
                    Center(
                      child: Image.asset(
                        "assets/images/merrimate_logo.png",
                        width: size.height * 0.27,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: VariableText(
                        text: tr("Select Language"),
                        fontFamily: fontBold,
                        fontcolor: primaryColor1,
                        fontsize: size.height * 0.035,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Flexible(
                        child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: data.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, int index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: padding, vertical: padding / 2.7),
                                child: InkWell(
                                  onTap: () {
                                    onSelectedIndex(index);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.height * 0.027,
                                        width: size.height * 0.027,
                                        decoration: BoxDecoration(
                                          color: index == selectedValueIndex
                                              ? primaryColor1
                                              : textColorW,
                                          border: Border.all(
                                            width: 2,
                                            color: index == selectedValueIndex
                                                ? primaryColor1
                                                : textColorG,
                                          ),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.check,
                                            color: textColorW,
                                            size: size.height * 0.018,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.05),
                                      Image.asset(
                                        data[index]['icon'],
                                        // height: size.height * 0.038,
                                        width: size.width * 0.11,
                                      ),
                                      SizedBox(width: size.width * 0.05),
                                      VariableText(
                                        text: data[index]['language'],
                                        fontFamily: fontRegular,
                                        // fontcolor: data[index]['isTrue']
                                        //     ? textColorB
                                        //     : textColorG,
                                        fontsize: size.height * 0.023,
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                    // SizedBox(height: size.height * 0.05),
                    Center(
                      child: MyButton(
                        onTap: () {
                          context.setLocale(Locale(data[selectedValueIndex]['code']));
                          setState(() {});
                          Navigator.push(
                              context,
                              SwipeLeftAnimationRoute(
                                widget: DescriptionScreen(),
                              ));
                        },
                        btnTxt: tr("CONTINUE"),
                        borderColor: primaryColor1,
                        btnColor: textColorW,
                        txtColor: primaryColor1,
                        btnRadius: 25,
                        btnWidth: size.width * 0.45,
                        btnHeight: 50,
                        fontSize: size.height * 0.020,
                        weight: FontWeight.w700,
                        fontFamily: fontSemiBold,
                      ),
                    ),

                    SizedBox(height: size.height * 0.02),
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
