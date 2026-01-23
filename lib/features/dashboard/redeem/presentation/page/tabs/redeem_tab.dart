import 'package:Bravoo/app/styles/text_styles.dart';
import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/app/view/widgets/dialog/success_dialog.dart';
import 'package:Bravoo/core/constants/app_assets.dart';
import 'package:Bravoo/core/constants/app_colors.dart';
import 'package:Bravoo/core/constants/fonts.dart';
import 'package:Bravoo/core/utils/helpers.dart';
import 'package:Bravoo/features/dashboard/earn/presentation/pages/invite_earn.dart';
import 'package:Bravoo/features/dashboard/earn/presentation/pages/jackpot_page.dart';
import 'package:Bravoo/features/dashboard/earn/presentation/widgets/referr_campaign.dart';
import 'package:Bravoo/features/dashboard/redeem/presentation/bloc/redeem_bloc.dart';
import 'package:Bravoo/features/dashboard/redeem/presentation/widget/redeem_gift_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../../utility/ui_tool_mix.dart';
import '../../../../../onbaording/data/model/user_profile.dart';
import '../../../../profile/presentation/bloc/profile_bloc.dart';
import '../../widget/redeem_learn_more_modal.dart';

class RedeemTab extends StatefulWidget {
  RedeemTab({super.key});
  @override
  State<RedeemTab> createState() => _RedeemTabState();
}

class _RedeemTabState extends State<RedeemTab>
    with SingleTickerProviderStateMixin, UIToolMixin {
  final _pageController = PageController(initialPage: 0);

  double _pageHeight = 350;
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          ReferCampaign(transparent: true),

          SizedBox(height: 20.h),
          // 💡 Info Box
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.white50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                spacing: 8.w,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppColors.black, size: 18.sp),
                  Expanded(
                    child: Column(
                      spacing: 8.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Keep engaging to unlock more rewards',
                            style: TextStyles.normalBold14(context),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          child: RichText(
                            text: TextSpan(
                              text: 'Refer more users to get more spin',
                              style: TextStyles.smallSemibold12(context)
                                  .copyWith(
                                    color: AppColors.primary,
                                    decoration: TextDecoration.underline,
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

          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTabTitle(context, index: 0, text: 'JACKPOT & GIVEAWAYS'),
              _buildTabTitle(context, index: 1, text: 'GIFTS & VIRTUAL CARDS'),
            ],
          ),
          SizedBox(height: 10.h),
          // 💰 Jackpot Cards
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _pageHeight.h,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                print(index);
                setState(() {
                  _currentPage = index;
                  // 👇 set different heights for different pages
                  _pageHeight = index == 0
                      ? 350
                      : (MediaQuery.of(context).size.height * 0.7);
                });
              },
              children: [JackpotCard(), RewardCard()],
            ),
          ),
          SizedBox(height: 10.h + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Expanded _buildTabTitle(
    BuildContext context, {
    required String text,
    required int index,
  }) {
    return Expanded(
      child: Column(
        spacing: 4.h,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _pageController.jumpToPage(index);
              print(_pageHeight);
            },
            child: RichText(
              text: TextSpan(
                text: text,
                style: TextStyles.smallRegular12(context).copyWith(
                  color: _currentPage != index ? AppColors.grey600 : null,
                  fontWeight: _currentPage == index ? FontWeight.bold : null,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            height: 2.h,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _currentPage == index ? 165.w : 20.w,
            color: _currentPage == index
                ? AppColors.primary
                : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class RewardCard extends StatefulWidget {
  const RewardCard({super.key});

  @override
  State<RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends State<RewardCard> with UIToolMixin {
  _loadingState(BuildContext context, RedeemLoadingState state) {
    if (state.type == RedeemType.redeemAirtimeData ||
        state.type == RedeemType.redeemGiftcard) {
      outerLoadingDialog(text: "Redeeming");
    }
  }

  _successState(BuildContext context, RedeemSuccessState state) async {
    if (state.type == RedeemType.redeemAirtimeData) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (Get.isBottomSheetOpen ?? false)
        Navigator.of(context, rootNavigator: true).pop();
      context.read<ProfileBloc>().add(GetProfileEvent());
      context.read<RedeemBloc>().add(LoadRedeemHistory());
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
      );
      successDialog(
        title: "Reward unlocked! 🎉",
        subTitle:
            "Your Bravoo coins just turned into something real. Nicely done!",
        mainBtnText: "Close",
        mainBtnPressed: () => Navigator.of(context, rootNavigator: true).pop(),
      );
    } else if (state.type == RedeemType.redeemGiftcard) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      if (Get.isBottomSheetOpen ?? false)
        Navigator.of(context, rootNavigator: true).pop();

      context.read<ProfileBloc>().add(GetProfileEvent());

      final uri = Uri.tryParse(state.message);

      if (uri == null) {
        showMessage(
          "Invalid gift card URL",
          context,
          color: Colors.white,
          styleColor: Colors.black,
          iconColor: Colors.red,
          status: true,
        );
      } else
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  _failureState(BuildContext context, RedeemFailureState state) {
    if (state.type == RedeemType.redeemAirtimeData ||
        state.type == RedeemType.redeemGiftcard) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<ProfileBloc>().add(GetProfileEvent());
      showMessage(
        state.message,
        context,
        color: Colors.white,
        styleColor: Colors.black,
        iconColor: Colors.red,
        status: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RedeemBloc, RedeemState>(
      listener: (context, state) {
        if (state is RedeemLoadingState) {
          _loadingState(context, state);
        }
        if (state is RedeemSuccessState) {
          _successState(context, state);
        }
        if (state is RedeemFailureState) {
          _failureState(context, state);
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          UserProfile profile = state.profile;
          return GridView.custom(
            childrenDelegate: SliverChildListDelegate([
              /* buildRewardCard(
                            title: "Paypal",
                            imagePath: "assets/images/slant_visa.png",
                            coins: "20,000 Coins",
                            isActive: true,
                          ),*/
              buildRewardCard(
                title: "Airtime",
                value: 5,
                imagePath: AssetsPngImages.cash,
                coins: 5000,
                isActive: (profile.totalPoints) >= 5000,
              ),
              buildRewardCard(
                title: "Data",
                value: 5,
                imagePath: AssetsPngImages.data,
                coins: 5000,
                isActive: (profile.totalPoints) >= 5000,
                isHot: true,
              ),
              buildRewardCard(
                title: "Giftcard",
                value: 10,
                imagePath: AssetsPngImages.giftcard,
                coins: 10000,
                isActive: (profile.totalPoints) >= 10000,
                isHot: true,
              ),
            ]),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              mainAxisExtent: 255.h,
            ),
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          );
        },
      ),
    );
  }

  Widget buildRewardCard({
    required String title,
    required String imagePath,
    required int coins,
    required int value,
    required bool isActive,
    bool isHot = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.white85,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1.5.r, color: AppColors.white50),
        boxShadow: [
          BoxShadow(
            color: Color(0xff9E9A9A).withValues(alpha: .1),
            blurRadius: 5,
            offset: const Offset(1, 2),
          ),
          BoxShadow(
            color: Color(0xff9E9A9A).withValues(alpha: .09),
            blurRadius: 10,
            offset: const Offset(3, 9),
          ),
          BoxShadow(
            color: Color(0xff9E9A9A).withValues(alpha: .05),
            blurRadius: 13,
            offset: const Offset(8, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: Column(
              spacing: 12.h,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 🔥 Hot badge + Image
                Image.asset(
                  imagePath,
                  height: 56.h,
                  width: 56.w,
                  fit: BoxFit.contain,
                ),
                RichText(
                  text: TextSpan(
                    text: "\$${value} $title",
                    style: TextStyles.bodyBold16(
                      context,
                    ).copyWith(fontFamily: AppFonts.baloo2, height: 1.sp),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary05,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Row(
                    spacing: 2.w,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/images/one_50.png",
                        height: 12.h,
                        width: 12.w,
                      ),
                      RichText(
                        text: TextSpan(
                          text: '${formatAmount(coins, compact: true)} Coins',
                          style: TextStyles.cardBold10(
                            context,
                          ).copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                IconTextButton(
                  onPressed: () {
                    if (isActive)
                      redeemGiftModal(
                        showPhone: ["Airtime", "Data"].contains(title),
                        onPressed: (val) {
                          final profile = context
                              .read<ProfileBloc>()
                              .state
                              .profile;
                          if (["Airtime", "Data"].contains(title)) {
                            if (val != null) {
                              context.read<RedeemBloc>().add(
                                RedeemAirtimeData(
                                  rewardType: title.toLowerCase(),
                                  phone: val,
                                  userName: profile.name,
                                  email: profile.email,
                                  coins: coins,
                                ),
                              );
                            }
                          } else {
                            context.read<RedeemBloc>().add(
                              RedeemGiftcard(
                                rewardType: title.toLowerCase(),
                                phone: "",
                                userName: profile.name,
                                email: profile.email,
                                coins: coins,
                              ),
                            );
                          }
                        },
                      );
                    else
                      showMessage(
                        "You don't have Sufficient Coins",
                        context,
                        color: Colors.white,
                        styleColor: Colors.black,
                        iconColor: Colors.red,
                        status: true,
                      );
                  },
                  height: 34,
                  color: isActive ? AppColors.black : AppColors.grey400,
                  textSize: 10,
                  borderColor: Colors.transparent,
                  textColor: isActive ? AppColors.white : AppColors.white60,
                  text: "Claim now",
                ),
                Divider(color: AppColors.black05, height: 1.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      redeemLearnMoreModal(image: imagePath);
                    },
                    child: Row(
                      spacing: 6.w,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_rounded,
                          size: 16.sp,
                          color: AppColors.grey500,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Learn more",
                            style: TextStyles.smallSemibold12(
                              context,
                            ).copyWith(color: AppColors.grey500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isHot)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.orange11,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  spacing: 2.w,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AssetsPngImages.flame,
                      width: 16.w,
                      height: 16.h,
                      fit: BoxFit.contain,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Hot",
                        style: TextStyles.cardBold10(
                          context,
                        ).copyWith(color: AppColors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class JackpotCard extends StatelessWidget {
  const JackpotCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        UserProfile profile = state.profile;
        return _rewardCard(
          context,
          icon: Icons.savings,
          title: 'Bravoo Jackpot 🏆',
          subtitle: SizedBox(
            width: 255.w,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(text: 'Your chance to win'),
                  TextSpan(
                    text: ' 20,000 coins ',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  TextSpan(
                    text:
                        'is here. Invite your friends and let the adventure begin!',
                  ),
                ],
                style: TextStyles.smallBold12(context),
              ),
            ),
          ),
          cost: '100 Coins',
          tag: 'Hot',
          tagColor: AppColors.redBrown,
          buttonText: 'Enter Jackpot',
          active: (profile.spins) > 0,
        );
      },
    );
  }

  Widget _rewardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget subtitle,
    required String cost,
    required String buttonText,
    required bool active,
    String? tag,
    Color? tagColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white40,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black05,
            blurRadius: 4.r,
            spreadRadius: -3,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          Row(
            children: [
              if (tag != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tagColor?.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Color(0xFFFE5613),
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        tag,
                        style: TextStyle(
                          color: tagColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          Image.asset("assets/images/flying_coins.png"),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
              text: title,
              style: TextStyles.titleSemiBold20(context),
            ),
          ),
          SizedBox(height: 4.h),
          subtitle,
          SizedBox(height: 12.h),
          IconTextButton(
            onPressed: () {
              if (active) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => JackpotScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => InviteAndEarnPage()),
                );
              }
            },
            height: 54,
            color: active ? AppColors.primary : AppColors.black,
            textColor: AppColors.white,
            text: active ? "Play the Jackpot" : "Invite your friends",
          ),
          SizedBox(height: 12.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Invite 10+ friends every month to unluck the jackpot",
              style: TextStyles.smallSemibold12(context, opacity: .7),
            ),
          ),
        ],
      ),
    );
  }
}
