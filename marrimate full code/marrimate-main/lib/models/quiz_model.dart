
import 'package:marrimate/models/user_model.dart';

class Quiz{
  int id;
  String creatorID;
  String name;
  String description;
  UserModel creatorDetails;
  List<Question> questions = [];
  String createdAt;


  Quiz({this.id, this.creatorID, this.name, this.description, this.creatorDetails, this.questions, this.createdAt});

  Quiz.empty(){
    name = "";
    description = "";
    questions.add(Question.empty());
  }

  Quiz.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      creatorID = json['user_id'].toString();
      name = json['quiz_name'];
      description = json['quiz_description'];
      createdAt = json['created_at'];
      if(json['question'] != null){
        for(var item in json['question']){
          questions.add(Question.fromJson(item));
        }
      }
      if(json['user'] != null){
        creatorDetails = UserModel.fromQuizJson(json['user']);
      }
    }catch(e, stack){
      print("Quiz.fromJson: " + stack.toString());
    }
  }
}

class Question{
  int id;
  String quizID;
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String answer;

  Question({this.question, this.option1, this.option2, this.option3,
    this.option4, this.answer});

  Question.empty(){
    question = "";
    option1 = "";
    option2 = "";
    option3 = "";
    option4 = "";
    answer = "";
  }

  Question.fromJson(Map<String, dynamic> json){
    try{
      id = json['id'];
      quizID = json['quiz_id'].toString();
      question = json['question'];
      option1 = json['option1'];
      option2 = json['option2'];
      option3 = json['option3'];
      option4 = json['option4'];
      answer = json['right_answer'];
    }catch(e, stack){
      print("Question.fromJson: " + stack.toString());
    }
  }
}