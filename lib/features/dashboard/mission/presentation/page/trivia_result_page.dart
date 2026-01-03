import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../data/bloc/mission_cubit.dart';
import '../../data/model/trivia_response.dart';

class TriviaResultScreen extends StatefulWidget {
  final int? yourScore;

  TriviaResultScreen({this.yourScore = 0, Key? key}) : super(key: key);

  @override
  State<TriviaResultScreen> createState() => _TriviaResultScreenState();
}

class _TriviaResultScreenState extends State<TriviaResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late MissionCubit missionCubit;
  bool init = true;
  List<Trivia> trivia = [];

  @override
  void initState() {
    super.initState();
    missionCubit = MissionCubit();
    missionCubit.fetchTrivia();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocListener<MissionCubit, MissionState>(
          bloc: missionCubit,
          listener: (context, state) {
            if (state is TriviaLoaded) {
              setState(() {
                init = false;
              });
              setState(() {
                trivia = state.triviaResponse.trivia!;
              });
              // print(userProfile.toJson());
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/trivia_bg.png",
                  fit: BoxFit.fill,
                ),
              ),

              init
                  ? Center(
                      child: Container(
                        height: 400,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(
                          backgroundColor: Color(0xff828282),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF9013FE),
                          ),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          SizedBox(height: 80),
                          _buildHeader(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/one_50.png",
                                height: 22,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'You won ${widget.yourScore} coins in this round',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Image.asset("assets/images/trivia_result.png"),
                          SizedBox(height: 20),

                          Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Column(
                                  children: [
                                    _buildShareButton(),
                                    SizedBox(height: 20),
                                    Expanded(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        itemCount: trivia.length,
                                        itemBuilder: (context, index) {
                                          return _buildLeaderboardItem(
                                            trivia[index],
                                            index,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const Text(
            'Trivia Result',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(120),
              border: Border.all(
                width: 0.2,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedCancel01,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/user.png"),
            SizedBox(width: 12),
            Text(
              'Share your results with friends',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(Trivia entry, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: entry.userId == SessionManager().userIdVal
            ? const Color(0xFF9D7BB5)
            : const Color(0xFF8B7A9E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildRankBadge(entry.userRank!, entry.hasMedal!),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 25),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.name.toString(),
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset("assets/images/one_50.png", height: 22),
                const SizedBox(width: 6),
                Text(
                  entry.totalPoints.toString(),
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank, bool hasMedal) {
    if (hasMedal) {
      Color medalColor;
      IconData icon;
      switch (rank) {
        case 1:
          medalColor = const Color(0xFFFFD700);
          icon = Icons.emoji_events;
          break;
        case 2:
          medalColor = const Color(0xFFC0C0C0);
          icon = Icons.emoji_events;
          break;
        case 3:
          medalColor = const Color(0xFFCD7F32);
          icon = Icons.emoji_events;
          break;
        default:
          medalColor = Colors.grey;
          icon = Icons.emoji_events;
      }
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: medalColor.withOpacity(0.4), blurRadius: 8),
          ],
        ),
        child: Icon(icon, color: medalColor, size: 28),
      );
    }
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      child: Text(
        rank.toString(),
        style: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final int score;
  final bool hasMedal;

  LeaderboardEntry(this.rank, this.name, this.score, this.hasMedal);
}
