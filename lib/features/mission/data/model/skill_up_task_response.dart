
import 'package:flowva/features/onbaording/data/model/user_profile.dart';

class SkillUpTaskResponse{
  List<SkillUpTask>? task;
  SkillUpTaskResponse({
    this.task
  });
  SkillUpTaskResponse.fromJson(Map<String,dynamic>json){
    task=List<SkillUpTask>.from(json['task'].map((e)=>SkillUpTask.fromJson(e)));
  }
}

class SkillUpTask{
  SkillUpTask({
    this.id,
    this.title,
    this.firstMission,
    this.secondMission,
    this.thirdMission,

  });
  SkillUp? firstMission;
  SkillUp? secondMission;
  SkillUp? thirdMission;
  String? title;
  int? id;
  SkillUpTask.fromJson(Map<String,dynamic>json){
print(json['third_mission']);
    if(json['first_mission']['first_mission']!=null){
      firstMission=SkillUp.fromJson(json['first_mission']['first_mission']);
    }
    if(json['second_mission']['second_mission']!=null){
      secondMission=SkillUp.fromJson(json['second_mission']['second_mission']);
    }
    if(json['third_mission']!=null){
      thirdMission=SkillUp.fromJson(json['third_mission']);
    }
    if(json['id']!=null){
      id=json['id'];
    }

  }
}

class  SkillUp{
  SkillUp(
      this.subject,
      this.contentOne,
      this.contentTwo,
      this.contentThird,
      );
  String? subject;
  Task? contentOne;
  Task? contentTwo;
  Task? contentThird;
  SkillUp.fromJson(Map<String,dynamic> json){
;    if(json['subject']!=null){
      subject=json['subject'];
    }
    if(json['content_one']!=null){
      contentOne=Task.fromJson(json['content_one']);
    }
    if(json['content_two']!=null){
      contentTwo=Task.fromJson(json['content_two']);
    }
    if(json['content_third']!=null){
      contentThird=Task.fromJson(json['content_third']);
    }
  }
}
class  Task{
  Task(
      this.title
      );
  String? title;
  String? content;
  Task.fromJson(Map<String,dynamic> json){
    if(json['title']!=null){
      title=json['title'];
    }
    if(json['content']!=null){
      content=json['content'];
    }
  }
}