class CommunityMission {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final int usersJoined;
  final int maxUsers;
  final List<MissionInstruction> instructions;
  final DateTime createdAt;
  final bool status;
  final int point;
  final String instructionTitle;

  CommunityMission({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.usersJoined,
    required this.maxUsers,
    required this.instructions,
    required this.createdAt,
    required this.status,
    required this.point,
    required this.instructionTitle,
  });

  factory CommunityMission.fromJson(Map<String, dynamic> json) {
    return CommunityMission(
      id: json['id'],
      title: json['title'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      usersJoined: json['users_joined'] ?? 0,
      maxUsers: json['max_users'] ?? 1,
      instructions: (json['instructions'] as List? ?? [])
          .map((e) => MissionInstruction.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'] ?? false,
      point: json['points'] ?? 0,
      instructionTitle: json['instruction_title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'users_joined': usersJoined,
      'max_users': maxUsers,
      'instructions': instructions.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'points': point,
      'instruction_title': instructionTitle,
    };
  }
}

class MissionInstruction {
  final String text;
  final String? sideImage;
  final String? bottomImage;

  MissionInstruction({required this.text, this.sideImage, this.bottomImage});

  factory MissionInstruction.fromJson(Map<String, dynamic> json) {
    return MissionInstruction(
      text: json['text'] ?? "",
      sideImage: json['sideImage'] ?? "",
      bottomImage: json['bottomImage'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'sideImage': sideImage, 'bottomImage': bottomImage};
  }
}
