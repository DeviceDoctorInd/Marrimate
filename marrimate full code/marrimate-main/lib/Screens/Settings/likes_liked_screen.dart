import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/LoginRegistration/sexual_orientation_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/hobbies_model.dart';
import 'package:marrimate/services/api.dart';

class LikesLikedScreen extends StatefulWidget {
  const LikesLikedScreen({Key key}) : super(key: key);

  @override
  State<LikesLikedScreen> createState() => _LikesLikedScreenState();
}

class _LikesLikedScreenState extends State<LikesLikedScreen> {
  bool isTrue = false;
  List<Map<String, dynamic>> data = [
    {
      "hobbie": "Photography",
      "icon": "assets/icons/ic_camera.png",
      "isTrue": false,
    },
    {
      "hobbie": "Games",
      "icon": "assets/icons/ic_game.png",
      "isTrue": false,
    },
    {
      "hobbie": "Shopping",
      "icon": "assets/icons/ic_shopping.png",
      "isTrue": false,
    },
    {
      "hobbie": "Art & Crafts",
      "icon": "assets/icons/ic-art.png",
      "isTrue": false,
    },
    {
      "hobbie": "Swimming",
      "icon": "assets/icons/ic_swimming.png",
      "isTrue": false,
    },
    {
      "hobbie": "karaoke",
      "icon": "assets/icons/ic_karaoke.png",
      "isTrue": false,
    },
    {
      "hobbie": "Cooking",
      "icon": "assets/icons/ic_cooking.png",
      "isTrue": false,
    },
    {
      "hobbie": "Music",
      "icon": "assets/icons/ic_music.png",
      "isTrue": false,
    },
    {
      "hobbie": "Travelling",
      "icon": "assets/icons/ic_traveling.png",
      "isTrue": false,
    },
    {
      "hobbie": "Drinking",
      "icon": "assets/icons/ic_drinking.png",
      "isTrue": false,
    },
    {
      "hobbie": "Fitness",
      "icon": "assets/icons/ic_fitness.png",
      "isTrue": false,
    },
    {
      "hobbie": "Movie",
      "icon": "assets/icons/ic_movie.png",
      "isTrue": false,
    },
  ];

  List<Hobby> hobbies = [];
  bool isLoadingMain = false;
  bool isLoading = false;

  getHobbies()async{
    setLoadingMain(true);
    var response = await API.getAllHobbies();
    if(response != null){
      for(var item in response){
        hobbies.add(Hobby.fromJson(item));
      }
      setLoadingMain(false);
    }else{
      setLoadingMain(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  setLoadingMain(bool loading){
    if(mounted) {
      setState(() {
        isLoadingMain = loading;
      });
    }
  }
  setLoading(bool loading){
    if(mounted) {
      setState(() {
        isLoading = loading;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getHobbies();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double padding = size.width * 0.06;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: textColorW,
        appBar: CustomSimpleAppBar(
          text: "Likes & Liked",
          isBack: true,
          height: size.height * 0.085,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.03),
                VariableText(
                  text: "Like, Interests",
                  fontFamily: fontBold,
                  fontcolor: primaryColor1,
                  fontsize: size.height * 0.040,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: size.height * 0.015),
                VariableText(
                  text: "Share your likes & passion with others",
                  fontFamily: fontMedium,
                  fontcolor: textColorG,
                  fontsize: size.height * 0.018,
                  textAlign: TextAlign.center,
                  max_lines: 2,
                  line_spacing: size.height * 0.0017,
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: EdgeInsets.all(padding * 1.2),
                  child: GridView.builder(
                      padding: EdgeInsets.all(0),
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                              data[index]['isTrue'] = !data[index]['isTrue'];
                            });
                          },
                          btnTxt: data[index]['hobbie'],
                          borderColor: data[index]['isTrue']
                              ? primaryColor1
                              : textColorG,
                          btnColor: data[index]['isTrue']
                              ? primaryColor1
                              : textColorW,
                          txtColor:
                              data[index]['isTrue'] ? textColorW : textColorG,
                          btnRadius: 25,
                          btnWidth: size.width * 0.45,
                          btnHeight: size.height * 0.1,
                          fontSize: size.height * 0.018,
                          weight: FontWeight.bold,
                          icon: data[index]['icon'],
                          iconHeight: size.height * 0.023,
                          iconColor: data[index]['isTrue'] ? textColorW : null,
                        );
                      }),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: padding * 4),
                  child: MyButton(
                    onTap: () {
                      /*Navigator.push(
                          context,
                          SwipeLeftAnimationRoute(
                            widget: SexualOrientationScreen(),
                          ));*/
                    },
                    btnTxt: "CONTINUE",
                    borderColor: primaryColor2,
                    btnColor: primaryColor2,
                    txtColor: textColorW,
                    btnRadius: 25,
                    btnWidth: size.width * 0.45,
                    btnHeight: 50,
                    fontSize: size.height * 0.020,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                  ),
                ),
                // SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
