import 'dart:async';

import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/app/view/widgets/cached_image_widget.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/referral_contest_screen.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/draw_end_page.dart';
import 'package:flowva/features/dashboard/home/data/model/campaign_response.dart';
import 'package:flowva/features/dashboard/home/data/model/spotlight_model.dart';
import 'package:flowva/features/dashboard/home/presentation/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/helpers.dart';
import '../../presentation/bloc/campaign_cubit.dart';

class ToolCardCarousel extends StatefulWidget {
  ToolCardCarousel({Key? key}) : super(key: key);

  @override
  State<ToolCardCarousel> createState() => _ToolCardCarouselState();
}

class _ToolCardCarouselState extends State<ToolCardCarousel> {
  final _pageController = PageController(viewportFraction: 1);
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  bool _isExpired = false;
  late HomeCubit homeCubit;
  List<CampaignModel> campaign = [];

  @override
  void initState() {
    super.initState();
    homeCubit = HomeCubit();
    campaign = homeCubit.state.campaign;

    homeCubit.fetchSpotlight();
    homeCubit.fetchSpotlight();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (campaign.isNotEmpty) {
        _remainingTime = Duration(
          days: campaign.first.campaignEndDate.day,
          hours: campaign.first.campaignEndDate.hour,
          minutes: campaign.first.campaignEndDate.minute,
          seconds: campaign.first.campaignEndDate.second,
        );
      }
      _startCountdown();
    });
  }

  void _startCountdown() {
    // Calculate initial remaining time
    _updateRemainingTime();

    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();
      final difference = campaign.isNotEmpty
          ? campaign.first.campaignEndDate.difference(now)
          : Duration.zero;

      if (difference.isNegative) {
        setState(() {
          _isExpired = true;
          _remainingTime = Duration.zero;
        });
        _timer?.cancel();
      } else {
        setState(() {
          _remainingTime = difference;
          _isExpired = false;
        });
      }
    });
  }

  double _currentPage = 0;
  int currentPage = 0;
  final List<String> backgroundImages = [
    'assets/images/top_tool_bg.png',
    'assets/images/top_user_b.png',
    'assets/images/quote_bg.png',
  ];

  final List<Map<String, dynamic>> data = [
    {
      'title': "Top User Spotlight",
      'name': "James Martins",
      'subtitle': "Top user",
      'image': "assets/avatar/2.png",
    },
    {
      'title': "Top User Spotlight",
      'name': "James Martins",
      'subtitle': "Top user",
      'image': "assets/avatar/2.png",
      'listOfImages': [
        "assets/images/one_50.png",
        "assets/images/one_50.png",
        "assets/images/one_50.png",
      ],
    },
    {
      'title':
          "“Progress isn’t always loud, sometimes it’s just steady. Your pace is enough.“",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PageView of cards
        Container(
          height: 230.h,
          child: PageView.builder(
            padEnds: true,
            controller: _pageController,
            physics: BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            scrollDirection: Axis.horizontal,
            itemCount: carousel.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
              homeCubit.fetchSpotlight();
            },
            itemBuilder: (context, index) {
              double scaleFactor = .8;
              double height = 230.h;
              Matrix4 matrix = Matrix4.identity();

              if (index == _currentPage.floor()) {
                var currScale = 1 - (_currentPage - index) * (1 - scaleFactor);
                var currTrans = height * (1 - currScale) / 2;
                matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                  ..setTranslationRaw(0, currTrans, 0);
              } else if (index == _currentPage.floor() + 1) {
                var currScale =
                    scaleFactor +
                    (_currentPage - index + 1) * (1 - scaleFactor);

                var currTrans = height * (1 - currScale) / 2;
                matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                  ..setTranslationRaw(0, currTrans, 0);
              } else if (index == _currentPage.floor() - 1) {
                var currScale = 1 - (_currentPage - index) * (1 - scaleFactor);
                var currTrans = height * (1 - currScale) / 2;
                matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                  ..setTranslationRaw(0, currTrans, 0);
              } else {
                var currScale = .8;
                matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                  ..setTranslationRaw(0, height * (1 - scaleFactor) / 2, 0);
              }
              return Transform(
                transform: matrix,
                child: Container(child: _buildToolCard(index)),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            carousel.length,
            (index) => GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: index == currentPage ? 18.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? AppColors.darkPrimary
                      : AppColors.darkPrimary20,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget?> get carousel => [
    BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        campaign = state.campaign;

        if (campaign.isEmpty) return SizedBox.shrink();

        final days = _remainingTime.inDays;
        final hours = _remainingTime.inHours.remainder(24);
        final minutes = _remainingTime.inMinutes.remainder(60);
        final seconds = _remainingTime.inSeconds.remainder(60);
        return Container(
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    "assets/images/giveaway_card.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/images/oraimo.png"),
                        SizedBox(width: 8),
                        Text(
                          campaign.first.name.toString(),
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              campaign.first.title.toString(),
                              style: GoogleFonts.baloo2(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFDCB5FF),
                              ),
                            ),
                          ),
                        ),

                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white.withValues(alpha: 0.08),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.3,
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFFDEC4FF),
                              child: Image.network(
                                campaign.first.url.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // SvgPicture.asset("assets/images/ear_pod.svg",height: 40,),
                      ],
                    ),
                    Container(
                      height: 90,

                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          // White container
                          Positioned(
                            bottom: 40, // lift the white box slightly
                            child: Container(
                              width: 290,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.80),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ends in ',
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF191919),
                                    ),
                                  ),
                                  _timerBox('$days days'),
                                  const Icon(
                                    Icons.more_vert,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  _timerBox('${hours}h'),
                                  const Icon(
                                    Icons.more_vert,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  _timerBox('${minutes}m'),
                                  const Icon(
                                    Icons.more_vert,
                                    size: 14,
                                    color: Colors.black,
                                  ),
                                  _timerBox('${seconds}s'),
                                ],
                              ),
                            ),
                          ),

                          // Button overlapping the white box bottom
                          Positioned(
                            bottom: 0,
                            child: GestureDetector(
                              //ReferralContestScreen() //DrawEndPage()
                              onTap: () {
                                final now = DateTime.now();

                                if (now.isAfter(
                                  campaign.first.campaignEndDate,
                                )) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => DrawEndPage(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BlocProvider<CampaignCubit>(
                                            create: (_) => sl<CampaignCubit>(
                                              param1: campaign.first.id,
                                            ),
                                            child: ReferralContestScreen(
                                              campaignEndDate: campaign
                                                  .first
                                                  .campaignEndDate,
                                            ),
                                          ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                width: 320,

                                child: Center(
                                  child: Text(
                                    'Join the draw',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2B2B2B),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
    SpotlightCard(),
    QuoteCard(),
  ];

  Widget _buildToolCard(int index) {
    return Container(
      // height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      child: Stack(children: [?carousel[index]]),
    );
  }

  Widget _timerBox(String text) {
    return Container(
      // margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191919),
        ),
      ),
    );
  }
}

class ReferralCard extends StatefulWidget {
  const ReferralCard({super.key});

  @override
  State<ReferralCard> createState() => _ReferralCardState();
}

class _ReferralCardState extends State<ReferralCard> {
  CampaignModel campaign = CampaignModel.empty();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchSpotlight();
    campaign = context.read<HomeCubit>().state.campaign.last;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        campaign = state.campaign.last;
        return Container();
      },
    );
  }
}

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: DecorationImage(
          image: AssetImage(AssetsPngImages.quoteBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                "“Progress isn’t always loud, sometimes it’s "
                "just steady. Your pace is enough.“",
            style: TextStyles.titleSemiBold20(context),
          ),
        ),
      ),
    );
  }
}

class SpotlightCard extends StatefulWidget {
  const SpotlightCard({super.key});

  @override
  State<SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> {
  SpotlightModel spotlight = SpotlightModel.empty();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchSpotlight();
    spotlight = context.read<HomeCubit>().state.spotlight;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        spotlight = state.spotlight;

        if (spotlight.name.isEmpty)
          return Text(
            "Empty",
            style: TextStyles.bodyBold16(
              context,
            ).copyWith(color: AppColors.white),
          );
        else
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: AssetImage(AssetsPngImages.spotlightBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Spotlight of the Month",
                    style: TextStyles.bodyBold16(
                      context,
                    ).copyWith(color: AppColors.white),
                  ),
                ),
                Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedImageRadius(
                      imageUrl: spotlight.image,
                      size: 103,
                      color: AppColors.white05,
                      circle: true,
                      fit: BoxFit.cover,
                    ),
                    Expanded(
                      child: Column(
                        spacing: 6.5.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: spotlight.name,
                              style: TextStyles.bodySemiBold16(
                                context,
                              ).copyWith(color: AppColors.white),
                            ),
                          ),
                          Row(
                            spacing: 4.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: "Top User",
                                  style: TextStyles.cardRegular10(
                                    context,
                                  ).copyWith(color: AppColors.grey300),
                                ),
                              ),
                              SizedBox(
                                height: 28,
                                width: 80, // adjust based on number of avatars
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    _buildToolIcon(AssetsPngImages.one50, 0),
                                    _buildToolIcon(AssetsPngImages.one50, 20),
                                    _buildToolIcon(AssetsPngImages.one50, 40),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 20.w,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Confetti.launch(
                          context,
                          options: const ConfettiOptions(
                            particleCount: 100,
                            spread: 30,
                            drift: -1,
                            y: 0.5,
                          ),
                        );
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 38.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: AppColors.white80,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetsPngImages.clap,
                              width: 16.w,
                              height: 16.h,
                              fit: BoxFit.contain,
                            ),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "Cheers",
                                style: TextStyles.cardBold10(
                                  context,
                                ).copyWith(color: AppColors.grey900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white10,
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            spacing: 6.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text:
                                            "${formatAmount(spotlight.missionsCompleted, compact: true, uniComp: true)}",
                                        style: TextStyles.smallSemibold12(
                                          context,
                                        ).copyWith(color: AppColors.white),
                                      ),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: "Mission",
                                        style: TextStyles.smallCardRegular8(
                                          context,
                                          opacity: .8,
                                        ).copyWith(color: AppColors.white85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: 1.w,
                                color: AppColors.white10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text:
                                            "${formatAmount(spotlight.coinsEarned, compact: true, uniComp: true)}",
                                        style: TextStyles.smallSemibold12(
                                          context,
                                        ).copyWith(color: AppColors.white),
                                      ),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: "Coins",
                                        style: TextStyles.smallCardRegular8(
                                          context,
                                          opacity: .8,
                                        ).copyWith(color: AppColors.white85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: double.infinity,
                                width: 1.w,
                                color: AppColors.white10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text:
                                            "\$${formatAmount(spotlight.redeemed, compact: true, uniComp: true)}",
                                        style: TextStyles.smallSemibold12(
                                          context,
                                        ).copyWith(color: AppColors.white),
                                      ),
                                    ),
                                    RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        text: "Redeemed",
                                        style: TextStyles.smallCardRegular8(
                                          context,
                                          opacity: .8,
                                        ).copyWith(color: AppColors.white85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                /*SizedBox(height: 20),
                data['listOfImages'] != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 100,

                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/cheer.png"),
                                SizedBox(width: 5),
                                Text(
                                  "Awesome",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 160,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '10',
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Mission',
                                      style: GoogleFonts.manrope(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Text(
                                      '3',
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Coins',
                                      style: GoogleFonts.manrope(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Text(
                                      '50',
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Earned',
                                      style: GoogleFonts.manrope(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),*/
              ],
            ),
          );
      },
    );
  }

  Widget _buildToolIcon(String asset, double left) {
    return Positioned(
      left: left,
      child: Image.asset(
        AssetsPngImages.one50,
        width: 26.w,
        height: 26.h,
        fit: BoxFit.contain,
      ),
    );
  }
}
