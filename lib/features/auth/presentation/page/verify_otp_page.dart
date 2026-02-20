import 'dart:io';

import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/core/constants/app_colors.dart';
import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../common/app_enum.dart';
import '../../../onbaording/page/onbaording_screen.dart';
import '../../../onbaording/page/progress_step.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> with UIToolMixin {
  final CountdownController _timerController = CountdownController(
    autoStart: true,
  );
  final _pinController = TextEditingController();
  final focusNode = FocusNode();

  bool _resendCode = false;
  bool _isOnboarding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  //Function to call the resend otp API
  Future<void> resendOtp() async {
    if (_resendCode) {
      _timerController.restart();
      setState(() {
        _resendCode = !_resendCode;
        _pinController.clear();
      });
      context.read<AuthBloc>().add(ResendOtpEvent(email: widget.data['email']));
    }
  }

  void _loadingAuthState(BuildContext context, AuthLoadingState state) {
    if (state.type == AuthType.completeOnboarding) {
      setState(() => _isOnboarding = true);
    }
  }

  void _successAuthState(BuildContext context, AuthSuccessState state) async {
    if (state.response.message == "ONBOARDED_USER") {
      setState(() => _isOnboarding = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StepProgressPage()),
      );
    } else if (state.response.message == "ONBOARDED_NO_SESSION") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
        (route) => false,
      );
    }
  }

  void _failedAuthState(BuildContext context, AuthFailureState state) {
    if (state.type == AuthType.completeOnboarding) {
      setState(() => _isOnboarding = false);
    }
    if (state.type == AuthType.resendOtp ||
        state.type == AuthType.completeOnboarding) {
      Future.delayed((Duration(milliseconds: 500)), () {
        if (Get.isDialogOpen == true)
          Navigator.of(context, rootNavigator: true).pop();

        showMessage(
          state.message,
          context,
          color: Colors.green,
          styleColor: Colors.white,
          status: true,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 75.w,
      height: 50.h,
      textStyle: TextStyles.h2Medium32(
        context,
      ).copyWith(color: AppColors.grey300, fontFamily: AppFonts.baloo),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          _loadingAuthState(context, state);
        } else if (state is AuthSuccessState) {
          _successAuthState(context, state);
        } else if (state is AuthFailureState) {
          _failedAuthState(context, state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: CircleAvatar(
            backgroundColor: AppColors.black05,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft02,
                color: Colors.black,
                strokeWidth: 1.5,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:
                      10.h +
                      MediaQuery.of(context).padding.top +
                      kToolbarHeight,
                ),
                RichText(
                  text: TextSpan(
                    text: "Check your email",
                    style: TextStyles.bigTitleSemiBold24(
                      context,
                    ).copyWith(fontFamily: AppFonts.baloo2),
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    text: "Enter the 6-digit code we sent to your inbox",
                    style: TextStyles.normalRegular14(
                      context,
                    ).copyWith(color: AppColors.grey500),
                  ),
                ),
                SizedBox(height: 20.h),
                Pinput(
                  enabled: !_isOnboarding,
                  controller: _pinController,
                  focusNode: focusNode,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: BoxDecoration(
                      color: AppColors.white50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.primary, width: 1.w),
                    ),
                  ),
                  obscureText: false,
                  showCursor: true,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                SizedBox(height: 40.h),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_resendCode)
                        RichText(
                          text: TextSpan(
                            text: "Did not receive an OTP? ",
                            style: TextStyles.normalMedium14(
                              context,
                            ).copyWith(color: Color(0xFF767676)),
                          ),
                        )
                      else ...[
                        Countdown(
                          controller: _timerController,
                          seconds: 60,
                          build: (BuildContext context, double time) {
                            int minutes = (time ~/ 60);
                            double seconds = time % 60;

                            String min = minutes.toString().padLeft(2, "0");
                            String sec = (seconds.floor()).toString().padLeft(
                              2,
                              "0",
                            );
                            return RichText(
                              text: TextSpan(
                                text:
                                    "$min min${minutes > 1 ? "s" : ""} $sec sec${seconds > 1 ? "s" : ""}",
                                style: TextStyles.normalMedium14(
                                  context,
                                  opacity: .65,
                                ),
                              ),
                            );
                          },
                          onFinished: () {
                            setState(() {
                              _resendCode = !_resendCode;
                            });
                          },
                        ),
                        SizedBox(width: 20.w),
                      ],
                      RichText(
                        text: TextSpan(
                          text: "Resend here",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => resendOtp(),
                          style: TextStyles.normalMedium14(context).copyWith(
                            color: !_resendCode
                                ? AppColors.grey500
                                : Color(0xFF9013FE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60.h),
                IconTextButton(
                  onPressed: () {
                    if (_isOnboarding) return;
                    if (_pinController.text.trim().isNotEmpty) {
                      context.read<AuthBloc>().add(
                        CompleteOnboardingEvent(
                          otp: _pinController.text.trim(),
                          profile: {
                            'email': widget.data["email"],
                            'name': widget.data["name"],
                            'goals': widget.data["goals"],
                            'referral_code': widget.data["referral_code"],
                            'pass': widget.data["pass"],
                          },
                          imageFile: File(widget.data['profilePic'] ?? ""),
                        ),
                      );
                    } else {}
                  },
                  height: 56.h,
                  text: "Verify account",
                  color: AppColors.black,
                  textColor: AppColors.white,
                  buttonState: _isOnboarding
                      ? AppButtonState.loading
                      : AppButtonState.idle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
