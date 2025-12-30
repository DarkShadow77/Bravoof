import 'package:flowva/features/dashboard/home/data/bloc/campaign_cubit.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../features/dashboard/home/data/bloc/home_cubit.dart';
import '../../features/dashboard/home/data/repository/campaign_repository.dart';
import '../../features/dashboard/home/data/repository/campaign_repository_impl.dart';
import '../../features/dashboard/home/data/repository/home_repository.dart';
import '../../features/dashboard/home/data/repository/home_repository_impl.dart';
import '../../features/dashboard/profile/data/repository/profile_repository.dart';
import '../../features/dashboard/profile/data/repository/profile_repository_impl.dart';
import '../../features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import '../../features/mission/data/repository/community_mission_repository.dart';
import '../../features/mission/data/repository/community_mission_repository_impl.dart';
import '../../features/mission/data/repository/featured_mission_repository.dart';
import '../../features/mission/data/repository/featured_mission_repository_impl.dart';
import '../../features/mission/data/repository/skill_up_repository.dart';
import '../../features/mission/data/repository/skill_up_repository_impl.dart';
import '../../features/mission/data/repository/social_mission_repository.dart';
import '../../features/mission/data/repository/social_mission_repository_impl.dart';
import '../../features/mission/data/repository/sponsored_mission_repository.dart';
import '../../features/mission/data/repository/sponsored_mission_repository_impl.dart';
import '../../features/mission/presentation/bloc/community_mission_bloc.dart';
import '../../features/mission/presentation/bloc/featured_mission_bloc.dart';
import '../../features/mission/presentation/bloc/skill_up_bloc.dart';
import '../../features/mission/presentation/bloc/social_mission_bloc.dart';
import '../../features/mission/presentation/bloc/sponsored_mission_bloc.dart';
import '../../features/onbaording/data/signup_repository/signup_repository.dart';
import '../../features/onbaording/data/signup_repository/signup_repository_impl.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton<SignupRepository>(() => SignupRepositoryImpl());
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
  sl.registerLazySingleton<SponsoredMissionRepository>(
    () => SponsoredMissionRepositoryImpl(),
  );
  sl.registerLazySingleton<SkillUpRepository>(() => SkillUpRepositoryImpl());
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl());

  //Blocs
  sl.registerSingleton<UserCubit>(UserCubit());
  sl.registerFactoryParam<CampaignCubit, int, void>(
    (campaignId, _) => CampaignCubit(
      campaignId: campaignId,
      campaignRepository: sl<CampaignRepository>(),
    ),
  );
  sl.registerSingleton<HomeCubit>(
    HomeCubit(homeRepository: sl<HomeRepository>()),
  );
  sl.registerSingleton<CommunityMissionBloc>(
    CommunityMissionBloc(repo: sl<CommunityMissionRepository>()),
  );
  sl.registerSingleton<SocialMissionBloc>(
    SocialMissionBloc(repo: sl<SocialMissionRepository>()),
  );
  sl.registerSingleton<FeaturedMissionBloc>(
    FeaturedMissionBloc(repo: sl<FeaturedMissionRepository>()),
  );
  sl.registerSingleton<SponsoredMissionBloc>(
    SponsoredMissionBloc(repo: sl<SponsoredMissionRepository>()),
  );
  sl.registerSingleton<SkillUpBloc>(SkillUpBloc(repo: sl<SkillUpRepository>()));
  sl.registerSingleton<ProfileBloc>(ProfileBloc(repo: sl<ProfileRepository>()));
}
