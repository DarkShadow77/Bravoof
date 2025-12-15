import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final SessionManager _sessionManager = SessionManager.internal();

  factory SessionManager() => _sessionManager;

  SessionManager.internal();

  late SharedPreferences sharedPreferences;

  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  final String shared_token = 'shared_token';
  final String userCred = 'userCred';
  final String onboardingData = 'onboardingData';
  final String firstTimeUser = 'firstTimeUser';
  final String firstWelcomeUser = 'firstWelcomeUser';
  final String userId = 'userId';
  final String userEmail = 'userEmail';
  final String hasAccount = 'hasAccount';
  final String mission = 'mission';
  final String points = 'points';
  final String isLastMission = 'isLastMission';
  final String isFunTimeCompleted = 'isFunTimeCompleted';
  final String isCompleted1 = 'isCompleted1';
  final String isCompleted2 = 'isCompleted2';
  final String isCompleted3 = 'isCompleted3';

  set sharedTokenVal(String val) =>
      sharedPreferences.setString(shared_token, val);
  String get sharedTokenVal => sharedPreferences.getString(shared_token) ?? "";
  // set userCredVal(String val) => sharedPreferences.s(userCred, val);
  // String get userCredVal => sharedPreferences.getString(userCred) ?? "";

  set onboardingDataVal(String val) =>
      sharedPreferences.setString(onboardingData, val);
  String get onboardingDataVal =>
      sharedPreferences.getString(onboardingData) ?? "";
  set firstTimeUserVal(String val) =>
      sharedPreferences.setString(firstTimeUser, val);
  String get firstTimeUserVal =>
      sharedPreferences.getString(firstTimeUser) ?? "YES";
  set firstWelcomeUserVal(String val) =>
      sharedPreferences.setString(firstWelcomeUser, val);
  String get firstWelcomeUserVal =>
      sharedPreferences.getString(firstWelcomeUser) ?? "YES";
  set userIdVal(String val) => sharedPreferences.setString(userId, val);
  String get userIdVal => sharedPreferences.getString(userId) ?? "";
  set userEmailval(String val) => sharedPreferences.setString(userEmail, val);
  String get userEmailval => sharedPreferences.getString(userEmail) ?? "";
  set hasAccountVal(bool val) => sharedPreferences.setBool(hasAccount, val);
  bool get hasAccountVal => sharedPreferences.getBool(hasAccount) ?? false;
  set isLastMissionVal(bool val) =>
      sharedPreferences.setBool(isLastMission, val);
  bool get isLastMissionVal =>
      sharedPreferences.getBool(isLastMission) ?? false;
  set isFunTimeCompletedVal(bool val) =>
      sharedPreferences.setBool(isFunTimeCompleted, val);
  bool get isFunTimeCompletedVal =>
      sharedPreferences.getBool(isFunTimeCompleted) ?? false;
  set isCompleted1Val(bool val) => sharedPreferences.setBool(isCompleted1, val);
  bool get isCompleted1Val => sharedPreferences.getBool(isCompleted1) ?? false;
  set isCompleted2Val(bool val) => sharedPreferences.setBool(isCompleted2, val);
  bool get isCompleted2Val => sharedPreferences.getBool(isCompleted2) ?? false;
  set isCompleted3Val(bool val) => sharedPreferences.setBool(isCompleted3, val);
  bool get isCompleted3Val => sharedPreferences.getBool(isCompleted3) ?? false;

  set missionVal(String val) => sharedPreferences.setString(mission, val);
  String get missionVal => sharedPreferences.getString(mission) ?? "";
  set pointsVal(int val) => sharedPreferences.setInt(points, val);
  int get pointsVal => sharedPreferences.getInt(points) ?? 0;
}
