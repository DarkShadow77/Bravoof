import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/app/view/widgets/loading/outer_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../common/custom_success.dart';
import '../../../../dashboard/profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/data/model/user_profile.dart';
import '../../data/model/streak_response.dart';
import '../bloc/streak_bloc.dart';

class StreakCard extends StatefulWidget {
  const StreakCard({super.key});

  @override
  State<StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<StreakCard> with UIToolMixin {
  final List<String> days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
  final List<String> quotes = [
    "Rest, reset, then rise again.",
    "Consistency is louder than motivation.",
    "Tiny wins make tomorrow lighter.",
    "Showed up today? That's progress.",
    "Momentum feels good, doesn't it?",
    "Progress loves consistency.",
  ];

  UserProfile userProfile = UserProfile.empty();
  StreakResponse streaks = StreakResponse(
    id: 0,
    userId: '',
    currentStreak: 0,
    history: [],
  );

  @override
  void initState() {
    super.initState();
    streaks = context.read<StreakBloc>().state.streak;
    userProfile = context.read<ProfileBloc>().state.profile;
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _startOfWeek(DateTime date) {
    // Monday as start of week
    return date.subtract(Duration(days: date.weekday - 1));
  }

  DateTime _endOfWeek(DateTime date) {
    return _startOfWeek(date).add(const Duration(days: 6));
  }

  List<String> getCheckedDays(StreakResponse streak) {
    if (streak.history.isEmpty) return [];

    final now = DateTime.now();
    final startOfWeek = _dateOnly(_startOfWeek(now));
    final endOfWeek = _dateOnly(_endOfWeek(now));

    return streak.history
        .where((d) {
          final date = _dateOnly(d.toLocal());
          return !date.isBefore(startOfWeek) && !date.isAfter(endOfWeek);
        })
        .map((d) => days[d.weekday - 1])
        .toList();
  }

  String shareStreak() {
    return "@${userProfile.name} kept showing up with a "
        "${streaks.currentStreak} day${streaks.currentStreak > 1 ? "(s)" : ""} streak\n"
        "If you're seeing this, consider it your invite:\n"
        'https://app.joinbravoo.com?ref=${userProfile.referralCode}';
  }

  String getStreakQuote(int streak) {
    if (streak < quotes.length) {
      return quotes[streak];
    } else if (streak < 14) {
      return "One week strong. Discipline unlocked 🔓";
    } else if (streak < 30) {
      return "This is no longer a streak. It’s a lifestyle 🔥";
    } else {
      return "Legend behavior. Keep going 👑";
    }
  }

  _loadingState(BuildContext context, StreakLoadingState state) {
    if (state.type == StreakType.checkIn) {
      outerLoadingDialog(text: "Checking In");
    }
  }

  _successState(BuildContext context, StreakSuccessState state) {
    if (state.type == StreakType.checkIn) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<ProfileBloc>().add(GetProfileEvent());
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (_) => CustomSuccess(
          title: "You earned 5 coins! ✨",
          bodyText: getStreakQuote(streaks.currentStreak),
          b_text1: "Done",
        ),
      );
    }
  }

  _failureState(BuildContext context, StreakFailureState state) {
    if (state.type == StreakType.checkIn) {
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
    final checkedDays = getCheckedDays(streaks);
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (p, c) => p.profile != c.profile,
          listener: (context, state) {
            setState(() {
              userProfile = state.profile;
            });
          },
        ),
        BlocListener<StreakBloc, StreakState>(
          listener: (context, state) {
            if (state is StreakLoadingState) {
              _loadingState(context, state);
            }
            if (state is StreakSuccessState) {
              _successState(context, state);
            }
            if (state is StreakFailureState) {
              _failureState(context, state);
            }
          },
        ),
      ],
      child: BlocBuilder<StreakBloc, StreakState>(
        builder: (context, state) {
          streaks = state.streak;
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFF6EDFE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 14.h),
                RichText(
                  text: TextSpan(
                    text: "🔥",
                    style: TextStyles.h1Bold38(context),
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    text: "${streaks.currentStreak}-Days Streak",
                    style: TextStyles.bodySemiBold16(context),
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                    text:
                        "You’ve checked in ${streaks.currentStreak} days straight. Keep it going!",
                    style: TextStyles.normalMedium14(context, opacity: .5),
                  ),
                ),
                // Days row
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 20.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: days.map((day) {
                      final isChecked = checkedDays.contains(day);
                      return Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: day,
                              style: TextStyles.normalMedium14(context),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          isChecked
                              ? Icon(
                                  Icons.check_circle,
                                  size: 22.sp,
                                  color: Color(0xFFFF8687),
                                )
                              : ["Sun"].contains(day)
                              ? Text("🔥", style: TextStyle(fontSize: 22))
                              : Icon(
                                  Icons.circle_outlined,
                                  size: 22.sp,
                                  color: Color(0xFFA5A5A5),
                                ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Column(
                    children: [
                      IconTextButton(
                        onPressed: () {
                          if (streaks.hasCheckedInToday) {
                            showMessage(
                              "You've already Checked In",
                              context,
                              color: Colors.white,
                              styleColor: Colors.black,
                            );
                          } else {
                            context.read<StreakBloc>().add(CheckInEvent());
                          }
                        },
                        text: streaks.hasCheckedInToday
                            ? "Checked in"
                            : "Check-in today",
                        color: AppColors.black,
                        textColor: AppColors.white,
                        shadowColor: AppColors.error,
                        iconWidget: HugeIcon(
                          icon: HugeIcons.strokeRoundedTickDouble02,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      IconTextButton(
                        onPressed: () {
                          SharePlus.instance.share(
                            ShareParams(text: shareStreak()),
                          );
                        },
                        text: "Share my streak",
                        iconWidget: HugeIcon(
                          icon: HugeIcons.strokeRoundedShare08,
                          color: AppColors.black,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
