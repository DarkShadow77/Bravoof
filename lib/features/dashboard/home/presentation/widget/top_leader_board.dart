import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/home/data/model/leaderboard_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../page/leaderboard_screen.dart';

class TopLeaderboard extends StatelessWidget {
  final List<LeaderboardModel> leaderboard;
  TopLeaderboard({required this.leaderboard, super.key});

  @override
  Widget build(BuildContext context) {
    leaderboard.sort((a, b) => b.totalEarned.compareTo(a.totalEarned));

    final first = leaderboard[0];
    final second = leaderboard.length > 1 ? leaderboard[1] : null;
    final third = leaderboard.length > 2 ? leaderboard[2] : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9419FD), Color(0xFFFDD3D8)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Leaderboard Info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/left_hand.png"),
                RichText(
                  text: TextSpan(
                    text: 'Celebrate Consistency',
                    style: TextStyles.bodySemiBold16(
                      context,
                    ).copyWith(color: AppColors.white),
                  ),
                ),
                Image.asset("assets/images/right_hand.png"),
              ],
            ),
            SizedBox(height: 20.h),

            // Podium
            Container(
              height: 165.h,
              child: Row(
                spacing: 10.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20.h),
                      Container(
                        width: 70.w,
                        height: 70.h,
                        child: Stack(
                          children: [
                            CachedImageRadius(
                              imageUrl: second!.profileImage,
                              size: 70,
                              circle: true,
                              color: AppColors.grey200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 2,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2.r),
                                width: 20.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: AppColors.redBrown50,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.white50),
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "2",
                                      style: TextStyles.cardBold10(
                                        context,
                                      ).copyWith(color: AppColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),
                      RichText(
                        text: TextSpan(
                          text: second.name.capitalize,
                          style: TextStyles.normalSemibold14(
                            context,
                          ).copyWith(color: AppColors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black05,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          spacing: 6.w,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetsPngImages.one50,
                              height: 14.h,
                              width: 14.w,
                              fit: BoxFit.contain,
                            ),
                            RichText(
                              text: TextSpan(
                                text: formatAmount(second.totalEarned),
                                style: TextStyles.cardBold10(
                                  context,
                                ).copyWith(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 80.h,
                        child: Stack(
                          children: [
                            CachedImageRadius(
                              imageUrl: first.profileImage,
                              size: 80,
                              circle: true,
                              color: AppColors.grey200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                width: 20.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: AppColors.orange50,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.white50),
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "1",
                                      style: TextStyles.cardBold10(
                                        context,
                                      ).copyWith(color: AppColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      RichText(
                        text: TextSpan(
                          text: first.name.capitalize,
                          style: TextStyles.normalSemibold14(
                            context,
                          ).copyWith(color: AppColors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black05,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          spacing: 6.w,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetsPngImages.one50,
                              height: 14.h,
                              width: 14.w,
                              fit: BoxFit.contain,
                            ),
                            RichText(
                              text: TextSpan(
                                text: formatAmount(first.totalEarned),
                                style: TextStyles.cardBold10(
                                  context,
                                ).copyWith(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 20.h),
                      Container(
                        width: 70.w,
                        height: 70.h,
                        child: Stack(
                          children: [
                            CachedImageRadius(
                              imageUrl: third!.profileImage,
                              size: 70,
                              circle: true,
                              color: AppColors.grey200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 2,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color(
                                    0xFF72410A,
                                  ).withValues(alpha: 0.54),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.white50),
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "3",
                                      style: TextStyles.cardBold10(
                                        context,
                                      ).copyWith(color: AppColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      RichText(
                        text: TextSpan(
                          text: third.name.capitalize,
                          style: TextStyles.normalSemibold14(
                            context,
                          ).copyWith(color: AppColors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.black05,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Row(
                          spacing: 6.w,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetsPngImages.one50,
                              height: 14.h,
                              width: 14.w,
                              fit: BoxFit.contain,
                            ),
                            RichText(
                              text: TextSpan(
                                text: formatAmount(third.totalEarned),
                                style: TextStyles.cardBold10(
                                  context,
                                ).copyWith(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            FlowvaButton.whiteButton(
              color: Colors.black,
              name: 'See Leaderboard',
              apply: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => LeaderboardScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
