import 'package:flowva/features/dashboard/home/data/bloc/campaign_cubit.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:get_it/get_it.dart';

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
}
