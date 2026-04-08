import 'dart:async';

import 'package:bravoo/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../utility/ui_tool_mix.dart';

class SquadRulesPage extends StatefulWidget {
  const SquadRulesPage({super.key});

  @override
  State<SquadRulesPage> createState() => _SquadRulesPageState();
}

class _SquadRulesPageState extends State<SquadRulesPage> with UIToolMixin {
  final _row1 = ["Life Hack", "Motivation", "Tech", "Design", "Growth"];
  final _row2 = ["Idea", "Innovation", "Strategy", "Wellness", "Finance"];
  final _row3 = ["Focus", "Productivity", "Learning", "Career", "Mindset"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          CustomScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                backgroundColor: Color(0xffFFE0E1),
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
                          text: "",
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
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: RichText(
                        text: TextSpan(
                          text: 'Rules',
                          style: TextStyles.titleRegular20(
                            context,
                          ).copyWith(fontFamily: AppFonts.baloo, height: 0.h),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 18.h,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white80,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        spacing: 12.h,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildRules(
                            context,
                            text:
                                "You must become a crew of a Squad in order to be eligible for any of the mission.",
                          ),
                          _buildRules(
                            context,
                            text:
                                "Once a Squad Mission is posted, Squad members must collaborate and make one submission as a team.",
                          ),
                          _buildRules(
                            context,
                            text:
                                "All qualifying pictures and videos must include the squad hashtag e.g **#CreativeSquad** in the  caption.",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: RichText(
                        text: TextSpan(
                          text: 'Get Inspired',
                          style: TextStyles.titleRegular20(
                            context,
                          ).copyWith(fontFamily: AppFonts.baloo, height: 0.h),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppColors.white80,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'Not sure where to start? Here are some ideas to spark your creativity. Join any squad that fits your style and pick any of the eligible mission categories of your choice  ',
                                style: TextStyles.smallMedium12(context),
                              ),
                            ),
                          ),
                          SizedBox(height: 38.h),
                          InfiniteScrollChips(items: _row1),
                          SizedBox(height: 8.h),
                          InfiniteScrollChips(
                            items: _row2,
                            reverseDirection: true,
                          ),
                          SizedBox(height: 8.h),
                          InfiniteScrollChips(items: _row3),
                        ],
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

  Widget _buildRules(BuildContext context, {required String text}) {
    return Row(
      spacing: 4.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          AssetsSvgIcons.star,
          width: 12.w,
          height: 12.h,
          fit: BoxFit.contain,
        ),
        Expanded(
          child: MarkdownBody(
            data: text,
            onTapLink: (text, href, title) async {
              if (href != null) {
                final uri = Uri.parse(href);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              }
            },
            styleSheet: MarkdownStyleSheet(
              a: TextStyle(
                color: AppColors.primary,
                decoration: TextDecoration.underline,
              ),
              p: TextStyles.smallMedium12(
                context,
              ).copyWith(color: AppColors.grey550),
              strong: TextStyles.smallBold12(context),
            ),
          ),
        ),
      ],
    );
  }
}

class InfiniteScrollChips extends StatefulWidget {
  final List<String> items;
  final bool reverseDirection; // for the second row scrolling opposite

  const InfiniteScrollChips({
    super.key,
    required this.items,
    this.reverseDirection = false,
  });

  @override
  State<InfiniteScrollChips> createState() => _InfiniteScrollChipsState();
}

class _InfiniteScrollChipsState extends State<InfiniteScrollChips> {
  late final ScrollController _scrollController;
  Timer? _timer;

  // Duplicate items so it feels infinite (original + copy)
  late final List<String> _items;

  @override
  void initState() {
    super.initState();
    // Triple the list so there's always content ahead and behind
    _items = [...widget.items, ...widget.items, ...widget.items];
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start at the middle copy so we can scroll both ways
      final middle = _scrollController.position.maxScrollExtent / 3;
      _scrollController.jumpTo(middle);
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!_scrollController.hasClients) return;

      final max = _scrollController.position.maxScrollExtent;
      final min = _scrollController.position.minScrollExtent;
      final current = _scrollController.offset;
      const speed = 0.8; // pixels per frame — adjust to taste

      double next = widget.reverseDirection ? current - speed : current + speed;

      // Loop: when you hit either end, jump to the middle third
      if (next >= max * (2 / 3)) {
        next = max / 3;
      } else if (next <= min + max * (1 / 3) && widget.reverseDirection) {
        next = max * (2 / 3);
      }

      _scrollController.jumpTo(next);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(), // disable manual scroll
      child: Row(
        children: _items
            .map(
              (label) => Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primary15,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: RichText(
                  text: TextSpan(
                    text: label,
                    style: TextStyles.smallMedium12(context),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
