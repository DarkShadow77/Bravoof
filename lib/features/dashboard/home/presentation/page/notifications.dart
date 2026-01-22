import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/core/constants/app_assets.dart';
import 'package:Bravoo/features/dashboard/home/data/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../bloc/notification_bloc.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationModel> notifications = [];
  @override
  void initState() {
    super.initState();
    final notificationBloc = context.read<NotificationBloc>();
    notifications = notificationBloc.state.notification;
    notificationBloc.add(LoadNotifications());
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _startOfWeek(DateTime d) {
    final day = d.weekday; // Mon = 1
    return _dateOnly(d.subtract(Duration(days: day - 1)));
  }

  Map<String, List<NotificationModel>> groupNotifications() {
    final now = DateTime.now();
    final today = _dateOnly(now);
    final yesterday = today.subtract(const Duration(days: 1));

    final thisWeekStart = _startOfWeek(today);
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = thisWeekStart.subtract(const Duration(days: 1));

    final thisMonthStart = DateTime(today.year, today.month, 1);
    final lastMonthStart = DateTime(today.year, today.month - 1, 1);
    final lastMonthEnd = thisMonthStart.subtract(const Duration(days: 1));

    final Map<String, List<NotificationModel>> grouped = {};

    for (final n in notifications) {
      final date = _dateOnly(n.createdAt);
      String key;

      if (date == today) {
        key = 'Today';
      } else if (date == yesterday) {
        key = 'Yesterday';
      } else if (date.isAfter(thisWeekStart)) {
        key = 'This Week';
      } else if (date.isAfter(lastWeekStart) &&
          date.isBefore(lastWeekEnd.add(const Duration(days: 1)))) {
        key = 'Last Week';
      } else if (date.isAfter(thisMonthStart)) {
        key = 'This Month';
      } else if (date.isAfter(lastMonthStart) &&
          date.isBefore(lastMonthEnd.add(const Duration(days: 1)))) {
        key = 'Last Month';
      } else {
        // Fallback to Month / Year
        final monthName = _monthName(date.month);
        key = date.year == today.year ? monthName : '$monthName ${date.year}';
      }

      grouped.putIfAbsent(key, () => []).add(n);
    }

    return grouped;
  }

  List<String> orderedKeys(Map<String, List<NotificationModel>> grouped) {
    final fixed = sectionOrder.where(grouped.containsKey).toList();

    final months = grouped.keys.where((k) => !sectionOrder.contains(k)).toList()
      ..sort((a, b) {
        // Optional: custom month sorting if needed
        return 0;
      });

    return [...fixed, ...months];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 16.w,
        title: Row(
          spacing: 8.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft02),
            ),
            RichText(
              text: TextSpan(
                text: "Notifications",
                style: TextStyles.titleSemiBold20(context),
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            position: PopupMenuPosition.under,
            onSelected: (value) {
              if (value == "mark all as read") {
                context.read<NotificationBloc>().add(MarkAllNotificationRead());
              } else if (value == "clear") {
                context.read<NotificationBloc>().add(ClearNotification());
              }
            },
            icon: Icon(Icons.more_horiz),
            menuPadding: EdgeInsets.zero,
            itemBuilder: (BuildContext context) => [
              _buildPopupMenuItem(
                value: "mark all as read",
                text: "Mark As Read",
                icon: AssetsSvgIcons.mail_open,
              ),
              _buildPopupMenuItem(
                value: "clear",
                text: "Clear all",
                icon: AssetsSvgIcons.delete,
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          notifications = state.notification;
          // Group transactions by month/year
          final grouped = groupNotifications();
          final keys = orderedKeys(grouped);

          if (grouped.isEmpty)
            return Column(
              spacing: 20.h,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "All Caught Up!",
                    style: TextStyles.normalBold14(context),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        "Start earning coins and your notifications\n"
                        "will light up in no time ⚡",
                    style: TextStyles.smallMedium12(
                      context,
                    ).copyWith(color: AppColors.grey500),
                  ),
                ),
                SvgPicture.asset(
                  AssetsSvgImages.emptyNotification,
                  width: 49.w,
                  height: 60.h,
                  fit: BoxFit.contain,
                ),
              ],
            );
          else
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 20.h),
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final key = keys[index];
                return _buildNotificationCard(
                  context,
                  month: key,
                  notificationList: grouped[key]!,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 20.h);
              },
            );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required String month,
    required List<NotificationModel> notificationList,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: RichText(
            text: TextSpan(
              text: month,
              style: TextStyles.smallSemibold12(
                context,
              ).copyWith(color: AppColors.grey550),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          itemCount: notificationList.length,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final notification = notificationList[index];
            return NotificationCard(notification: notification);
          },
        ),
      ],
    );
  }

  final sectionOrder = [
    'Today',
    'Yesterday',
    'This Week',
    'Last Week',
    'This Month',
    'Last Month',
  ];

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

  PopupMenuItem<String> _buildPopupMenuItem({
    required String value,
    required String text,
    required String icon,
    Color? color,
  }) {
    return PopupMenuItem<String>(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      value: value,
      child: Row(
        spacing: 6.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 14.w,
            height: 14.h,
            colorFilter: color != null
                ? ColorFilter.mode(color, BlendMode.srcIn)
                : null,
          ),
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: text,
              style: TextStyles.smallSemibold12(context).copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!notification.read)
          context.read<NotificationBloc>().add(
            MarkNotificationRead(notificationId: notification.id),
          );
      },
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          spacing: 8.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: notification.read
                    ? AppColors.purple0
                    : AppColors.purple400,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: notification.read
                    ? AppColors.grey200
                    : AppColors.purple50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: "B.",
                    style: TextStyles.normalBold14(context).copyWith(
                      color: notification.read ? AppColors.grey500 : null,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: notification.title,
                      style: TextStyles.normalBold14(context).copyWith(
                        color: notification.read ? AppColors.grey500 : null,
                      ),
                    ),
                  ),
                  MarkdownBody(
                    data: notification.message,
                    onTapLink: (text, href, title) async {
                      if (href != null) {
                        final uri = Uri.parse(href);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                        if (!notification.read)
                          context.read<NotificationBloc>().add(
                            MarkNotificationRead(
                              notificationId: notification.id,
                            ),
                          );
                      }
                    },
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyles.smallMedium12(
                        context,
                      ).copyWith(color: AppColors.grey500),
                      strong: TextStyles.smallBold12(
                        context,
                      ).copyWith(color: AppColors.grey500),
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
