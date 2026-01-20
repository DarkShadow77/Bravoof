import 'dart:ui';

import 'package:Bravoo/features/common/app_enum.dart';
import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:Bravoo/features/common/flowva_text_field.dart';
import 'package:Bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:Bravoo/features/onbaording/data/bloc/user_cubit.dart';
import 'package:Bravoo/features/onbaording/page/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with UIToolMixin {
  ValueNotifier<bool> isSending = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  late UserCubit userCubit;

  @override
  void initState() {
    userCubit = UserCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      bloc: userCubit,
      listener: (context, state) {
        if (state is UserLoading) {
          setState(() {
            isSending.value = true;
          });
        }
        if (state is UserSuccess) {
          setState(() {
            isSending.value = false;
          });
          showMessage(
            "Email Sent Successfully",
            context,
            color: Colors.green,
            styleColor: Colors.white,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => VerifyEmail(email: email.text)),
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
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.73,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (ctx, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Form(
                  key: formKey,
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
                          "Enter your email",
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Enter your email and we will send you a code",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email field
                        AppTextFeild(
                          controller: email,
                          hintText: "Email address",
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Email is required"),
                            EmailValidator(errorText: "Invalid email address"),
                          ]).call,
                        ),
                        const SizedBox(height: 12),

                        // Continue button with gradient
                        SizedBox(
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
                                  userCubit.forgotPassword(
                                    email: email.text.trim(),
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
            },
          ),
        ],
      ),
    );
  }
}
