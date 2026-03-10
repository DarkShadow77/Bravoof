import 'dart:ui';

import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/nav_bar.dart';
import 'package:bravoo/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';

class ShowAdMessage extends StatelessWidget {
  const ShowAdMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(color: Colors.black.withValues(alpha: 0.2)),
        ),
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/welcome_m.png"),
              Container(
                height: 36,
                width: 36,
                margin: EdgeInsets.only(top: 60),
                decoration: BoxDecoration(
                  // color: Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(120),
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ShowWelcomeMessage extends StatelessWidget {
  const ShowWelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (canPop, result) {
        SessionManager().firstWelcomeUserVal = "NO";
      },
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: Colors.black.withValues(alpha: 0.6)),
          ),
          Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AssetsPngImages.welcome,
                      height: 92.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20.h),
                    RichText(
                      text: TextSpan(
                        text: "We’ve missed you! 🥺",
                        style: TextStyles.bodyBold16(context),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            "Others earned rewards while you were away, but guess what? We saved yours. 😉 🎁",
                        style: TextStyles.normalMedium14(
                          context,
                        ).copyWith(color: AppColors.grey550),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      spacing: 16.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _rewardBox("assets/images/ear_pod.png"),
                        _rewardBox("assets/images/blue_cards.png"),
                        _rewardBox("assets/images/one_50.png"),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    FlowvaButton.blueButton(
                      apply: () {
                        SessionManager().firstWelcomeUserVal = "NO";
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomNavBar(index: 1),
                          ),
                        );
                      },
                      name: "Claim your rewards now",
                    ),
                    SizedBox(height: 6.h),
                    IconTextButton(
                      text: "Take Me Home",
                      color: AppColors.white,
                      onPressed: () {
                        SessionManager().firstWelcomeUserVal = "NO";
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BottomNavBar(index: 0),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rewardBox(String path) {
    return Container(
      height: 60,
      width: 60,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: Colors.white),
      ),
      child: Image.asset(path),
    );
  }
}
