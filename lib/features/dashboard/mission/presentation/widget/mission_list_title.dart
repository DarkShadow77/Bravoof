import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/view/widgets/cached_image_widget.dart';
import '../../../../../app/view/widgets/loading/outer_loading.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/in_app_review.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../common/custom_success.dart';
import '../../../../common/flowva_button.dart';
import '../../../../dashboard/earn/data/models/mission_res.dart';
import '../../../../dashboard/earn/presentation/pages/invite_earn.dart'
    hide MissionTile;
import '../../../../dashboard/profile/presentation/bloc/profile_bloc.dart';
import '../../data/bloc/mission_cubit.dart';
import '../bloc/growth_mission_bloc.dart';

class MissionCard extends StatefulWidget {
  const MissionCard({super.key, this.isFull = true});

  final bool isFull;

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> with UIToolMixin {
  List<Mission> missions = [];
  List<Mission> shownMissions = [];

  @override
  void initState() {
    super.initState();
    final growthBloc = context.read<GrowthMissionBloc>();
    growthBloc.add(LoadGrowthMission());
    missions = growthBloc.state.missions;
    _sortMission();
  }

  _sortMission() {
    if (widget.isFull) {
      shownMissions = missions;
    } else {
      shownMissions = missions.isNotEmpty ? missions.take(3).toList() : [];
    }
  }

  _loadingState(BuildContext context, GrowthMissionLoadingState state) {
    if (state.type == GrowthMissionType.completeMission) {
      outerLoadingDialog(text: "Completing Mission");
    }
  }

  _successState(BuildContext context, GrowthMissionSuccessState state) {
    if (state.type == GrowthMissionType.completeMission) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      context.read<ProfileBloc>().add(GetProfileEvent());
      context.read<GrowthMissionBloc>().add(LoadGrowthMission());
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (_) => CustomSuccess(
          title: "Mission complete!",
          bodyText: "You’ve earned a reward 💜",
          b_text1: "💜️ Bravoo? Tell the world ",
          b_text2: "Explore more missions",
        ),
      );
    }
  }

  _failedState(BuildContext context, GrowthMissionFailureState state) {
    if (state.type == GrowthMissionType.completeMission) {
      if (Get.isDialogOpen == true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      showMessage(
        state.message,
        context,
        color: Colors.red,
        styleColor: Colors.white,
        status: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GrowthMissionBloc, GrowthMissionState>(
      listener: (context, state) {
        if (state is GrowthMissionLoadingState) {
          _loadingState(context, state);
        } else if (state is GrowthMissionSuccessState) {
          _successState(context, state);
        } else if (state is GrowthMissionFailureState) {
          _failedState(context, state);
        }
      },
      builder: (context, state) {
        missions = state.missions;

        _sortMission();
        return Column(
          children: shownMissions.map((mission) {
            return MissionListTitle(mission: mission);
          }).toList(),
        );
      },
    );
  }
}

class MissionListTitle extends StatefulWidget {
  const MissionListTitle({super.key, required this.mission});

  final Mission mission;

  @override
  State<MissionListTitle> createState() => _MissionListTitleState();
}

class _MissionListTitleState extends State<MissionListTitle> with UIToolMixin {
  late MissionCubit missionCubit;

  @override
  void initState() {
    super.initState();
    missionCubit = MissionCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: MissionTile(
        mission: widget.mission,
        onClaim: () async {
          if (widget.mission.completed == false) {
            if (widget.mission.subject!.toLowerCase() == "watch") {
              final Uri _url = Uri.parse(
                'https://www.youtube.com/watch?v=s7NG1PZaRCE',
              );
              if (!await launchUrl(
                _url,
                mode: LaunchMode.externalApplication,
              )) {
                throw Exception('Could not launch $_url');
              }

              // Mark mission completed for current user
              context.read<GrowthMissionBloc>().add(
                CompleteGrowthMission(mission: {"id": widget.mission.id}),
              );

              setState(() {
                widget.mission.completed = true;
                widget.mission.progress = 100;
              });
            } else if (widget.mission.subject!.toLowerCase() == "rate us") {
              final success = await requestAppRating();

              if (success) {
                // Update mission as completed in Supabase
                context.read<GrowthMissionBloc>().add(
                  CompleteGrowthMission(mission: {"id": widget.mission.id}),
                );
                setState(() {
                  widget.mission.completed = true;
                });
                showMessage(
                  "Thank you for rating our app! 🎉",
                  context,
                  color: Colors.green,
                  styleColor: Colors.white,
                );
              } else {
                showMessage(
                  "Could not open review dialog. Please rate us manually from the store.",
                  context,
                  color: Colors.orange,
                  styleColor: Colors.black,
                );
              }
            } else if (widget.mission.subject!.toLowerCase() == "invite") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InviteAndEarnPage()),
              );
            }
          }
        },
      ),
    );
  }
}

class MissionTile extends StatelessWidget {
  final Mission mission;
  final VoidCallback onClaim;

  const MissionTile({required this.mission, required this.onClaim, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 2, right: 2, bottom: 2),
      decoration: BoxDecoration(
        color: mission.completed! ? Color(0xFFF6FDF5) : Color(0xFFF6FDF5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedImageSize(
            imageUrl: mission.icon ?? "",
            width: 28.w,
            height: 28.h,
            color: AppColors.grey200,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    mission.title!,
                    style: GoogleFonts.baloo2(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: mission.id == "rate"
                          ? Colors.black.withValues(alpha: 0.24)
                          : Colors.black.withValues(alpha: 0.50),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                mission.completed!
                    ? Image.asset("assets/images/mark.png")
                    : Container(),
                // : Container(
                //     padding: EdgeInsets.symmetric(horizontal: 15),
                //     child: Stack(
                //       children: [
                //         ClipRRect(
                //           borderRadius: BorderRadius.circular(12),
                //           child: Stack(
                //             children: [
                // //               // Background color (track)
                //               Container(
                //                 height: 20,
                //                 decoration: BoxDecoration(
                //                   color: Color(0xFFF1F1F1),
                //                   gradient: LinearGradient(
                //                     begin: Alignment.topCenter,
                //                     end: Alignment.bottomCenter,
                //                     colors: [
                //                       const Color(0xFFD9AEFF),
                //                       const Color(0xFF550AA9),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //
                //               // Gradient progress bar
                //               LayoutBuilder(
                //                 builder: (context, constraints) {
                //                   return Container(
                //                     height: 16,
                //                     width:
                //                         constraints.maxWidth *
                //                         mission.progress!,
                //                     // width proportional to value
                //                     decoration: BoxDecoration(
                //                       color: Color(0xFFF1F1F1),
                //                       gradient: LinearGradient(
                //                         begin: Alignment.topCenter,
                //                         end: Alignment.bottomCenter,
                //                         colors: [
                //                           const Color(0xFFD9AEFF),
                //                           const Color(0xFF550AA9),
                //                         ],
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               ),
                //             ],
                //           ),
                //         ),
                //         Positioned(
                //           left: 50,
                //           right: 50,
                //           top: -1,
                //
                //           child: Center(
                //             child: Text(
                //               progressTextFromValue(mission.progress!),
                //               style: GoogleFonts.baloo2(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w700,
                //                 color: Colors.white.withValues(alpha:0.42),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: EdgeInsets.only(top: 8, right: 4, left: 4),
            // height: 80,
            width: 88,
            decoration: BoxDecoration(
              color: mission.completed!
                  ? Color(0xFFF1F1F1)
                  : Color(0xFF9013FE).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mission.id == null
                        ? Image.asset(mission.rightIcon!, height: 22)
                        : Image.network(mission.rightIcon!, height: 22),
                    SizedBox(width: 5),
                    Text(
                      "${mission.points}",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withValues(alpha: 0.34),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 5),
                // const SizedBox(height: 10),
                FlowvaButton.purpleButton(
                  color: mission.completed! ? Colors.grey : null,
                  name: mission.completed! ? "Completed" : "${mission.subject}",
                  apply: onClaim,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
