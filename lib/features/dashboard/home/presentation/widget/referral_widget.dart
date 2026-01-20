import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/app/view/widgets/gradient_progress.dart';
import 'package:Bravoo/core/constants/app_assets.dart';
import 'package:Bravoo/features/common/flowva_colors.dart';
import 'package:Bravoo/features/dashboard/earn/presentation/pages/invite_earn.dart';
import 'package:Bravoo/features/onbaording/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class ReferralWidget extends StatelessWidget {
  ReferralWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Big invite card / illustration
        Container(
          height: 170.h,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.white50,
            borderRadius: BorderRadius.circular(24.r),
            /*image: DecorationImage(
              image: AssetImage(AssetsPngImages.inviteBg),
              fit: BoxFit.fitHeight,
            ),*/
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            fit: StackFit.expand,
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(AssetsPngImages.inviteBg, fit: BoxFit.cover),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  spacing: 8.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/gift_bag.png",
                        height: 67,
                      ),
                    ),
                    SvgPicture.asset(
                      AssetsLogo.logo,
                      height: 42.h,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Invite and Earn",
                        style: TextStyles.normalBold14(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  'Every friend counts: Get 1000 coins when you invite 10 friends.',
              style: TextStyles.smallSemibold12(context, opacity: .65),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        // Referral card
        ReferralCard(share: false),
      ],
    );
  }

  // small helper that builds each curated tile
  Widget curatedTile(String label, Widget icon) {
    return Column(
      children: [
        Container(
          width: 74,
          height: 78,
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 74,
              height: 78,
              decoration: BoxDecoration(
                color: kLightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(height: 10),
                  Text(
                    label,
                    textAlign: TextAlign.center,

                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191919),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReferralCard extends StatelessWidget {
  const ReferralCard({super.key, this.share = true});

  final bool share;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        UserProfile userProfile = state.profile;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.white50,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 16.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: referralMessage(userProfile.referralCode),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Referral link copied to clipboard!'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      spacing: 8.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Your Referral Link',
                            style: TextStyles.normalSemibold14(context),
                          ),
                        ),
                        SvgPicture.asset(
                          AssetsSvgIcons.copy,
                          height: 12.r,
                          width: 12.r,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Referral link pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 12.h,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(28.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary15,
                                  blurRadius: 12.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              spacing: 8.w,
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.link, size: 18.sp, color: kPurple),
                                Flexible(
                                  child: RichText(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'https://app.joinbravoo.com?ref=',
                                        ),
                                        TextSpan(
                                          text: userProfile.referralCode,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                      style: TextStyles.normalSemibold14(
                                        context,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(width: 1.5.r, color: AppColors.black05),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey200.withValues(alpha: .1),
                      blurRadius: 4.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  children: [
                    if (share)
                      IconTextButton(
                        onPressed: () => SharePlus.instance.share(
                          ShareParams(
                            text: referralMessage(
                              userProfile.referralCode ?? "",
                            ),
                          ),
                        ),
                        text: "Share Referral Code",
                        color: AppColors.black,
                        textColor: AppColors.white,
                        icon: AssetsSvgIcons.share,
                      )
                    else
                      IconTextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => InviteAndEarnPage(),
                          ),
                        ),
                        text: "Invite Friends",
                        color: AppColors.black,
                        textColor: AppColors.white,
                        icon: AssetsSvgIcons.invite,
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Divider(height: 1.h, color: AppColors.black10),
                    ),
                    // Progress row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // coin circle
                        Image.asset("assets/images/one_50.png", height: 50),
                        const SizedBox(width: 12),
                        // center column with next unlock and progress
                        Expanded(
                          child: Column(
                            spacing: 2.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'First 10 referrals :',
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${(((userProfile.referralCount ?? 0) > 10 ? 10 : userProfile.referralCount) ?? 0) * 100}",
                                          style: TextStyles.bodySemiBold16(
                                            context,
                                          ),
                                        ),
                                        TextSpan(text: "/1000"),
                                      ],
                                      style: TextStyles.smallMedium12(
                                        context,
                                      ).copyWith(color: AppColors.grey550),
                                    ),
                                  ),
                                ],
                              ),
                              GradientProgress(
                                height: 8.h,
                                progress: (userProfile.referralCount ?? 0) / 10,
                              ),
                            ],
                          ),
                        ),
                        // right fraction
                      ],
                    ),
                    SizedBox(height: 20),
                    // you referred row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 4.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'You referred',
                                  style: TextStyles.smallSemibold12(context),
                                ),
                              ),
                              Icon(
                                Icons.info_outline_rounded,
                                color: AppColors.grey400,
                                size: 16.sp,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => InviteAndEarnPage(),
                            ),
                          ),
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            spacing: 4.w,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AssetsSvgIcons.userFilled,
                                width: 16.r,
                                height: 16.r,
                                fit: BoxFit.contain,
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "${userProfile.referralCount}",
                                  style: TextStyles.bodySemiBold16(context),
                                ),
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
        );
      },
    );
  }
}

// the color is clean  will use later
// Container(
// width: 72,
// height: 72,
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(12),
// boxShadow: [
// BoxShadow(
// color: Colors.black.withValues( alpha:0.04),
// blurRadius: 10,
// offset: const Offset(0, 6),
// )
// ],
// ),
// child: Center(
// child: Container(
// width: 44,
// height: 44,
// decoration: BoxDecoration(
// color: Color(0xFFF1F1F6),
// borderRadius: BorderRadius.circular(10),
// ),
// child: Center(child: Icon(icon, color: kPurple, size: 22)),
// ),
// ),
// ),
