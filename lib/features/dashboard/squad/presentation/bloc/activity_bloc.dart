import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/response/recent_activity_model.dart';
import '../../data/repository/activity_repository.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class RecentActivityBloc
    extends Bloc<RecentActivityEvent, RecentActivityState> {
  final RecentActivityRepository repo;

  RecentActivityBloc({required this.repo})
    : super(
        ActivityInitialState(activities: [], hasMore: false, currentPage: 1),
      ) {
    on<FetchActivityEvent>(_fetchActivity);
    on<FetchMoreActivityEvent>(_fetchMoreActivity);
    on<ReactToActivityEvent>(_reactToActivity);
  }

  Future<void> _fetchActivity(
    FetchActivityEvent event,
    Emitter<RecentActivityState> emit,
  ) async {
    emit(
      ActivityLoadingState(
        type: ActivityType.fetch,
        activities: state.activities,
        hasMore: false,
        currentPage: 1,
      ),
    );

    final res = await repo.fetchRecentActivity(page: 1);

    res.fold(
      (err) => emit(
        ActivityErrorState(
          type: ActivityType.fetch,
          message: err,
          activities: state.activities,
          hasMore: state.hasMore,
          currentPage: state.currentPage,
        ),
      ),
      (page) => emit(
        ActivityLoadedState(
          activities: page.activities,
          hasMore: page.hasMore,
          currentPage: page.page,
        ),
      ),
    );
  }

  Future<void> _fetchMoreActivity(
    FetchMoreActivityEvent event,
    Emitter<RecentActivityState> emit,
  ) async {
    // Guard: don't fetch if already loading or no more pages
    if (state is ActivityLoadingMoreState) return;
    if (!state.hasMore) return;

    final nextPage = state.currentPage + 1;

    emit(
      ActivityLoadingMoreState(
        activities: state.activities,
        hasMore: state.hasMore,
        currentPage: state.currentPage,
      ),
    );

    final res = await repo.fetchRecentActivity(page: nextPage);

    res.fold(
      (err) => emit(
        ActivityErrorState(
          type: ActivityType.fetchMore,
          message: err,
          activities: state.activities,
          hasMore: state.hasMore,
          currentPage: state.currentPage,
        ),
      ),
      (page) => emit(
        ActivityLoadedState(
          // Append new activities to existing list
          activities: [...state.activities, ...page.activities],
          hasMore: page.hasMore,
          currentPage: page.page,
        ),
      ),
    );
  }

  Future<void> _reactToActivity(
    ReactToActivityEvent event,
    Emitter<RecentActivityState> emit,
  ) async {
    // Optimistic update — toggle locally first so UI feels instant
    final updatedActivities = state.activities.map((activity) {
      if (activity.id != event.activityId) return activity;

      final alreadyReacted = activity.reactions.hasReacted(event.emoji);
      List<ReactionEmoji> updatedUserReactions = alreadyReacted
          ? activity.reactions.userReactions
                .where((e) => e != event.emoji)
                .toList()
          : [...activity.reactions.userReactions, event.emoji];

      final updatedReactions = ActivityReactions(
        heart:
            activity.reactions.heart +
            _delta(event.emoji.emoji, '❤️', alreadyReacted),
        fire:
            activity.reactions.fire +
            _delta(event.emoji.emoji, '🔥', alreadyReacted),
        clap:
            activity.reactions.clap +
            _delta(event.emoji.emoji, '👏', alreadyReacted),
        wow:
            activity.reactions.wow +
            _delta(event.emoji.emoji, '😮', alreadyReacted),
        party:
            activity.reactions.party +
            _delta(event.emoji.emoji, '🎉', alreadyReacted),
        userReactions: updatedUserReactions,
        hundred:
            activity.reactions.hundred +
            _delta(event.emoji.emoji, '💯', alreadyReacted),
      );

      return RecentActivity(
        id: activity.id,
        activityType: activity.activityType,
        message: activity.message,
        createdAt: activity.createdAt,
        user: activity.user,
        squad: activity.squad,
        brand: activity.brand,
        squadMission: activity.squadMission,
        brandMission: activity.brandMission,
        missionParticipants: activity.missionParticipants,
        reactions: updatedReactions,
      );
    }).toList();

    emit(state.copyWith(activities: updatedActivities));

    // Fire and forget — if it fails, we could revert but keeping it simple
    await repo.reactToActivity(
      activityId: event.activityId,
      emoji: event.emoji.emoji,
    );
  }

  int _delta(String tapped, String target, bool wasReacted) {
    if (tapped != target) return 0;
    return wasReacted ? -1 : 1;
  }
}
