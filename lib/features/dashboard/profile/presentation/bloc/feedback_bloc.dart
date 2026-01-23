import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repository/feedback_repository.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FeedbackRepository repo;

  Logger logger = Logger();
  final supabase = Supabase.instance.client;

  FeedbackBloc({required this.repo}) : super(FeedbackInitialState()) {
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoadingState());

    final response = await repo.submitFeedback(
      userId: supabase.auth.currentUser!.id,
      title: event.title,
      message: event.message,
    );

    response.fold(
      (failure) {
        logger.e("Failed to Submit Feedback");
        emit(FeedbackFailureState(message: failure));
      },
      (user) {
        logger.w("Sent Feedback Successfully");
        emit(FeedbackSuccessState(message: "Sent Feedback Successfully"));
      },
    );
  }
}
