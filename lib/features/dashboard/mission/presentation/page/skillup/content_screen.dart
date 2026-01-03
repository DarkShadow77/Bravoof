import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/styles/text_styles.dart';
import '../../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/fonts.dart';
import '../../../data/model/skill_up_mission_model.dart';

class ContentScreen extends StatelessWidget {
  final double progress;
  final SkillUpStep mission;
  final SkillUpContentBlock content;
  final VoidCallback mainPressed;
  final VoidCallback subPressed;
  final String mainText;
  final String subText;

  ContentScreen({
    super.key,
    required this.progress,
    required this.mission,
    required this.content,
    required this.mainPressed,
    required this.subPressed,
    required this.mainText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 30.w,
                      vertical: 30.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white50,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        width: 1.5.r,
                        color: AppColors.white50,
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(.92, 1.8),
                          blurRadius: 4.6.r,
                          color: Color(0xff9E9A9A).withValues(alpha: .1),
                        ),
                        BoxShadow(
                          offset: Offset(2.8, 8.3),
                          blurRadius: 9.19.r,
                          color: Color(0xff9E9A9A).withValues(alpha: .09),
                        ),
                        BoxShadow(
                          offset: Offset(7.35, 18.38),
                          blurRadius: 11.95.r,
                          color: Color(0xff9E9A9A).withValues(alpha: .05),
                        ),
                        BoxShadow(
                          offset: Offset(12, 33),
                          blurRadius: 13.79.r,
                          color: Color(0xff9E9A9A).withValues(alpha: .01),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          spacing: 6.w,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.r),
                                child: Container(
                                  height: 14.h,
                                  width: double.infinity,
                                  color: AppColors.grey200, // background
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FractionallySizedBox(
                                      widthFactor: progress,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFA259FF),
                                              Color(0xFFDEC4FF),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffF5EBFF),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Row(
                                spacing: 4.w,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/one_50.png",
                                    height: 11.5.r,
                                    width: 11.5.r,
                                  ),
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text:
                                          "+${mission.minPoints}-${mission.maxPoints}",
                                      style: TextStyles.cardBold10(
                                        context,
                                      ).copyWith(color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 30.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: content.title,
                                  style: TextStyles.titleRegular20(context)
                                      .copyWith(
                                        fontFamily: AppFonts.baloo,
                                        height: 1.sp,
                                      ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: content.subtitle,
                                  style: TextStyles.smallSemibold12(context),
                                ),
                              ),
                              SizedBox(height: 18.h),
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  text: content.content,
                                  style: TextStyles.smallRegular12(context),
                                ),
                              ),
                              SizedBox(height: 18.h),
                              IconTextButton(
                                onPressed: mainPressed,
                                color: AppColors.black,
                                text: mainText,
                                textColor: AppColors.white,
                              ),
                              SizedBox(height: 12.h),
                              IconTextButton(
                                onPressed: subPressed,
                                text: subText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
