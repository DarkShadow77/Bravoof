part of 'mission_cubit.dart';

@immutable
sealed class MissionState {}

final class MissionInitial extends MissionState {}

class MissionUpdateLoading extends MissionState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class StreakLoading extends MissionState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PageLoading extends MissionState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class StreakLoaded extends MissionState {
  final StreakResponse streakResponse;

  StreakLoaded(this.streakResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [streakResponse];
}
class RewardLoaded extends MissionState {
  final RewardsSummaryResponse rewardsSummaryResponse;

  RewardLoaded(this.rewardsSummaryResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [rewardsSummaryResponse];
}

class CheckedIn extends MissionState {
  final StreakResponse streakResponse;

  CheckedIn(this.streakResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [streakResponse];
}

class MissionLoaded extends MissionState {
  final MissionResponse missionResponse;

  MissionLoaded(this.missionResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [missionResponse];
}
class SocialMissionLoaded extends MissionState {
  final SocialTriviaResponse socialTriviaResponse;

  SocialMissionLoaded(this.socialTriviaResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [socialTriviaResponse];
}
class QuizLoaded extends MissionState {
  final QuizResponse quizResponse;

  QuizLoaded(this.quizResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [quizResponse];
}
class SkillUpTaskLoaded extends MissionState {
  final SkillUpTaskResponse skillUpTaskResponse;

  SkillUpTaskLoaded(this.skillUpTaskResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [skillUpTaskResponse];
}
class TriviaLoaded extends MissionState {
  final TriviaResponse triviaResponse;

  TriviaLoaded(this.triviaResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [triviaResponse];
}

class MissionUpdated extends MissionState {
  final AppBaseResponse appBaseResponse;

  MissionUpdated(this.appBaseResponse);

  @override
  // TODO: implement props
  List<Object?> get props => [appBaseResponse];
}

class MissionUpdateFailed extends MissionState {
  final String err;

  MissionUpdateFailed(this.err);

  @override
  // TODO: implement props
  List<Object?> get props => [err];
}

class MissionFailed extends MissionState {
  final String err;

  MissionFailed(this.err);

  @override
  // TODO: implement props
  List<Object?> get props => [err];
}
class CheckInFailed extends MissionState {
  final String err;

  CheckInFailed(this.err);

  @override
  // TODO: implement props
  List<Object?> get props => [err];
}

