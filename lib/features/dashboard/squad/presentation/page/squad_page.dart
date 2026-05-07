import 'package:bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:bravoo/features/dashboard/squad/presentation/page/brands_page.dart';
import 'package:bravoo/features/dashboard/squad/presentation/page/recent_activity_page.dart';
import 'package:bravoo/features/dashboard/squad/presentation/page/squad_rules_page.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../common/flowva_app_bar.dart';
import '../../../earn/presentation/widgets/referr_campaign.dart';
import '../../../home/presentation/bloc/home_cubit.dart';
import '../../../home/presentation/widget/campain_winner_card.dart';
import '../../../home/presentation/widget/referral_widget.dart';
import '../widget/brands_card.dart';
import '../widget/recent_activity_card.dart';
import '../widget/squads_card.dart';

class SquadPage extends StatefulWidget {
  SquadPage({super.key});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  List<CampaignResponseModel> campaign = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h + MediaQuery.of(context).padding.top),
                FlowvaAppBar(title: "Squad"),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 12.h),
                        CardCarousel(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => SquadRulesPage(),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                  horizontal: 25.w,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(12.r),
                                  ),
                                ),
                                child: RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: 'Rules',
                                    style: TextStyles.smallBold12(context)
                                        .copyWith(
                                          fontFamily: AppFonts.baloo2,
                                          color: AppColors.white,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 16.w,
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: 'Squads',
                              style: TextStyles.titleRegular20(context)
                                  .copyWith(
                                    fontFamily: AppFonts.baloo,
                                    height: 0.h,
                                  ),
                            ),
                          ),
                        ),
                        SquadsCard(),
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 16.w,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Brands',
                                  style: TextStyles.titleRegular20(context)
                                      .copyWith(
                                        fontFamily: AppFonts.baloo,
                                        height: 0.h,
                                      ),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'View all',
                                  style: TextStyles.normalSemibold14(
                                    context,
                                    opacity: .67,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => BrandsPage(),
                                      ),
                                    ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        BrandsCard(),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 16.w,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Recent Activity',
                                  style: TextStyles.titleRegular20(context)
                                      .copyWith(
                                        fontFamily: AppFonts.baloo,
                                        height: 0.h,
                                      ),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: 'View all',
                                  style: TextStyles.normalSemibold14(
                                    context,
                                    opacity: .67,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => RecentActivityPage(),
                                      ),
                                    ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RecentActivityCard(),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          child: ReferralCard(share: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardCarousel extends StatefulWidget {
  CardCarousel({Key? key}) : super(key: key);

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        // Build carousel dynamically based on state
        final carouselWidgets = _buildCarouselItems(state);
        final isLoading = _isCarouselLoading(state);

        // Show shimmer placeholders while loading
        if ((isLoading && carouselWidgets.isEmpty) || carouselWidgets.isEmpty) {
          return _buildShimmerLoading();
        }

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

  bool _isCarouselLoading(HomeState state) {
    // True while any of the initial data fetches are still in flight
    if (state is HomeLoadingState) {
      return state.type == HomeType.getCampaign;
    }
    return false;
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: [
        Container(
          height: 240.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r)),
          clipBehavior: Clip.antiAlias,
          child: FadeShimmer(
            width: double.infinity,
            height: double.infinity,
            radius: 24.r,
            baseColor: AppColors.darkPrimary05,
            highlightColor: AppColors.grey300.withValues(alpha: .25),
          ),
        ),
        SizedBox(height: 12.h),
        // Shimmer dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            1,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              width: index == 0 ? 18.w : 6.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.darkPrimary20,
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCarouselItems(HomeState state) {
    List<Widget> items = [];
    final now = DateTime.now();

    // Active campaign
    final activeCampaigns = state.campaign
        .where((c) => c.campaignEndDate.isAfter(now))
        .toList();

    if (activeCampaigns.isNotEmpty) {
      // Sort to get the most recent active campaign
      activeCampaigns.sort(
        (a, b) => b.campaignEndDate.compareTo(a.campaignEndDate),
      );
      for (final campaign in activeCampaigns) {
        items.add(
          ReferCampaign(campaign: campaign, campaignList: state.campaign),
        );
      }
    }

    // Winner announcement (most recently ended campaign)
    final endedCampaigns = state.campaign
        .where((c) => c.campaignEndDate.isBefore(now))
        .toList();

    if (endedCampaigns.isNotEmpty) {
      // Sort to get the most recent ended campaign
      endedCampaigns.sort(
        (a, b) => b.campaignEndDate.compareTo(a.campaignEndDate),
      );
      items.add(CampaignWinnerCard(campaign: endedCampaigns[0]));
    }

    return items;
  }
}
