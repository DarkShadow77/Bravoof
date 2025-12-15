import 'dart:ui';

import 'package:flowva/features/common/app_enum.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/flowva_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utility/ui_tool_mix.dart';
import '../data/bloc/user_cubit.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with UIToolMixin {
  final formkey = GlobalKey<FormState>();

  final pass = TextEditingController();
  final cp = TextEditingController();
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
                        "Create a new password",
                        style: GoogleFonts.manrope(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Enter a new password to secure your account",
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email field
                      AppPassword(pass: pass, hintText: 'New Password'),
                      const SizedBox(height: 12),

                      // Password field
                      AppPassword(pass: cp, hintText: 'Confirm password'),
                      const SizedBox(height: 20),

                      // Continue button with gradient
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
                            if (state.appBaseResponse.message ==
                                "PASSWORD_RESET_SUCCESS") {
                              showMessage(
                                "Password Reset Successfully",
                                context,
                                color: Colors.green,
                                styleColor: Colors.white,
                              );

                              // Send them to your onboarding stage
                              Navigator.pop(context);
                              return;
                            }
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
                                name: "Continue",
                                apply: () {
                                  if (!formkey.currentState!.validate()) return;
                                  userCubit.resetPassword(
                                    password: pass.text.trim(),
                                  );
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
