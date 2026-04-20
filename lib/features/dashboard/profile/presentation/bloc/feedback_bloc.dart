import 'package:bloc/bloc.dart';
import 'package:bravoo/core/utils/logger.dart';
import 'package:meta/meta.dart';

import '../../data/repository/feedback_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository repo;

  final logger = AppLogger();

  FeedbackBloc({required this.repo}) : super(FeedbackInitialState()) {
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoadingState());

    final response = await repo.submitFeedback(
      title: event.title,
      message: event.message,
    );

    response.fold(
      (failure) => emit(FeedbackFailureState(message: failure)),
      (user) =>
          emit(FeedbackSuccessState(message: "Sent Feedback Successfully")),
    );
  }
}
