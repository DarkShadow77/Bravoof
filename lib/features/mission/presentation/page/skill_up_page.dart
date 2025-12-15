// challenge_cards.dart
// Single-file Flutter example that recreates the provided UI and makes it interactive.

import 'package:flowva/features/mission/data/bloc/mission_cubit.dart';
import 'package:flowva/features/mission/data/model/skill_up_task_response.dart';
import 'package:flowva/features/mission/data/repository/guide.dart';
import 'package:flowva/features/mission/presentation/widget/skill_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late MissionCubit missionCubit;
  List<SkillUpTask>task=[];
  int _timeLeft = 5;
  bool init=true;

  @override
  void initState() {
    missionCubit=MissionCubit();
    missionCubit.fetchSkillUPTask();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<MissionCubit, MissionState>(
      bloc: missionCubit,
      listener: (context, state) {
        if (state is SkillUpTaskLoaded) {
          setState(() {
            init = false;
          });
          setState(() {
            task = state.skillUpTaskResponse.task!;
          });
          // print(userProfile.toJson());
        }
      },
      child:init? Center(
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
      ): Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Ready for a Challenge?',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF020617),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Alright hero... show us what you\'ve got 😎🔥',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6E6B76),
            ),
          ),
          // const SizedBox(height: 22),

          // Grid of cards
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 18,
                childAspectRatio: .72,
              ),
              itemCount: task.length,
              itemBuilder: (context, index) {
                final skills = [
                  {
                    "title": "AI Prompting",
                    "hot": true,
                    "bgColor": const Color(0xffFFF0DB),
                    "navigate": () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (ctx) => SkillUpScreen(task: guide[0]),
                      //   ),
                      // );
                    }
                  },
                  {
                    "title": "Design",
                    "hot": false,
                    "bgColor": const Color(0xffF5EBFF),
                    "navigate": () {} // No navigation assigned
                  },
                  {
                    "title": "Content Creation",
                    "hot": false,
                    "bgColor": const Color(0xffE3FAE1),
                    "navigate": () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (ctx) => SkillUpScreen(guide: guide[1]),
                      //   ),
                      // );
                    }
                  },
                  {
                    "title": "Vibe coding",
                    "hot": true,
                    "bgColor": const Color(0xffC2E0FF),
                    "navigate": () {} // No navigation assigned
                  },
                ];

                return SkillCard(
                  index: index,
                  selectedIndex: selectedCard,
                  onTap: () {
                    // print(task[index].title);
                    // return;
                    setState(() => selectedCard = index);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => SkillUpScreen(task: task[index]),
                      ),
                    );
                  },
                  title: skills[index]["title"] as String,
                  hot: skills[index]["hot"] as bool,
                  bgColor: skills[index]["bgColor"] as Color,
                );
              },
            )
            ,
          ),
        ],
      ),
    );
  }
}

class SkillCard extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;
  final String title;
  final bool hot;
  final Color bgColor;

  const SkillCard({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.title,
    this.hot = false,
    required this.bgColor,
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
          color: bgColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? Color(0xFF9013FE).withOpacity(0.4)
                : Colors.black.withOpacity(0.04),
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Stack(
          children: [
            // IMAGE BOX → pushed down with margin
            Positioned(
              top: 20, // 👈 pushes the black box down
              left: 12,
              right: 12,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.asset("assets/images/human_head.png"),
              ),
            ),

            // HOT BADGE
            if (hot)
              Positioned(
                right: 5,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFCE4D1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    "🔥 Hot",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFE5613),
                    ),
                  ),
                ),
              ),

            // TITLE → centered at bottom
            Positioned(
              bottom: 30,
              left: 0,
              right: 0, // 👈 allows Center to truly center the text
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
