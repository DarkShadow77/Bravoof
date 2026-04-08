import 'dart:ui';

import 'package:bravoo/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/utils/helpers.dart';
import '../../data/model/response/squad_mission_model.dart';

Future<dynamic> joinedSquadMissionDialog({
  required SquadMission squadMission,
  required JoinedSquadMission joinedSquadMission,
}) async {
  return Get.dialog(
    name: "joined_squad_mission_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    JoinedSquadMissionDialog(
      squadMission: squadMission,
      joinedSquadMission: joinedSquadMission,
    ),
  );
}

class JoinedSquadMissionDialog extends StatelessWidget {
  const JoinedSquadMissionDialog({
    super.key,
    required this.squadMission,
    required this.joinedSquadMission,
  });

  final SquadMission squadMission;
  final JoinedSquadMission joinedSquadMission;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: AppColors.black.withValues(alpha: 0.2)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.white85,
                  borderRadius: BorderRadius.circular(32.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffD9AEFF).withValues(alpha: .18),
                                Color(0xffD9AEFF).withValues(alpha: .3),
                                Color(0xffFF8687).withValues(alpha: .1),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(32.r),
                          ),
                          child: Row(
                            spacing: 6.5.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AssetsPngImages.one50,
                                width: 27.r,
                                height: 27.r,
                                fit: BoxFit.contain,
                              ),
                              RichText(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text:
                                      "Unlock ${formatAmount(squadMission.points)}",
                                  style: TextStyles.bigTitleBold24(context)
                                      .copyWith(
                                        fontFamily: AppFonts.baloo2,
                                        color: AppColors.primary40,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Image.asset(
                      AssetsPngImages.one50,
                      width: 112.r,
                      height: 112.r,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 16.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "🎉You’ve joined a squad mission",
                        style: TextStyles.normalBold14(
                          context,
                        ).copyWith(color: AppColors.grey550),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          if (joinedSquadMission.isCaptain)
                            TextSpan(
                              text:
                                  "Congratulations on being the squad lead!\n",
                            ),
                          TextSpan(
                            text:
                                "You have ${squadMission.timeLeft} to complete  this mission with your squad.",
                          ),
                        ],
                        style: TextStyles.normalMedium14(
                          context,
                        ).copyWith(fontSize: 13.sp, color: AppColors.grey550),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    IconTextButton(
                      height: 50,
                      onPressed: () {},
                      text: "Start Mission",
                      color: AppColors.black,
                      textColor: AppColors.white,
                    ),
                    SizedBox(height: 12.h),
                    IconTextButton(
                      height: 50,
                      onPressed: () => Navigator.pop(context),
                      text: "Back to Squad Mission",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
