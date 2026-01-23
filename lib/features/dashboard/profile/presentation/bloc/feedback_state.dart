part of 'feedback_bloc.dart';

@immutable
sealed class FeedbackState {}

class FeedbackInitialState extends FeedbackState {
  FeedbackInitialState();
}

class FeedbackLoadingState extends FeedbackState {
  FeedbackLoadingState();
}

class FeedbackFailureState extends FeedbackState {
  final String message;
  FeedbackFailureState({required this.message});
}

class FeedbackSuccessState extends FeedbackState {
  final String message;
  FeedbackSuccessState({required this.message});
}
