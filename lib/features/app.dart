import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    }

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.signedOut) {}

      if (event == AuthChangeEvent.signedIn) {
        profileBloc.add(GetProfileEvent());
        profileBloc.add(UpdateLocationEvent());
        profileBloc.add(SaveFCMTokenEvent());
        profileBloc.add(LogUserLoginActivityEvent(eventType: "login"));
      }
      if (event == AuthChangeEvent.tokenRefreshed) {
        profileBloc.add(GetProfileEvent());
      }
      if (event == AuthChangeEvent.userUpdated) {
        profileBloc.add(GetProfileEvent());
      }

      if (event == AuthChangeEvent.passwordRecovery) {
        Navigator.pop(context);
      }
    });
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
