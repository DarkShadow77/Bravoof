import 'package:bravoo/features/common/flowva_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/bottom_modals/show_modal_sheet.dart';
import '../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../utility/ui_tool_mix.dart';
import '../../../common/app_enum.dart';
import '../bloc/auth_bloc.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> with UIToolMixin {
  final _formKey = GlobalKey<FormState>();

  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isLoading = false;

  void _loadingAuthState(BuildContext context, AuthLoadingState state) {
    if (state.type == AuthType.resetPassword) {
      setState(() => _isLoading = true);
    }
  }

  void _successAuthState(BuildContext context, AuthSuccessState state) {
    if (state.response.message == "PASSWORD_RESET_SUCCESS") {
      setState(() => _isLoading = false);
      showMessage(
        "Password reset successfully. Please sign in with your new password.",
        context,
        color: Colors.green,
        styleColor: Colors.white,
      );

      // Send them to your onboarding page
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      return;
    }
  }

  void _failedAuthState(BuildContext context, AuthFailureState state) {
    if (state.type == AuthType.resetPassword) {
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
        } else if (state is AuthSuccessState) {
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
                    text: "Create a new password",
                    style: TextStyles.titleMedium20(context),
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "Enter a new password to secure your account",
                    style: TextStyles.normalRegular14(context, opacity: .65),
                  ),
                ),
                SizedBox(height: 20.h),
                AppPassword(
                  pass: _passController,
                  hintText: 'New Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                AppPassword(
                  pass: _confirmPassController,
                  hintText: 'Confirm password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                IconTextButton(
                  onPressed: () {
                    if (_isLoading) return;
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                        ResetPasswordEvent(
                          password: _passController.text.trim(),
                          confirmPassword: _confirmPassController.text.trim(),
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
                /*   // Continue button with gradient
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

                                  // Send them to your onboarding page
                                  Navigator.pop(context);
                                  Navigator.pop(context);
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
                                      if (!_formKey.currentState!.validate())
                                        return;
                                      userCubit.resetPassword(
                                        password: _passController.text.trim(),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
