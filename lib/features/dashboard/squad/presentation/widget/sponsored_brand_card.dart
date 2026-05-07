import 'package:bravoo/features/dashboard/squad/presentation/bloc/brand_individual_bloc.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../mission/data/model/mission_status_enum.dart';
import '../../../mission/data/model/sponsored_mission_model.dart';
import '../../../mission/presentation/widget/sponsored_event_dialog.dart';

class SponsoredBrandCard extends StatefulWidget {
  const SponsoredBrandCard({super.key, required this.textColor});

  final Color textColor;

  @override
  State<SponsoredBrandCard> createState() => _SponsoredBrandCardState();
}

class _SponsoredBrandCardState extends State<SponsoredBrandCard>
    with UIToolMixin {
  final _pageController = PageController(viewportFraction: 1, initialPage: 0);

  List<SponsoredMission> sponsoredMissions = [];

  double _currentPage = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    final sponsoredBloc = BlocProvider.of<BrandIndividualBloc>(context);
    sponsoredMissions = sponsoredBloc.state.sponsoredMissions;

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandIndividualBloc, BrandIndividualState>(
      builder: (context, state) {
        sponsoredMissions = state.sponsoredMissions;

        bool loading =
            state is BrandIndividualLoadingState &&
            state.type == BrandIndividualType.fetch;

        if (sponsoredMissions.isEmpty && loading) {
          return FadeShimmer(
            width: double.infinity,
            height: 326.h,
            radius: 16.r,
            baseColor: widget.textColor.withValues(alpha: .05),
            highlightColor: widget.textColor.withValues(alpha: .1),
          );
        } else if (sponsoredMissions.isEmpty) {
          return SizedBox(
            height: 80.h,
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: "No Sponsored Missions Yet",
                  style: TextStyles.smallSemibold12(
                    context,
                  ).copyWith(color: widget.textColor.withValues(alpha: .65)),
                ),
              ),
            ),
          );
        } else if (sponsoredMissions.isNotEmpty) {
          return Column(
            children: [
              Container(
                height: 328.h,
                child: PageView.builder(
                  padEnds: true,
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),

                  allowImplicitScrolling: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: sponsoredMissions.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    double scaleFactor = .8;
                    double height = 130.h;
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

                    final sponsoredMission = sponsoredMissions[index];
                    final missionStatus = sponsoredMission.userStatus;
                    final joined =
                        (missionStatus == MissionStatus.pending ||
                        missionStatus == MissionStatus.completed);
                    return Transform(
                      transform: matrix,
                      child: Container(
                        height: 328.h,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              hexToColor(sponsoredMission.color.start),
                              hexToColor(sponsoredMission.color.end),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: 'Powered by ${sponsoredMission.by}',
                                      style: TextStyles.normalBold14(context)
                                          .copyWith(
                                            color: hexToColor(
                                              sponsoredMission.textColor,
                                            ).withValues(alpha: .6),
                                          ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: hexToColor(
                                      sponsoredMission.textColor,
                                    ).withValues(alpha: .2),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: Row(
                                    spacing: 4.w,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          spacing: 2.w,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 20.r,
                                              height: 20.r,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: hexToColor(
                                                  sponsoredMission.textColor,
                                                ),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  AssetsSvgIcons.userMultiple,
                                                  width: 12.w,
                                                  height: 12.h,
                                                  colorFilter: ColorFilter.mode(
                                                    AppColors.black,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text:
                                                    "${sponsoredMission.usersJoined} / ${sponsoredMission.maxUsers}",
                                                style:
                                                    TextStyles.cardRegular10(
                                                      context,
                                                    ).copyWith(
                                                      fontFamily:
                                                          AppFonts.baloo,
                                                      color: hexToColor(
                                                        sponsoredMission
                                                            .textColor,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          spacing: 2.w,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              "assets/images/one_50.png",
                                              height: 16.r,
                                              width: 16.r,
                                            ),
                                            RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                text:
                                                    "${sponsoredMission.points}",
                                                style:
                                                    TextStyles.smallSemibold12(
                                                      context,
                                                    ).copyWith(
                                                      color: hexToColor(
                                                        sponsoredMission
                                                            .textColor,
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
                              ],
                            ),
                            SizedBox(height: 12.h),
                            RichText(
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: sponsoredMission.title,
                                style: TextStyles.titleRegular20(context)
                                    .copyWith(
                                      color: hexToColor(
                                        sponsoredMission.textColor,
                                      ),
                                      fontFamily: AppFonts.baloo,
                                      height: 1.1.sp,
                                    ),
                              ),
                            ),
                            SizedBox(height: 13.h),
                            CachedImageSize(
                              imageUrl: sponsoredMission.image,
                              width: 90,
                              height: 90,
                              borderRadius: 14.r,
                              fit: BoxFit.cover,
                              color: AppColors.grey300.withValues(alpha: .5),
                            ),
                            SizedBox(height: 10.h),
                            RichText(
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: sponsoredMission.subtitle,
                                style: TextStyles.smallSemibold12(context)
                                    .copyWith(
                                      color: hexToColor(
                                        sponsoredMission.textColor,
                                      ),
                                    ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            joined
                                ? IconTextButton(
                                    onPressed: () {
                                      showMessage(
                                        "Mission Already Completed",
                                        context,
                                        color: Colors.white,
                                        styleColor: Colors.black,
                                      );
                                    },
                                    text: "Mission Completed",
                                    color: AppColors.grey300,
                                  )
                                : IconTextButton(
                                    onPressed: () => sponsoredEventDialog(
                                      sponsoredMission: sponsoredMission,
                                    ),
                                    text: "Start Mission",
                                  ),
                          ],
                        ),
                      ),
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
                  sponsoredMissions.length,
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
                            ? widget.textColor
                            : widget.textColor.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else
          return const SizedBox();
      },
    );
  }
}
