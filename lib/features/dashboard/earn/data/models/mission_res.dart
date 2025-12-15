import 'package:flutter/material.dart';
class MissionResponse{
  List<Mission>? mission;
  MissionResponse.fromJson(Map<String,dynamic>json){
    mission=List<Mission>.from(json['mission'].map((e)=>Mission.fromJson(e)));
  }
}
class Mission {
   int? id;
   String? title;
   String? subject;
  String? rightIcon;
   String? points;
   int? progress;
   bool? completed;

  Mission({
     this.id,
     this.title,
     this.subject,
     this.rightIcon,
     this.points,
     this.progress,
     this.completed,
  });
Mission.fromJson(Map<String,dynamic>json){
  id=json['id'];
  title=json['title'];
  subject=json['subject'];
  rightIcon=json['right_icon'];
  points=json['points'];
  progress=json['progress'];
  completed=json['completed'];
}
  Widget get icon {
    switch (subject!.toLowerCase()) {
      case 'watch':
        return Image.asset("assets/images/play.png", height: 28);
      case 'rate us':
        return Image.asset("assets/images/thumb_stars.png", height: 28);
      case 'invite':
        return Image.asset("assets/images/tt.png", height: 28);
      default:
        return Container();
    }
  }

  Mission copyWith({bool? completed}) {
    return Mission(
      id: id,
      title: title,
      subject: subject,
      rightIcon: rightIcon,
      points: points,
      progress:progress ,
      completed: completed ?? this.completed,
    );
  }
}