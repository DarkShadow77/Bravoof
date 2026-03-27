import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bravoo/core/services/firebase_messaging_service.dart';
import 'package:bravoo/core/services/local_notification_service.dart';
import 'package:bravoo/features/dashboard/home/presentation/bloc/home_cubit.dart';
import 'package:bravoo/features/dashboard/redeem/presentation/bloc/redeem_bloc.dart';
import 'package:bravoo/session/session_manager.dart';
import 'package:bravoo/utility/auth_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;

import 'app/theme/app_themes.dart';
import 'core/constants/navigators/routeName.dart';
import 'core/constants/navigators/router.dart';
import 'core/constants/strings.dart';
import 'core/di/service_locator.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/dashboard/earn/presentation/bloc/jackpot_bloc.dart';
import 'features/dashboard/home/presentation/bloc/notification_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/community_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/featured_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/growth_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/new_social_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/skill_up_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/social_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/sponsored_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/streak_bloc.dart';
import 'features/dashboard/profile/presentation/bloc/auth_link_bloc.dart';
import 'features/dashboard/profile/presentation/bloc/feedback_bloc.dart';
import 'features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'firebase_options.dart';
import 'utility/navigation.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationService = LocalNotificationService.instance();
  await localNotificationService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(
    localNotificationService: localNotificationService,
  );

  //Initialize dotenv for environment variables
  await dotenv.load(fileName: ".env.development");

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"] ?? "",
    anonKey: dotenv.env["ANON_KEY"] ?? "",
  );

  setupAuthListener();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  final storageDir = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : storageDir,
  );

  // Initialize timezone data
  tz_data.initializeTimeZones();

  await initDI();
  await SessionManager().init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      FlutterNativeSplash.remove();
    });
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    // Handle links
    _linkSubscription = AppLinks().uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<AuthLinkBloc>()),
        BlocProvider(create: (_) => sl<CommunityMissionBloc>()),
        BlocProvider(create: (_) => sl<SocialMissionBloc>()),
        BlocProvider(create: (_) => sl<NewSocialMissionBloc>()),
        BlocProvider(create: (_) => sl<FeaturedMissionBloc>()),
        BlocProvider(create: (_) => sl<SponsoredMissionBloc>()),
        BlocProvider(create: (_) => sl<SkillUpBloc>()),
        BlocProvider(create: (_) => sl<StreakBloc>()),
        BlocProvider(create: (_) => sl<GrowthMissionBloc>()),
        BlocProvider(create: (_) => sl<RedeemBloc>()),
        BlocProvider(create: (_) => sl<JackpotBloc>()),
        BlocProvider(create: (_) => sl<NotificationBloc>()),
        BlocProvider(create: (_) => sl<FeedbackBloc>()),
        BlocProvider(
          create: (_) => sl<HomeCubit>()
            ..communityMissionBloc = sl<CommunityMissionBloc>()
            ..featuredMissionBloc = sl<FeaturedMissionBloc>()
            ..newSocialMissionBloc = sl<NewSocialMissionBloc>()
            ..socialMissionBloc = sl<SocialMissionBloc>()
            ..sponsoredMissionBloc = sl<SponsoredMissionBloc>()
            ..communityMissionBloc = sl<CommunityMissionBloc>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 815),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            // routerConfig: _router,
            navigatorObservers: [routeObserver],
            navigatorKey: navigatorKey,
            title: Strings.appName,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            onGenerateRoute: generateRoute,
            initialRoute: RouteName.indexPage,
          );
        },
      ),
    );
  }
}
