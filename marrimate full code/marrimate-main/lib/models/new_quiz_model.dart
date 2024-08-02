
import 'package:flutter/material.dart';
import 'package:marrimate/models/quiz_model.dart';

class NewQuiz with ChangeNotifier{
  Quiz quiz;

  initializeQuiz(){
    quiz = Quiz.empty();
    //quiz.questions.add(Question.empty());
    notifyListeners();
  }

  Map<String, dynamic> toCreateJson(Quiz quizDetails) {
    List<String> questionsList = [];
    List<String> option1List = [];
    List<String> option2List = [];
    List<String> option3List = [];
    List<String> option4List = [];
    List<String> answersList = [];

    for(var item in quiz.questions){
      questionsList.add(item.question);
      option1List.add(item.option1);
      option2List.add(item.option2);
      option3List.add(item.option3);
      option4List.add(item.option4);
      answersList.add(item.answer);
    }

    Map<String, dynamic> data = Map<String, dynamic>();
    data['quiz_name'] = quizDetails.name;
    data['quiz_description'] = quizDetails.description;
    data['question'] = questionsList;
    data['option1'] = option1List;
    data['option2'] = option2List;
    data['option3'] = option3List;
    data['option4'] = option4List;
    data['right_answer'] = answersList;
    return data;
  }

  addQuestion(){
    quiz.questions.add(Question.empty());
    notifyListeners();
  }

  removeQuestion(int index){
    quiz.questions.removeAt(index);
    notifyListeners();
  }
}