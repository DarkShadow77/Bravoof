import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/dashboard/nav_bar.dart';
import 'package:flowva/features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:flowva/features/onbaording/data/model/user_profile.dart';
import 'package:flowva/features/onbaording/widget/first_screen.dart';
import 'package:flowva/features/onbaording/widget/second_screen.dart';
import 'package:flowva/features/onbaording/widget/third_screen.dart';
import 'package:flowva/features/onboarding2/widget/login_bottom_sheet.dart';
import 'package:flowva/utility/ui_tool_mix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../session/session_manager.dart';
import '../../common/data/constants.dart';
import 'referral_code.dart';

class OnboardingScreen extends StatefulWidget {
  // OnboardingScreen({super.key})
  var routeName = "/";

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with UIToolMixin {
  final PageController _pageController = PageController(initialPage: 0);
  ValueNotifier<bool> isSending = ValueNotifier(false);
  final _formkey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  int currentPage = 0;
  bool _isTapped = false;
  bool isLogin = true;
  late UserCubit userCubit;

  @override
  void initState() {
    userCubit = UserCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [FirstScreen(), SecondScreen(), ThirdScreen()],
              ),
            ),
            // SizedBox(height: 20),
            Container(
              width: 58,
              decoration: BoxDecoration(
                color: const Color(0x11111114),
                // Use a clean light grey background
                borderRadius: BorderRadius.circular(
                  20,
                ), // Optional: soften corners
              ),
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: currentPage == index ? 8 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? Colors.black
                          : Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            BlocListener<UserCubit, UserState>(
              bloc: userCubit,
              listener: (context, state) async {
                if (state is UserLoading) {
                  setState(() {
                    isSending.value = true;
                  });
                }
                if (state is UserSuccess) {
                  setState(() {
                    isSending.value = false;
                  });
                  if (state.appBaseResponse.message == "NEW_GOOGLE_USER") {
                    var userProfile = await Constants().getUser();
                    final email = userProfile['email'];
                    // Send them to your onboarding stage
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      builder: (_) => ReferralCode(
                        data: {
                          'email': email,
                          'pass': null,
                          "isLogin": false,
                          "loginMethod": "Google",
                        },
                      ),
                    );

                    return;
                  } else if (state.appBaseResponse.message ==
                      "NEW_APPLE_USER") {
                    var userProfile = await Constants().getUser();
                    final email = userProfile['email'];
                    // Send them to your onboarding stage
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      builder: (_) => ReferralCode(
                        data: {
                          'email': email,
                          'pass': null,
                          "isLogin": false,
                          "loginMethod": "Apple",
                        },
                      ),
                    );
                    return;
                  }
                  context.read<ProfileBloc>().add(GetProfileEvent());
                  SessionManager().firstWelcomeUserVal = "YES";
                  SessionManager().firstTimeUserVal = "YES";
                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => BottomNavBar()),
                      (ctx) => false,
                    );
                  });
                }
                if (state is UserFailure) {
                  setState(() {
                    isSending.value = false;
                  });
                  if (state.error.contains(
                    "activity is cancelled by the user",
                  )) {
                  } else {
                    showMessage(
                      state.error,
                      context,
                      color: Colors.white,
                      styleColor: Colors.black,
                      status: true,
                    );
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: FlowvaButton.blueButton(
                  name: "Get started",
                  apply: () async {
                    setState(() {
                      _isTapped = true;
                    });

                    _pageController.page == 2
                        ? showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            barrierColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (_) => LoginBottomSheet(
                              apply: (val) async {
                                if (val["loginMethod"] == "Google") {
                                  userCubit.googleLogin();
                                  return;
                                } else if (val["loginMethod"] == "Apple") {
                                  userCubit.appleLogin();
                                  return;
                                }
                                if (!_formkey.currentState!.validate()) return;
                                if (val['isLogin']) {
                                  userCubit.signIn(
                                    userProfile: UserProfile(
                                      email: _email.text,
                                      pass: _pass.text,
                                    ),
                                  );
                                  return;
                                }
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  barrierColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  builder: (_) => ReferralCode(
                                    data: {
                                      'email': _email.text,
                                      'pass': _pass.text,
                                      "isLogin": val['isLogin'],
                                    },
                                  ),
                                );
                              },
                              formkey: _formkey,
                              email: _email,
                              pass: _pass,
                              isSending: isSending,
                              isLogin: isLogin,
                            ),
                          )
                        : _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                    Future.delayed(
                      Duration(milliseconds: 200),
                      () => setState(() {
                        _isTapped = false;
                      }),
                    );
                  },
                  isTapped: _isTapped,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
