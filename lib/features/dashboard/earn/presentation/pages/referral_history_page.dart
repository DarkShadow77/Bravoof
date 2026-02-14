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

    BlocProvider.of<HomeCubit>(context).getUserReferrals();
  }

  search() {
    searchedReferrals.clear();

    if (searchText.isEmpty) {
      searchedReferrals.addAll(referrals);
    } else {
      searchedReferrals.addAll(
        referrals
            .where(
              (element) => (element.name ?? "").toLowerCase().contains(
                searchText.toLowerCase(),
              ),
            )
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<UserProfile>>{};
    for (final tx in searchedReferrals) {
      final key =
          '${_monthName((tx.createdAt ?? DateTime.now()).month)} ${(tx.createdAt ?? DateTime.now()).year}'; // e.g. October 2025
      grouped.putIfAbsent(key, () => []).add(tx);
    }
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        setState(() {
          referrals = state.referrals;
        });
        search();
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Referral History",
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF191919),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),

                children: [
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
                  const SizedBox(height: 16),

                  ...grouped.entries.map(
                    (entry) =>
                        _buildReferralCard(context, entry.key, entry.value),
                  ),
                ],
              ),
            ],
          ),
        ),
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

Widget _buildReferralCard(
  BuildContext context,
  String month,
  List<UserProfile> items,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5F5F5F),
          ),
        ),
        SizedBox(height: 10),
        ...items.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundImage: NetworkImage(e.profilePic ?? ""),
                  backgroundColor: AppColors.grey300.withValues(alpha: .5),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.name ?? "",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // status chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE3FAE1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "Joined",
                          style: GoogleFonts.manrope(
                            color: Color(0xFF008753),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    text: formatSmartDate(e.createdAt?.toIso8601String() ?? ""),
                    style: TextStyles.cardSemibold10(context, opacity: .65),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}
