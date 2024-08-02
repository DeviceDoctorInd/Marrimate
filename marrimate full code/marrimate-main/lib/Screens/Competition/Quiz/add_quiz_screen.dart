import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marrimate/Screens/Competition/Quiz/all_quiz_screen.dart';
import 'package:marrimate/Widgets/common.dart';
import 'package:marrimate/Widgets/styles.dart';
import 'package:marrimate/models/new_quiz_model.dart';
import 'package:marrimate/models/quiz_model.dart';
import 'package:marrimate/models/user_model.dart';
import 'package:marrimate/services/api.dart';
import 'package:provider/provider.dart';

class AddQuizScreen extends StatefulWidget {
  AddQuizScreen({Key key}) : super(key: key);

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen>{

  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  bool isLoading = false;

  setLoading(bool loading){
    setState(() {
      isLoading = loading;
    });
  }

  validate(){
    if(_formKey.currentState.validate()){
      var newQuiz = Provider.of<NewQuiz>(context, listen: false);
      print("Validated!!!");
      print(newQuiz.toCreateJson(newQuiz.quiz));
      createQuiz();
    }
  }

  createQuiz()async{
    setLoading(true);
    var userDetails = Provider.of<UserModel>(context, listen: false);
    var newQuiz = Provider.of<NewQuiz>(context, listen: false);
    var response = await API.createQuiz(newQuiz, userDetails);
    if(response != null){
      if(response['status']){
        setLoading(false);
        Fluttertoast.showToast(
            msg: "Quiz created successfully",
            toastLength: Toast.LENGTH_SHORT);
        Navigator.of(context).pop(true);
      }else{
        setLoading(false);
        Fluttertoast.showToast(
            msg: response['msg'],
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
    var newQuiz = Provider.of<NewQuiz>(context).quiz;
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(
                "assets/images/profile_header.png",
                width: double.infinity,
                height: size.height * 0.3,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppBar(
                    title: VariableText(
                      text: tr("Create Quiz"),
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
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: size.height * 0.1),
                      Container(
                        //height:  size.height * 0.28,
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.05),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white)
                        ),
                        child: Column(
                          children: [
                            ///Title
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding, vertical: padding / 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VariableText(
                                    text: "Title",
                                    fontcolor: textColorB,
                                    fontFamily: fontRegular,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  TextFormField(
                                    controller: _titleController,
                                    onChanged: (value){
                                      newQuiz.name = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter quiz title';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: textColor1,
                                      fontSize: size.height * 0.02,
                                    ),
                                    decoration: const InputDecoration(
                                        hintText: "Enter Quiz Title",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 12, right: 8, bottom: 0)),
                                  ),
                                ],
                              ),
                            ),
                            ///Description
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padding, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  VariableText(
                                    text: "Description",
                                    fontcolor: textColorB,
                                    fontFamily: fontRegular,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  TextFormField(
                                    maxLines: 3,
                                    controller: _descController,
                                    onChanged: (value){
                                      newQuiz.description = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter quiz description';
                                      }
                                      return null;
                                    },
                                    style: TextStyle(
                                      fontFamily: fontRegular,
                                      color: textColor1,
                                      fontSize: size.height * 0.02,
                                      height: size.height * 0.0018,
                                    ),
                                    decoration: const InputDecoration(
                                        hintText: "Enter Description",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 12, right: 8, top: 8, bottom: 0)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      VariableText(
                                        text: "Questions:",
                                        fontcolor: textColorB,
                                        fontFamily: fontRegular,
                                        weight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          itemCount: newQuiz.questions.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return NewQuizQuestion(
                              index: index,
                              questionDetails: newQuiz.questions[index],
                            );
                          }),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 2,
                            vertical: padding / 2,
                          ),
                          child: MyButton(
                            onTap: () {
                              if(newQuiz.questions.length < 15){
                                Provider.of<NewQuiz>(context, listen: false).addQuestion();
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Questions Limit Reached",
                                    toastLength: Toast.LENGTH_SHORT);

                              }
                            },
                            btnTxt: tr("Add More"),
                            borderColor: primaryColor1,
                            btnColor: primaryColor1,
                            txtColor: textColorW,
                            btnRadius: 5,
                            btnWidth: size.width * 0.3,
                            btnHeight: 40,
                            fontSize: size.height * 0.020,
                            weight: FontWeight.w700,
                            fontFamily: fontSemiBold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: padding * 2,
                          vertical: padding / 2,
                        ),
                        child: MyButton(
                          onTap: () {
                            if(newQuiz.questions.length < 5){
                              Fluttertoast.showToast(
                                  msg: "Add Minimum 5 Questions",
                                  toastLength: Toast.LENGTH_SHORT);
                            }else{
                              validate();
                            }
                          },
                          btnTxt: tr("Save And Continue"),
                          borderColor: primaryColor1,
                          btnColor: primaryColor1,
                          txtColor: textColorW,
                          btnRadius: 5,
                          btnWidth: size.width,
                          btnHeight: 40,
                          fontSize: size.height * 0.020,
                          weight: FontWeight.w700,
                          fontFamily: fontSemiBold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
              if(isLoading) Positioned.fill(child: ProcessLoadingLight())
            ],
          ),
        ),
      ),
    );
  }
}

class NewQuizQuestion extends StatefulWidget {
  int index;
  Question questionDetails;
  NewQuizQuestion({Key key, this.questionDetails, this.index}) : super(key: key);

  @override
  _NewQuizQuestionState createState() => _NewQuizQuestionState();
}

class _NewQuizQuestionState extends State<NewQuizQuestion> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _option1Controller = TextEditingController();
  TextEditingController _option2Controller = TextEditingController();
  TextEditingController _option3Controller = TextEditingController();
  TextEditingController _option4Controller = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var padding = size.height * 0.03;

    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.05),
      //height: size.height * 0.5,
      decoration: BoxDecoration(
        color: textColorW,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VariableText(
                text: "Q${widget.index + 1}:",
                fontcolor: textColorB,
                fontFamily: fontRegular,
                weight: FontWeight.w600,
              ),
              if(widget.index != 0)
                InkWell(
                    onTap: (){
                      Provider.of<NewQuiz>(context, listen: false).removeQuestion(widget.index);
                    },
                    child: Icon(Icons.clear, color: Colors.black)
                )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              maxLines: 4,
              controller: _questionController,
              onChanged: (value){
                widget.questionDetails.question = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter question';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: borderLightColor.withOpacity(0.12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: borderColor, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: borderColor, width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red, width: 1.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red, width: 1.0),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10
                ),
                hintText:
                "Enter Question here",
                hintStyle: TextStyle(
                  fontFamily: fontSemiBold,
                  fontSize: size.height * 0.019,
                  color: textColorG,
                ),
              ),
            ),
          ),
          ///option1
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: padding / 2, vertical: padding / 4),
            child: TextFormField(
              controller: _option1Controller,
              textInputAction: TextInputAction.next,
              onChanged: (value){
                widget.questionDetails.option1 = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option';
                }
                return null;
              },
              style: TextStyle(
                fontFamily: fontRegular,
                color: textColor1,
                fontSize: size.height * 0.019,
              ),
              decoration: InputDecoration(
                  hintText: "Enter Option A",
                  prefixIcon: Container(
                    width: size.width * 0.01,
                    //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: textColorW,
                      borderRadius: BorderRadius.circular(size.height * 0.01),
                      border: Border.all(
                        color: textColorB,
                      ),
                    ),
                    child: Center(
                      child: VariableText(
                        text: "A",
                        fontFamily: fontBold,
                        fontsize: size.height * 0.020,
                        fontcolor: textColorB,
                        max_lines: 1,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  contentPadding: EdgeInsets.only(
                      left: 12, right: 8, bottom: 0)),
            ),
          ),
          ///option2
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: padding / 2, vertical: padding / 4),
            child: TextFormField(
              controller: _option2Controller,
              textInputAction: TextInputAction.next,
              onChanged: (value){
                widget.questionDetails.option2 = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option';
                }
                return null;
              },
              style: TextStyle(
                fontFamily: fontRegular,
                color: textColor1,
                fontSize: size.height * 0.019,
              ),
              decoration: InputDecoration(
                  hintText: "Enter Option B",
                  prefixIcon: Container(
                    width: size.width * 0.01,
                    //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: textColorW,
                      borderRadius: BorderRadius.circular(size.height * 0.01),
                      border: Border.all(
                        color: textColorB,
                      ),
                    ),
                    child: Center(
                      child: VariableText(
                        text: "B",
                        fontFamily: fontBold,
                        fontsize: size.height * 0.020,
                        fontcolor: textColorB,
                        max_lines: 1,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  contentPadding: EdgeInsets.only(
                      left: 12, right: 8, bottom: 0)),
            ),
          ),
          ///option3
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: padding / 2, vertical: padding / 4),
            child: TextFormField(
              controller: _option3Controller,
              textInputAction: TextInputAction.next,
              onChanged: (value){
                widget.questionDetails.option3 = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option';
                }
                return null;
              },
              style: TextStyle(
                fontFamily: fontRegular,
                color: textColor1,
                fontSize: size.height * 0.019,
              ),
              decoration: InputDecoration(
                  hintText: "Enter Option C",
                  prefixIcon: Container(
                    width: size.width * 0.01,
                    //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: textColorW,
                      borderRadius: BorderRadius.circular(size.height * 0.01),
                      border: Border.all(
                        color: textColorB,
                      ),
                    ),
                    child: Center(
                      child: VariableText(
                        text: "C",
                        fontFamily: fontBold,
                        fontsize: size.height * 0.020,
                        fontcolor: textColorB,
                        max_lines: 1,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  contentPadding: EdgeInsets.only(
                      left: 12, right: 8, bottom: 0)),
            ),
          ),
          ///option4
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: padding / 2, vertical: padding / 4),
            child: TextFormField(
              controller: _option4Controller,
              textInputAction: TextInputAction.next,
              onChanged: (value){
                widget.questionDetails.option4 = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter option';
                }
                return null;
              },
              style: TextStyle(
                fontFamily: fontRegular,
                color: textColor1,
                fontSize: size.height * 0.019,
              ),
              decoration: InputDecoration(
                  hintText: "Enter Option D",
                  prefixIcon: Container(
                    width: size.width * 0.01,
                    //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: textColorW,
                      borderRadius: BorderRadius.circular(size.height * 0.01),
                      border: Border.all(
                        color: textColorB,
                      ),
                    ),
                    child: Center(
                      child: VariableText(
                        text: "D",
                        fontFamily: fontBold,
                        fontsize: size.height * 0.020,
                        fontcolor: textColorB,
                        max_lines: 1,
                      ),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  contentPadding: EdgeInsets.only(
                      left: 12, right: 8, bottom: 0)),
            ),
          ),
          ///Answer
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: padding / 2, vertical: padding / 4),
            child: TextFormField(
              controller: _answerController,
              textInputAction: TextInputAction.done,
              onChanged: (value){
                widget.questionDetails.answer = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter answer';
                }else if(value == _option1Controller.text ||
                    value == _option2Controller.text ||
                    value == _option3Controller.text ||
                    value == _option4Controller.text
                ){
                  return null;
                }else{
                  return "Answer not found in options";
                }
                return null;
              },
              style: TextStyle(
                fontFamily: fontRegular,
                color: textColor1,
                fontSize: size.height * 0.019,
              ),
              decoration: InputDecoration(
                  hintText: "Enter Answer",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: textColorB, width: 1.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: Colors.red, width: 1.0),
                  ),
                  contentPadding: EdgeInsets.only(
                      left: 12, right: 8, bottom: 0)),
            ),
          ),
        ],
      ),
    );
  }
}

