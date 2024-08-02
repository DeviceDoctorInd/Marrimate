import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/LoginRegistration/description_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.08;

    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        appBar: CustomSimpleAppBar(
          text: "Policies",
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
                  text: "Our Terms & Condition",
                  fontFamily: fontBold,
                  fontcolor: primaryColor1,
                  fontsize: size.height * 0.035,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: VariableText(
                  text:
                      "Our Terms & Condition Our Terms & Condition Our Terms & Condition Our Terms & Condition Our Terms & Condition",
                  fontFamily: fontRegular,
                  fontcolor: textColorG,
                  fontsize: size.height * 0.02,
                  textAlign: TextAlign.left,
                  max_lines: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
