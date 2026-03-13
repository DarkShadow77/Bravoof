import 'package:bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../home/presentation/bloc/home_cubit.dart';
import '../../../profile/data/model/user_profile.dart';

class ReferralHistory {
  final String name;
  final String statusLabel;
  final String status; // Missions, Reward, Jackpot, Conversion, Referral
  final String avatar; // Positive for earned, negative for spent
  final String? coins; // Positive for earned, negative for spent
  final DateTime date;

  ReferralHistory({
    required this.name,
    required this.statusLabel,
    required this.status,
    required this.avatar,
    this.coins,
    required this.date,
  });
}

String formatSmartDate(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal();
  final now = DateTime.now();

  final isSameDay =
      dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day;

  final isSameYear = dateTime.year == now.year;

  if (isSameDay) {
    // 🟢 Same day → time only
    return DateFormat('hh:mm a').format(dateTime);
  }

  if (isSameYear) {
    // 🟡 Same year → date + time
    return DateFormat('dd MMM\nhh:mm a').format(dateTime);
  }

  // 🔴 Different year → full date + time
  return DateFormat('dd MMM yyyy\nhh:mm a').format(dateTime);
}

class ReferralHistoryPage extends StatefulWidget {
  ReferralHistoryPage({super.key});

  @override
  State<ReferralHistoryPage> createState() => _ReferralHistoryPageState();
}

class _ReferralHistoryPageState extends State<ReferralHistoryPage> {
  String searchText = "";
  List<UserProfile> referrals = [];
  List<UserProfile> searchedReferrals = [];

  @override
  void initState() {
    super.initState();
    final homeBloc = context.read<HomeCubit>();
    referrals = homeBloc.state.referrals;
    homeBloc.getUserReferrals();
    search();
  }

  search() {
    searchedReferrals.clear();

    if (searchText.isEmpty) {
      searchedReferrals.addAll(referrals);
    } else {
      searchedReferrals.addAll(
        referrals
            .where(
              (element) => (element.name).toLowerCase().contains(
                searchText.toLowerCase(),
              ),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        referrals = state.referrals;
        search();
        final grouped = <String, List<UserProfile>>{};
        for (final tx in searchedReferrals) {
          final key =
              '${_monthName((tx.createdAt).month)} ${(tx.createdAt).year}'; // e.g. October 2025
          grouped.putIfAbsent(key, () => []).add(tx);
        }
        final entries = grouped.entries.toList();
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: const Icon(Icons.arrow_back, color: AppColors.black),
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 10.w),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: "Referral History",
                    style: TextStyles.bodyBold16(
                      context,
                    ).copyWith(fontSize: 18.sp, color: AppColors.black),
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        searchText = val;
                      });
                      search();
                    },
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedSearch01,
                          color: Colors.grey,
                          size: 15.0,
                          strokeWidth: 2.5, // Custom stroke width
                        ),
                      ),
                      hintText: "Search",
                      hintStyle: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return _buildReferralCard(
                          context,
                          entry.key,
                          entry.value,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16.h);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

Widget _buildReferralCard(
  BuildContext context,
  String month,
  List<UserProfile> items,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: month,
          style: TextStyles.smallSemibold12(
            context,
          ).copyWith(color: AppColors.grey300),
        ),
      ),
      SizedBox(height: 10.h),
      ...items.map((e) {
        return Container(
          margin: EdgeInsets.only(bottom: 15.h),
          decoration: BoxDecoration(
            color: AppColors.grey100.withValues(alpha: .6),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 14.w),
          child: Row(
            spacing: 12.w,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageRadius(
                imageUrl: e.profilePic,
                size: 44,
                fit: BoxFit.cover,
                circle: true,
                color: AppColors.grey300.withValues(alpha: .5),
              ),
              Expanded(
                child: Column(
                  spacing: 4.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: e.name,
                        style: TextStyles.smallSemibold12(context),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: "Joined",
                          style: TextStyles.cardSemibold10(
                            context,
                          ).copyWith(color: AppColors.green500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.end,
                text: TextSpan(
                  text: formatSmartDate(e.createdAt.toIso8601String()),
                  style: TextStyles.cardSemibold10(context, opacity: .65),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ],
  );
}
