
import 'package:flowva/features/onbaording/data/model/user_profile.dart';

class QuizResponse{
  List<Quiz>? quiz;
  QuizResponse({
    this.quiz
  });
  QuizResponse.fromJson(Map<String,dynamic>json){
    quiz=List<Quiz>.from(json['quiz'].map((e)=>Quiz.fromJson(e)));
  }
}

class Quiz{
  Quiz({
    this.question,
    this.correctAnswer,
    this.id,
    this.quizAnswers,

  });
  String? question;
  String? correctAnswer;
  int? id;
  List<QuizAnswers>? quizAnswers;
  Quiz.fromJson(Map<String,dynamic>json){

    if(json['question']!=null){
      question=json['question'];
    }
    if(json['id']!=null){
      id=json['id'];
    }
    if(json['correct_answer']!=null){
      correctAnswer=json['correct_answer'];
    }
    if(json['quiz_answers']!=null){
      quizAnswers=List<QuizAnswers>.from(json['quiz_answers'].map((e)=>QuizAnswers.fromJson(e)));
    }
  }
}

class QuizAnswers{
  QuizAnswers(
      this.options
      );
  List<String>? options;
  QuizAnswers.fromJson(Map<String,dynamic> json){
    options = json['options'] != null
        ? List<String>.from(json['options'])
        : null;
  }
}