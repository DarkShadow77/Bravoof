import 'package:flutter/material.dart';
class SocialTriviaResponse{
  List<SocialTrivia>? socialTrivia;
  SocialTriviaResponse.fromJson(Map<String,dynamic>json){
    socialTrivia=List<SocialTrivia>.from(json['social'].map((e)=>SocialTrivia.fromJson(e)));
  }
}
class SocialTrivia {
  int? id;
  String? title;
  String? userId;
  bool? completed;

  SocialTrivia({
    this.id,
    this.title,
    this.userId,
    this.completed,
  });
  SocialTrivia.fromJson(Map<String,dynamic>json){
    id=json['id'];
    title=json['title'];
    userId=json['user_id'];

    completed=json['completed'];
  }


}