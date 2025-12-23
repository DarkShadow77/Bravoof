import 'package:flowva/features/dashboard/earn/bloc/community_mission_bloc.dart';
import 'package:flowva/features/dashboard/home/data/bloc/campaign_cubit.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../features/dashboard/earn/bloc/featured_mission_bloc.dart';
import '../../features/dashboard/earn/bloc/social_mission_bloc.dart';
import '../../features/dashboard/earn/data/repositories/community_mission_repository.dart';
import '../../features/dashboard/earn/data/repositories/community_mission_repository_impl.dart';
import '../../features/dashboard/earn/data/repositories/featured_mission_repository.dart';
import '../../features/dashboard/earn/data/repositories/featured_mission_repository_impl.dart';
import '../../features/dashboard/earn/data/repositories/social_mission_repository.dart';
import '../../features/dashboard/earn/data/repositories/social_mission_repository_impl.dart';
import '../../features/dashboard/home/data/bloc/home_cubit.dart';
import '../../features/dashboard/home/data/repository/campaign_repository.dart';
import '../../features/dashboard/home/data/repository/campaign_repository_impl.dart';
import '../../features/dashboard/home/data/repository/home_repository.dart';
import '../../features/dashboard/home/data/repository/home_repository_impl.dart';
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
}
