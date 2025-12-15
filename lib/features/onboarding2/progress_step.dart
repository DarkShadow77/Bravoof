// import 'package:flutter/material.dart';
// import 'dart:math';
//
// class StepProgressPage extends StatelessWidget {
//   const StepProgressPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final steps = [
//       {"step": "1/3", "title": "We’re curating your tools"},
//       {"step": "2/3", "title": "Organizing your library"},
//       {"step": "3/3", "title": "Turning your interests into a custom journey..."},
//     ];
//
//     final activeStep = 2; // 👈 currently active step (1-based index)
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: ListView.separated(
//           shrinkWrap: true,
//           padding: const EdgeInsets.all(16),
//           itemCount: steps.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 20),
//           itemBuilder: (context, index) {
//             final step = steps[index];
//             final isActive = (index + 1) == activeStep;
//
//             return CustomPaint(
//               painter: CircleProgressPainter(
//                 progress: (index + 1) / steps.length,
//                 isActive: isActive,
//               ),
//               child: Container(
//                 width: 250,
//                 height: 250,
//                 alignment: Alignment.center,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       step["step"]!,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isActive ? Colors.purple : Colors.grey,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Icon(
//                       Icons.check_circle,
//                       color: isActive ? Colors.purple : Colors.grey,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       step["title"]!,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 18,
//                         color: isActive ? Colors.purple : Colors.black54,
//                         fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// /// 🎨 Custom painter for circular progress arc
// class CircleProgressPainter extends CustomPainter {
//   final double progress; // from 0.0 to 1.0
//   final bool isActive;
//
//   CircleProgressPainter({required this.progress, required this.isActive});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final strokeWidth = 6.0;
//     final rect = Offset.zero & size;
//     final startAngle = -pi / 2;
//
//     final bgPaint = Paint()
//       ..color = Colors.purple.withOpacity(0.1)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth;
//
//     final progressPaint = Paint()
//       ..color = isActive ? Colors.purple : Colors.grey
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = strokeWidth;
//
//     // Draw background circle
//     canvas.drawArc(rect.deflate(strokeWidth / 2), 0, 2 * pi, false, bgPaint);
//
//     // Draw progress arc
//     canvas.drawArc(
//       rect.deflate(strokeWidth / 2),
//       startAngle,
//       2 * pi * progress,
//       false,
//       progressPaint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

import 'package:flowva/features/common/data/constants.dart';
import 'package:flowva/features/dashboard/home/home_page.dart';
import 'package:flowva/features/dashboard/nav_bar.dart';
import 'package:flowva/features/login/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:collection/collection.dart';
import 'package:page_transition/page_transition.dart';

class StepProgressPage extends StatefulWidget {
  @override
  _StepProgressPageState createState() => _StepProgressPageState();
}

class _StepProgressPageState extends State<StepProgressPage>  with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _scale1;
  late Animation<double> _scale2;
  late Animation<double> _scale3;

  int activeStep = 0; // Track active step
  final Set<int> completedSteps = {}; // Keep track of completed ones

  final List<Map<String, String>> steps = [
    {"step": "1/3", "title": "Preparing your missions"},
    {"step": "2/3", "title": "Levelling up your next mission."},
    {"step": "3/3", "title": "Your journey to rewards starts now."},
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..addListener(() {
      final t = _controller.value;
      int newStep;
      if (t < 0.33) {
        newStep = 0;
      } else if (t < 0.66) {
        newStep = 1;
      } else {
        newStep = 2;
      }

      if (newStep != activeStep) {
        completedSteps.add(activeStep); // mark previous step as completed
        activeStep = newStep;
      }
      // ✅ When animation finishes, mark last step completed
      if (_controller.isCompleted) {
        completedSteps.add(2);
      }

      setState(() {});
    });

    // Step 1
    _scale1 = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 3), // zoom in
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 3), // zoom out
      TweenSequenceItem(tween: ConstantTween(0.9), weight: 3),
    ]).animate(_controller);

    // Step 2
    _scale2 = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.8), weight: 3), // wait
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 3), // zoom in
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.9), weight: 3), // zoom out
    ]).animate(_controller);


    // Step 3 (final focus)
    _scale3 = TweenSequence([
      TweenSequenceItem(tween: ConstantTween(0.8), weight: 6), // wait
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 3), // zoom in
    ]).animate(_controller);

    _controller.forward();
    // Add navigation after 7 seconds

    Future.delayed(const Duration(seconds: 16), () async{
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
                type: PageTransitionType.fade,
                duration : Duration(milliseconds: 1500),
                child: BottomNavBar()
            )
            ,
                (ctx) => false);

        await Constants.setConfigure(true);
      }
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Widget _buildStep({
    required String title,
    required bool isActive,
    required bool isCompleted,
    required Animation<double> scale,
  }) {
    final Color textColor = isActive ? Color(0xFF400387) : Colors.grey;
    final double fontSize = isActive ? 14 : 12;
    final FontWeight fontWeight = isActive ? FontWeight.w700 : FontWeight.w600;

    Widget icon;
    if (isCompleted) {
      icon = Icon(Icons.check_circle, color: textColor, size: 16);
    } else {
      icon = SizedBox(
        width: 14,
        height: 14,
        child: SvgPicture.asset("assets/images/loading.svg")
      );
    }

    return ScaleTransition(
      scale: scale,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child:Center(
          child: IntrinsicWidth( // 👈 makes sure the row takes just enough space
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // 👈 keeps icon aligned with first line
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2.0), // optional tweak
                  child: icon,
                ),
                const SizedBox(width: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    title,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.manrope(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )

        ,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 160,),
          Text(
            "Almost there",
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF2B2B2B),
            ),
          ),
          SizedBox(height: 50,),
          Text(
            "Getting Bravoo ready for you",
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final double progress = _controller.value;

                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(
                        width: 271,
                        height: 271,
                        child: CustomPaint(
                          painter: CircleProgressPainter(
                            backgroundColor: Colors.grey.shade300,
                            progressColor: Color(0xFF9013FE).withOpacity(0.5),
                            progress: progress,
                            strokeWidth: 7,
                          ),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Step count at top
                            SizedBox(height: 50),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${activeStep + 1}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF400387),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "/${steps.length}",
                                    style: GoogleFonts.manrope(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Show all steps
                            _buildStep(
                              title: steps[0]['title']!,
                              isActive: activeStep == 0,
                              isCompleted: completedSteps.contains(0),
                              scale: _scale1,
                            ),
                            _buildStep(
                              title: steps[1]['title']!,
                              isActive: activeStep == 1,
                              isCompleted: completedSteps.contains(1),
                              scale: _scale2,
                            ),
                            _buildStep(
                              title: steps[2]['title']!,
                              isActive: activeStep == 2,
                              isCompleted: completedSteps.contains(2),
                              scale: _scale3,
                            ),
                          ],
                        ),

                  ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 30,),
          Text(
            "Setting the stage for your next big win...",
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),

    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final Color backgroundColor;
  final Color progressColor;
  final double progress; // Value from 0.0 to 1.0
  final double strokeWidth;

  CircleProgressPainter({
    required this.backgroundColor,
    required this.progressColor,
    required this.progress,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center1 = Offset(size.width / 2, size.height / 2);
    final radius1 = (size.shortestSide / 2) - (strokeWidth / 2);
    // Define the paint for the background circle
    final innerPaint = Paint()
      ..color = Color(0xFFFDE2E4).withOpacity(0.1) // 👈 your inner circle color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center1, radius1, innerPaint);
    final backgroundPaint = Paint()


      // ..style = PaintingStyle.
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Define the paint for the progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Optional: for rounded ends

    // Calculate the center and radius
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - (strokeWidth / 2);

    // Draw the background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw the progress arc
    final double sweepAngle = 2 * 3.1415926535 * progress; // Convert progress to radians
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.1415926535 / 2, // Start from the top (12 o'clock)
      sweepAngle,
      false, // Don't connect to center
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircleProgressPainter oldDelegate) {
    // Repaint only if any of the properties change
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// [
// _buildStep(
// steps[0]["step"]!, steps[0]["title"]!, _scale1.value, 0),
// const SizedBox(height: 15),
// _buildStep(
// steps[1]["step"]!, steps[1]["title"]!, _scale2.value, 1),
// const SizedBox(height: 15),
// _buildStep(
// steps[2]["step"]!, steps[2]["title"]!, _scale3.value, 2),
// ],