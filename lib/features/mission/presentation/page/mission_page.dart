import 'package:flowva/features/common/flowva_app_bar.dart';
import 'package:flowva/features/dashboard/earn/bloc/community_mission_bloc.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/earn_overview_screen.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/mission_hub.dart';
import 'package:flowva/features/mission/presentation/page/skill_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MissionPage extends StatefulWidget {
  MissionPage({super.key, this.index});
  final int? index;

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  var tab = ["Overview", "Adventures", "Skill Up" /*"Fun time"*/];
  final _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null) {
        selectedIndex = widget.index!;
        _pageController.jumpToPage(widget.index!);
      }
      BlocProvider.of<CommunityMissionBloc>(
        context,
      ).add(LoadCommunityMission());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),

          // 🔥 Gradient + soft blobs background
          // Container(child: Image.asset("assets/images/stacks.png")),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                FlowvaAppBar(title: "Missions"),
                const SizedBox(height: 12),
                // Tabs
                Container(
                  height: 45,
                  width: double.infinity,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    itemCount: tab.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final isSelected2 = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedIndex = index);
                          _pageController.jumpToPage(index);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected2 ? Colors.white : null,
                            borderRadius: BorderRadius.circular(120),
                            border: isSelected2
                                ? Border.all(
                                    width: 0.2,
                                    color: Colors.black.withOpacity(0.6),
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              tab[index],
                              style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected2
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    children: [
                      EarnOverviewScreen(),
                      AdventureScreen(),
                      SkillUpPage(),
                      // TriviaPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
