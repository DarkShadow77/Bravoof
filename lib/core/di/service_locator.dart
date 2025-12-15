import 'package:get_it/get_it.dart';

import '../../features/onbaording/data/signup_repository/signup_repository.dart';
import '../../features/onbaording/data/signup_repository/signup_repository_impl.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton<SignupRepository>(() => SignupRepositoryImpl());
}
