import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/LoginRegistration/sexual_orientation_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/hobbies_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class HobbiesScreen extends StatefulWidget {
  const HobbiesScreen({Key key}) : super(key: key);

  @override
  State<HobbiesScreen> createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends State<HobbiesScreen> {
  bool isLoading = false;
  List<Hobby> hobbies = [];
  List<bool> isSelected = [];

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }


  getHobbies()async{
    setLoading(true);
    var response = await API.getAllHobbies();
    if(response != null){
      for(var item in response){
        hobbies.add(Hobby.fromJson(item));
      }
      isSelected = List.filled(hobbies.length, false);
      setLoading(false);
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  validate(){
    bool isOkay = false;
    for(var item in isSelected){
      if(item){
        isOkay = true;
        break;
      }
    }
    if(!isOkay){
      Fluttertoast.showToast(
          msg: "Select at least one hobby",
          toastLength: Toast.LENGTH_SHORT);
    }
    return isOkay;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHobbies();
  }

  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<UserModel>(context, listen: true);

    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.06;

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
              top: size.height * 0.06,
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
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.085),
                // SizedBox(height: size.height * 0.12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 4.4),
                  child: Image.asset(
                    "assets/images/merrimate_logo.png",
                    // width: size.width * 0.25,
                  ),
                ),
                SizedBox(height: size.height * 0.08),
                VariableText(
                  text: tr("Hobbies"),
                  fontFamily: fontMatchMaker,
                  fontcolor: primaryColor2,
                  fontsize: size.height * 0.047,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.015),
                VariableText(
                  text: tr("Share your likes & passion with others"),
                  fontFamily: fontMedium,
                  fontcolor: textColorG,
                  fontsize: size.height * 0.018,
                  textAlign: TextAlign.center,
                  max_lines: 2,
                  line_spacing: size.height * 0.0017,
                ),
                //SizedBox(height: size.height * 0.01),
                isLoading ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProcessLoadingWhite()
                    ],
                  ),
                ) :
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(padding * 1.2),
                    child: GridView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: hobbies.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: size.width * 0.05,
                          mainAxisSpacing: size.height * 0.03,
                          childAspectRatio: 3.5,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, int index) {
                          return SocialLoginButton(
                            onTap: () {
                              setState(() {
                                isSelected[index] = !isSelected[index];
                              });
                            },
                            btnTxt: hobbies[index].name,
                            borderColor: isSelected[index]
                                ? primaryColor1
                                : textColorG,
                            btnColor: isSelected[index]
                                ? primaryColor1
                                : textColorW,
                            txtColor:
                            isSelected[index] ? textColorW : textColorG,
                            btnRadius: 25,
                            btnWidth: size.width * 0.45,
                            btnHeight: size.height * 0.1,
                            fontSize: size.height * 0.018,
                            weight: FontWeight.bold,
                            icon: hobbies[index].icon,
                            iconHeight: size.height * 0.023,
                            iconColor:
                            isSelected[index] ? textColorW : null,
                          );
                        }),
                  ),
                ),

                if(!isLoading)
                MyButton(
                  onTap: () {
                    if(validate()){
                      userDetails.hobbies.clear();
                      for(int i=0; i < isSelected.length; i++){
                        if(isSelected[i]){
                          userDetails.hobbies.add(hobbies[i]);
                        }
                      }
                      Navigator.push(
                          context,
                          SwipeLeftAnimationRoute(
                            widget: SexualOrientationScreen(),
                          ));
                    }
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
                SizedBox(height: size.height * 0.01),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
