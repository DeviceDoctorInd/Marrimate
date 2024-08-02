import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marrimate/Screens/Dashboard/Chat/video_call_screen.dart';
import 'package:marrimate/Screens/Dashboard/main_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/constants.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:provider/provider.dart';

import '../../../models/filters_model.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String dropdownValue = 'Make New Friends';
  String selectedGender;
  String selectedAgeRange;
  String selectedLanguage;
  String dropdownValue5 = 'Goa, India';
  double slider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var filterDetails = Provider.of<Filters>(context, listen: false);
    selectedGender = filterDetails.gender;
    selectedAgeRange = filterDetails.ageRange;
    selectedLanguage = filterDetails.language;
    slider = double.tryParse(filterDetails.distanceRange)??25;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;
    return SafeArea(
      child: Scaffold(
        backgroundColor: textColorW,
        appBar: CustomSimpleAppBar(
          text: tr("Filter"),
          isBack: true,
          height: size.height * 0.085,
        ),
        body: SingleChildScrollView(
          child: Container(
            // width: size.width,
            // height: size.height,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: padding - 2,
                          left: padding - 6,
                          right: padding - 6),
                      child: VariableText(
                        text: tr("Filter Options"),
                        fontFamily: fontSemiBold,
                        fontcolor: primaryColor1,
                        fontsize: size.height * 0.028,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: padding / 3, left: padding - 6, right: padding - 6),
                  child: VariableText(
                    text:
                        tr("Manage and set your preference to find the matches for you, keep enjoying"),
                    fontFamily: fontRegular,
                    fontcolor: textColorG,
                    fontsize: size.height * 0.017,
                    max_lines: 3,
                  ),
                ),
                /*Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: padding,
                    horizontal: padding * 2,
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Here to",
                      labelStyle: TextStyle(
                        fontSize: size.height * 0.025,
                        color: textColorB,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                    ),
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    elevation: 16,
                    style: TextStyle(
                        color: textColorG,
                        fontFamily: fontRegular,
                        fontSize: size.height * 0.02),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Make New Friends', 'Make New Friends2', 'Make New Friends3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),*/
                SizedBox(height: padding),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: padding / 5,
                    horizontal: padding * 2,
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Want to Meet",
                      labelStyle: TextStyle(
                        fontSize: size.height * 0.025,
                        color: textColorB,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                    ),
                    value: selectedGender,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    elevation: 16,
                    style: TextStyle(
                        color: textColorG,
                        fontFamily: fontRegular,
                        fontSize: size.height * 0.02),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                    items: Constants.genders
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: padding,
                    horizontal: padding * 2,
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Prefer Age Range",
                      labelStyle: TextStyle(
                        fontSize: size.height * 0.025,
                        color: textColorB,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                    ),
                    value: selectedAgeRange,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    elevation: 16,
                    style: TextStyle(
                        color: textColorG,
                        fontFamily: fontRegular,
                        fontSize: size.height * 0.02),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedAgeRange = newValue;
                      });
                    },
                    items: Constants.ageRange
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: padding / 5,
                    horizontal: padding * 2,
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Prefer Language",
                      labelStyle: TextStyle(
                        fontSize: size.height * 0.025,
                        color: textColorB,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                    ),
                    value: selectedLanguage,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    elevation: 16,
                    style: TextStyle(
                        color: textColorG,
                        fontFamily: fontRegular,
                        fontSize: size.height * 0.02),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedLanguage = newValue;
                      });
                    },
                    items: Constants.languages
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                /*Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: padding,
                    horizontal: padding * 2,
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Location",
                      labelStyle: TextStyle(
                        fontSize: size.height * 0.025,
                        color: textColorB,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor1, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // filled: true,
                      // fillColor: Colors.blueAccent,
                    ),
                    value: dropdownValue5,
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    elevation: 16,
                    style: TextStyle(
                        color: textColorG,
                        fontFamily: fontRegular,
                        fontSize: size.height * 0.02),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue5 = newValue;
                      });
                    },
                    items: <String>['Goa, India', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),*/
                SizedBox(height: padding),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: padding / 10,
                    horizontal: padding * 2.6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VariableText(
                        text: "Distance Range",
                        fontFamily: fontSemiBold,
                        fontcolor: primaryColor2,
                        fontsize: size.height * 0.017,
                        max_lines: 3,
                      ),
                      VariableText(
                        text: "1 - ${slider.toStringAsFixed(0)} km",
                        fontFamily: fontSemiBold,
                        fontcolor: primaryColor1,
                        fontsize: size.height * 0.017,
                        max_lines: 3,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: padding / 10,
                    horizontal: padding * 2.6,
                  ),
                  child: Slider(
                      divisions: 100,
                      min: 1,
                      max: 200,
                      activeColor: primaryColor1,
                      inactiveColor: primaryColor2,
                      value: slider,
                      onChanged: (double value) {
                        setState(() {
                          slider = value;
                        });
                      }),
                ),
                SizedBox(height: padding),
                MyButton(
                  onTap: () {
                    Provider.of<Filters>(context, listen: false).setFilters(
                      selectedGender: selectedGender,
                      selectedAge: selectedAgeRange,
                      selectedLanguage: selectedLanguage,
                      selectedRange: slider.toString()
                    );
                    Navigator.of(context).pop();
                  },
                  btnTxt: tr("Apply Filters"),
                  btnColor: textColorW,
                  txtColor: primaryColor1,
                  borderColor: primaryColor1,
                  btnRadius: 25,
                  btnWidth: size.width * 0.45,
                  btnHeight: 50,
                  fontSize: size.height * 0.020,
                  weight: FontWeight.w700,
                  fontFamily: fontSemiBold,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
