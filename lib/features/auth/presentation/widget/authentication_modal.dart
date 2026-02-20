import 'dart:io';

import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/features/auth/data/model/enums.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../session/session_manager.dart';
import '../../../common/app_enum.dart';
import '../../../common/data/constants.dart';
import '../../../common/flowva_text_field.dart';
import '../../../dashboard/nav_bar.dart';
import '../../../dashboard/profile/presentation/bloc/profile_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../page/forgot_password.dart';
import '../page/referral_code.dart';

Future authenticationModal() {
  return Get.bottomSheet(
    isScrollControlled: true,
    ignoreSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    enterBottomSheetDuration: const Duration(milliseconds: 400),
    exitBottomSheetDuration: const Duration(milliseconds: 400),
    AuthenticationModal(),
  );
}

class AuthenticationModal extends StatefulWidget {
  AuthenticationModal();

  @override
  State<AuthenticationModal> createState() => _AuthenticationModalState();
}

class _AuthenticationModalState extends State<AuthenticationModal>
    with UIToolMixin {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  bool _isLogin = true;
  bool _isLoginLoading = false;
  bool _isEmailCheck = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _loadingAuthState(BuildContext context, AuthLoadingState state) {
    if (state.type == AuthType.checkEmail) {
      setState(() => _isEmailCheck = true);
    } else if (state.type == AuthType.signIn) {
      setState(() => _isLoginLoading = true);
    }
  }

  void _emailCheckState(BuildContext context, EmailCheckResponseState state) {
    setState(() => _isEmailCheck = false);
    if (state.response.available) {
      _proceedToOnboard(true);
    } else {
      showMessage(
        state.response.message,
        context,
        color: Colors.green,
        styleColor: Colors.white,
        status: true,
      );
    }
  }

  void _successAuthState(BuildContext context, AuthSuccessState state) async {
    setState(() => _isLoginLoading = false);
    if (state.response.message == "EXISTING_USER") {
      context.read<ProfileBloc>().add(GetProfileEvent());
      context.read<ProfileBloc>().add(UpdateLocationEvent());
      context.read<ProfileBloc>().add(SaveFCMTokenEvent());
      SessionManager().firstWelcomeUserVal = "YES";
      SessionManager().firstTimeUserVal = "YES";
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => BottomNavBar()),
        (ctx) => false,
      );
    } else if (state.response.message == "NEW_USER") {
      _proceedToOnboard(false);
    }
  }

  void _failedAuthState(BuildContext context, AuthFailureState state) {
    if (state.type == AuthType.checkEmail) {
      setState(() => _isEmailCheck = false);
    } else if (state.type == AuthType.signIn) {
      setState(() => _isLoginLoading = false);
    }
    if (state.type == AuthType.checkEmail ||
        state.type == AuthType.signIn ||
        state.type == AuthType.googleAuth ||
        state.type == AuthType.appleAuth) {
      Future.delayed((Duration(milliseconds: 500)), () {
        if (Get.isDialogOpen == true)
          Navigator.of(context, rootNavigator: true).pop();
        final error = state.message.toLowerCase();

        if (error.contains("cancelled by") ||
            error.contains("the user canceled") ||
            error.contains("authorizationerrorcode.canceled")) {
        } else {
          showMessage(
            state.message,
            context,
            color: Colors.green,
            styleColor: Colors.white,
            status: true,
          );
        }
      });
    }
  }

  _proceedToOnboard(bool isSignUp) async {
    var userProfile = await Constants().getUser();
    final email = userProfile['email'];
    // Send them to your onboarding stage
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => ReferralCode(
        data: {
          'email': isSignUp ? _emailController.text.trim() : email,
          'pass': isSignUp ? _passController.text.trim() : null,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          _loadingAuthState(context, state);
        } else if (state is EmailCheckResponseState) {
          _emailCheckState(context, state);
        } else if (state is AuthSuccessState) {
          _successAuthState(context, state);
        } else if (state is AuthFailureState) {
          _failedAuthState(context, state);
        }
      },
      child: ShowModalSheet(
        maxHeight: 700.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
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
                    text: "Continue to ${_isLogin ? "log in" : "sign up"}",
                    style: TextStyles.titleMedium20(context),
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "Let’s get you started.",
                    style: TextStyles.normalRegular14(context, opacity: .65),
                  ),
                ),
                SizedBox(height: 20.h),
                AppTextFeild(
                  enable: !_isLoginLoading || !_isEmailCheck,
                  controller: _emailController,
                  hintText: "Email address",
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Email is required"),
                    EmailValidator(errorText: "Invalid email address"),
                  ]).call,
                ),
                SizedBox(height: 8.h),
                AppPassword(pass: _passController, hintText: 'Password'),
                SizedBox(height: 8.h),
                IconTextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_isLoginLoading || _isEmailCheck) return;
                      if (_isLogin) {
                        context.read<AuthBloc>().add(
                          SignInEvent(
                            email: _emailController.text.trim(),
                            password: _passController.text.trim(),
                          ),
                        );
                      } else {
                        context.read<AuthBloc>().add(
                          CheckEmailEvent(
                            email: _emailController.text.trim(),
                            context: EmailCheckContext.signUp,
                          ),
                        );
                      }
                    }
                  },
                  height: 56.h,
                  text: "Continue",
                  color: AppColors.black,
                  textColor: AppColors.white,
                  buttonState: _isLoginLoading || _isEmailCheck
                      ? AppButtonState.loading
                      : AppButtonState.idle,
                ),
                SizedBox(height: 10.h),
                if (_isLogin) ...[
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
                        style: TextStyles.smallMedium12(context, opacity: .65),
                      ),
                    ),
                    Expanded(
                      child: Divider(height: 1.h, color: AppColors.grey200),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                IconTextButton(
                  onPressed: () {
                    if (_isLoginLoading || _isEmailCheck) return;
                    context.read<AuthBloc>().add(GoogleAuthEvent());
                  },
                  height: 56.h,
                  spacing: 30,
                  iconSize: 20,
                  text: "Continue with Google",
                  icon: AssetsSvgIcons.google,
                ),
                if (Platform.isIOS) ...[
                  SizedBox(height: 8.h),
                  IconTextButton(
                    onPressed: () {
                      if (_isLoginLoading || _isEmailCheck) return;
                      context.read<AuthBloc>().add(AppleAuthEvent());
                    },
                    height: 56.h,
                    spacing: 30,
                    iconSize: 20,
                    text: "Continue with Apple",
                    icon: AssetsSvgIcons.apple,
                  ),
                ],
                SizedBox(height: 22.h),
                RichText(
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _isLogin
                            ? "Don't have an account? "
                            : "Already have an account? ",
                      ),
                      TextSpan(
                        text: _isLogin ? "Sign up" : "Login",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              _isLogin = !_isLogin;
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
    );
  }
}
