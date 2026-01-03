part of 'skill_up_bloc.dart';

enum SkillUpType { fetchMission, completeMission, unlockSkillUp }

@immutable
class SkillUpState {
  final List<SkillUpMission> missions;

  SkillUpState({required this.missions});

  SkillUpState copWith({List<SkillUpMission>? missions}) {
    return SkillUpState(missions: missions ?? this.missions);
  }
}

class SkillUpInitial extends SkillUpState {
  SkillUpInitial({required super.missions});
}

class SkillUpLoading extends SkillUpState {
  final int? missionId;
  final SkillUpType type;
  SkillUpLoading({this.missionId, required this.type, required super.missions});
}

class SkillUpError extends SkillUpState {
  final int? missionId;
  final String message;
  final SkillUpType type;
  SkillUpError({
    this.missionId,
    required this.message,
    required this.type,
    required super.missions,
  });
}

class SkillUpCompleted extends SkillUpState {
  final int missionId;
  final int stepId;
  SkillUpCompleted({
    required this.missionId,
    required this.stepId,
    required super.missions,
  });
}

class SkillUpUnlocked extends SkillUpState {
  final int stepId;
  SkillUpUnlocked({required this.stepId, required super.missions});
}
