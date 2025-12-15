import 'package:flowva/features/mission/data/model/social_trivia_response.dart';
import 'package:flowva/features/mission/presentation/widget/social_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class FollowUsCard extends StatefulWidget {
  List<SocialTrivia> socialTrivia = [];

  FollowUsCard({required this.socialTrivia, super.key});

  @override
  State<FollowUsCard> createState() => _FollowUsCardState();
}

class _FollowUsCardState extends State<FollowUsCard> {
  bool isXCompleted = false;
  bool isInstaCompleted = false;
  bool isLinkCompleted = false;
  int progress = 0;

  @override
  void initState() {
    widget.socialTrivia.forEach((e) {
      if (e.completed!) {
        progress += e.title!.contains("linkedin")&&progress==50?50:25;
      }

      if (e.title!.toLowerCase().contains("instagram") && e.completed!) {
        isInstaCompleted = e.completed!;
      } else if (e.title!.toLowerCase().contains("x") && e.completed!) {
        isXCompleted = e.completed!;
      } else if (e.title!.toLowerCase().contains("linkedin") && e.completed!) {

        isLinkCompleted = e.completed!;
      }
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const cardRadius = 20.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Follow Us On Socials 🔥',

            style: GoogleFonts.baloo2(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),

          // Total progress row (label + percent)

          // Progress bar area with markers and icons
          Text(
            'Total Progress 50%',
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2B2B2B),
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,

            child: Container(
              height: 8,

              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFF1F1F1),
              ),

              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: progress / 100,
                    // progress percentage
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA259FF), Color(0xFFDEC4FF)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100,
                    child: const Text(
                      '0%',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: const Text(
                      '25%',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: const Text(
                      '55%',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ],
              ),

              const Text(
                '100%',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Three tier cards row: Beginner / Explorer / Master
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  child: _SmallTierCard(
                    title: 'Instagram',
                    statusText: isInstaCompleted
                        ? Image.asset("assets/images/mark.png")
                        : null,
                    locked: !isInstaCompleted ? true : false,
                    showDots: true,
                    icon: Image.asset("assets/images/instagram.png"),
                    apply: () => isInstaCompleted ?null:showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.transparent,
                      builder: (context) => SocialMediaWidget(
                        title: "Instagram Trivia",
                        text1: "Go to Bravoo Insta profile using this link: ",
                        link: " https://pplx.ai/mTd46rF",
                        text2: "Find the Trivia for October",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  child: _SmallTierCard(
                    title: 'X (Twitter)',
                    statusText: isXCompleted
                        ? Image.asset("assets/images/mark.png")
                        : null,
                    locked: !isXCompleted ? true : false,
                    showDots: true,
                    showProfileBubble: true,
                    icon: Image.asset("assets/images/x.png"),
                    apply: () => isXCompleted?null:showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.transparent,
                      builder: (context) => SocialMediaWidget(
                        title: "X Trivia",
                        text1: "Go to Bravoo X profile using this link: ",
                        link: " https://pplx.ai/mTd46rF",
                        text2: "Find the Trivia for October",
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  child: _SmallTierCard(
                    title: 'LinkedIn',
                    statusText: isLinkCompleted
                        ? Image.asset("assets/images/mark.png")
                        : null,
                    locked: !isLinkCompleted ? true : false,
                    showDots: true,
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset("assets/images/linkedin.png"),
                    ),
                    apply: () => isLinkCompleted?null:showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.transparent,
                      builder: (context) => SocialMediaWidget(
                        title: "LinkedIn Trivia",
                        text1:
                            "Go to Bravoo LinkedIn profile using this link: ",
                        link: " https://pplx.ai/mTd46rF",
                        text2: "Find the Trivia for October",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallIconBadge extends StatelessWidget {
  final Widget icon;

  const _SmallIconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withOpacity(0.08)),
      ),
      child: icon,
    );
  }
}

/* small tier card (Beginner / Explorer / Master) */
class _SmallTierCard extends StatelessWidget {
  final String title;
  final Widget? statusText;
  final bool locked;
  Widget icon;
  final bool showDots;
  final bool showProfileBubble;
  Function apply;

  _SmallTierCard({
    this.title = '',
    this.statusText,
    required this.icon,
    this.locked = false,
    this.showDots = false,
    this.showProfileBubble = false,
    required this.apply,
  });

  @override
  Widget build(BuildContext context) {
    // container with rounded corners and subtle background
    return Column(
      children: [
        GestureDetector(
          onTap: () => apply(),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: statusText != null ? Color(0xFFECD6FF) : Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 6),
                ),
              ],
              // border: Border.all(color: Colors.white),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                statusText != null
                    ? statusText!
                    : (locked
                          ? HugeIcon(icon: HugeIcons.strokeRoundedSquareLock02)
                          : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double progress; // 0..1
  _ProgressBarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final trackHeight = 12.0;
    final centerY = size.height / 2;

    // track paint (light)
    final trackPaint = Paint()
      ..color = const Color(0xFFE9E7EF)
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final trackRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, centerY - trackHeight / 2, size.width - 5, trackHeight),
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
      bottomLeft: const Radius.circular(8),
      bottomRight: const Radius.circular(8),
    );
    canvas.drawRRect(trackRect, trackPaint);

    // filled gradient portion
    final filledWidth = (size.width - 16) * progress;
    final filledRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, centerY - trackHeight / 2, filledWidth, trackHeight),
      topLeft: const Radius.circular(8),
      bottomLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
      bottomRight: const Radius.circular(8),
    );

    final gradient = LinearGradient(
      colors: [const Color(0xFFB16EFF), const Color(0xFF6A00F4)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(8, centerY - trackHeight / 2, filledWidth, trackHeight),
      );
    canvas.drawRRect(filledRect, paint);

    // small vertical ticks for 25% and 55% (visual, subtle)
    final tickPaint = Paint()..color = const Color(0xFFDCD6E8);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.25 - 1, centerY - 30, 2, 24),
      tickPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.50 - 1, centerY - 30, 2, 24),
      tickPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
