import 'package:bravoo/features/dashboard/home/data/model/campaign_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../earn/presentation/pages/referral_contest_screen.dart';
import '../bloc/campaign_bloc.dart';
import '../bloc/home_cubit.dart';

class PastCampaignPage extends StatefulWidget {
  const PastCampaignPage({super.key});

  @override
  State<PastCampaignPage> createState() => _PastCampaignPageState();
}

class _PastCampaignPageState extends State<PastCampaignPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  CampaignResponseModel campaign = CampaignResponseModel.empty();
  List<CampaignResponseModel> campaigns = [];
  @override
  void initState() {
    super.initState();
    final homeBloc = context.read<HomeCubit>();
    campaigns = homeBloc.state.campaign
        .where((c) => c.campaignEndDate.isBefore(DateTime.now()))
        .toList();
    campaigns.sort((a, b) => b.campaignEndDate.compareTo(a.campaignEndDate));
    if (campaigns.isNotEmpty) {
      campaign = campaigns.first;
    }
    homeBloc.fetchCampaigns();

    tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        campaigns = state.campaign
            .where((c) => c.campaignEndDate.isBefore(DateTime.now()))
            .toList();
        campaigns.sort(
          (a, b) => b.campaignEndDate.compareTo(a.campaignEndDate),
        );
        if (campaigns.isNotEmpty) {
          campaign = campaigns.first;
        }
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/earn_bg.png",
                  fit: BoxFit.fill,
                ),
              ),
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  // App Bar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    centerTitle: false,
                    title: Row(
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
                              text: "Campaign",
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
                  // Content
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 14.h),
                        // Winners Display (Triangle/Pyramid Layout)
                        WinnersPyramidWidget(campaign: campaign),
                        SizedBox(height: 14.h),
                        // Reward Section
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 20.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff9013FE).withValues(alpha: .4),
                                Color(0xffE99EC7).withValues(alpha: .3),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TabBar(
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                padding: EdgeInsets.zero,
                                unselectedLabelStyle: TextStyles.smallRegular12(
                                  context,
                                ),
                                dividerColor: AppColors.white,
                                labelStyle: TextStyles.smallBold12(context),
                                labelColor: AppColors.primary,
                                unselectedLabelColor: AppColors.white50,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorColor: AppColors.primary,
                                controller: tabController,
                                tabs: [Tab(text: 'Reward Received')],
                              ),
                              SizedBox(height: 16.h),
                              AnimatedBuilder(
                                animation: tabController,
                                builder: (context, _) {
                                  return [
                                    RewardWidget(campaign: campaign),
                                  ][tabController.index];
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Past Winners Header
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
                                  text: "Past Winners",
                                  style: TextStyles.normalSemibold14(
                                    context,
                                  ).copyWith(color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),
                      ]),
                    ),
                  ),
                  // Past Campaign List
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final pastCampaign = campaigns[index];

                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: PastCampaignTile(
                            isLatest: false,
                            pastCampaign: pastCampaign,
                          ),
                        );
                      }, childCount: campaigns.length),
                    ),
                  ),

                  // Bottom padding
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: 20.h + MediaQuery.of(context).viewPadding.top,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class WinnersPyramidWidget extends StatelessWidget {
  WinnersPyramidWidget({super.key, required this.campaign});

  final CampaignResponseModel campaign;

  final supabase = Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    if (campaign.winners.isEmpty) return SizedBox.shrink();

    // Get current user ID from Supabase
    final currentUserId = supabase.auth.currentUser!.id;

    // Reorder winners to put current user in middle
    List<CampaignWinner> orderedWinners = _orderWinners(
      campaign.winners,
      currentUserId,
    );

    // Take max 5 winners for display
    final displayWinners = orderedWinners.take(5).toList();
    final hasMore = campaign.winners.length > 5;

    return SizedBox(
      height: 140.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Winners in pyramid layout
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _buildPyramidLayout(context, displayWinners),
          ),

          // "+X more" indicator
          if (hasMore)
            Positioned(
              right: 20.w,
              bottom: 10.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: RichText(
                  text: TextSpan(
                    text: "+${campaign.winners.length - 5} more",
                    style: TextStyles.cardSemibold10(
                      context,
                    ).copyWith(color: AppColors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<CampaignWinner> _orderWinners(
    List<CampaignWinner> winners,
    String currentUserId,
  ) {
    if (currentUserId.isEmpty) return winners;

    final currentUserIndex = winners.indexWhere(
      (w) => w.userId == currentUserId,
    );
    if (currentUserIndex == -1) return winners;

    // Move current user to middle
    final List<CampaignWinner> reordered = [...winners];
    final currentUser = reordered.removeAt(currentUserIndex);
    final middleIndex = (reordered.length / 2).floor();
    reordered.insert(middleIndex, currentUser);

    return reordered;
  }

  List<Widget> _buildPyramidLayout(
    BuildContext context,
    List<CampaignWinner> winners,
  ) {
    if (winners.isEmpty) return [];

    switch (winners.length) {
      case 1:
        return [_buildWinnerAvatar(context, winners[0], 80)];

      case 2:
        return [
          _buildWinnerAvatar(context, winners[0], 70),
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[1], 70),
        ];

      case 3:
        return [
          _buildWinnerAvatar(context, winners[0], 60),
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[1], 80), // Middle largest
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[2], 60),
        ];

      case 4:
        return [
          _buildWinnerAvatar(context, winners[0], 55),
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[1], 70), // Middle left
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[2], 70), // Middle right
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[3], 55),
        ];

      default: // 5+
        return [
          _buildWinnerAvatar(context, winners[0], 50),
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[1], 65),
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[2], 80), // Middle largest
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[3], 65),
          SizedBox(width: 8.w),
          _buildWinnerAvatar(context, winners[4], 50),
        ];
    }
  }

  Widget _buildWinnerAvatar(
    BuildContext context,
    CampaignWinner winner,
    double size,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.h,
          width: size.w,
          child: Stack(
            children: [
              CachedImageRadius(
                imageUrl: winner.profileImage,
                circle: true,
                size: size,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white50, width: 2.5.w),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: size + 10,
          child: RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            text: TextSpan(
              text: winner.name.capitalize,
              style: TextStyles.smallSemibold12(
                context,
              ).copyWith(fontSize: size == 80 ? 12.sp : 10.sp),
            ),
          ),
        ),
      ],
    );
  }
}

// UPDATED: Past Campaign Tile with Expansion
class PastCampaignTile extends StatefulWidget {
  const PastCampaignTile({
    super.key,
    required this.isLatest,
    required this.pastCampaign,
  });

  final bool isLatest;
  final CampaignResponseModel pastCampaign;

  @override
  State<PastCampaignTile> createState() => _PastCampaignTileState();
}

class _PastCampaignTileState extends State<PastCampaignTile> {
  bool isExpanded = false;

  // NEW: Get current user's profile if they're a winner
  CampaignWinner? _getCurrentUserWinner() {
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) return null;

    try {
      return widget.pastCampaign.winners.firstWhere(
        (w) => w.userId == currentUserId,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isLatest
        ? hexToColor(widget.pastCampaign.bgColor)
        : AppColors.black;

    final hasMultipleWinners = widget.pastCampaign.winners.length > 1;
    final currentUserWinner = _getCurrentUserWinner();
    final isCurrentUserWinner = currentUserWinner != null;

    // Display current user if winner, else first winner
    final displayWinner = isCurrentUserWinner
        ? currentUserWinner
        : (widget.pastCampaign.winners.isNotEmpty
              ? widget.pastCampaign.winners.first
              : null);

    final displayName = displayWinner?.name ?? widget.pastCampaign.winnerName;
    final displayImage =
        displayWinner?.profileImage ?? widget.pastCampaign.winnerProfileImage;

    return Container(
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: [
            if (widget.isLatest) ...[
              hexToColor(widget.pastCampaign.bgColor),
              hexToColor(widget.pastCampaign.bgColor).withValues(alpha: .3),
            ] else ...[
              AppColors.white80,
              AppColors.white50,
            ],
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        spacing: 10.h,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Main winner row with expansion indicator
          GestureDetector(
            onTap: hasMultipleWinners
                ? () => setState(() => isExpanded = !isExpanded)
                : null,
            behavior: HitTestBehavior.opaque,
            child: Row(
              spacing: 15.w,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    spacing: 5.w,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CachedImageRadius(
                            imageUrl: displayImage,
                            size: 50,
                            color: AppColors.white05,
                            circle: true,
                            fit: BoxFit.cover,
                          ),
                          // Winner badge for current user
                          if (isCurrentUserWinner)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(2.r),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 12.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          // Multiple winners indicator
                          if (hasMultipleWinners && !isCurrentUserWinner)
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text:
                                        "+${widget.pastCampaign.winners.length - 1}",
                                    style: TextStyles.smallCardRegular8(
                                      context,
                                    ).copyWith(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                        ],
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
                                text: hasMultipleWinners
                                    ? (isCurrentUserWinner
                                          ? "You ${widget.pastCampaign.winners.length > 1 ? '+${widget.pastCampaign.winners.length - 1}' : ''}"
                                          : "${displayName.capitalize} +${widget.pastCampaign.winners.length - 1}")
                                    : displayName.capitalize,
                                style: TextStyles.smallSemibold12(context)
                                    .copyWith(
                                      color: widget.isLatest
                                          ? hexToColor(
                                              widget.pastCampaign.textColor,
                                            )
                                          : textColor,
                                    ),
                              ),
                            ),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: widget.pastCampaign.name.capitalize,
                                style: TextStyles.cardSemibold10(context)
                                    .copyWith(
                                      color: widget.isLatest
                                          ? hexToColor(
                                              widget.pastCampaign.textColor,
                                            )
                                          : textColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (hasMultipleWinners)
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: widget.isLatest
                              ? hexToColor(widget.pastCampaign.textColor)
                              : textColor,
                        ),
                    ],
                  ),
                ),
                Container(
                  height: 50.h,
                  width: 50.w,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    gradient: LinearGradient(
                      colors: [
                        if (widget.isLatest) ...[
                          hexToColor(widget.pastCampaign.textColor),
                          hexToColor(
                            widget.pastCampaign.bgColor,
                          ).withValues(alpha: .1),
                        ] else ...[
                          AppColors.primary10,
                          AppColors.primary10,
                        ],
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0.w,
                        child: Image.asset(
                          AssetsPngImages.one50,
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        right: 5.w,
                        child: CachedImageSize(
                          imageUrl: widget.pastCampaign.url,
                          width: 45.w,
                          height: 40.h,
                          color: Colors.transparent,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        right: 22.w,
                        left: 0,
                        bottom: -5.h,
                        child: Image.asset(
                          AssetsPngImages.trophy,
                          width: 24.w,
                          height: 32.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Expanded winners list
          if (isExpanded && hasMultipleWinners)
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: widget.isLatest
                    ? hexToColor(
                        widget.pastCampaign.textColor,
                      ).withValues(alpha: .1)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                spacing: 8.h,
                children: widget.pastCampaign.winners
                    .where(
                      (w) =>
                          w.userId !=
                          (isCurrentUserWinner
                              ? currentUserWinner.userId
                              : null),
                    )
                    .map((winner) {
                      return Row(
                        spacing: 8.w,
                        children: [
                          CachedImageRadius(
                            imageUrl: winner.profileImage,
                            size: 35,
                            circle: true,
                            fit: BoxFit.cover,
                            color: AppColors.white05,
                          ),
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: winner.name.capitalize,
                                style: TextStyles.smallSemibold12(context)
                                    .copyWith(
                                      color: widget.isLatest
                                          ? hexToColor(
                                              widget.pastCampaign.textColor,
                                            )
                                          : textColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      );
                    })
                    .toList(),
              ),
            ),
          IconTextButton(
            height: 40,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<CampaignBloc>(
                    create: (_) =>
                        sl<CampaignBloc>(param1: widget.pastCampaign.id),
                    child: ReferralContestScreen(campaign: widget.pastCampaign),
                  ),
                ),
              );
            },
            color: widget.isLatest
                ? hexToColor(widget.pastCampaign.textColor)
                : textColor,
            textColor: widget.isLatest
                ? hexToColor(widget.pastCampaign.inverseTextColor)
                : AppColors.white,
            text: "See Result and Claim Reward",
          ),
        ],
      ),
    );
  }
}

class RewardWidget extends StatelessWidget {
  const RewardWidget({super.key, required this.campaign});

  final CampaignResponseModel campaign;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemCount: campaign.rewardList.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 70.w,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 8.w,
        mainAxisExtent: 80.h,
      ),
      itemBuilder: (context, index) {
        return Center(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppColors.white80,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Column(
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedImageRadius(
                  imageUrl: campaign.rewardList[index].image,
                  size: 45,
                  fit: BoxFit.contain,
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: campaign.rewardList[index].name.capitalize,
                    style: TextStyles.smallCardRegular8(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
