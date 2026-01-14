import 'dart:ui';

import 'package:flowva/features/common/app_enum.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/flowva_text_field.dart';
import 'package:flowva/features/onbaording/page/forgot_password.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginBottomSheet extends StatefulWidget {
  LoginBottomSheet({
    super.key,
    required this.apply,
    required this.formkey,
    required this.email,
    required this.pass,
    required this.isLogin,
    required this.isSending,
  });

  Function(dynamic) apply;
  GlobalKey<FormState> formkey;
  TextEditingController email;
  TextEditingController pass;
  bool isLogin;
  ValueNotifier<bool> isSending = ValueNotifier(false);

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  bool isLogin = false;

  initState() {
    super.initState();
    isLogin = widget.isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Form(
                  key: widget.formkey,
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
                          isLogin
                              ? "Continue to log in"
                              : "Continue to sign up",
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Let’s get you started.",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email field
                        AppTextFeild(
                          controller: widget.email,
                          hintText: "Email address",
                          validator: MultiValidator([
                            RequiredValidator(errorText: "Email is required"),
                            EmailValidator(errorText: "Invalid email address"),
                          ]).call,
                        ),
                        const SizedBox(height: 12),

                        // Password field
                        AppPassword(pass: widget.pass, hintText: 'Password'),
                        const SizedBox(height: 10),

                        // Continue button with gradient
                        SizedBox(
                          width: double.infinity,
                          child: ValueListenableBuilder(
                            valueListenable: widget.isSending,

                            builder: (context, val, _) {
                              return FlowvaButton.blueButton(
                                buttonState: val
                                    ? AppButtonState.loading
                                    : AppButtonState.idle,
                                name: "Continue",
                                apply: () => widget.apply({"isLogin": isLogin}),
                              );
                            },
                          ),
                        ),
                        if (isLogin)
                          GestureDetector(
                            onTap: () {
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
                                builder: (_) => ForgotPassword(),
                              );
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Forgot your password?",
                                style: GoogleFonts.manrope(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9013FE),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                height: 2,
                                color: Color(0xFFF1F1F1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                "OR",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                height: 2,
                                color: Color(0xFFF1F1F1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Social Buttons
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,

                              child: FlowvaButton.whiteButton(
                                name: "Continue with Google",
                                icon: Image.asset("assets/images/google.png"),
                                spaceBetween: 20.0,
                                color: Colors.black,

                                apply: () =>
                                    widget.apply({"loginMethod": "Google"}),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: FlowvaButton.whiteButton(
                                name: "Continue with Apple",
                                icon: Icon(Icons.apple_rounded),
                                spaceBetween: 20.0,
                                color: Colors.black,
                                apply: () =>
                                    widget.apply({"loginMethod": "Apple"}),
                              ),
                            ),

                            !isLogin
                                ? RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Already have an account? ",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Login ",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF9013FE),
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              setState(() {
                                                isLogin = !isLogin;
                                              });

                                              // your action here
                                            },
                                        ),
                                      ],
                                    ),
                                  )
                                : RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Don’t have an account? ",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Sign up ",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF9013FE),
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              setState(() {
                                                isLogin = !isLogin;
                                              });
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                            Text(
                              "By continuing you agree to the Rules and Policy",
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
