import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/LoginRegistration/description_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';

import '../../main.dart';
import '../splash_screen.dart';

class LanguageSettingScreen extends StatefulWidget {
  String activeLocale;
  LanguageSettingScreen({Key key, this.activeLocale}) : super(key: key);

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen> {
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
    /*
    {
      "icon": "assets/icons/ic_german.png",
      "language": "German",
      "code": "de",
      "isTrue": 0,
    },
    {
      "icon": "assets/icons/ic_polish.png",
      "language": "Polish",
      "code": "pl",
      "isTrue": 0,
    },*/
  ];

  onSelectedIndex(int index) {
    setState(() {
      selectedValueIndex = index;
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.08;

    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        appBar: CustomSimpleAppBar(
          text: tr('Language'), //DemoLocalization.translate("Language"),
          isBack: true,
          height: size.height * 0.085,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.04),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: VariableText(
                  text: tr("Choose Language"),
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
                   /* Locale newLocale = Locale(data[selectedValueIndex]['code']);
                    MyApp.setLocale(context, newLocale);
                    SplashScreen.sp.setString("lCode", data[selectedValueIndex]['code']);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SplashScreen()), (route) => route.isCurrent);*/
                  },
                  btnTxt: "Apply",
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
      ),
    );
  }
}
