import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/app/view/widgets/cached_image_widget.dart';
import 'package:Bravoo/core/constants/app_assets.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:Bravoo/features/dashboard/home/data/model/quote_model.dart';
import 'package:Bravoo/features/dashboard/home/data/model/spotlight_model.dart';
import 'package:Bravoo/features/dashboard/home/presentation/bloc/home_cubit.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../earn/presentation/widgets/referr_campaign.dart';
import '../../../mission/presentation/page/tabs/skill_up_tab.dart';
import '../../data/model/dynamic_carousel_model.dart';

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
    context.read<HomeCubit>().fetchExtraHomeCard();
    context.read<HomeCubit>().fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Build carousel dynamically based on state
        final carouselWidgets = _buildCarouselItems(state);

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
  }

  List<Widget> _buildCarouselItems(HomeState state) {
    List<Widget> items = [];

    if (state.campaign.isNotEmpty) {
      items.add(ReferCampaign());
    }

    if (state.spotlight.name.isNotEmpty) {
      items.add(SpotlightCard());
    }

    final dynamicCarouselItems = state.extraCard;

    if (dynamicCarouselItems.isNotEmpty) {
      // Add each backend item as a separate carousel slide
      for (var item in dynamicCarouselItems) {
        items.add(DynamicCarouselCard(item: item));
      }
    }

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
                          text: "“${quotes.quote}“",
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

class DynamicCarouselCard extends StatelessWidget {
  const DynamicCarouselCard({super.key, required this.item});

  final DynamicCarouselModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
      child: CachedImageSize(
        imageUrl: item.image,
        width: double.infinity,
        height: double.infinity,
        color: AppColors.grey100,
        fit: BoxFit.cover,
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
    spotlight = context.read<HomeCubit>().state.spotlight;
    context.read<HomeCubit>().fetchSpotlight();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        spotlight = state.spotlight;

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
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
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
                    text: spotlight.title,
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
                    /*   GestureDetector(
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
                    ),*/
                    Expanded(
                      flex: 2,
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
