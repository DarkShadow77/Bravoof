import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../dashboard/profile/presentation/bloc/profile_bloc.dart';
import '../../../../onbaording/data/model/user_profile.dart';

class TotalPointsCard extends StatelessWidget {
  const TotalPointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        UserProfile profile = state.profile;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black05,
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: "Total Coin Earned",
                  style: TextStyles.titleBold20(context).copyWith(
                    color: Color(0xFF70403E),
                    fontFamily: AppFonts.baloo2,
                    height: 1.sp,
                  ),
                ),
              ),
              Image.asset("assets/images/one_50.png", height: 48),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${profile.totalPoints}",
                      style: TextStyles.bodyBold16(context),
                    ),
                    TextSpan(text: "/ ${profile.basePoints}"),
                  ],
                  style: TextStyles.normalMedium14(context, opacity: .65),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Container(
                  height: 8.h,
                  width: double.infinity,
                  color: AppColors.grey100, // background
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor:
                          (profile.totalPoints ?? 0) /
                          (profile.basePoints ?? 5000),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFA259FF), Color(0xFFDEC4FF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "Just ${(profile.basePoints ?? 5000) - (profile.totalPoints ?? 0)} "
                          "coins until your next win!",
                      style: TextStyles.smallSemibold12(context, opacity: .65),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
