import 'dart:ui';

import 'package:Bravoo/features/common/app_enum.dart';
import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:Bravoo/features/common/flowva_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utility/ui_tool_mix.dart';
import '../../onboarding2/onbaord_second_stage.dart';
import '../data/bloc/user_cubit.dart';

class ReferralCode extends StatefulWidget {
  ReferralCode({this.data, super.key});

  Map<String, dynamic>? data;

  @override
  State<ReferralCode> createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode> with UIToolMixin {
  final formkey = GlobalKey<FormState>();

  final referralCode = TextEditingController();
  ValueNotifier<bool> isSending = ValueNotifier(false);

  late UserCubit userCubit;

  @override
  void initState() {
    userCubit = UserCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.5), // Optional dark overlay
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.73,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Form(
                key: formkey,
                child: Container(
                  width: double.infinity,
                  // padding: const EdgeInsets.all(16),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 80,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Title & Subtitle
                      Text(
                        "Enter your referral code",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Enter a code here if you were referred by someone",
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppTextFeild(
                        controller: referralCode,
                        onChanged: (value) {
                          setState(() {});
                        },
                        hintText: "Enter your code",
                      ),
                      const SizedBox(height: 12),
                      // Continue button with gradient
                      BlocListener<UserCubit, UserState>(
                        bloc: userCubit,
                        listener: (context, state) async {
                          if (state is UserLoading) {
                            setState(() {
                              isSending.value = true;
                            });
                          }
                          if (state is ReferralCodeVerified) {
                            setState(() {
                              isSending.value = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnbaordSecondStage(
                                  data: {
                                    'email': widget.data!["email"],
                                    'pass': widget.data!['pass'],
                                    "isLogin": widget.data!['isLogin'],
                                    "loginMethod": widget.data!['loginMethod'],
                                    "referral_code": referralCode.text.trim(),
                                  },
                                ),
                              ),
                            );
                          }
                          if (state is UserFailure) {
                            setState(() {
                              isSending.value = false;
                            });
                            showMessage(
                              state.error,
                              context,
                              color: Colors.white,
                              styleColor: Colors.black,
                              status: true,
                            );
                          }
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: ValueListenableBuilder(
                            valueListenable: isSending,
                            builder: (context, val, _) {
                              return FlowvaButton.blueButton(
                                buttonState: val
                                    ? AppButtonState.loading
                                    : AppButtonState.idle,
                                name: referralCode.text.trim().isEmpty
                                    ? "Skip"
                                    : "Continue",
                                apply: () {
                                  if (referralCode.text.trim().isEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OnbaordSecondStage(
                                              data: {
                                                'email': widget.data!["email"],
                                                'pass': widget.data!['pass'],
                                                "isLogin":
                                                    widget.data!['isLogin'],
                                                "loginMethod":
                                                    widget.data!['loginMethod'],
                                                "referral_code": null,
                                              },
                                            ),
                                      ),
                                    );
                                  } else {
                                    userCubit.verifyReferralCode(
                                      code: referralCode.text.trim(),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
