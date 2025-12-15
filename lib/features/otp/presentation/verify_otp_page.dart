import 'dart:developer';

import 'package:flowva/features/common/app_enum.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/onboarding2/progress_step.dart';
import 'package:flowva/features/otp/data/bloc/verify_otp_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // TODO: implement initState
    verifyOtpCubit = VerifyOtpCubit();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 100),
              Text(
                "Check your email",
                style: GoogleFonts.dmSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                "Enter the 6-digit code we sent to your inbox",
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF767676),
                ),
              ),
              SizedBox(height: 20),
              Pinput(
                controller: _pinController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF0D1E63),
                      width: 1,
                    ),
                  ),
                ),
                obscureText: false,
                showCursor: true,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(height: 40),
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

                            log("Resend Otp Email: $email");
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

  final defaultPinTheme = PinTheme(
    width: 75,
    height: 50,
    textStyle: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: Colors.black.withOpacity(0.2),
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
