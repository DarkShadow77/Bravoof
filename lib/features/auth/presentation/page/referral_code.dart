import 'package:Bravoo/app/view/widgets/bottom_modals/show_modal_sheet.dart';
import 'package:Bravoo/features/common/app_enum.dart';
import 'package:Bravoo/features/common/flowva_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/styles/text_styles.dart';
import '../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../utility/ui_tool_mix.dart';
import '../../../onbaording/page/onbaord_second_stage.dart';
import '../bloc/auth_bloc.dart';

class ReferralCode extends StatefulWidget {
  ReferralCode({required this.data, super.key});

  final Map<String, dynamic> data;

  @override
  State<ReferralCode> createState() => _ReferralCodeState();
}

class _ReferralCodeState extends State<ReferralCode> with UIToolMixin {
  final _formKey = GlobalKey<FormState>();

  final referralCode = TextEditingController();
  bool _isReferralCheck = false;

  void _loadingAuthState(BuildContext context, AuthLoadingState state) {
    if (state.type == AuthType.verifyReferralCode) {
      setState(() => _isReferralCheck = true);
    }
  }

  void _referralAuthState(BuildContext context, ReferralResponseState state) {
    setState(() => _isReferralCheck = false);
    _proceedToOnboard(true);
  }

  void _failedAuthState(BuildContext context, AuthFailureState state) {
    if (state.type == AuthType.verifyReferralCode) {
      setState(() => _isReferralCheck = false);
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

  _proceedToOnboard(bool hasReferral) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OnboardSecondStage(
          data: {
            'email': widget.data["email"],
            'pass': widget.data['pass'],
            "referral_code": hasReferral ? referralCode.text.trim() : null,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          _loadingAuthState(context, state);
        } else if (state is ReferralResponseState) {
          _referralAuthState(context, state);
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
                    text: "Enter your referral code",
                    style: TextStyles.titleMedium20(context),
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "Enter a code here if you were referred by someone",
                    style: TextStyles.normalRegular14(context, opacity: .65),
                  ),
                ),
                SizedBox(height: 20.h),
                AppTextFeild(
                  enable: !_isReferralCheck,
                  controller: referralCode,
                  hintText: "Enter your code",
                  onChanged: (value) => setState(() {}),
                ),
                SizedBox(height: 12.h),

                IconTextButton(
                  onPressed: () {
                    if (_isReferralCheck) return;
                    if (referralCode.text.trim().isNotEmpty) {
                      context.read<AuthBloc>().add(
                        VerifyReferralCodeEvent(code: referralCode.text.trim()),
                      );
                    } else {
                      _proceedToOnboard(false);
                    }
                  },
                  height: 56.h,
                  text: referralCode.text.trim().isEmpty ? "Skip" : "Continue",
                  color: AppColors.black,
                  textColor: AppColors.white,
                  buttonState: _isReferralCheck
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
