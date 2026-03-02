import 'package:bravoo/features/dashboard/home/data/model/spotlight_model.dart';
import 'package:bravoo/features/dashboard/home/presentation/widget/tool_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../bloc/home_cubit.dart';

class PastSpotlightPage extends StatefulWidget {
  const PastSpotlightPage({super.key});

  @override
  State<PastSpotlightPage> createState() => _PastSpotlightPageState();
}

class _PastSpotlightPageState extends State<PastSpotlightPage> {
  SpotlightModel spotlight = SpotlightModel.empty();
  List<SpotlightModel> spotlights = [];
  @override
  void initState() {
    super.initState();
    final homeBloc = context.read<HomeCubit>();
    spotlight = homeBloc.state.spotlight;
    spotlights = homeBloc.state.spotlights;
    homeBloc.fetchSpotlight();
    homeBloc.fetchSpotlights();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        spotlight = state.spotlight;
        spotlights = state.spotlights;
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/earn_bg.png",
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    SizedBox(
                      height: kToolbarHeight,
                      child: Row(
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
                                text: "Spotlight",
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
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 240.h,
                      child: SpotlightCard(isMainPage: true),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1.h,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Past Featured Spotlight",
                              style: TextStyles.normalSemibold14(
                                context,
                              ).copyWith(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        itemCount: spotlights.length,
                        itemBuilder: (context, index) {
                          final pastSpotlight = spotlights[index];
                          bool isLatest = pastSpotlight.id == spotlight.id;
                          final textColor = isLatest
                              ? hexToColor(pastSpotlight.bgColor)
                              : AppColors.black;
                          return Container(
                            clipBehavior: Clip.antiAlias,
                            padding: EdgeInsets.symmetric(
                              vertical: 12.h,
                              horizontal: 16.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              gradient: LinearGradient(
                                colors: [
                                  if (isLatest) ...[
                                    hexToColor(spotlight.gradientColor.start),
                                    hexToColor(spotlight.gradientColor.end),
                                  ] else ...[
                                    AppColors.white80,
                                    AppColors.white50,
                                  ],
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Row(
                              spacing: 15.w,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    spacing: 5.w,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CachedImageRadius(
                                        imageUrl: pastSpotlight.image,
                                        size: 50,
                                        color: AppColors.white05,
                                        circle: true,
                                        fit: BoxFit.cover,
                                      ),
                                      Expanded(
                                        child: Column(
                                          spacing: 4.h,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              text: TextSpan(
                                                text: pastSpotlight.name.capitalize,
                                                style:
                                                    TextStyles.smallSemibold12(
                                                      context,
                                                    ).copyWith(
                                                      color: isLatest
                                                          ? hexToColor(
                                                              pastSpotlight
                                                                  .textColor,
                                                            )
                                                          : textColor,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 4.h,
                                                horizontal: 6.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isLatest
                                                    ? hexToColor(
                                                        pastSpotlight.textColor,
                                                      )
                                                    : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: RichText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  text: pastSpotlight
                                                      .month
                                                      .capitalize,
                                                  style:
                                                      TextStyles.cardSemibold10(
                                                        context,
                                                      ).copyWith(
                                                        color: textColor,
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
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                      horizontal: 16.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isLatest
                                          ? hexToColor(
                                              pastSpotlight.textColor,
                                            ).withValues(alpha: .7)
                                          : AppColors.white,
                                      borderRadius: BorderRadius.circular(
                                        100.r,
                                      ),
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        spacing: 6.w,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text:
                                                        "${formatAmount(pastSpotlight.missionsCompleted, compact: true, uniComp: true)}",
                                                    style:
                                                        TextStyles.smallSemibold12(
                                                          context,
                                                        ).copyWith(
                                                          color: textColor,
                                                        ),
                                                  ),
                                                ),
                                                RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text: "Mission",
                                                    style:
                                                        TextStyles.smallCardRegular8(
                                                          context,
                                                          opacity: .8,
                                                        ).copyWith(
                                                          color: textColor
                                                              .withValues(
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
                                            color: textColor.withValues(
                                              alpha: .1,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text:
                                                        "${formatAmount(pastSpotlight.coinsEarned, compact: true, uniComp: true)}",
                                                    style:
                                                        TextStyles.smallSemibold12(
                                                          context,
                                                        ).copyWith(
                                                          color: textColor,
                                                        ),
                                                  ),
                                                ),
                                                RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text: "Coins",
                                                    style:
                                                        TextStyles.smallCardRegular8(
                                                          context,
                                                          opacity: .8,
                                                        ).copyWith(
                                                          color: textColor
                                                              .withValues(
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
                                            color: textColor.withValues(
                                              alpha: .1,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text:
                                                        "\$${formatAmount(pastSpotlight.redeemed, compact: true, uniComp: true)}",
                                                    style:
                                                        TextStyles.smallSemibold12(
                                                          context,
                                                        ).copyWith(
                                                          color: textColor,
                                                        ),
                                                  ),
                                                ),
                                                RichText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text: "Redeemed",
                                                    style:
                                                        TextStyles.smallCardRegular8(
                                                          context,
                                                          opacity: .8,
                                                        ).copyWith(
                                                          color: textColor
                                                              .withValues(
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
                          );
                        },
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
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
