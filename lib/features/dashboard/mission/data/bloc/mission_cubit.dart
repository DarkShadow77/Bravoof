import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../model/quiz_response.dart';
import '../model/rewards_summary_response.dart';
import '../model/skill_up_task_response.dart';
import '../model/social_trivia_response.dart';
import '../model/trivia_response.dart';
import '../repository/mission_repository.dart';

part 'mission_state.dart';

class MissionCubit extends Cubit<MissionState> {
  MissionCubit() : super(MissionInitial());

  final missionRepository = MissionRepository();

  void fetchSkillUpChallenge() async {
    // emit(MissionLoading());

    final either = await missionRepository.fetchSkillUpChallenge();
    print(either);
    either.fold((failure) => emit(MissionFailed(failure.toString())), (
      mission,
    ) {
      emit(SocialMissionLoaded(mission));
    });
  }

  void fetchAllUsersReward() async {
    emit(PageLoading());

    final either = await missionRepository.fetchAllUsersReward();
    either.fold((failure) => emit(MissionFailed(failure.toString())), (streak) {
      emit(RewardLoaded(streak));
    });
  }

  void fetchQuiz() async {
    // emit(MissionLoading());

    final either = await missionRepository.fetchQuiz();
    print(either);
    either.fold((failure) => emit(MissionFailed(failure.toString())), (quiz) {
      emit(QuizLoaded(quiz));
    });
  }

  void fetchQuizCompleted() async {
    // emit(MissionLoading());

    final either = await missionRepository.fetchQuizCompleted();
    print(either);
    either.fold((failure) => emit(MissionFailed(failure.toString())), (quiz) {
      emit(QuizLoaded(quiz));
    });
  }

  void fetchSkillUPTask() async {
    // emit(MissionLoading());

    final either = await missionRepository.fetchSkillUPTask();
    print(either);
    either.fold((failure) => emit(MissionFailed(failure.toString())), (quiz) {
      emit(SkillUpTaskLoaded(quiz));
    });
  }

  void fetchTrivia() async {
    emit(PageLoading());

    final either = await missionRepository.fetchTrivia();
    print(either);
    either.fold((failure) => emit(MissionFailed(failure.toString())), (trivia) {
      emit(TriviaLoaded(trivia));
    });
  }
}
