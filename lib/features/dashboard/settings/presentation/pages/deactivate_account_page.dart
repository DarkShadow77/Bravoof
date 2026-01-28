import 'package:Bravoo/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../onbaording/page/onbaording_screen.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class DeactivateAccountPage extends StatefulWidget {
  const DeactivateAccountPage({super.key, required this.reason});

  final String reason;

  @override
  State<DeactivateAccountPage> createState() => _DeactivateAccountPageState();
}

class _DeactivateAccountPageState extends State<DeactivateAccountPage>
    with UIToolMixin {
  void _loadingProfileState(BuildContext context, ProfileLoadingState state) {
    if (state.type == ProfileType.deleteAccount) {
      outerLoadingDialog(text: 'Deleting Account…');
    }
  }

  void _successProfileState(BuildContext context, ProfileSuccessState state) {
    if (state.type == ProfileType.deleteAccount) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<ProfileBloc>().add(LogoutProfileEvent());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => OnboardingScreen()),
        (route) => false,
      );
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
      );
    }
  }

  void _failedProfileState(BuildContext context, ProfileFailureState state) {
    if (state.type == ProfileType.deleteAccount) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
        iconColor: Colors.red,
        status: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadingState) {
          _loadingProfileState(context, state);
        } else if (state is ProfileSuccessState) {
          _successProfileState(context, state);
        } else if (state is ProfileFailureState) {
          _failedProfileState(context, state);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          centerTitle: true,
          title: RichText(
            text: TextSpan(
              text: "Deactivate account?",
              style: TextStyles.titleSemiBold20(context),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final email = state.profile.email;
                  return RichText(
                    text: TextSpan(
                      text: email,
                      style: TextStyles.bodySemiBold16(context),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.h),
              ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                title: RichText(
                  text: TextSpan(
                    text:
                        "Your profile, tools, stack and subscriptions on this account will disappear",
                    style: TextStyles.normalMedium14(
                      context,
                    ).copyWith(color: AppColors.grey550),
                  ),
                ),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                ),
              ),
              ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                title: RichText(
                  text: TextSpan(
                    text:
                        "You wont be able to access the account info or past rewards and badges on the platform.",
                    style: TextStyles.normalMedium14(
                      context,
                    ).copyWith(color: AppColors.grey550),
                  ),
                ),
                leading: HugeIcon(
                  icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                ),
              ),
              Spacer(),
              IconTextButton(
                height: 56,
                color: AppColors.error,
                textColor: AppColors.white,
                onPressed: () {
                  context.read<ProfileBloc>().add(
                    DeleteAccountEvent(reason: widget.reason),
                  );
                },
                text: "Deactivate Account",
              ),
              SizedBox(height: 10.h + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
