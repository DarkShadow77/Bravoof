import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/features/dashboard/home/data/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';

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
          final grouped = <String, List<NotificationModel>>{};
          for (final tx in notifications) {
            final key =
                '${_monthName(tx.createdAt.month)} ${tx.createdAt.year}'; // e.g. October 2025
            grouped.putIfAbsent(key, () => []).add(tx);
          }

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
                return _buildNotificationCard(
                  context,
                  month: grouped.keys.elementAt(index),
                  notificationList: grouped.values.elementAt(index),
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
