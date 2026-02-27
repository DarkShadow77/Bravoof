import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/core/utils/helpers.dart';
import 'package:bravoo/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../home/data/model/leaderboard_response_model.dart';
import '../../../home/presentation/bloc/home_cubit.dart';
import '../../../home/presentation/page/leaderboard_screen.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class LeaderboardPage extends StatelessWidget {
  final bool fullScreen;
  LeaderboardPage({this.fullScreen = false});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xFF9419FD); // Purple gradient base
    final Color secondaryColor = Color(0xFFFDD3D8);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profile = state.profile;
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final leaderboard = state.leaderboard.leaderboard;
            leaderboard.sort((a, b) => b.totalEarned.compareTo(a.totalEarned));

            final List<LeaderboardModel> listAfterTop3 = leaderboard.length > 3
                ? leaderboard.sublist(3)
                : [];
            final List<LeaderboardModel> leaderboardList = fullScreen
                ? listAfterTop3
                : listAfterTop3.take(4).toList();

            final first = leaderboard[0];
            final second = leaderboard.length > 1 ? leaderboard[1] : null;
            final third = leaderboard.length > 2 ? leaderboard[2] : null;

            final userLeaderboard = leaderboard.firstWhere(
              (element) => element.userId == profile.userId,
              orElse: () => LeaderboardModel.empty(),
            );
            int userIndex = leaderboard.indexOf(userLeaderboard);
            return Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryColor, secondaryColor],
                ),
              ),
              child: Column(
                children: [
                  // Top Leaderboard Info
                  if (fullScreen)
                    SizedBox(height: MediaQuery.of(context).padding.top),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 20.w,
                        children: [
                          if (fullScreen)
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20.sp,
                                color: AppColors.white,
                              ),
                            ),
                          Text(
                            'Leaderboard',
                            style: GoogleFonts.baloo2(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFC58F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFF77A38),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '#${userIndex + 1}',
                                style: GoogleFonts.baloo2(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Keep the momentum going! You are number ${userIndex + 1} this month!',
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111111),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  // Podium
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Top3Widget(
                          isFullScreen: fullScreen,
                          leaderboardDetails: second,
                          position: 2,
                          podiumHeight: 115,
                          podiumColor: Color(0xFF6312A8),
                        ),
                        Top3Widget(
                          isFullScreen: fullScreen,
                          isFirst: true,
                          leaderboardDetails: first,
                          position: 1,
                          podiumHeight: 140,
                          podiumColor: Color(0xFF7B24E8),
                        ),
                        Top3Widget(
                          isFullScreen: fullScreen,
                          leaderboardDetails: third,
                          position: 3,
                          podiumHeight: 100,
                          podiumColor: Color(0xFF6312A8),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 100.h,
                      maxHeight: 330.h,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: leaderboardList.isEmpty
                        ? Center(
                            child: Text(
                              'No more players yet',
                              style: GoogleFonts.manrope(color: Colors.grey),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: leaderboardList.length,
                            physics: fullScreen
                                ? BouncingScrollPhysics()
                                : NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            itemBuilder: (context, index) {
                              final leaderboard = leaderboardList[index];
                              int userIndex = leaderboardList.indexOf(
                                userLeaderboard,
                              );
                              return leaderboardTile(
                                context,
                                rank: index + 4,
                                leaderboard: leaderboard,
                                isUser: userIndex == index,
                              );
                            },
                            separatorBuilder: (_, _) {
                              return SizedBox(height: 4.h);
                            },
                          ),
                    /*child: Column(
                      children: [
                        ...rewardsSummary.asMap().entries.map((e) {
                          final index = e.key;
                          final leaderboard = e.value;
                          return leaderboardTile(
                            rank: index + 1,
                            name: leaderboard.userProfile!.name!,
                            role: leaderboard.userProfile!.bio!,
                            score: leaderboard.totalPointRedeemed.toString(),
                            image: leaderboard.userProfile!.profilePic!,
                          );
                        }),
                      ],
                    ),*/
                  ),
                  if (!fullScreen) ...[
                    // Leader List
                    SizedBox(height: 10.h),
                    FlowvaButton.whiteButton(
                      color: Colors.black,
                      name: 'See Leaderboard',
                      apply: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => LeaderboardScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget leaderboardTile(
    BuildContext context, {
    required LeaderboardModel leaderboard,
    required int rank,
    bool isLast = false,
    bool isUser = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.5.h),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary10 : null,
        borderRadius: BorderRadius.circular(14.r),
        border: isUser ? Border.all(color: AppColors.black10) : null,
      ),
      child: Row(
        spacing: 8.w,
        children: [
          Container(
            width: 30.w,
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: "$rank",
                  style: TextStyles.bodyBold16(context),
                ),
              ),
            ),
          ),
          CachedImageRadius(
            imageUrl: leaderboard.profileImage,
            size: 40,
            circle: true,
            color: AppColors.grey200,
          ),
          Expanded(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text:
                        "${leaderboard.name.capitalize} ${isUser ? "(You)" : ""}",
                    style: TextStyles.smallSemibold12(context),
                  ),
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: leaderboard.bio,
                    style: TextStyles.cardMedium10(
                      context,
                    ).copyWith(color: AppColors.grey500),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.black05,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Row(
              spacing: 4.w,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AssetsPngImages.one50,
                  height: 12.h,
                  width: 12.w,
                  fit: BoxFit.contain,
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: formatAmount(leaderboard.totalEarned),
                    style: TextStyles.cardBold10(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget userColumn({
    required String name,
    required String image,
    required String score,
    required Color badgeColor,
    required Color positionColor,
    bool showMedal = false,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(radius: 40, backgroundImage: NetworkImage(image)),
            if (showMedal)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: badgeColor,
                  child: Icon(
                    Icons.emoji_events,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(color: positionColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bubble_chart, color: Colors.white70, size: 16),
            SizedBox(width: 4),
            Text(score, style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }

  Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}

Widget podiumBlock({
  bool isFull = true,
  required int position,
  required double height,
  required Color color,
}) {
  final Color frontFaceColor = color;
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      // Front face (main block)
      Container(
        width: isFull ? 108.w : 98.w,
        height: height,
        decoration: BoxDecoration(
          color: position == 1 ? null : frontFaceColor,
          gradient: position == 1
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF6312A8), Color(0xFF9720FC)],
                )
              : null,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(5.r),
          ),
        ),
        alignment: Alignment.bottomCenter,

        child: Text(
          '$position',
          style: GoogleFonts.baloo2(
            fontSize: 64,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),

      // Top face (angled using Transform)
      Positioned(
        top: 0,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.skewX(-0.4), // Skew to create 3D angle
          child: Container(
            width: isFull ? 103.11.w : 92.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: Color(0xFFCA8DFD),
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
        ),
      ),
    ],
  );
}

class Top3Widget extends StatelessWidget {
  const Top3Widget({
    super.key,
    this.isFirst = false,
    this.isFullScreen = false,
    required this.position,
    required this.podiumHeight,
    required this.podiumColor,
    this.leaderboardDetails,
  });

  final bool isFirst;
  final bool isFullScreen;
  final int position;
  final double podiumHeight;
  final Color podiumColor;
  final LeaderboardModel? leaderboardDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedImageRadius(
              imageUrl: leaderboardDetails?.profileImage ?? "",
              size: isFirst ? 80 : 64,
              circle: true,
              color: AppColors.grey200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.h),
            if (leaderboardDetails != null) ...[
              RichText(
                text: TextSpan(
                  text: leaderboardDetails?.name.capitalize ?? "--",
                  style: TextStyles.smallRegular12(context).copyWith(
                    color: AppColors.white,
                    fontWeight: isFirst ? FontWeight.bold : null,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                spacing: 6.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 12.h,
                    width: 12.w,
                    child: Image.asset(
                      AssetsPngImages.one50,
                      fit: BoxFit.contain,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: formatAmount(leaderboardDetails?.totalEarned ?? 0),
                      style: TextStyles.cardSemibold10(
                        context,
                      ).copyWith(color: AppColors.white),
                    ),
                  ),
                ],
              ),
            ] else ...[
              RichText(
                text: TextSpan(
                  text: "No Record",
                  style: TextStyles.cardSemibold10(
                    context,
                  ).copyWith(color: AppColors.white),
                ),
              ),
            ],
            SizedBox(height: 10.h),
            podiumBlock(
              position: position,
              height: podiumHeight.h,
              color: podiumColor,
              isFull: isFullScreen,
            ),
          ],
        ),
      ],
    );
  }
}
