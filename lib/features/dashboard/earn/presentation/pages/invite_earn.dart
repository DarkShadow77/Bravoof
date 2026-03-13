import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/core/constants/app_colors.dart';
import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/earn/presentation/pages/referral_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../home/presentation/bloc/home_cubit.dart';
import '../../../profile/data/model/user_profile.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../widgets/referr_campaign.dart';

String referralMessage(String code, [bool encode = false]) {
  if (encode) {
    return Uri.encodeComponent(
      'Join me on Bravoo 🚀\n'
      'https://www.joinbravoo.com\n'
      'Use my referral code: $code\n',
    );
  } else {
    return 'Join me on Bravoo 🚀\n'
        'https://www.joinbravoo.com\n'
        'Use my referral code: $code\n';
  }
}

class InviteAndEarnPage extends StatefulWidget {
  InviteAndEarnPage({super.key});

  @override
  State<InviteAndEarnPage> createState() => _InviteAndEarnPageState();
}

class _InviteAndEarnPageState extends State<InviteAndEarnPage> {
  UserProfile userProfile = UserProfile.empty();

  List<UserProfile> referrals = [];
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = context.read<ProfileBloc>();
    profileBloc.add(GetProfileEvent());
    userProfile = profileBloc.state.profile;
    BlocProvider.of<HomeCubit>(context).getUserReferrals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              setState(() {
                referrals = state.referrals;
              });
            },
          ),
        ],
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            userProfile = state.profile;
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Invite and Earn",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF191919),
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      children: [
                        Text(
                          "Invite your friends and win big on Bravoo",
                          style: GoogleFonts.manrope(
                            color: Color(0xFF767676),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// --- Invite Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                "Invites",
                                "${userProfile.referralCount}",
                                Icon(
                                  Icons.group,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// --- Invite Button
                        FlowvaButton.blueButton(
                          name: "Share with Friends",
                          icon: Icon(
                            Icons.person_add_alt_1,
                            color: Colors.white,
                          ),
                          apply: () {
                            SharePlus.instance.share(
                              ShareParams(
                                text: referralMessage(userProfile.referralCode),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        /// --- Active Missions Section
                        Row(
                          children: [
                            _circleIcon(
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedUserGroup,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Active Referral Missions",
                              style: GoogleFonts.manrope(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        ReferCampaign(showMargin: false, expanded: true),

                        SizedBox(height: 10.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // small description under title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    _circleIcon(
                                      HugeIcon(
                                        icon: HugeIcons.strokeRoundedUserList,
                                        size: 18,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Referral History",
                                      style: GoogleFonts.manrope(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => ReferralHistoryPage(),
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF1F1F1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Text(
                                      "See more",
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF191919),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Referral list
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: referrals.length <= 5
                                  ? referrals.length
                                  : 5,
                              itemBuilder: (context, index) {
                                final user = referrals[index];
                                return _buildReferralCard(
                                  avatar: user.profilePic,
                                  name: user.name,
                                  time: user.createdAt.toIso8601String(),
                                );
                              },
                              separatorBuilder: (_, _) {
                                return SizedBox(height: 12.h);
                              },
                            ),

                            const SizedBox(height: 26),

                            // Tip / Anti Abuse box
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 22,
                                horizontal: 18,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF8FE),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFDCC6FF,
                                    ).withValues(alpha: 0.35),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "Tipping/Anti Abuse",
                                    style: GoogleFonts.baloo2(
                                      color: const Color(0xFF957DAB),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Don’t spam. Earn honest invites. Abuse may freeze your rewards.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.manrope(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// --- Stat Card
  Widget _buildStatCard(String title, String value, Widget icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFEFEFEF),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: icon,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: Color(0xFFA5A5A5),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),

              Text(
                value,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: const Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // referral list item (rounded card)
  Widget _buildReferralCard({
    required String avatar,
    required String name,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100.withValues(alpha: .6),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
      child: Row(
        spacing: 12.w,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedImageRadius(
            imageUrl: avatar,
            size: 44,
            fit: BoxFit.cover,
            circle: true,
            color: AppColors.grey300.withValues(alpha: .5),
          ),
          Expanded(
            child: Column(
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: name,
                    style: TextStyles.smallSemibold12(context),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: "Joined",
                      style: TextStyles.cardSemibold10(
                        context,
                      ).copyWith(color: AppColors.green500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              text: formatSmartDate(time),
              style: TextStyles.cardSemibold10(context, opacity: .65),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(Widget child) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Color(0xFFF1F1F1),
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }
}
