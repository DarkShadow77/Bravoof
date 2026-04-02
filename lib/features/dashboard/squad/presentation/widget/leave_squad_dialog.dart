import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../app/view/widgets/button/icon_text_button.dart';
import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../data/model/response/squad_model.dart';
import '../bloc/activity_bloc.dart';
import '../bloc/squad_bloc.dart';

Future<dynamic> leaveSquadDialog({required Squad squad}) async {
  return Get.dialog(
    name: "leave_squad_dialog",
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    LeaveSquadDialog(squad: squad),
  );
}

class LeaveSquadDialog extends StatefulWidget {
  const LeaveSquadDialog({super.key, required this.squad});

  final Squad squad;

  @override
  State<LeaveSquadDialog> createState() => _LeaveSquadDialogState();
}

class _LeaveSquadDialogState extends State<LeaveSquadDialog> with UIToolMixin {
  _loadingState(BuildContext context, SquadLoadingState state) {
    if (state.type == SquadType.leaveSquad ||
        state.squadId == widget.squad.id) {
      outerLoadingDialog(text: "Leaving Squad");
    }
  }

  _successState(BuildContext context, SquadSuccessState state) {
    if (state.type == SquadType.leaveSquad ||
        state.squadId == widget.squad.id) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<SquadBloc>().add(FetchSquadsEvent());
      context.read<RecentActivityBloc>().add(FetchActivityEvent());

      Navigator.of(context, rootNavigator: true).pop();
      showMessage(
        "Successfully left ${widget.squad.name.capitalize} squad",
        context,
      );

      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  _failureState(BuildContext context, SquadErrorState state) {
    if (state.type == SquadType.leaveSquad ||
        state.squadId == widget.squad.id) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      showMessage(state.message, context, status: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocListener<SquadBloc, SquadState>(
        listener: (context, state) {
          if (state is SquadLoadingState) {
            _loadingState(context, state);
          }
          if (state is SquadSuccessState) {
            _successState(context, state);
          }
          if (state is SquadErrorState) {
            _failureState(context, state);
          }
        },
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(color: AppColors.black.withValues(alpha: 0.2)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white85,
                    borderRadius: BorderRadius.circular(32.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              hexToColor(
                                widget.squad.gradientColor.end,
                              ).withValues(alpha: .18),
                              hexToColor(
                                widget.squad.gradientColor.start,
                              ).withValues(alpha: .18),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: RichText(
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text:
                                "Leave ${widget.squad.name.capitalize} Squad?",
                            style: TextStyles.bigTitleBold24(context).copyWith(
                              height: 1.h,
                              fontFamily: AppFonts.baloo2,
                              color: hexToColor(widget.squad.gradientColor.end),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.5.h),
                      CachedImageSize(
                        imageUrl: widget.squad.image,
                        width: 120,
                        height: 90,
                        fit: BoxFit.contain,
                        color: Colors.transparent,
                      ),
                      SizedBox(height: 18.5.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(text: "Once you leave, "),
                            TextSpan(
                              text: "you can’t join again for 30 days,",
                              style: TextStyles.smallBold12(context),
                            ),
                          ],
                          style: TextStyles.smallMedium12(
                            context,
                          ).copyWith(color: AppColors.grey550),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      IconTextButton(
                        height: 48,
                        onPressed: () {
                          context.read<SquadBloc>().add(
                            LeaveSquadEvent(squadId: widget.squad.id),
                          );
                        },
                        text: "Continue to leave",
                        color: AppColors.black,
                        textColor: AppColors.white,
                      ),
                      SizedBox(height: 12.h),
                      IconTextButton(
                        height: 48,
                        onPressed: () => Navigator.pop(context),
                        text: "Cancel",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
