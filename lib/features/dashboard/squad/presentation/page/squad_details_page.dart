import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/features/dashboard/squad/data/model/response/squad_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/date_time_helper.dart';

class SquadDetailsPage extends StatefulWidget {
  const SquadDetailsPage({super.key, required this.squad});

  final Squad squad;

  @override
  State<SquadDetailsPage> createState() => _SquadDetailsPageState();
}

class _SquadDetailsPageState extends State<SquadDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                pinned: true,
                centerTitle: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.black05,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft02,
                          color: Colors.black,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Join Squad",
                          style: TextStyles.titleSemiBold20(context),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: CircleAvatar(
                        backgroundColor: AppColors.black05,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft02,
                          color: Colors.black,
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 40.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 116.w,
                          height: 98.h,
                          decoration: BoxDecoration(
                            color: AppColors.white80,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              width: 3.w,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "${widget.squad.name.capitalize} Squad",
                        style: TextStyles.titleSemiBold20(
                          context,
                        ).copyWith(height: 1.h, fontFamily: AppFonts.baloo2),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      spacing: 2.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedCalendar03,
                          size: 16.sp,
                          color: AppColors.grey500,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                                "Created ${formatSmartDate(widget.squad.createdAt.toIso8601String(), showTime: false)}",
                            style: TextStyles.cardBold10(
                              context,
                            ).copyWith(color: AppColors.grey500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: widget.squad.about.isEmpty
                            ? "No Description"
                            : widget.squad.about,
                        style: TextStyles.smallMedium12(context, opacity: .75),
                      ),
                    ),
                  ]),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: 20.h + MediaQuery.of(context).viewPadding.top,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
