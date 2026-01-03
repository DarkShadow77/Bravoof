import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../data/model/featured_mission_model.dart';
import '../../data/model/mission_status_enum.dart';
import '../bloc/featured_mission_bloc.dart';
import 'featured_event_dialog.dart';

class FeaturedCard extends StatefulWidget {
  const FeaturedCard({super.key});

  @override
  State<FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> with UIToolMixin {
  final _pageController = PageController(viewportFraction: 1, initialPage: 0);

  List<FeaturedMission> featuredMissions = [];
  List<MissionStatus> featuredMissionStatus = [];

  double _currentPage = 0;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    final featuredBloc = BlocProvider.of<FeaturedMissionBloc>(context);
    featuredMissions = featuredBloc.state.missions;
    featuredMissionStatus = featuredBloc.state.hasJoined;

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
    return BlocBuilder<FeaturedMissionBloc, FeaturedMissionState>(
      builder: (context, state) {
        featuredMissions = state.missions;
        featuredMissionStatus = state.hasJoined;
        bool loading =
            state is FeaturedMissionLoading &&
            state.type == FeaturedMissionType.fetchMission;

        if (featuredMissions.isEmpty && loading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: FadeShimmer(
              width: double.infinity,
              height: 326.h,
              radius: 16.r,
              baseColor: AppColors.darkPrimary05,
              highlightColor: AppColors.grey300.withValues(alpha: .25),
            ),
          );
        } else if (featuredMissions.isNotEmpty) {
          return Column(
            children: [
              Container(
                height: 444.h,
                child: PageView.builder(
                  padEnds: true,
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),

                  allowImplicitScrolling: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: featuredMissions.length,
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

                    final featuredMission = featuredMissions[index];
                    final missionStatus = featuredMissionStatus[index];
                    final joined =
                        (missionStatus == MissionStatus.pending ||
                        missionStatus == MissionStatus.completed);
                    return Transform(
                      transform: matrix,
                      child: Container(
                        height: 444.h,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              hexToColor(featuredMission.color.end),
                              hexToColor(featuredMission.color.start),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
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
                                      text: 'Powered by ${featuredMission.by}',
                                      style: TextStyles.normalBold14(context)
                                          .copyWith(
                                            color: hexToColor(
                                              featuredMission.textColor,
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
                                      featuredMission.textColor,
                                    ).withValues(alpha: .2),
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: Row(
                                    spacing: 4.w,
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
                                          text: "${featuredMission.points}",
                                          style:
                                              TextStyles.smallSemibold12(
                                                context,
                                              ).copyWith(
                                                color: hexToColor(
                                                  featuredMission.textColor,
                                                ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            RichText(
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: featuredMission.title,
                                style: TextStyles.titleRegular20(context)
                                    .copyWith(
                                      color: hexToColor(
                                        featuredMission.textColor,
                                      ),
                                      fontFamily: AppFonts.baloo,
                                      height: 1.1.sp,
                                    ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            CachedImageSize(
                              imageUrl: featuredMission.image,
                              width: double.infinity,
                              height: 172.h,
                              borderRadius: 24.r,
                              fit: BoxFit.cover,
                              color: AppColors.grey300.withValues(alpha: .5),
                            ),
                            SizedBox(height: 17.h),
                            RichText(
                              maxLines: 3,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: featuredMission.subtitle,
                                style: TextStyles.normalSemibold14(context)
                                    .copyWith(
                                      color: hexToColor(
                                        featuredMission.textColor,
                                      ),
                                    ),
                              ),
                            ),
                            SizedBox(height: 17.h),
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
                                    onPressed: () => featuredEventDialog(
                                      featuredMission: featuredMission,
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
                  featuredMissions.length,
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
        } else
          return SizedBox();
      },
    );
  }
}
