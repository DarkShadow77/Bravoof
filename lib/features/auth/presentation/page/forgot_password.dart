import 'package:bravoo/features/auth/presentation/page/verify_forgot_password_email_page.dart';
import 'package:bravoo/features/common/app_enum.dart';
import 'package:bravoo/features/common/flowva_text_field.dart';
import 'package:bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> with UIToolMixin {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void _loadingAuthState(BuildContext context, AuthLoadingState state) {
    if (state.type == AuthType.forgotPassword) {
      setState(() => _isLoading = true);
    }
  }

  void _successAuthState(BuildContext context, AuthTextSuccessState state) {
    if (state.type == AuthType.forgotPassword) {
      setState(() => _isLoading = false);
      showMessage(
        state.message,
        context,
        color: Colors.green,
        styleColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => VerifyForgotPasswordEmailPage(
            email: _emailController.text.trim(),
          ),
        ),
      );
    }
  }

  void _failedAuthState(BuildContext context, AuthFailureState state) {
    if (state.type == AuthType.forgotPassword) {
      setState(() => _isLoading = false);
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          _loadingAuthState(context, state);
        } else if (state is AuthTextSuccessState) {
          _successAuthState(context, state);
        } else if (state is AuthFailureState) {
          _failedAuthState(context, state);
        }
      },
      child: ShowModalSheet(
        minHeight: 600,
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
                    text: "Enter your email",
                    style: TextStyles.titleMedium20(context),
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "Enter your email and we will send you a code",
                    style: TextStyles.normalRegular14(context, opacity: .65),
                  ),
                ),
                SizedBox(height: 20.h),
                // Email field
                AppTextFeild(
                  enable: !_isLoading,
                  controller: _emailController,
                  hintText: "Email address",
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Email is required"),
                    EmailValidator(errorText: "Invalid email address"),
                  ]).call,
                ),
                SizedBox(height: 12.h),
                IconTextButton(
                  onPressed: () {
                    if (_isLoading) return;
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        ForgotPasswordEvent(
                          email: _emailController.text.trim(),
                        ),
                      );
                    }
                  },
                  height: 56.h,
                  text: "Continue",
                  color: AppColors.black,
                  textColor: AppColors.white,
                  buttonState: _isLoading
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
