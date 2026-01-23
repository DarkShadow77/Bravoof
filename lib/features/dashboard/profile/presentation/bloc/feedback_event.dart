part of 'feedback_bloc.dart';

@immutable
sealed class FeedbackEvent {}

class SubmitFeedbackEvent extends FeedbackEvent {
  final String title;
  final String message;

  SubmitFeedbackEvent({required this.title, required this.message});
}
