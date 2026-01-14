import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/styles/text_styles.dart';
import '../../../core/constants/app_colors.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<Offset> _leftSlide;
  // late Animation<Offset> _rightSlide;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   _controller = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 1200),
  //   );
  //
  //   _leftSlide = Tween<Offset>(
  //     begin: const Offset(-1.5, 0), // start off screen to the left
  //     end: Offset.zero, // move to original position
  //   ).animate(CurvedAnimation(
  //     parent: _controller,
  //     curve: const Interval(0.0, 0.5, curve: Curves.easeInOut), // First half
  //   ),);
  //
  //   _rightSlide = Tween<Offset>(
  //     begin: const Offset(1.5, 0), // start off screen to the right
  //     end: Offset.zero,
  //   ).animate(CurvedAnimation(
  //     parent: _controller,
  //     curve: const Interval(0.5, 1.0, curve: Curves.easeInOut), // Second half
  //   ),);
  //
  //   _controller.forward(); // Start animation
  // }
  //
  // @override
  // void dispose() {
  //   _controller.dispose(); // Clean up
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset("assets/images/third_slide.png"),
          SizedBox(height: 90.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Your efforts unlock\nreal perks.",
              style: TextStyles.bigTitleBold24(context).copyWith(fontSize: 28),
            ),
          ),
          SizedBox(height: 16.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Cash out with gift cards and real rewards.",
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

  Widget subscriptionCard({
    required Widget logo,
    required String name,
    required String price,
    required String billedIn,
    List<Widget>? actions,
    bool faded = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: faded
            ? Colors.white.withOpacity(0.2)
            : const Color(0xFFFDF8F9).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!faded)
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              logo,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: faded ? Colors.black54 : Colors.black,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: faded ? Colors.black54 : Colors.black,
                    ),
                  ),
                  Text(
                    billedIn,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: faded ? Colors.black45 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (actions != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: actions,
            ),
          ],
        ],
      ),
    );
  }

  Widget actionButton(
    String text, {
    Color? textColor,
    Color? bgColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor ?? Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
