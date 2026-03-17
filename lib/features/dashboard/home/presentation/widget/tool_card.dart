import 'dart:convert';

import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:bravoo/core/constants/app_assets.dart';
import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/features/dashboard/home/data/model/quote_model.dart';
import 'package:bravoo/features/dashboard/home/data/model/spotlight_model.dart';
import 'package:bravoo/features/dashboard/home/presentation/bloc/home_cubit.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../earn/presentation/widgets/referr_campaign.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../data/model/dynamic_carousel_model.dart';
import '../page/past_spotlight_page.dart';
import 'campain_winner_card.dart';

class ToolCardCarousel extends StatefulWidget {
  ToolCardCarousel({Key? key}) : super(key: key);

  @override
  State<ToolCardCarousel> createState() => _ToolCardCarouselState();
}

class _ToolCardCarouselState extends State<ToolCardCarousel> {
  final _pageController = PageController(viewportFraction: 1);

  double _currentPage = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
    _fetchDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _fetchDetails() {
    context.read<HomeCubit>().fetchCampaigns();
    context.read<HomeCubit>().fetchSpotlight();
    context.read<HomeCubit>().fetchSpotlights();
    context.read<HomeCubit>().fetchExtraHomeCard();
    context.read<HomeCubit>().fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, pState) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            // Build carousel dynamically based on state
            final carouselWidgets = _buildCarouselItems(state, pState);

            return Column(
              children: [
                // PageView of cards
                Container(
                  height: 240.h,
                  child: Center(
                    child: PageView.builder(
                      padEnds: true,
                      controller: _pageController,
                      physics: BouncingScrollPhysics(),
                      allowImplicitScrolling: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: carouselWidgets.length,
                      onPageChanged: (index) {
                        _fetchDetails();
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        double scaleFactor = .8;
                        double height = 230.h;
                        Matrix4 matrix = Matrix4.identity();

                        if (index == _currentPage.floor()) {
                          var currScale =
                              1 - (_currentPage - index) * (1 - scaleFactor);
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
                          var currScale =
                              1 - (_currentPage - index) * (1 - scaleFactor);
                          var currTrans = height * (1 - currScale) / 2;
                          matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                            ..setTranslationRaw(0, currTrans, 0);
                        } else {
                          var currScale = .8;
                          matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                            ..setTranslationRaw(
                              0,
                              height * (1 - scaleFactor) / 2,
                              0,
                            );
                        }
                        return Transform(
                          transform: matrix,
                          child: Container(
                            width: double.infinity,
                            child: carouselWidgets[index],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    carouselWidgets.length,
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
          },
        );
      },
    );
  }

  List<Widget> _buildCarouselItems(HomeState state, ProfileState pState) {
    List<Widget> items = [];
    // Active campaign
    if (state.campaign.isNotEmpty) {
      items.add(ReferCampaign());
    }

    // Winner announcement (most recently ended campaign)
    final endedCampaigns = state.campaign
        .where((c) => c.campaignEndDate.isBefore(DateTime.now()))
        .toList();

    if (endedCampaigns.isNotEmpty) {
      // Sort to get the most recent ended campaign
      endedCampaigns.sort(
        (a, b) => b.campaignEndDate.compareTo(a.campaignEndDate),
      );
      items.add(CampaignWinnerCard());
    }

    // Dynamic carousel items
    final dynamicCarouselItems = state.extraCard;
    if (dynamicCarouselItems.isNotEmpty) {
      for (var item in dynamicCarouselItems) {
        items.add(
          DynamicCarouselCard(item: item, userId: pState.profile.userId),
        );
      }
    }

    // Spotlight
    if (state.spotlight.name.isNotEmpty) {
      items.add(SpotlightCard());
    }

    // Quote
    items.add(QuoteCard());

    return items;
  }
}

class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  QuoteModel quotes = QuoteModel.empty();

  @override
  void initState() {
    super.initState();
    quotes = context.read<HomeCubit>().state.quote;
    context.read<HomeCubit>().fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        quotes = state.quote;
        bool loading =
            state is HomeLoadingState && state.type == HomeType.getQuote;
        return Container(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (quotes.backgroundImage.isNotEmpty)
                Positioned.fill(
                  child: CachedImageSize(
                    imageUrl: quotes.backgroundImage,
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.grey100,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Positioned.fill(
                  child: Image.asset(
                    AssetsPngImages.quoteBg,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  spacing: 14.h,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loading && quotes.quote.isEmpty) ...[
                      FadeShimmer(
                        width: 250.w,
                        height: 16.h,
                        radius: 12.r,
                        baseColor: AppColors.grey200,
                        highlightColor: AppColors.grey100,
                      ),
                      FadeShimmer(
                        width: 150.w,
                        height: 16.h,
                        radius: 12.r,
                        baseColor: AppColors.grey200,
                        highlightColor: AppColors.grey100,
                      ),
                    ] else if (quotes.quote.isEmpty)
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text:
                              "“Progress isn’t always loud, sometimes it’s "
                              "just steady. Your pace is enough.“",
                          style: TextStyles.titleSemiBold20(context).copyWith(
                            fontFamily: AppFonts.baloo2,
                            fontStyle: FontStyle.italic,
                            color: hexToColor("#000000"),
                          ),
                        ),
                      )
                    else
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: quotes.quote,
                          style: TextStyles.titleSemiBold20(context).copyWith(
                            fontFamily: AppFonts.baloo2,
                            fontStyle: FontStyle.italic,
                            color: hexToColor(quotes.textColor),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DynamicCarouselCard extends StatefulWidget {
  const DynamicCarouselCard({
    super.key,
    required this.item,
    required this.userId,
  });

  final DynamicCarouselModel item;
  final String userId;

  @override
  State<DynamicCarouselCard> createState() => _DynamicCarouselCardState();
}

class _DynamicCarouselCardState extends State<DynamicCarouselCard> {
  bool _isViewed = false;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _checkIfViewed();
  }

  Future<void> _checkIfViewed() async {
    final viewed = await ViewedItemsService.hasBeenViewed(
      widget.item.id, // Assuming your DynamicCarouselModel has an id field
      widget.userId,
    );

    if (mounted) {
      setState(() {
        _isViewed = viewed;
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsViewed() async {
    await ViewedItemsService.markAsViewed(widget.item.id, widget.userId);

    if (mounted) {
      setState(() {
        _isViewed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _markAsViewed();
        Navigator.pushNamed(context, widget.item.destination);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
        child: Stack(
          children: [
            CachedImageSize(
              imageUrl: widget.item.image,
              width: double.infinity,
              height: double.infinity,
              color: AppColors.grey100,
              fit: BoxFit.cover,
            ),
            // Only show "New!" badge if not viewed and not loading
            if (!_isViewed && !_isLoading)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                  margin: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffFCE4D1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: "New!",
                      style: TextStyles.cardBold10(
                        context,
                      ).copyWith(color: AppColors.redBrown),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SpotlightCard extends StatefulWidget {
  const SpotlightCard({super.key, this.isMainPage = false});

  final bool isMainPage;

  @override
  State<SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> {
  SpotlightModel spotlight = SpotlightModel.empty();

  @override
  void initState() {
    super.initState();
    spotlight = context.read<HomeCubit>().state.spotlight;
    context.read<HomeCubit>().fetchSpotlight();
    context.read<HomeCubit>().fetchSpotlights();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        spotlight = state.spotlight;
        final textColor = hexToColor(spotlight.textColor);
        if (spotlight.name.isEmpty)
          return Center(
            child: Text(
              "Empty",
              style: TextStyles.bodyBold16(
                context,
              ).copyWith(color: AppColors.white),
            ),
          );
        else
          return Container(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.symmetric(
              horizontal: widget.isMainPage ? 0 : 16.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: hexToColor(spotlight.bgColor),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    AssetsPngImages.campaignBg1,
                    fit: BoxFit.cover,
                    color: textColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                text: spotlight.title,
                                style: TextStyles.bodyBold16(
                                  context,
                                ).copyWith(color: textColor),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: !widget.isMainPage,
                            child: SizedBox(
                              width: 126.w,
                              child: IconTextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => PastSpotlightPage(),
                                  ),
                                ),
                                height: 35,
                                textSize: 10,
                                text: "Past Spotlights",
                                textColor: hexToColor(spotlight.btnTextColor),
                                color: hexToColor(spotlight.btnColor),
                                innerShadow: hexToColor(
                                  spotlight.btnTextColor,
                                ).withValues(alpha: .1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 16.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120.w,
                            height: 115.h,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          hexToColor(
                                            spotlight.gradientColor.start,
                                          ),
                                          hexToColor(
                                            spotlight.gradientColor.end,
                                          ),
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    child: CachedImageRadius(
                                      imageUrl: spotlight.image,
                                      size: 103,
                                      color: AppColors.white05,
                                      circle: true,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: SvgPicture.asset(
                                    AssetsSvgIcons.crown,
                                    width: 45.w,
                                    height: 40.h,
                                  ),
                                ),
                              ],
                            ),
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
                                    text: spotlight.name.capitalize,
                                    style: TextStyles.bodySemiBold16(
                                      context,
                                    ).copyWith(color: textColor),
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
                                        style: TextStyles.cardRegular10(context)
                                            .copyWith(
                                              color: textColor.withValues(
                                                alpha: .5,
                                              ),
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 28,
                                      width:
                                          80, // adjust based on number of avatars
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          _buildToolIcon(
                                            AssetsPngImages.one50,
                                            0,
                                          ),
                                          _buildToolIcon(
                                            AssetsPngImages.one50,
                                            20,
                                          ),
                                          _buildToolIcon(
                                            AssetsPngImages.one50,
                                            40,
                                          ),
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
                        spacing: 15.w,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: IconTextButton(
                              text: "Cheers",
                              textSize: 10,
                              spacing: 0,
                              innerShadow: AppColors.primary10,
                              color: textColor,
                              iconWidget: Image.asset(
                                AssetsPngImages.clap,
                                width: 16.w,
                                height: 16.h,
                                fit: BoxFit.contain,
                              ),
                              onPressed: () {
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
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 16.w,
                              ),
                              decoration: BoxDecoration(
                                color: textColor.withValues(alpha: .1),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  spacing: 6.w,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text:
                                                  "${formatAmount(spotlight.missionsCompleted, compact: true, uniComp: true)}",
                                              style: TextStyles.smallSemibold12(
                                                context,
                                              ).copyWith(color: textColor),
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text: "Mission",
                                              style:
                                                  TextStyles.smallCardRegular8(
                                                    context,
                                                    opacity: .8,
                                                  ).copyWith(
                                                    color: textColor.withValues(
                                                      alpha: .85,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: double.infinity,
                                      width: 1.w,
                                      color: textColor.withValues(alpha: .1),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text:
                                                  "${formatAmount(spotlight.coinsEarned, compact: true, uniComp: true)}",
                                              style: TextStyles.smallSemibold12(
                                                context,
                                              ).copyWith(color: textColor),
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text: "Coins",
                                              style:
                                                  TextStyles.smallCardRegular8(
                                                    context,
                                                    opacity: .8,
                                                  ).copyWith(
                                                    color: textColor.withValues(
                                                      alpha: .85,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: double.infinity,
                                      width: 1.w,
                                      color: textColor.withValues(alpha: .1),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text:
                                                  "\$${formatAmount(spotlight.redeemed, compact: true, uniComp: true)}",
                                              style: TextStyles.smallSemibold12(
                                                context,
                                              ).copyWith(color: textColor),
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              text: "Redeemed",
                                              style:
                                                  TextStyles.smallCardRegular8(
                                                    context,
                                                    opacity: .8,
                                                  ).copyWith(
                                                    color: textColor.withValues(
                                                      alpha: .85,
                                                    ),
                                                  ),
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
                ),
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

class ViewedItemsService {
  static const String _key = 'viewed_carousel_items';

  // Store viewed item
  static Future<void> markAsViewed(int itemId, String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final viewedItems = await getViewedItems();

    final viewedItem = {
      'itemId': itemId,
      'userId': userId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Check if already exists
    final exists = viewedItems.any(
      (item) => item['itemId'] == itemId && item['userId'] == userId,
    );

    if (!exists) {
      viewedItems.add(viewedItem);
      await prefs.setString(_key, json.encode(viewedItems));
    }
  }

  // Check if item has been viewed by user
  static Future<bool> hasBeenViewed(int itemId, String userId) async {
    final viewedItems = await getViewedItems();
    return viewedItems.any(
      (item) => item['itemId'] == itemId && item['userId'] == userId,
    );
  }

  // Get all viewed items
  static Future<List<Map<String, dynamic>>> getViewedItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? itemsJson = prefs.getString(_key);

    if (itemsJson == null || itemsJson.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = json.decode(itemsJson);
    return decoded.cast<Map<String, dynamic>>();
  }

  // Clear all viewed items (optional, for testing or user preference)
  static Future<void> clearViewedItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
