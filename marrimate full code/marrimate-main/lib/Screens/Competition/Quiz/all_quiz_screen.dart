import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:marrimate/Screens/Competition/Quiz/add_quiz_screen.dart';
import 'package:marrimate/Screens/Dashboard/Dashboard/couple_match_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/new_quiz_model.dart';
import 'package:marrimate/models/quiz_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../leaderboard_screen.dart';
import '../start_quiz_screen.dart';
import 'liked_screen.dart';

class AllQuizScreen extends StatefulWidget {
  AllQuizScreen({Key key}) : super(key: key);

  @override
  State<AllQuizScreen> createState() => _AllQuizScreenState();
}

class _AllQuizScreenState extends State<AllQuizScreen>{

  List<Quiz> allQuiz = [];
  bool isLoading = false;
  DateFormat monthFormatter = DateFormat("MMM");
  DateFormat dayFormatter = DateFormat("dd");

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  getAllQuiz()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getAllQuiz(userDetails);
    if(response != null){
      if(response['status']){
        allQuiz.clear();
        for(var item in response['data']){
          allQuiz.add(Quiz.fromJson(item));
        }
        setLoading(false);
      }else{
        allQuiz.clear();
        setLoading(false);
      }
    }else{
      allQuiz.clear();
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllQuiz();
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            // height: size.height,
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/profile_header.png",
                  width: double.infinity,
                  height: size.height * 0.3,
                  fit: BoxFit.fill,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppBar(
                      title: VariableText(
                        text: tr("My Quiz"),
                        fontFamily: fontSemiBold,
                        fontsize: size.height * 0.026,
                        fontcolor: textColorW,
                      ),
                      leading: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          "assets/icons/ic_back.png",
                          scale: 2,
                        ),
                      ),
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      actions: [
                        InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                SwipeLeftAnimationRoute(
                                  widget: LeaderboardScreen(),
                                ));
                          },
                          child: Container(
                            child: Image.asset("assets/icons/ic_leaderboard.png", scale: 2.3, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                isLoading ?
                Column(
                  children: [
                    SizedBox(height: size.height * 0.1),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      period: Duration(milliseconds: 1000),
                      child: ListView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (BuildContext context, index){
                            return Column(
                              children: [
                                Container(
                                  height: size.height * 0.24,
                                  width: size.width,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        child: Container(
                                          //height: cHeight,
                                            width: size.width * 0.80,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                    )
                  ],
                ) :
                    allQuiz.isEmpty ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: size.height * 0.40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VariableText(
                                  text: tr("No Quiz Found"),
                                  fontFamily: fontSemiBold,
                                  fontsize: size.height * 0.020,
                                  fontcolor: textColorG,
                                ),
                              ],
                            ),
                          ],
                        ) :
                Column(
                  children: [
                    SizedBox(height: size.height * 0.1),
                    ListView.builder(
                      itemCount: allQuiz.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return quizCard(allQuiz[index]);
                      },
                    ),
                  ],
                ),
                /*Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      quizCard(),
                      quizCard(),
                      quizCard(),
                      quizCard(),
                      quizCard(),
                    ],
                  ),
                ),*/
              ],
            ),
          ),
        ),
        bottomNavigationBar: MyButton(
          onTap: () {
            Provider.of<NewQuiz>(context, listen: false).initializeQuiz();
            Navigator.push(
                context, SwipeLeftAnimationRoute(widget: AddQuizScreen())).then((value){
                  if(value != null){
                    if(value){
                      getAllQuiz();
                    }
                  }
            });
          },
          btnTxt: tr("Create a Quiz"),
          borderColor: primaryColor1,
          btnColor: primaryColor1,
          txtColor: textColorW,
          btnRadius: 0,
          btnWidth: size.width,
          btnHeight: 50,
          fontSize: size.height * 0.020,
          weight: FontWeight.w700,
          fontFamily: fontSemiBold,
        ),
      ),
    );
  }

  Widget quizCard(Quiz quizDetails) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.height * 0.00),
      //height: size.height * 0.2,
      color: textColorW,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: padding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(height: size.height * 0.01),
              VariableText(
                text: monthFormatter.format(DateTime.parse(quizDetails.createdAt)),
                fontFamily: fontSemiBold,
                fontsize: size.height * 0.019,
                fontcolor: textColorB,
                textAlign: TextAlign.left,
                line_spacing: size.height * 0.0017,
              ),
              Container(
                width: size.width * 0.08,
                height: size.width * 0.08,
                /*padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.024,
                    vertical: size.width * 0.015),*/
                // margin: EdgeInsets.symmetric(vertical: padding / 2),
                decoration: BoxDecoration(
                  color: Color(0xFF56CCF2),
                  borderRadius: BorderRadius.circular(size.height * 0.1),
                  border: Border.all(
                    color: textColorB,
                  ),
                ),
                child: Center(
                  child: VariableText(
                    text: dayFormatter.format(DateTime.parse(quizDetails.createdAt)),
                    fontFamily: fontSemiBold,
                    fontsize: size.height * 0.015,
                    fontcolor: textColorB,
                    //textAlign: TextAlign.left,
                    //line_spacing: size.height * 0.0017,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: padding / 2, vertical: padding / 3),
              margin: EdgeInsets.symmetric(vertical: padding / 2),
              decoration: BoxDecoration(
                color: borderLightColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(size.height * 0.01),
                border: Border.all(
                  color: borderColor,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/icons/ic_quiz2.png",
                    height: size.height * 0.05,
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VariableText(
                          text: quizDetails.name,
                          fontFamily: fontBold,
                          fontsize: size.height * 0.019,
                          fontcolor: textColorB,
                          max_lines: 1,
                          textAlign: TextAlign.left,
                          line_spacing: size.height * 0.0017,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: VariableText(
                                text: quizDetails.description,
                                fontFamily: fontSemiBold,
                                fontsize: size.height * 0.019,
                                fontcolor: textColorG,
                                max_lines: 6,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            // horizontal: padding * 2,
                            vertical: padding / 2,
                          ),
                          child: MyButton(
                            onTap: () {
                              /*Navigator.push(
                                  context,
                                  SwipeLeftAnimationRoute(
                                      widget: StartQuizScreen(
                                        quizID: quizDetails.id,
                                      )));*/
                              Navigator.push(
                                  context,
                                  SwipeLeftAnimationRoute(
                                      widget: LikedScreen(
                                        quizDetails: quizDetails,
                                      )));
                            },
                            btnTxt: "Share",
                            borderColor: primaryColor1,
                            btnColor: primaryColor1,
                            txtColor: textColorW,
                            btnRadius: 5,
                            btnWidth: size.width * 0.5,
                            btnHeight: 40,
                            fontSize: size.height * 0.020,
                            weight: FontWeight.w700,
                            fontFamily: fontSemiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
