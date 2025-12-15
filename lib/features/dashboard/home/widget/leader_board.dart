import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../mission/data/bloc/mission_cubit.dart';
import '../../../mission/data/model/rewards_summary_response.dart';
import '../../earn/presentation/widgets/leaderboard_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key, required this.leaderboardList});
  final List<RewardsSummary> leaderboardList;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<RewardsSummary> rewardsSummary = [];

  late MissionCubit missionCubit;

  @override
  void initState() {
    super.initState();
    rewardsSummary = widget.leaderboardList;

    missionCubit = MissionCubit();

    missionCubit.fetchAllUsersReward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MissionCubit, MissionState>(
      bloc: missionCubit,
      listener: (context, state) {
        if (state is RewardLoaded) {
          rewardsSummary = state.rewardsSummaryResponse.rewardsSummary!;

          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LeaderboardPage(fullScreen: true, rewardsSummary: rewardsSummary),
      ),
    );
  }
}
