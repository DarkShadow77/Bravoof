part of 'activity_bloc.dart';

enum ActivityType { fetch, fetchMore, react }

@immutable
class RecentActivityState {
  final List<RecentActivity> activities;
  final bool hasMore;
  final int currentPage;

  const RecentActivityState({
    required this.activities,
    required this.hasMore,
    required this.currentPage,
  });

  RecentActivityState copyWith({
    List<RecentActivity>? activities,
    bool? hasMore,
    int? currentPage,
  }) {
    return RecentActivityState(
      activities: activities ?? this.activities,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ActivityInitialState extends RecentActivityState {
  ActivityInitialState({
    required super.activities,
    required super.hasMore,
    required super.currentPage,
  });
}

class ActivityLoadingState extends RecentActivityState {
  final ActivityType type;

  const ActivityLoadingState({
    required this.type,
    required super.activities,
    required super.hasMore,
    required super.currentPage,
  });
}

// Separate state for pagination loading so UI can show a bottom spinner
// without replacing the whole list with a full-screen loader
class ActivityLoadingMoreState extends RecentActivityState {
  const ActivityLoadingMoreState({
    required super.activities,
    required super.hasMore,
    required super.currentPage,
  });
}

class ActivityLoadedState extends RecentActivityState {
  const ActivityLoadedState({
    required super.activities,
    required super.hasMore,
    required super.currentPage,
  });
}

class ActivityErrorState extends RecentActivityState {
  final String message;
  final ActivityType type;

  const ActivityErrorState({
    required this.message,
    required this.type,
    required super.activities,
    required super.hasMore,
    required super.currentPage,
  });
}
