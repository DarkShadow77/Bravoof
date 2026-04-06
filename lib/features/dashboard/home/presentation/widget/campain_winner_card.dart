import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../profile/data/model/users_model.dart';
import '../../data/model/campaign_response.dart';
import '../page/past_campaign_page.dart';

class CampaignWinnerCard extends StatelessWidget {
  CampaignWinnerCard({super.key, required this.campaign});

  final CampaignResponseModel campaign;

  Users? _getCurrentUserWinnerDetails() {
    SupabaseClient supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) return null;

    try {
      return campaign.winners.firstWhere((w) => w.userId == currentUserId);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    SupabaseClient supabase = Supabase.instance.client;
    final textColor = hexToColor(campaign.textColor);
    final bgColor = hexToColor(campaign.bgColor);
    final hasEnded = campaign.campaignEndDate.isBefore(DateTime.now());
    final currentUserId = supabase.auth.currentUser?.id ?? '';
    final isWinner = campaign.isUserWinner(currentUserId);
    final currentUserWinner = _getCurrentUserWinnerDetails();

    // Display profile image (current user if winner, else first winner)
    final displayProfileImage =
        hasEnded && isWinner && currentUserWinner != null
        ? currentUserWinner.profileImage
        : campaign.winners.isNotEmpty
        ? campaign.winners.first.profileImage
        : campaign.winnerProfileImage;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => PastCampaignPage()),
      ),
      behavior: HitTestBehavior.opaque,
      child: Container(
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
                      Expanded(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: campaign.name.toString(),
                            style: TextStyles.smallBold12(
                              context,
                            ).copyWith(color: textColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 126.w,
                        child: IconTextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => PastCampaignPage(),
                            ),
                          ),
                          height: 35,
                          textSize: 10,
                          text: "${campaign.month} Winner(s)",
                          textColor: hexToColor(campaign.textColor),
                          color: hexToColor(campaign.inverseTextColor),
                          innerShadow: hexToColor(
                            campaign.textColor,
                          ).withValues(alpha: .3),
                          paddingW: 0,
                          paddingH: 0,
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
                            imageUrl: displayProfileImage,
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
          ],
        ),
      ),
    );
  }
}
