import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/helpers.dart';
import '../bloc/home_cubit.dart';

class CampaignWinnerCard extends StatelessWidget {
  const CampaignWinnerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final campaignList = state.campaign;
        if (campaignList.isEmpty) return SizedBox.shrink();

        // Find the most recently ended campaign
        final endedCampaigns = campaignList
            .where((c) => c.campaignEndDate.isBefore(DateTime.now()))
            .toList();

        if (endedCampaigns.isEmpty) return SizedBox.shrink();

        // Sort by campaign_end_date descending to get the most recent
        endedCampaigns.sort(
          (a, b) => b.campaignEndDate.compareTo(a.campaignEndDate),
        );
        final campaign = endedCampaigns.first;

        final textColor = hexToColor(campaign.textColor);
        final bgColor = hexToColor(campaign.bgColor);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Image.asset(
                  AssetsPngImages.campaignBg1,
                  fit: BoxFit.cover,
                  color: textColor,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),

              // Content
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  spacing: 4.h,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      spacing: 8.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedImageRadius(
                          imageUrl: campaign.brandImage,
                          size: 25,
                          circle: true,
                          color: Colors.transparent,
                          fit: BoxFit.cover,
                        ),
                        RichText(
                          text: TextSpan(
                            text: campaign.name.toString(),
                            style: TextStyles.smallBold12(
                              context,
                            ).copyWith(color: textColor),
                          ),
                        ),
                      ],
                    ),

                    // Winner announcement stack
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned(
                            left: 100.w,
                            right: 0.w,
                            top: 40.h,
                            child: Image.asset(
                              AssetsPngImages.one50,
                              width: 72.w,
                              height: 72.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            left: 50.w,
                            top: 30.h,
                            child: CachedImageRadius(
                              imageUrl: campaign.winnerProfileImage,
                              size: 88,
                              circle: true,
                              fit: BoxFit.cover,
                              color: Colors.transparent,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 5.h,
                            child: CachedImageSize(
                              imageUrl: campaign.url,
                              width: 142.w,
                              height: 110.h,
                              color: Colors.transparent,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 15.h,
                            child: Image.asset(
                              AssetsPngImages.campaignWinner,
                              width: 200.w,
                              height: 116.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Confetti overlay
              Positioned.fill(
                child: Image.asset(
                  AssetsPngImages.confetti,
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
