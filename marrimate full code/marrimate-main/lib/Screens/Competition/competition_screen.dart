import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Competition/result_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/quiz_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class CompetitionScreen extends StatefulWidget {
  Quiz quizDetails;
  CompetitionScreen({Key key, this.quizDetails}) : super(key: key);

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen>
    with TickerProviderStateMixin{

  List<AnimationController> _controllers = [];
  List<Animation<Offset>> _offsetAnimations = [];
  List<bool> _visibles = [];
  List<bool> _actives = [];
  int activeIndex;

  double vWidth = 0.0;
  int currentIndex = 1;

  Timer timer;
  int _countDown = 15;

  setTimer(){
    timer  = Timer.periodic(const Duration(seconds: 1),
            (Timer _timer) {
          if (_countDown == 1) {
            setState(() {
              if(selectedAnswerIndex != -1){
                answers.add(getOption(widget.quizDetails.questions[activeIndex], selectedAnswerIndex));
              }else{
                answers.add("");
              }
              if(widget.quizDetails.questions.length-1 == activeIndex){
                _timer.cancel();
                submitQuiz();
              }else{
                nextQuestion(activeIndex);
                _countDown = 15;
              }
            });
          } else {
            setState(() {
              _countDown--;
            });
          }
        }
    );
  }

  nextQuestion(int index){
    currentIndex++;
    activeIndex = index+1;
    calculateProgress();
    _controllers[index].forward();
    setState(() {
      selectedAnswerIndex = -1;
      _visibles[index] = false;
      _actives[index+1] = true;
    });
  }

  calculateProgress(){
    var size = MediaQuery.of(context).size;
    //print("${size.width * 0.70}");
    double totalWidth = size.width * 0.70;
    double singleWidth = totalWidth / widget.quizDetails.questions.length;
    //print(singleWidth.toString());
    setState(() {
      vWidth = currentIndex * singleWidth;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTimer();
    for(int i=0; i < widget.quizDetails.questions.length; i++){
      _controllers.add(AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      )
      );

      _offsetAnimations.add(Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.0, 0.0),
      ).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.linear,
      )
      )
      );
      _visibles.add(true);
      _actives.add(false);
    }
    _actives.first = true;
    activeIndex = 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  Future<bool> onWillPop() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to quit the Quiz?'),
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
    var userDetails = Provider.of<UserModel>(context);
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: textColorW,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: size.height * 0.085,
            backgroundColor: textColorW,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/appbar_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  //flex: 10,
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.00),
                      Container(
                        height: size.height * 0.05,
                        width: size.height * 0.05,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: userDetails.profilePicture,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.totalSize != null ?
                                      downloadProgress.downloaded / downloadProgress.totalSize
                                          : null,
                                      color: primaryColor2),
                                ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: VariableText(
                          text: userDetails.name,
                          fontFamily: fontSemiBold,
                          fontsize: size.height * 0.018,
                          fontcolor: textColorW,
                          max_lines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                  width: size.height * 0.05,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/ic_clock.png",
                        scale: 2.5,
                      ),
                      VariableText(
                        text: "0:${_countDown.toString()}",
                        fontFamily: fontSemiBold,
                        fontsize: size.height * 0.02,
                        fontcolor: textColorW,
                      ),
                    ],
                  )
                ),
                Expanded(
                  //flex: 10,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: VariableText(
                          text: widget.quizDetails.creatorDetails.name,
                          fontFamily: fontSemiBold,
                          fontsize: size.height * 0.018,
                          fontcolor: textColorW,
                          max_lines: 2,
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Container(
                        height: size.height * 0.05,
                        width: size.height * 0.05,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: widget.quizDetails.creatorDetails.profilePicture,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: size.height * 0.128),
                                  child: CircularProgressIndicator(
                                      value: downloadProgress.totalSize != null ?
                                      downloadProgress.downloaded / downloadProgress.totalSize
                                          : null,
                                      color: primaryColor2),
                                ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          )
                        ),
                      ),
                      //SizedBox(width: size.width * 0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            height: size.height,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.03),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.12),
                  child: Row(
                    children: [
                      VariableText(
                        text: "Question ${currentIndex.toString()}/${widget.quizDetails.questions.length}",
                        fontFamily: fontBold,
                        fontsize: size.height * 0.019,
                        fontcolor: primaryColor2,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.12),
                  child: Row(
                    children: [
                      Container(
                        height: 8,
                        width: size.width * 0.70,
                        decoration: BoxDecoration(
                          color: primaryColor2,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                              height: 8,
                              width: vWidth,
                              decoration: BoxDecoration(
                                  color: primaryColor1,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  //height: size.height * 0.65,
                  width: double.infinity,
                  //color: Colors.brown,
                  child: Stack(
                    children: [
                      ...renderQuestions(size)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> renderQuestions(Size size){
    final children = <Widget>[];
    for(int i=widget.quizDetails.questions.length-1; i >= 0; i--){
      children.add(
          AnimatedOpacity(
            opacity: _visibles[i] ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: SlideTransition(
              position: _offsetAnimations[i],
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Container(
                      height: size.height * 0.65,
                      width: size.width * 0.88,
                      margin: EdgeInsets.only(top: 30.0),
                      decoration: BoxDecoration(
                          color: primaryColor2,
                          //color: _actives[i] ? Colors.white : Colors.white.withOpacity(0.5),
                          //border:  Border.all(color: primaryColor2),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: renderQuestion(widget.quizDetails.questions[i], size, i),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: Image.asset(
                        "assets/images/bird.png",
                        width: size.height * 0.11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    }
    return children;
  }

  renderQuizCheck(context){
    var size = MediaQuery.of(context).size;
    showGeneralDialog(
      barrierLabel: "Trim",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return StatefulBuilder(
            builder: (context, setState) {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  height: size.height * 0.16,
                  width: size.width * 0.85,
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.02, horizontal: size.width * 0.08),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: size.height * 0.04,
                          width: size.height * 0.04,
                          child: CircularProgressIndicator(strokeWidth: 4.0, color: primaryColor2)
                      ),
                      SizedBox(height: size.height * 0.02),
                      VariableText(
                        text: "Checking Quiz...",
                        fontFamily: fontSemiBold,
                        fontsize: size.height * 0.020,
                        fontcolor: primaryColor1,
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          //position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  List<String> answers = [];
  int selectedAnswerIndex = -1;

  onAnswerSelect(int index){
    setState(() {
      selectedAnswerIndex = index;
    });
  }

  String getOption(Question questionDetails, int index){
    if(index == 0){
      return questionDetails.option1;
    }else if(index == 1){
      return questionDetails.option2;
    }else if(index == 2){
      return questionDetails.option3;
    }else if(index == 3){
      return questionDetails.option4;
    }
  }

  submitQuiz(){
    int totalQuestions = widget.quizDetails.questions.length;
    int correctAnswers = 0;
    renderQuizCheck(context);
    for(int i=0; i < widget.quizDetails.questions.length; i++){
      print(answers[i]);
      if(widget.quizDetails.questions[i].answer == answers[i]){
        correctAnswers++;
      }
    }
    print(correctAnswers.toString());
    double result = (correctAnswers / totalQuestions) * 100;
    print(result.toStringAsFixed(2));
    publishResult(result);
  }

  publishResult(double result)async{
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var response = await API.publishResult(widget.quizDetails, result.toStringAsFixed(0), userDetails);
    if(response != null){
      if(response['status']){
        Navigator.of(context).pop();
        Navigator.push(
            context,
            SwipeLeftAnimationRoute(
              widget: ResultScreen(
                quizDetails: widget.quizDetails,
                result: result.toStringAsFixed(0),
              ),
            ));
      }else{
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Try again later",
            toastLength: Toast.LENGTH_SHORT);
      }
    }else{
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Try again later",
          toastLength: Toast.LENGTH_SHORT);

    }
  }

  renderQuestion(Question questionDetails, Size size, int index){
    return Column(
      children: [
        SizedBox(height: size.height * 0.11),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Row(
            children: [
              Expanded(
                child: VariableText(
                  text: "${index+1}. ${questionDetails.question}",
                  fontFamily: fontMedium,
                  fontsize: size.height * 0.021,
                  fontcolor: textColorW,
                  max_lines: 4,
                  line_spacing: 1.3,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              children: List.generate(4, (index){
                return InkWell(
                  onTap: (){
                    onAnswerSelect(index);
                  },
                  child: Container(
                    //height: size.height * 0.055,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                      vertical: size.height * 0.012
                    ),
                    decoration: BoxDecoration(
                      color: selectedAnswerIndex == index ? textColorW : primaryColor2,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: textColorW, width: 2)
                    ),
                    child: Row(
                      children: [
                        if(selectedAnswerIndex == index)
                          Container(
                            height: size.height * 0.025,
                            width: size.height * 0.022,
                            margin: EdgeInsets.only(right: size.width * 0.01),
                            child: Stack(
                              children: [
                                Image.asset("assets/icons/ic_quiz_polygon.png", fit: BoxFit.cover),
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.done, size: 13, color: textColorW,))
                              ],
                            ),
                          ),
                        Expanded(
                          child: VariableText(
                            text: getOption(questionDetails, index),
                            fontFamily: fontRegular,
                            fontsize: size.height * 0.019,
                            fontcolor: selectedAnswerIndex == index ? primaryColor1 : textColorW,
                            max_lines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Container(
          height: size.height * 0.008,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryColor1.withOpacity(0.6),
          ),
        ),
        InkWell(
          onTap: (){
            if(selectedAnswerIndex == -1){
              Fluttertoast.showToast(
                  msg: "Please Select Answer",
                  toastLength: Toast.LENGTH_SHORT);
            }else{
              answers.add(getOption(questionDetails, selectedAnswerIndex));
              if(index == widget.quizDetails.questions.length-1){
                timer.cancel();
                submitQuiz();
              }else{
                setState(() {
                  _countDown = 15;
                });
                nextQuestion(index);
              }
            }
          },
          child: Container(
            height: size.height * 0.062,
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)
              ),
            ),
            child: Center(
              child: VariableText(
                text: index == widget.quizDetails.questions.length-1 ? "Submit" : "Next",
                fontFamily: fontSemiBold,
                fontsize: size.height * 0.022,
                fontcolor: textColorW,
                max_lines: 1,
              ),
            ),
          ),
        )
      ],
    );
  }
}
