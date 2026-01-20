import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/core/constants/app_colors.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:Bravoo/features/common/app_enum.dart';
import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:Bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:Bravoo/features/onboarding2/progress_step.dart';
import 'package:Bravoo/features/otp/data/bloc/verify_otp_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../common/data/constants.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> with UIToolMixin {
  ValueNotifier<bool> isSending = ValueNotifier(false);
  final _pinController = TextEditingController();
  late VerifyOtpCubit verifyOtpCubit;

  @override
  void initState() {
    verifyOtpCubit = VerifyOtpCubit();

    super.initState();
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100.h),
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
                controller: _pinController,
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
                child: RichText(
                  text: TextSpan(
                    text: "Did not receive an OTP? ",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF767676),
                    ),
                    children: [
                      TextSpan(
                        text: "Resend here",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9013FE),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            var userProfile = await Constants().getUser();
                            final email = userProfile['email'];
                            showMessage(
                              "Code resent",
                              context,
                              color: Colors.white,
                              styleColor: Colors.black,
                            );
                            verifyOtpCubit.resendOtp(email: email);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60),
              BlocConsumer<VerifyOtpCubit, VerifyOtpState>(
                bloc: verifyOtpCubit,
                listener: (context, state) {
                  if (state is Verifying) {
                    isSending.value = true;
                  }
                  if (state is VerifyOtpSuccessful) {
                    isSending.value = false;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StepProgressPage(),
                      ),
                    );
                  }
                  if (state is OtpFailure) {
                    isSending.value = false;
                    showMessage(
                      state.err,
                      context,
                      color: Colors.white,
                      styleColor: Colors.black,
                      status: true,
                    );
                  }
                },
                builder: (context, state) {
                  return ValueListenableBuilder(
                    valueListenable: isSending,
                    builder: (context, val, _) {
                      return FlowvaButton.blueButton(
                        name: "Verify account",
                        buttonState: val
                            ? AppButtonState.loading
                            : AppButtonState.idle,
                        apply: () {
                          verifyOtpCubit.verifyOtp(otp: _pinController.text);
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
