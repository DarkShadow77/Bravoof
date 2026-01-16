import 'dart:ui';

import 'package:flowva/app/view/widgets/button/icon_text_button.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../common/app_enum.dart';
import '../../common/flowva_text_field.dart';
import '../../onbaording/page/forgot_password.dart';

Future authModal({
  required Function(dynamic) apply,
  required GlobalKey<FormState> formKey,
  required ValueNotifier<bool> isSending,
}) {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 400),
    exitBottomSheetDuration: const Duration(milliseconds: 400),
    AuthModal(apply: apply, formKey: formKey, isSending: isSending),
  );
}

class AuthModal extends StatefulWidget {
  AuthModal({
    super.key,
    required this.apply,
    required this.formKey,
    required this.isSending,
  });

  final Function(dynamic) apply;
  final GlobalKey<FormState> formKey;
  final ValueNotifier<bool> isSending;

  @override
  State<AuthModal> createState() => _AuthModalState();
}

class _AuthModalState extends State<AuthModal> with UIToolMixin {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  bool isLogin = true;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.r, sigmaY: 10.r),
          child: Container(color: AppColors.black50),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ShowModalSheet(
            maxHeight: 700.h,

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      spacing: 20.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 6.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: AppColors.grey300,
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Continue to ${isLogin ? "log in" : "sign up"}",
                        style: TextStyles.titleMedium20(context),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Let’s get you started.",
                        style: TextStyles.normalRegular14(
                          context,
                          opacity: .65,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    AppTextFeild(
                      controller: email,
                      hintText: "Email address",
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Email is required"),
                        EmailValidator(errorText: "Invalid email address"),
                      ]).call,
                    ),
                    SizedBox(height: 8.h),
                    AppPassword(pass: pass, hintText: 'Password'),

                    SizedBox(height: 8.h),
                    ValueListenableBuilder(
                      valueListenable: widget.isSending,
                      builder: (context, val, _) {
                        return IconTextButton(
                          onPressed: () => widget.apply({
                            "isLogin": isLogin,
                            "email": email.text.trim(),
                            "pass": pass.text.trim(),
                          }),
                          height: 56.h,
                          text: "Continue",
                          color: AppColors.black,
                          textColor: AppColors.white,
                          buttonState: val
                              ? AppButtonState.loading
                              : AppButtonState.idle,
                        );
                      },
                    ),
                    SizedBox(height: 10.h),
                    if (isLogin) ...[
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
                          child: RichText(
                            text: TextSpan(
                              text: "Forgot your password?",
                              style: TextStyles.normalMedium14(
                                context,
                              ).copyWith(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                    Row(
                      spacing: 8.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(height: 1.h, color: AppColors.grey200),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "OR",
                            style: TextStyles.smallMedium12(
                              context,
                              opacity: .65,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(height: 1.h, color: AppColors.grey200),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    IconTextButton(
                      onPressed: () => widget.apply({"loginMethod": "Google"}),
                      height: 56.h,
                      spacing: 30,
                      iconSize: 20,
                      text: "Continue with Google",
                      icon: AssetsSvgIcons.google,
                    ),
                    SizedBox(height: 8.h),
                    IconTextButton(
                      onPressed: () => widget.apply({"loginMethod": "Apple"}),
                      height: 56.h,
                      spacing: 30,
                      iconSize: 20,
                      text: "Continue with Apple",
                      icon: AssetsSvgIcons.apple,
                    ),
                    SizedBox(height: 22.h),
                    RichText(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: isLogin
                                ? "Don't have an account? "
                                : "Already have an account? ",
                          ),
                          TextSpan(
                            text: isLogin ? "Sign up" : "Login",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                          ),
                        ],
                        style: TextStyles.normalRegular14(context, opacity: .5),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    RichText(
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "By continuing you agree to the Rules and Policy",
                        style: TextStyles.normalRegular14(context, opacity: .5),
                      ),
                    ),
                    SizedBox(
                      height: 20.h + MediaQuery.of(context).viewPadding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
