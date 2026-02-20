import 'dart:async';
import 'dart:math';

import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:bravoo/core/constants/fonts.dart';
import 'package:bravoo/core/utils/helpers.dart';
import 'package:bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:bravoo/features/dashboard/earn/presentation/bloc/jackpot_bloc.dart';
import 'package:bravoo/features/dashboard/earn/presentation/widgets/jackpot_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class GridItem {
  final String type;
  final int value;
  final String emoji;

  GridItem({required this.type, required this.value, required this.emoji});
}

class JackpotScreen extends StatefulWidget {
  const JackpotScreen({super.key});

  @override
  State<JackpotScreen> createState() => _JackpotScreenState();
}

class _JackpotScreenState extends State<JackpotScreen> with UIToolMixin {
  int selectedIndex = 7;
  int currentPosition = 0;
  bool isSpinning = false;
  int spinsLeft = 0;
  GridItem? winner;
  bool showResult = false;
  Timer? spinTimer;
  final Random random = Random();

  int? winningIndex;
  bool apiResolved = false;
  DateTime? spinStartTime;

  // Define grid items
  final List<GridItem> gridItems = [
    // Section 1 - Row 1 (4 items)
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.gift),
    GridItem(type: 'coins', value: 100, emoji: AssetsPngImages.one50),
    GridItem(type: 'coins', value: 500, emoji: AssetsPngImages.one50),

    // Section 2 - Rows 2-3 (8 items)
    GridItem(type: 'coins', value: 100, emoji: AssetsPngImages.one50),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.gift),
    GridItem(type: 'coins', value: 20, emoji: AssetsPngImages.one50),
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),

    GridItem(type: 'coins', value: 1000, emoji: AssetsPngImages.one50),
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),
    GridItem(type: 'gift', value: 2, emoji: AssetsPngImages.gift),
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),

    // Section 3 - Rows 4-6 (12 items)
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),
    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.gift),
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),
    GridItem(type: 'coins', value: 2000, emoji: AssetsPngImages.one50),

    GridItem(type: 'coins', value: 200, emoji: AssetsPngImages.one50),
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),
    GridItem(type: 'gift', value: 2, emoji: AssetsPngImages.gift),
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),

    GridItem(type: 'gift', value: 1, emoji: AssetsPngImages.gift),
    GridItem(type: 'coins', value: 50, emoji: AssetsPngImages.one50),
    GridItem(type: 'coins', value: 20, emoji: AssetsPngImages.one50),
    GridItem(type: 'coins', value: 500, emoji: AssetsPngImages.one50),
  ];

  @override
  void dispose() {
    spinTimer?.cancel();
    super.dispose();
  }

  Future<void> startSpinWithServer() async {
    if (spinsLeft <= 0 || isSpinning) {
      if (spinsLeft <= 0) {
        showMessage(
          "Insufficient Spin Tokens",
          context,
          color: Colors.red,
          styleColor: Colors.white,
          status: true,
        );
      }
      return;
    }
    ;

    context.read<JackpotBloc>().add(SpinJackpotEvent());
  }

  _loadingState(BuildContext context, JackpotLoadingState state) {
    setState(() {
      isSpinning = true;
      showResult = false;
      winner = null;
      winningIndex = null;
      apiResolved = false;
      spinStartTime = DateTime.now();
    });

    // 🔁 Start free spinning immediately
    _startFreeSpin();
  }

  _spinedState(BuildContext context, JackpotSpinedState state) {
    context.read<ProfileBloc>().add(GetProfileEvent());
    final rewardType = state.result['rewardType'];
    final rewardValue = state.result['rewardValue'];

    final matchingIndices = <int>[];

    for (int i = 0; i < gridItems.length; i++) {
      final item = gridItems[i];
      if (item.type == rewardType && item.value == rewardValue) {
        matchingIndices.add(i);
      }
    }

    if (matchingIndices.isNotEmpty) {
      winningIndex = matchingIndices[Random().nextInt(matchingIndices.length)];
    } else {
      // Fallback safety net
      winningIndex = Random().nextInt(gridItems.length);
    }

    apiResolved = true;
    _startTargetedSlowdown();
  }

  _failureState(BuildContext context, JackpotErrorState state) {
    context.read<ProfileBloc>().add(GetProfileEvent());
    stopSpinning(force: true);

    showMessage(
      state.message,
      context,
      color: Colors.red,
      styleColor: Colors.white,
      status: true,
    );
  }

  void _startFreeSpin() {
    spinTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (apiResolved) {
        timer.cancel();
        return;
      }

      setState(() {
        currentPosition = (currentPosition + 1) % gridItems.length;
      });
    });
  }

  void _startTargetedSlowdown() {
    if (winningIndex == null) return;

    const int extraLoops = 2; // Makes it feel satisfying
    final totalSteps =
        (extraLoops * gridItems.length) +
        ((winningIndex! - currentPosition + gridItems.length) %
            gridItems.length);

    int step = 0;

    void move() {
      if (step >= totalSteps) {
        stopSpinning();
        return;
      }

      double progress = step / totalSteps;
      int delay = (80 + (progress * progress * 600)).toInt(); // smooth ease-out

      spinTimer = Timer(Duration(milliseconds: delay), () {
        if (!mounted) return;

        setState(() {
          currentPosition = (currentPosition + 1) % gridItems.length;
          step++;
        });

        move();
      });
    }

    move();
  }

  void stopSpinning({bool force = false}) {
    spinTimer?.cancel();

    if (!force && winningIndex != null) {
      setState(() {
        currentPosition = winningIndex!;
        winner = gridItems[winningIndex!];
      });
    }

    setState(() {
      isSpinning = false;
      showResult = true;
      spinsLeft--;
    });

    if (force) {
    } else {
      jackpotSuccessDialog(
        rewardType: winner!.type,
        rewardValue: winner!.value,
      );
      showMessage(
        "${winner!.value} ${winner!.type == "gift" ? "Jackpot" : "Coins"} added to your winnings",
        context,
        color: Colors.red,
        styleColor: Colors.white,
      );

      /* showDialog(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.3),
        builder: (_) =>
            WinsPop(*/ /*rewardType: winner!.type, rewardValue: winner!.value*/ /*),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JackpotBloc, JackpotState>(
      listener: (context, state) {
        if (state is JackpotLoadingState) {
          _loadingState(context, state);
        } else if (state is JackpotSpinedState) {
          _spinedState(context, state);
        } else if (state is JackpotErrorState) {
          _failureState(context, state);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.purple,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 12.w,
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Row(
              spacing: 8.w,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  size: 16.sp,
                  color: AppColors.white,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "Spin a Jackpot",
                      style: TextStyles.titleSemiBold20(
                        context,
                      ).copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Image.asset(
                AssetsPngImages.homeBg,
                fit: BoxFit.cover,
                height: 440.h + MediaQuery.of(context).padding.top,
                width: double.infinity,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: kToolbarHeight + MediaQuery.of(context).padding.top,
                  ),
                  ClipPath(
                    clipper: _TopInwardClipper(),
                    child: Container(
                      width: double.infinity,
                      height: 36.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [AppColors.purple700, Color(0xFF4C277D)],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: AppColors.purple700,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 15.w,
                    ),
                    child: Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 22.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.purple600,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          width: 4.w,
                          color: AppColors.white50,
                        ),
                      ),
                      child: Column(
                        spacing: 6.h,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "BRAVOO'S",
                              style: TextStyles.smallRegular12(context)
                                  .copyWith(
                                    fontFamily: AppFonts.baloo,
                                    height: 1.sp,
                                    color: AppColors.white,
                                  ),
                            ),
                          ),
                          Image.asset(
                            AssetsPngImages.fullJackpot,
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                            height: 70.h,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 2,
                    child: ClipPath(
                      clipper: _TopInwardClipper(),
                      child: Container(
                        width: double.infinity,
                        height: 23.h,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [AppColors.purple900, AppColors.purple900],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 391.h,
                    width: double.infinity,
                    color: AppColors.purple800,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.purple700,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          width: 2.w,
                          color: AppColors.purple600,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildGridSection(0, 4),
                          // Section 2: 2 rows (8 items)
                          buildGridSection(4, 12),
                          // Section 3: 3 rows (12 items)
                          buildGridSection(12, 24),
                        ],
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: _TopInwardClipper(),
                    child: Container(
                      width: double.infinity,
                      height: 37.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xff3A0874), Color(0xff371222)],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: AppColors.purple800,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: BlocBuilder<ProfileBloc, ProfileState>(
                              builder: (context, state) {
                                final profile = state.profile;
                                spinsLeft = profile.spins;
                                return IconTextButton(
                                  height: 65,
                                  color: AppColors.purple600,
                                  borderColor: AppColors.white32,
                                  iconWidget: HugeIcon(
                                    icon: HugeIcons.strokeRoundedRepeat,
                                    color: isSpinning
                                        ? AppColors.grey
                                        : AppColors.white,
                                  ),
                                  text: isSpinning
                                      ? 'SPINNING...'
                                      : 'SPIN ($spinsLeft LEFT)',
                                  fontFamily: AppFonts.baloo,
                                  textColor: isSpinning
                                      ? AppColors.grey
                                      : AppColors.white,
                                  onPressed: () => startSpinWithServer(),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridSection(int startIdx, int endIdx) {
    final items = gridItems.sublist(startIdx, endIdx);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 9.h,
        crossAxisSpacing: 8.w,
        mainAxisExtent: 34.h,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final actualIndex = startIdx + index;
        final item = items[index];
        final isSelected = currentPosition == actualIndex;
        final selectedTransform = Matrix4.identity()..scale(1.05);
        final normalTransform = Matrix4.identity();
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 1.5.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (isSelected)
                  ? [AppColors.orange300, AppColors.orange300]
                  : [
                      AppColors.white.withValues(alpha: 0),
                      AppColors.white75,
                      AppColors.white.withValues(alpha: 0),
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          transform: isSelected ? selectedTransform : normalTransform,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7038F3),
                  Color(0xFF7F52E8),
                  Color(0xFF7038F3),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              spacing: 2.w,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  item.emoji,
                  height: 20.h,
                  width: 20.w,
                  fit: BoxFit.contain,
                ),
                RichText(
                  text: TextSpan(
                    text: item.type == 'coins'
                        ? '${formatAmount(item.value, uniComp: true)}'
                        : 'x${formatAmount(item.value, uniComp: true)}',
                    style: TextStyles.normalBold14(context).copyWith(
                      fontFamily: AppFonts.baloo2,
                      color: Colors.white,
                    ),
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

// 🟣 Custom Clipper for the sharp top trapezoid
class _TopInwardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const double inwardOffset = 30; // how much to pull top corners inward

    // Start from bottom left
    path.moveTo(0, size.height);

    // bottom edge
    path.lineTo(size.width, size.height);

    // top right inward
    path.lineTo(size.width - inwardOffset, 0);

    // top left inward
    path.lineTo(inwardOffset, 0);

    // close back to bottom left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
