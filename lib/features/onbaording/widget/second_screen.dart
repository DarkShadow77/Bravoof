import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/styles/text_styles.dart';
import '../../../core/constants/app_colors.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with TickerProviderStateMixin {
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
          curve: Interval(
            start,
            end,
            curve: Curves.easeOut,
          ), // smooth fall animation
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset("assets/images/second_slide.png"),
          SizedBox(height: 70.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Turn progress into\nrewards.",
              style: TextStyles.bigTitleBold24(context).copyWith(fontSize: 28),
            ),
          ),
          SizedBox(height: 16.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Make daily actions count for real skill-building.",
              style: TextStyles.smallRegular12(
                context,
              ).copyWith(color: AppColors.grey500),
            ),
          ),
          SizedBox(height: 41.h),
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
                .map(
                  (icon) => Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Image.asset(icon, height: 30),
                  ),
                )
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
