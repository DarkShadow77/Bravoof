import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/core/constants/app_assets.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:Bravoo/core/utils/helpers.dart';
import 'package:Bravoo/features/dashboard/redeem/data/redeem_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/date_time_helper.dart';
import '../../../../mission/presentation/bloc/streak_bloc.dart';
import '../../../../profile/presentation/bloc/profile_bloc.dart';
import '../../bloc/redeem_bloc.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RedeemBloc, RedeemState>(
      builder: (context, state) {
        final redeemHistory = state.redeemHistory;

        // Group transactions by month/year
        final grouped = <String, List<RedeemHistory>>{};
        for (final tx in redeemHistory) {
          final key =
              '${_monthName(tx.createdAt.month)} ${tx.createdAt.year}'; // e.g. October 2025
          grouped.putIfAbsent(key, () => []).add(tx);
        }

        return Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                child: _buildStatsRow(context),
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.white32,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                  child: grouped.isEmpty
                      ? Column(
                          spacing: 6.h,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AssetsNavbar.redeem,
                              width: 40.w,
                              height: 40.h,
                              fit: BoxFit.contain,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: "No Redeem Yet",
                                style: TextStyles.titleSemiBold20(
                                  context,
                                ).copyWith(fontFamily: AppFonts.baloo2),
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text:
                                    "Complete Missions to unlock\nmore Rewards!",
                                style: TextStyles.normalMedium14(
                                  context,
                                  opacity: .65,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 20.h,
                          ),

                          itemCount: grouped.length,
                          itemBuilder: (context, index) {
                            return _buildRedeemCard(
                              context,
                              month: grouped.keys.elementAt(index),
                              redeemHistoryList: grouped.values.elementAt(
                                index,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20.h);
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      spacing: 10.w,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final profile = state.profile;
            return Expanded(
              child: StatusCard(
                icon: AssetsPngImages.one50,
                value: "${formatAmount(profile.totalEarned, compact: true)}",
                label: 'Total \nEarned',
              ),
            );
          },
        ),
        BlocBuilder<RedeemBloc, RedeemState>(
          builder: (context, state) {
            final redeemHistory = state.redeemHistory;
            return Expanded(
              child: StatusCard(
                icon: "assets/images/gift_with_money.png",
                value: "${redeemHistory.length}",
                label: 'Rewards\nRedeemed',
              ),
            );
          },
        ),
        BlocBuilder<StreakBloc, StreakState>(
          builder: (context, state) {
            final streak = state.streak;
            return Expanded(
              child: StatusCard(
                icon: AssetsPngImages.flame,
                value: "${streak.currentStreak}",
                label: 'Active\nStreak',
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRedeemCard(
    BuildContext context, {
    required String month,
    required List<RedeemHistory> redeemHistoryList,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: month,
              style: TextStyles.smallSemibold12(
                context,
              ).copyWith(color: AppColors.grey550),
            ),
          ),
          SizedBox(height: 12.h),
          ListView.separated(
            shrinkWrap: true,
            itemCount: redeemHistoryList.length,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final redeemHistory = redeemHistoryList[index];
              return RedeemCard(redeemHistory: redeemHistory);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 8.h);
            },
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}

class StatusCard extends StatelessWidget {
  const StatusCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white40,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.white50, width: 1.5.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, height: 24.h, width: 24.w, fit: BoxFit.contain),
          SizedBox(height: 16.h),
          RichText(
            text: TextSpan(text: value, style: TextStyles.titleBold20(context)),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyles.cardMedium10(
                context,
              ).copyWith(fontSize: 11.sp, color: AppColors.grey500),
            ),
          ),
        ],
      ),
    );
  }
}

class RedeemCard extends StatelessWidget {
  const RedeemCard({super.key, required this.redeemHistory});

  final RedeemHistory redeemHistory;

  @override
  Widget build(BuildContext context) {
    final imageMap = {
      'Airtime': AssetsPngImages.cash,
      'Giftcard': AssetsPngImages.giftcard,
      'Data': AssetsPngImages.data,
    };
    final colorMap = {
      'Airtime': Color(0xFFF77A38),
      'Giftcard': AppColors.primary,
      'Data': Color(0xFFF76593),
    };

    final image = imageMap[redeemHistory.rewardType.capitalize] ?? null;
    final color = colorMap[redeemHistory.rewardType.capitalize] ?? null;

    /* final color = colorMap[redeemHistory.rewardType] ?? Colors.grey;
    Widget icon = iconMap[redeemHistory.rewardType] ?? Icons.info as Widget;
*/
    return Container(
      height: 88.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white70,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          image == null
              ? Icon(Icons.info, size: 32.sp, color: AppColors.primary)
              : Image.asset(image, width: 32.w, height: 32.h),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "Redeemed ${redeemHistory.rewardType.capitalize}",
                style: TextStyles.smallSemibold12(context),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            spacing: 4.h,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: RichText(
                  text: TextSpan(
                    text: "Redeem",
                    style: TextStyles.cardMedium10(
                      context,
                    ).copyWith(color: AppColors.white),
                  ),
                ),
              ),

              RichText(
                text: TextSpan(
                  text: "-${formatAmount(redeemHistory.coinsSpent)}",
                  style: TextStyles.normalBold14(
                    context,
                  ).copyWith(color: AppColors.primary),
                ),
              ),

              RichText(
                text: TextSpan(
                  text:
                      "${formatSmartDate(redeemHistory.createdAt.toIso8601String())}",
                  style: TextStyles.cardSemibold10(
                    context,
                  ).copyWith(color: AppColors.grey500),
                ),
              ),
            ],
          ),

          /*CircleAvatar(backgroundColor: Colors.white, child: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(2),
                  ),
                ),
                child: Text(
                  tx.type,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),

                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tx.amount.toString(),
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                tx.subtitle,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5F5F5F),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
