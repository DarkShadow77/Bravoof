import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utility/in_app_review.dart';
import '../../../../../utility/ui_tool_mix.dart';
import '../../../../mission/data/bloc/mission_cubit.dart';
import '../../../../mission/presentation/page/tabs/adventures_tab.dart';
import '../../../earn/data/models/mission_res.dart';
import '../../../earn/presentation/pages/invite_earn.dart' hide MissionTile;

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

    missionCubit.fetchMission();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
              missionCubit.updateReward({
                "id": widget.mission.id,
                "name": widget.mission.subject,
                "reward_title": widget.mission.title,
                "points": widget.mission.points,
              });

              setState(() {
                widget.mission.completed = true;
                widget.mission.progress = 100;
              });
            } else if (widget.mission.subject!.toLowerCase() == "rate us") {
              final success = await requestAppRating();

              if (success) {
                // Update mission as completed in Supabase
                missionCubit.updateReward({
                  "id": widget.mission.id,
                  "name": widget.mission.subject,
                  "reward_title": widget.mission.title,
                  "points": "0",
                  "number_of_spins": 1,
                });
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
