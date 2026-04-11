part of 'skill_up_bloc.dart';

@immutable
abstract class SkillUpEvent {}

class LoadSkillUpMission extends SkillUpEvent {
  LoadSkillUpMission();
}

class CompleteSkillUpMission extends SkillUpEvent {
  final int missionId;
  final int stepId;
  final String? imageUrl;
  final String? evidenceText;

  CompleteSkillUpMission({
    required this.missionId,
    required this.stepId,
    this.imageUrl,
    this.evidenceText,
  });
}

class UnlockSkillUpMission extends SkillUpEvent {
  final int stepId;
  final UnlockSource source;

  UnlockSkillUpMission({required this.stepId, required this.source});
}
