class MissionResponse {
  List<Mission>? mission;
  MissionResponse.fromJson(Map<String, dynamic> json) {
    mission = List<Mission>.from(
      json['mission'].map((e) => Mission.fromJson(e)),
    );
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
  String? icon;

  Mission({
    this.id,
    this.title,
    this.subject,
    this.rightIcon,
    this.points,
    this.progress,
    this.completed,
    this.icon,
  });
  Mission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subject = json['subject'];
    rightIcon = json['right_icon'];
    points = json['points'];
    progress = json['progress'];
    completed = json['completed'];
    icon = json['icon'];
  }

  Mission copyWith({bool? completed}) {
    return Mission(
      id: id,
      title: title,
      subject: subject,
      rightIcon: rightIcon,
      points: points,
      progress: progress,
      completed: completed ?? this.completed,
      icon: icon ?? this.icon,
    );
  }
}
