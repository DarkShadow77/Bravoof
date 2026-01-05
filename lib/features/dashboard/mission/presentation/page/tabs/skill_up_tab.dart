// challenge_cards.dart
// Single-file Flutter example that recreates the provided UI and makes it interactive.

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/app/view/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../data/model/skill_up_mission_model.dart';
import '../../bloc/skill_up_bloc.dart';
import '../skillup/skill_up_screen.dart';

// IMPORTANT: The image file path from your upload is used as the `imageUrl` below.
// The platform will transform this local path to a usable URL when running the preview.
const String imageUrl = '/mnt/data/Screenshot 2025-11-20 at 10.48.13.png';

class SkillUpPage extends StatefulWidget {
  SkillUpPage({super.key});

  @override
  State<SkillUpPage> createState() => _SkillUpPageState();
}

class _SkillUpPageState extends State<SkillUpPage> {
  int selectedCard = -1;

  List<SkillUpMission> skillUpMissions = [];

  @override
  void initState() {
    super.initState();
    final featuredBloc = BlocProvider.of<SkillUpBloc>(context);
    skillUpMissions = featuredBloc.state.missions;
  }

  Color hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 28.h),
          RichText(
            text: TextSpan(
              text: 'Ready for a Challenge?',
              style: TextStyles.titleBold20(context),
            ),
          ),
          SizedBox(height: 6.h),
          RichText(
            text: TextSpan(
              text: "Alright hero… show us what you’ve got 😎🔥",
              style: TextStyles.normalRegular14(context, opacity: .75),
            ),
          ),
          // Grid of cards
          BlocBuilder<SkillUpBloc, SkillUpState>(
            builder: (context, state) {
              skillUpMissions = state.missions;
              bool loading =
                  state is SkillUpLoading &&
                  state.type == SkillUpType.fetchMission;
              return Flexible(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 7.w,
                    mainAxisSpacing: 11.h,
                    mainAxisExtent: 230.h,
                  ),
                  itemCount: loading ? 4 : skillUpMissions.length,
                  itemBuilder: (context, index) {
                    if (loading) {
                      return FadeShimmer(
                        width: double.infinity,
                        height: double.infinity,
                        radius: 16.r,
                        baseColor: AppColors.darkPrimary05,
                        highlightColor: AppColors.grey300.withValues(
                          alpha: .25,
                        ),
                      );
                    }
                    final skill = skillUpMissions[index];
                    return SkillCard(
                      index: index,
                      selectedIndex: selectedCard,
                      skill: skill,
                      onTap: () {
                        setState(() => selectedCard = index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                SkillUpScreen(skill: skill, index: index),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Color hexToColor(String hex) {
  return Color(int.parse(hex.replaceFirst('#', '0xff')));
}

class SkillCard extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final SkillUpMission skill;
  final VoidCallback onTap;

  const SkillCard({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.skill,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexToColor(skill.color.end),
              hexToColor(skill.color.start),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary40
                : AppColors.black.withValues(alpha: .04),
            width: isSelected ? 3.r : 1.5.r,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CachedImageSize(
                    imageUrl: skill.image,
                    width: double.infinity,
                    height: 140.h,
                    fit: BoxFit.cover,
                    borderRadius: 10,
                    color: AppColors.grey300.withValues(alpha: .5),
                  ),
                  SizedBox(height: 12.h),
                  Flexible(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: skill.title,
                        style: TextStyles.bodySemiBold16(
                          context,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // HOT BADGE
            if (skill.isHot)
              Positioned(
                right: 5,
                top: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFCE4D1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: "🔥 Hot",
                      style: TextStyles.smallSemibold12(
                        context,
                      ).copyWith(color: Color(0xFFFE5613)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
