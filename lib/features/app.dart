import 'dart:io';

import 'package:bravoo/app/view/widgets/bottom_modals/update_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app/view/page/maintenance_page.dart';
import '../core/model/version_model.dart';
import '../core/services/version_service.dart';
import 'dashboard/home/presentation/bloc/home_cubit.dart';
import 'dashboard/nav_bar.dart';
import 'dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'onbaording/page/onbaording_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final routeName = "/";

  @override
  void initState() {
    super.initState();

    final profileBloc = context.read<ProfileBloc>();

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      profileBloc.add(LogUserLoginActivityEvent(eventType: "app_open"));
      context.read<HomeCubit>().checkIncompleteMissions();
    }

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.initialSession) {
        _checkVersion();
      }

      if (event == AuthChangeEvent.tokenRefreshed) {
        profileBloc.add(GetProfileEvent());
        _checkVersion();
      }

      if (event == AuthChangeEvent.signedIn) {
        profileBloc.add(GetProfileEvent());
        // profileBloc.add(UpdateLocationEvent());
        profileBloc.add(SaveFCMTokenEvent());
        profileBloc.add(LogUserLoginActivityEvent(eventType: "login"));
        _checkVersion();
      }
      if (event == AuthChangeEvent.userUpdated) {
        profileBloc.add(GetProfileEvent());
        _checkVersion();
      }

      if (event == AuthChangeEvent.passwordRecovery) {
        Navigator.pop(context);
      }
    });
  }

  Future<void> _checkVersion() async {
    final versionService = VersionCheckService();
    final result = await versionService.checkVersion();

    if (!mounted) return;

    switch (result.status) {
      case VersionStatus.blocked:
      case VersionStatus.forceUpdate:
        forceUpdateModal(result: result, service: versionService);
        break;

      case VersionStatus.updateAvailable:
        if (!context.read<HomeCubit>().state.updateLater)
          optionalUpdateModal(result: result, service: versionService);
        break;

      case VersionStatus.maintenance:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (ctx) => MaintenancePage(result: result)),
          (route) => false,
        );
        break;

      case VersionStatus.ok:
        // Try Android in-app update in background
        if (Platform.isAndroid) {
          versionService.checkAndPerformInAppUpdate();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profileId = state.profile.userId;
        final completed =
            session != null &&
            profileId.isNotEmpty &&
            session.user.id == profileId;

        return Scaffold(body: completed ? BottomNavBar() : OnboardingScreen());
      },
    );
  }
}
