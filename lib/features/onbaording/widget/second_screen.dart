import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Create staggered slide animations for each card
    _slideAnimations = List.generate(3, (index) {
      final start = index * 0.2;
      final end = start + 0.6;
      return Tween<Offset>(
        begin: const Offset(0, -3.6), // start further above the screen
        end: Offset.zero, // normal position
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut), // smooth fall animation
        ),
      );
    });

    _controller.forward(); // start animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildCard({
    required Widget child,
    required int index,
    required Matrix4 transform,
  }) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: Transform(transform: transform, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 150),
          Image.asset("assets/images/second_slide.png",),
          // Card 1
          // buildCard(
          //   index: 0,
          //   transform: Matrix4.skewY(-0.03),
          //   child: buildContainer(
          //     title: "Designers Toolkit",
          //     subtitle: "1,200 creatives trust this stack",
          //     icons: [
          //       'assets/images/figma.png',
          //       'assets/images/framer.png',
          //       'assets/images/canvas.png',
          //     ],
          //   ),
          // ),
          //
          // // Card 2
          // buildCard(
          //   index: 1,
          //   transform: Matrix4.skewY(0.01),
          //   child: buildContainer(
          //     title: "Indie Hacker’s Essentials",
          //     subtitle:
          //     "Curated by Sam Ortega building profitable products solo",
          //     icons: [
          //       'assets/images/youtube.png',
          //       'assets/images/notion.png',
          //       'assets/images/serve.png',
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 20),
          // // Card 3
          // buildCard(
          //   index: 2,
          //   transform: Matrix4.skew(-0.0004, -0.05),
          //   child: buildContainer(
          //     title: "Remote Team Starter Pack",
          //     subtitle:
          //     "Curated by Kendra Holt helping distributed teams thrive",
          //     icons: [
          //       'assets/images/slack.png',
          //       'assets/images/miro.png',
          //       'assets/images/loom.png',
          //     ],
          //   ),
          // ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              "Turn progress into \nrewards.",
              style: GoogleFonts.manrope(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF191919),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              "Make daily actions count for real skill-building.",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget buildContainer({
    required String title,
    required String subtitle,
    required List<String> icons,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 0.3, color: Colors.deepOrange),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: icons
                .map((icon) => Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(icon, height: 30),
            ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
