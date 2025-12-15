import 'package:flowva/features/common/app_enum.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/onbaording/page/change_password.dart';
import 'package:flowva/features/otp/data/bloc/verify_otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../data/bloc/user_cubit.dart';

class VerifyEmail extends StatefulWidget {
  String email;

  VerifyEmail({required this.email, super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> with UIToolMixin {
  ValueNotifier<bool> isSending = ValueNotifier(false);
  final _pinController = TextEditingController();
  late VerifyOtpCubit verifyOtpCubit;
  late UserCubit userCubit;

  @override
  void initState() {
    verifyOtpCubit = VerifyOtpCubit();
    userCubit = UserCubit();

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

              SizedBox(height: 60),
              ValueListenableBuilder(
                valueListenable: isSending,
                builder: (context, val, _) {
                  return FlowvaButton.whiteButton(
                    name: "Resend code",
                    color: Colors.black,
                    apply: () {
                      userCubit.forgotPassword(email: widget.email);
                    },
                  );
                },
              ),
              MultiBlocListener(
                listeners: [
                  BlocListener<VerifyOtpCubit, VerifyOtpState>(
                    bloc: verifyOtpCubit,
                    listener: (context, state) {
                      if (state is Verifying) {
                        setState(() {
                          isSending.value = true;
                        });
                      }
                      if (state is VerifyOtpSuccessful) {
                        setState(() {
                          isSending.value = false;
                        });
                        showMessage(
                          "Email Sent Successfully",
                          context,
                          color: Colors.green,
                          styleColor: Colors.white,
                        );
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
                          builder: (_) => ChangePassword(),
                        );
                      }
                      if (state is OtpFailure) {
                        setState(() {
                          isSending.value = false;
                        });
                        showMessage(
                          state.err,
                          context,
                          color: Colors.white,
                          styleColor: Colors.black,
                          status: true,
                        );
                      }
                    },
                  ),
                  BlocListener<UserCubit, UserState>(
                    bloc: userCubit,
                    listener: (context, state) {
                      if (state is UserFailure) {
                        isSending.value = false;
                        showMessage(
                          state.error,
                          context,
                          color: Colors.white,
                          styleColor: Colors.black,
                          status: true,
                        );
                      }
                    },
                  ),
                ],
                child: ValueListenableBuilder(
                  valueListenable: isSending,
                  builder: (context, val, _) {
                    return FlowvaButton.blueButton(
                      name: "Verify code",
                      buttonState: val
                          ? AppButtonState.loading
                          : AppButtonState.idle,
                      apply: () {
                        verifyOtpCubit.verifyResetPasswordOtp(
                          otp: {
                            "email": widget.email,
                            "otp": _pinController.text,
                          },
                        );
                      },
                    );
                  },
                ),
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
