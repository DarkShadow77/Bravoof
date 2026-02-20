import 'package:bravoo/features/dashboard/home/presentation/bloc/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../earn/presentation/widgets/leaderboard_widget.dart';
import '../../data/model/leaderboard_response_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardModel> leaderboard = [];

  @override
  void initState() {
    super.initState();
    final homeBloc = context.read<HomeCubit>();
    leaderboard = homeBloc.state.leaderboard.leaderboard;
    homeBloc.fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LeaderboardPage(fullScreen: true),
    );
  }
}
