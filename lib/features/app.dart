
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'common/data/constants.dart';
import 'dashboard/nav_bar.dart';
import 'onbaording/page/onbaording_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final routeName="/";
@override
  void initState() {
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final AuthChangeEvent event = data.event;

    if (event == AuthChangeEvent.passwordRecovery) {
      Navigator.pop(context);

    }
  });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OnboardingScreen());

    return FutureBuilder(
      future: Constants.getConfigure(),
      builder: (context, snapshot) {

        return snapshot.data!=null ?
        // FlowvaHomePage()
        BottomNavBar()
            :
        OnboardingScreen();
      }
    );

  }
}




