import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flowva/features/dashboard/home/presentation/bloc/home_cubit.dart';
import 'package:flowva/features/dashboard/redeem/presentation/bloc/redeem_bloc.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flowva/utility/auth_listener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/theme/app_themes.dart';
import 'core/constants/strings.dart';
import 'core/di/service_locator.dart';
import 'features/app.dart';
import 'features/dashboard/earn/presentation/bloc/jackpot_bloc.dart';
import 'features/dashboard/home/presentation/bloc/notification_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/community_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/featured_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/growth_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/skill_up_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/social_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/sponsored_mission_bloc.dart';
import 'features/dashboard/mission/presentation/bloc/streak_bloc.dart';
import 'features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'features/onbaording/data/bloc/user_cubit.dart';
import 'utility/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  // try {
  //   await dotenv.load(fileName: ".env"); // Load environment variables
  //   print('initialized');
  // } catch (e) {
  //   throw Exception('Error loading .env file: $e'); // Print error if any
  // }

  await Supabase.initialize(
    // url: "https://kjdgnwokoxaxwfpvpyru.supabase.co",
    url: "https://urdebuxbzqiwqgyzrrmy.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVyZGVidXhienFpd3FneXpycm15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0NDgzMzEsImV4cCI6MjA3NjAyNDMzMX0.sX0a4xtEfHAHeSSCReY-9JUGrHxZwYLe0nYKsbTdRpE",
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
        BlocProvider(create: (_) => sl<HomeCubit>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<CommunityMissionBloc>()),
        BlocProvider(create: (_) => sl<SocialMissionBloc>()),
        BlocProvider(create: (_) => sl<FeaturedMissionBloc>()),
        BlocProvider(create: (_) => sl<SponsoredMissionBloc>()),
        BlocProvider(create: (_) => sl<SkillUpBloc>()),
        BlocProvider(create: (_) => sl<StreakBloc>()),
        BlocProvider(create: (_) => sl<GrowthMissionBloc>()),
        BlocProvider(create: (_) => sl<RedeemBloc>()),
        BlocProvider(create: (_) => sl<JackpotBloc>()),
        BlocProvider(create: (_) => sl<NotificationBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 815),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            // routerConfig: _router,
            navigatorKey: navigatorKey,
            title: Strings.appName,
            theme: lightTheme,
            initialRoute: "/",
            onGenerateRoute: (RouteSettings settings) {
              Widget routeWidget = App();

              // Mimic web routing
              final routeName = settings.name;

              return MaterialPageRoute(
                builder: (context) => routeWidget,
                settings: settings,
                fullscreenDialog: true,
              );
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return MultiBlocProvider(
            providers: [BlocProvider.value(value: UserCubit())],
            child: const App(),
          );
        },
      ),
    ],
  );
}
