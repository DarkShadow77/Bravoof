import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'common/data/constants.dart';
import 'dashboard/nav_bar.dart';
import 'dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'onbaording/data/model/user_profile.dart';
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
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        Navigator.pop(context);
      }
    });

    final profileBloc = context.read<ProfileBloc>();

    if (profileBloc.state.profile.email.isNotEmpty) {
      profileBloc.add(UpdateLocationEvent());
    }

    // requestNotificationPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          UserProfile profile = state.profile;
          if ((profile.email).isNotEmpty) {
            return BottomNavBar();
          }
          return OnboardingScreen();
        },
      ),
    );

    return FutureBuilder(
      future: Constants.getConfigure(),
      builder: (context, snapshot) {
        return snapshot.data != null
            ?
              // FlowvaHomePage()
              BottomNavBar()
            : OnboardingScreen();
      },
    );
  }
}
