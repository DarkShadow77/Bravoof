void setupAuthListener() {
  /*  final supabase = Supabase.instance.client;

  supabase.auth.onAuthStateChange.listen((data) async {
    final event = data.event;
    final session = data.session;

    if (event != AuthChangeEvent.signedIn || session == null) return;

    final user = session.user;

    // Check profile existence
    final check = await supabase
        .from('user_profile')
        .select()
        .eq('user_id', user.id);

    if (check.isNotEmpty) {
      // Existing user
      SessionManager().userIdVal = user.id;
      SessionManager().hasAccountVal = true;

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => BottomNavBar()),
        (_) => false,
      );
    } else {
      // New OAuth user
      Constants().setUser({
        "email": user.email,
        "user_id": user.id,
        "name": user.userMetadata?['full_name'] ?? 'User',
      });

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => OnbaordSecondStage(
            data: {
              'email': user.email,
              'pass': null,
              "isLogin": false,
              "loginMethod": "Apple",
            },
          ),
        ),
      );
    }
  });*/
}
