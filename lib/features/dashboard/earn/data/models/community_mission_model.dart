class CommunityMission {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final int usersJoined;
  final List<MissionInstruction> instructions;
  final DateTime createdAt;
  final bool status;
  final int point;

  CommunityMission({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.usersJoined,
    required this.instructions,
    required this.createdAt,
    required this.status,
    required this.point,
  });

  factory CommunityMission.fromJson(Map<String, dynamic> json) {
    return CommunityMission(
      id: json['id'],
      title: json['title'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      usersJoined: json['users_joined'] ?? 0,
      instructions: (json['instructions'] as List? ?? [])
          .map((e) => MissionInstruction.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'] ?? false,
      point: json['point'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'users_joined': usersJoined,
      'instructions': instructions.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'point': point,
    };
  }
}

class MissionInstruction {
  final String text;
  final String? rightImage;
  final String? bottomImage;

  MissionInstruction({required this.text, this.rightImage, this.bottomImage});

  factory MissionInstruction.fromJson(Map<String, dynamic> json) {
    return MissionInstruction(
      text: json['text'] ?? '',
      rightImage: json['rightImage'],
      bottomImage: json['bottomImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'rightImage': rightImage, 'bottomImage': bottomImage};
  }
}
