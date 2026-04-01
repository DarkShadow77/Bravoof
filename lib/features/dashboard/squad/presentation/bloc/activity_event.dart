part of 'activity_bloc.dart';

@immutable
abstract class RecentActivityEvent {}

class FetchActivityEvent extends RecentActivityEvent {}

class FetchMoreActivityEvent extends RecentActivityEvent {}

class ReactToActivityEvent extends RecentActivityEvent {
  final int activityId;
  final ReactionEmoji emoji;

  ReactToActivityEvent({required this.activityId, required this.emoji});
}
