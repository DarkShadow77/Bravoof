import 'package:get_it/get_it.dart';

import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/dashboard/earn/data/repositories/jackpot_repository.dart';
import '../../features/dashboard/earn/data/repositories/jackpot_repository_impl.dart';
import '../../features/dashboard/earn/presentation/bloc/jackpot_bloc.dart';
import '../../features/dashboard/home/data/repository/campaign_repository.dart';
import '../../features/dashboard/home/data/repository/campaign_repository_impl.dart';
import '../../features/dashboard/home/data/repository/home_repository.dart';
import '../../features/dashboard/home/data/repository/home_repository_impl.dart';
import '../../features/dashboard/home/data/repository/notification_repository.dart';
import '../../features/dashboard/home/data/repository/notification_repository_impl.dart';
import '../../features/dashboard/home/presentation/bloc/campaign_bloc.dart';
import '../../features/dashboard/home/presentation/bloc/home_cubit.dart';
import '../../features/dashboard/home/presentation/bloc/notification_bloc.dart';
import '../../features/dashboard/mission/data/repository/community_mission_repository.dart';
import '../../features/dashboard/mission/data/repository/community_mission_repository_impl.dart';
import '../../features/dashboard/mission/data/repository/featured_mission_repository.dart';
import '../../features/dashboard/mission/data/repository/featured_mission_repository_impl.dart';
import '../../features/dashboard/mission/data/repository/growth_mission_repository.dart';
import '../../features/dashboard/mission/data/repository/growth_mission_repository_impl.dart';
import '../../features/dashboard/mission/data/repository/new_social_mission_repository.dart';
import '../../features/dashboard/mission/data/repository/new_social_mission_repository_impl.dart';
import '../../features/dashboard/mission/data/repository/skill_up_repository.dart';
import '../../features/dashboard/mission/data/repository/skill_up_repository_impl.dart';
import '../../features/dashboard/mission/data/repository/social_mission_repository.dart';
import '../../features/dashboard/mission/data/repository/social_mission_repository_impl.dart';
import '../../features/dashboard/mission/data/repository/sponsored_mission_repository.dart';
import '../../features/dashboard/mission/data/repository/sponsored_mission_repository_impl.dart';
import '../../features/dashboard/mission/data/repository/streak_repository.dart';
import '../../features/dashboard/mission/data/repository/streak_repository_impl.dart';
import '../../features/dashboard/mission/presentation/bloc/community_mission_bloc.dart';
import '../../features/dashboard/mission/presentation/bloc/featured_mission_bloc.dart';
import '../../features/dashboard/mission/presentation/bloc/growth_mission_bloc.dart';
import '../../features/dashboard/mission/presentation/bloc/new_social_mission_bloc.dart';
import '../../features/dashboard/mission/presentation/bloc/skill_up_bloc.dart';
import '../../features/dashboard/mission/presentation/bloc/social_mission_bloc.dart';
import '../../features/dashboard/mission/presentation/bloc/sponsored_mission_bloc.dart';
import '../../features/dashboard/mission/presentation/bloc/streak_bloc.dart';
import '../../features/dashboard/profile/data/repository/auth_link_repository.dart';
import '../../features/dashboard/profile/data/repository/auth_link_repository_impl.dart';
import '../../features/dashboard/profile/data/repository/feedback_repository.dart';
import '../../features/dashboard/profile/data/repository/feedback_repository_impl.dart';
import '../../features/dashboard/profile/data/repository/profile_repository.dart';
import '../../features/dashboard/profile/data/repository/profile_repository_impl.dart';
import '../../features/dashboard/profile/presentation/bloc/auth_link_bloc.dart';
import '../../features/dashboard/profile/presentation/bloc/feedback_bloc.dart';
import '../../features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import '../../features/dashboard/redeem/data/repository/redeem_repository.dart';
import '../../features/dashboard/redeem/data/repository/reward_repository_impl.dart';
import '../../features/dashboard/redeem/presentation/bloc/redeem_bloc.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<CampaignRepository>(() => CampaignRepositoryImpl());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl());
  sl.registerLazySingleton<CommunityMissionRepository>(
    () => CommunityMissionRepositoryImpl(),
  );
  sl.registerLazySingleton<SocialMissionRepository>(
    () => SocialMissionRepositoryImpl(),
  );
  sl.registerLazySingleton<FeaturedMissionRepository>(
    () => FeaturedMissionRepositoryImpl(),
  );
  sl.registerLazySingleton<NewSocialMissionRepository>(
    () => NewSocialMissionRepositoryImpl(),
  );
  sl.registerLazySingleton<SponsoredMissionRepository>(
    () => SponsoredMissionRepositoryImpl(),
  );
  sl.registerLazySingleton<GrowthMissionRepository>(
    () => GrowthMissionRepositoryImpl(),
  );
  sl.registerLazySingleton<SkillUpRepository>(() => SkillUpRepositoryImpl());
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());
  sl.registerLazySingleton<StreakRepository>(() => StreakRepositoryImpl());
  sl.registerLazySingleton<RedeemRepository>(() => RedeemRepositoryImpl());
  sl.registerLazySingleton<JackpotRepository>(() => JackpotRepositoryImpl());
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(),
  );
  sl.registerLazySingleton<FeedbackRepository>(() => FeedbackRepositoryImpl());
  sl.registerLazySingleton<AuthLinkRepository>(() => AuthLinkRepositoryImpl());

  //Blocs
  sl.registerSingleton<AuthBloc>(AuthBloc(repo: sl<AuthRepository>()));
  sl.registerFactoryParam<CampaignBloc, int, void>(
    (campaignId, _) =>
        CampaignBloc(campaignId: campaignId, repo: sl<CampaignRepository>()),
  );
  sl.registerSingleton<HomeCubit>(HomeCubit());
  sl.registerSingleton<CommunityMissionBloc>(
    CommunityMissionBloc(repo: sl<CommunityMissionRepository>()),
  );
  sl.registerSingleton<SocialMissionBloc>(
    SocialMissionBloc(repo: sl<SocialMissionRepository>()),
  );
  sl.registerSingleton<FeaturedMissionBloc>(
    FeaturedMissionBloc(repo: sl<FeaturedMissionRepository>()),
  );
  sl.registerSingleton<NewSocialMissionBloc>(
    NewSocialMissionBloc(repo: sl<NewSocialMissionRepository>()),
  );
  sl.registerSingleton<SponsoredMissionBloc>(
    SponsoredMissionBloc(repo: sl<SponsoredMissionRepository>()),
  );
  sl.registerSingleton<GrowthMissionBloc>(
    GrowthMissionBloc(repo: sl<GrowthMissionRepository>()),
  );
  sl.registerSingleton<SkillUpBloc>(SkillUpBloc(repo: sl<SkillUpRepository>()));
  sl.registerSingleton<ProfileBloc>(ProfileBloc(repo: sl<ProfileRepository>()));
  sl.registerSingleton<StreakBloc>(StreakBloc(repo: sl<StreakRepository>()));
  sl.registerSingleton<RedeemBloc>(RedeemBloc(repo: sl<RedeemRepository>()));
  sl.registerSingleton<JackpotBloc>(JackpotBloc(repo: sl<JackpotRepository>()));
  sl.registerSingleton<NotificationBloc>(
    NotificationBloc(repo: sl<NotificationRepository>()),
  );
  sl.registerSingleton<FeedbackBloc>(
    FeedbackBloc(repo: sl<FeedbackRepository>()),
  );
  sl.registerSingleton<AuthLinkBloc>(
    AuthLinkBloc(repo: sl<AuthLinkRepository>()),
  );
}
