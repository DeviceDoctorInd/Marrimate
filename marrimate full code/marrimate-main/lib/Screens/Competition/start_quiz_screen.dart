import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Competition/competition_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/quiz_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class StartQuizScreen extends StatefulWidget {
  int quizID;
  StartQuizScreen({Key key, this.quizID}) : super(key: key);

  @override
  State<StartQuizScreen> createState() => _StartQuizScreenState();
}

class _StartQuizScreenState extends State<StartQuizScreen> {

  Quiz quizDetails;
  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  checkAvailability()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.checkQuiz(widget.quizID, userDetails);
    if(response != null){
      if(response['status']){
        print(response.toString());
        getQuizDetails();
      }else{
        setLoading(false);
        Fluttertoast.showToast(
            msg: response['msg'].toString(),
            toastLength: Toast.LENGTH_LONG);
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);

    }
  }

  getQuizDetails()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.getSingleQuiz(widget.quizID, userDetails);
    if(response != null){
      if(response['status']){
        quizDetails = Quiz.fromJson(response['data']);
        setLoading(false);
        Navigator.push(
            context,
            SwipeLeftAnimationRoute(
              widget: CompetitionScreen(
                quizDetails: quizDetails,
              ),
            ));
      }else{
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      setLoading(false);
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);

    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: textColorW,
            appBar: CustomAppBar(
              text: "",
              isBack: true,
              actionImage: "assets/icons/ic_more_option.png",
              height: size.height * 0.085,
              isActionBar: false,
            ),
            body: Container(
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.1),
                  Image.asset(
                    "assets/images/competition.png",
                    width: size.height * 0.25,
                  ),
                  SizedBox(height: size.height * 0.04),
                  Container(
                    width: size.width * 0.5,
                    child: VariableText(
                      text: "Compatibility Test",
                      fontFamily: fontMatchMaker,
                      fontcolor: primaryColor2,
                      fontsize: size.height * 0.044,
                      textAlign: TextAlign.center,
                      max_lines: 2,
                      line_spacing: 1.2,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  /*Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.height * 0.04),
                    child: VariableText(
                      text: "Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                      fontFamily: fontRegular,
                      fontcolor: primaryColor2,
                      fontsize: size.height * 0.0185,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w600,
                      max_lines: 5,
                      line_spacing: 1.3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.height * 0.04),
                    child: VariableText(
                      text: "Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                      fontFamily: fontRegular,
                      fontcolor: primaryColor2,
                      fontsize: size.height * 0.0185,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w600,
                      max_lines: 5,
                      line_spacing: 1.3,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.height * 0.04),
                    child: VariableText(
                      text: "Lorem Ipsum Lorem Ipsum Lorem Ipsum",
                      fontFamily: fontRegular,
                      fontcolor: primaryColor2,
                      fontsize: size.height * 0.0185,
                      textAlign: TextAlign.center,
                      weight: FontWeight.w600,
                      max_lines: 5,
                      line_spacing: 1.3,
                    ),
                  ),*/
                  SizedBox(height: size.height * 0.05),
                  MyButton(
                    onTap: () {
                      checkAvailability();
                    },
                    btnTxt: "Start",
                    btnColor: primaryColor2,
                    txtColor: textColorW,
                    btnRadius: 5,
                    btnWidth: size.width * 0.75,
                    btnHeight: 50,
                    fontSize: size.height * 0.020,
                    weight: FontWeight.w700,
                    fontFamily: fontSemiBold,
                  ),
                ],
              ),
            ),
          ),
          if(isLoading) ProcessLoadingLight()
        ],
      ),
    );
  }
}
