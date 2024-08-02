import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Dashboard/Chat/chatting_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/constants.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/models/user_privacy_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class PrivacyOptionScreen extends StatefulWidget {
  const PrivacyOptionScreen({Key key}) : super(key: key);

  @override
  State<PrivacyOptionScreen> createState() => _PrivacyOptionScreenState();
}

class _PrivacyOptionScreenState extends State<PrivacyOptionScreen> {
  int selectedValueIndex = 0;
  String selectedGender;
  String selectedAgeRange;
  bool isEmail = true;
  bool isNumber = true;
  bool isBirth = true;
  bool isLocation = true;
  bool isBio = true;
  bool isLoading = false;
  bool isLoadingUpdate = false;

  List<PrivacyList> whoSeeList = [];

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }
  setLoadingUpdate(bool loading){
    setState(() {
      isLoadingUpdate = loading;
    });
  }

  getPrivacyList()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getPrivacyList(userDetails);
    if(response != null){
      if(response['status']){
        for(var item in response['data']){
          whoSeeList.add(PrivacyList.fromJson(item));
        }
        selectedValueIndex = whoSeeList.indexWhere((element) => element.id == userDetails.userPrivacy.whoSeeYou);
        setLoading(false);
      }else{
        setLoading(false);
        whoSeeList.clear();
      }
    }else{
      setLoading(false);
      whoSeeList.clear();
    }
  }

  updatePrivacyOptions()async{
    setLoadingUpdate(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    Privacy privacyDetails = Privacy(
      showEmail: isEmail,
      showContact: isNumber,
      showDob: isBirth,
      showLocation:  isLocation,
      showBio: isBio,
      preferredGender: selectedGender,
      ageRange: selectedAgeRange,
      whoSeeYou: whoSeeList[selectedValueIndex].id
    );
    var response = await API.updatePrivacyList(privacyDetails, userDetails);
    if(response != null){
      if(response['status']){
        Provider.of<UserModel>(context, listen: false).updatePrivacyOptions(privacyDetails);
        setLoadingUpdate(false);
        Fluttertoast.showToast(
            msg: "Updated Successfully",
            toastLength: Toast.LENGTH_SHORT);
      }else{
        setLoadingUpdate(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      setLoadingUpdate(false);
      Fluttertoast.showToast(
          msg: "Try again later: 500",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrivacyList();
    var userDetails = Provider.of<UserModel>(context, listen: false);
    isEmail = userDetails.userPrivacy.showEmail;
    isNumber = userDetails.userPrivacy.showContact;
    isBirth = userDetails.userPrivacy.showDob;
    isLocation = userDetails.userPrivacy.showLocation;
    isBio = userDetails.userPrivacy.showBio;
    selectedGender = userDetails.userPrivacy.preferredGender;
    selectedAgeRange = userDetails.userPrivacy.ageRange;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    onSelectedIndex(int index) {
      setState(() {
        selectedValueIndex = index;
      });
    }

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: textColorW,
            appBar: CustomSimpleAppBar(
              text: tr("Privacy Option"),
              isBack: false,
              height: size.height * 0.085,
            ),
            body: isLoading ? ProcessLoadingWhite() :
            SingleChildScrollView(
              child: Container(
                height: size.height,
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: padding - 7, left: padding - 6),
                      child: Row(
                        children: [
                          VariableText(
                            text: "Visible on your profile",
                            fontFamily: fontSemiBold,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.022,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: padding / 3,
                          left: padding * 2,
                          right: padding * 2,
                          bottom: padding / 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          VariableText(
                            text: "Email Address",
                            fontFamily: fontRegular,
                            fontsize: size.height * 0.020,
                            fontcolor: textColorG,
                            textAlign: TextAlign.left,
                          ),
                          FlutterSwitch(
                            width: size.width * 0.13,
                            height: size.height * 0.035,
                            valueFontSize: size.height * 0.015,
                            toggleSize: size.height * 0.025,
                            value: isEmail,
                            borderRadius: 30.0,
                            // padding: 8.0,
                            showOnOff: true,
                            activeColor: primaryColor1,
                            inactiveText: "Off",
                            inactiveColor: primaryColor1,
                            inactiveTextColor: textColorW,
                            activeTextColor: textColorW,
                            onToggle: (val) {
                              setState(() {
                                isEmail = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: padding * 2,
                          right: padding * 2,
                          bottom: padding / 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          VariableText(
                            text: "Your Number",
                            fontFamily: fontRegular,
                            fontsize: size.height * 0.020,
                            fontcolor: textColorG,
                            textAlign: TextAlign.left,
                          ),
                          FlutterSwitch(
                            width: size.width * 0.13,
                            height: size.height * 0.035,
                            valueFontSize: size.height * 0.015,
                            toggleSize: size.height * 0.025,
                            value: isNumber,
                            borderRadius: 30.0,
                            // padding: 8.0,
                            showOnOff: true,
                            activeColor: primaryColor1,
                            inactiveText: "Off",
                            inactiveColor: primaryColor1,
                            inactiveTextColor: textColorW,
                            activeTextColor: textColorW,
                            onToggle: (val) {
                              setState(() {
                                isNumber = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: padding * 2,
                          right: padding * 2,
                          bottom: padding / 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          VariableText(
                            text: "Birthday",
                            fontFamily: fontRegular,
                            fontsize: size.height * 0.020,
                            fontcolor: textColorG,
                            textAlign: TextAlign.left,
                          ),
                          FlutterSwitch(
                            width: size.width * 0.13,
                            height: size.height * 0.035,
                            valueFontSize: size.height * 0.015,
                            toggleSize: size.height * 0.025,
                            value: isBirth,
                            borderRadius: 30.0,
                            // padding: 8.0,
                            showOnOff: true,
                            activeColor: primaryColor1,
                            inactiveText: "Off",
                            inactiveColor: primaryColor1,
                            inactiveTextColor: textColorW,
                            activeTextColor: textColorW,
                            onToggle: (val) {
                              setState(() {
                                isBirth = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: padding * 2,
                          right: padding * 2,
                          bottom: padding / 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          VariableText(
                            text: "Location",
                            fontFamily: fontRegular,
                            fontsize: size.height * 0.020,
                            fontcolor: textColorG,
                            textAlign: TextAlign.left,
                          ),
                          FlutterSwitch(
                            width: size.width * 0.13,
                            height: size.height * 0.035,
                            valueFontSize: size.height * 0.015,
                            toggleSize: size.height * 0.025,
                            value: isLocation,
                            borderRadius: 30.0,
                            // padding: 8.0,
                            showOnOff: true,
                            activeColor: primaryColor1,
                            inactiveText: "Off",
                            inactiveColor: primaryColor1,
                            inactiveTextColor: textColorW,
                            activeTextColor: textColorW,
                            onToggle: (val) {
                              setState(() {
                                isLocation = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: padding * 2,
                          right: padding * 2,
                          bottom: padding / 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          VariableText(
                            text: "Your Bio",
                            fontFamily: fontRegular,
                            fontsize: size.height * 0.020,
                            fontcolor: textColorG,
                            textAlign: TextAlign.left,
                          ),
                          FlutterSwitch(
                            width: size.width * 0.13,
                            height: size.height * 0.035,
                            valueFontSize: size.height * 0.015,
                            toggleSize: size.height * 0.025,
                            value: isBio,
                            borderRadius: 30.0,
                            // padding: 8.0,
                            showOnOff: true,
                            activeColor: primaryColor1,
                            inactiveText: "Off",
                            inactiveColor: primaryColor1,
                            inactiveTextColor: textColorW,
                            activeTextColor: textColorW,
                            onToggle: (val) {
                              setState(() {
                                isBio = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: padding - 7, left: padding - 6),
                      child: Row(
                        children: [
                          VariableText(
                            text: "Set who can see you",
                            fontFamily: fontSemiBold,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.022,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.01,
                            horizontal: size.height * 0.04),
                        itemCount: whoSeeList.length,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 5,
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                        ),
                        itemBuilder: (context, int index) {
                          return InkWell(
                            onTap: () {
                              onSelectedIndex(index);

                            },
                            child: Row(
                              children: [
                                Container(
                                  height: size.height * 0.022,
                                  width: size.height * 0.022,
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
                                      size: size.height * 0.015,
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                VariableText(
                                  text: whoSeeList[index].name,
                                  fontFamily: fontRegular,
                                  fontcolor: textColorG,
                                  fontsize: size.height * 0.020,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: padding - 7, bottom: padding, left: padding - 6),
                      child: Row(
                        children: [
                          VariableText(
                            text: "Set who can see you",
                            fontFamily: fontSemiBold,
                            fontcolor: primaryColor2,
                            fontsize: size.height * 0.022,
                          ),
                        ],
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
                          labelText: "Gender",
                          labelStyle: TextStyle(
                            fontSize: size.height * 0.025,
                            color: primaryColor2,
                            fontFamily: fontSemiBold,
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
                          labelText: "Age Range",
                          labelStyle: TextStyle(
                            fontSize: size.height * 0.025,
                            color: primaryColor2,
                            fontFamily: fontSemiBold,
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding * 4, vertical: padding / 2),
                      child: MyButton(
                        onTap: () {
                          updatePrivacyOptions();
                          // Navigator.push(
                          //     context,
                          //     SwipeLeftAnimationRoute(
                          //       widget: SexualOrientationScreen(),
                          //     ));
                        },
                        btnTxt: tr("Save"),
                        borderColor: primaryColor2,
                        btnColor: primaryColor2,
                        txtColor: textColorW,
                        btnRadius: 25,
                        btnWidth: size.width * 0.75,
                        btnHeight: 50,
                        fontSize: size.height * 0.020,
                        weight: FontWeight.w700,
                        fontFamily: fontSemiBold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if(isLoadingUpdate) ProcessLoadingLight()
        ],
      ),
    );
  }
}
