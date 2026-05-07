import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../data/model/response/squad_model.dart';
import '../bloc/squad_bloc.dart';
import '../page/squad_details_page.dart';
import 'join_squad_dialog.dart';
import 'leave_squad_dialog.dart';

class SquadsCard extends StatelessWidget {
  const SquadsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: BlocBuilder<SquadBloc, SquadState>(
        builder: (context, state) {
          List<Squad> squads = state.squads;

          bool isLoading =
              state is SquadLoadingState && state.type == SquadType.fetchSquads;

          if (squads.isEmpty && isLoading) {
            return Center(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemBuilder: (context, index) {
                  return FadeShimmer(
                    width: 161.w,
                    height: 150.h,
                    radius: 12.r,
                    baseColor: AppColors.darkPrimary05,
                    highlightColor: AppColors.grey300.withValues(alpha: .25),
                  );
                },
                separatorBuilder: (_, _) => SizedBox(width: 10.w),
              ),
            );
          } else if (squads.isEmpty) {
            return Center(
              child: RichText(
                text: TextSpan(
                  text: 'No Squad Available',
                  style: TextStyles.normalRegular14(context),
                ),
              ),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: squads.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemBuilder: (context, index) {
                Squad squad = squads[index];
                return SquadTile(squad: squad);
              },
              separatorBuilder: (_, _) => SizedBox(width: 10.w),
            );
          }
        },
      ),
    );
  }
}

class SquadTile extends StatelessWidget with UIToolMixin {
  const SquadTile({super.key, required this.squad});

  final Squad squad;

  @override
  Widget build(BuildContext context) {
    final textColor = hexToColor(squad.textColor);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SquadDetailsPage(squad: squad)),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 161.w,
        height: 150.h,
        padding: EdgeInsets.symmetric(vertical: 6.5.h, horizontal: 10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexToColor(squad.gradientColor.end),
              hexToColor(squad.gradientColor.start),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedImageSize(
              imageUrl: squad.image,
              width: 60,
              height: 55,
              fit: BoxFit.contain,
              color: Colors.transparent,
            ),
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: squad.name,
                style: TextStyles.bodySemiBold16(
                  context,
                ).copyWith(fontSize: 15.sp, color: hexToColor(squad.textColor)),
              ),
            ),
            Row(
              spacing: 2.w,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AssetsSvgIcons.userFilled,
                  width: 11.w,
                  height: 11.h,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                    textColor.withValues(alpha: .5),
                    BlendMode.srcIn,
                  ),
                ),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text:
                        "${formatAmount(squad.members.length, uniComp: true)}/${formatAmount(squad.maxUsers, uniComp: true)}",
                    style: TextStyles.cardMedium10(
                      context,
                    ).copyWith(color: textColor.withValues(alpha: .5)),
                  ),
                ),
              ],
            ),
            IconTextButton(
              height: 34,
              onPressed: () {
                if (squad.isFull) {
                  showMessage(
                    "${squad.name.capitalize} Squad is Full",
                    context,
                    status: true,
                  );
                } else if (squad.cooldownDaysRemaining > 1) {
                  showMessage(
                    "Please wait ${squad.cooldownDaysRemaining} more day(s) before joining",
                    context,
                    status: true,
                  );
                } else if (squad.canJoin) {
                  joinSquadDialog(squad: squad);
                } else if (squad.isJoined) {
                  leaveSquadDialog(squad: squad);
                }
              },
              text: squad.isFull
                  ? "Full"
                  : squad.isJoined
                  ? "Leave Squad"
                  : "Join Squad",
              textColor: AppColors.white,
              textSize: 12,
              paddingW: .25,
              paddingH: .25,
              color: squad.isJoined
                  ? AppColors.error
                  : squad.isFull
                  ? AppColors.grey550
                  : textColor,
              innerShadowOffset: Offset(-1, 0),
            ),
          ],
        ),
      ),
    );
  }
}
