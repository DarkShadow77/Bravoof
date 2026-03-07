import 'package:bravoo/app/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            "assets/images/first_slide.png",
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
          ),
          SizedBox(height: 22.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Grow through small \nmissions.",
              style: TextStyles.bigTitleBold24(context).copyWith(fontSize: 28),
            ),
          ),
          SizedBox(height: 16.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Level up your skills one mission at a time.",
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
      // margin: const EdgeInsets.only(bottom: 16),
      // padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: faded
            ? Colors.white.withValues(alpha: 0.2)
            : const Color(0xFFFDF8F9).withValues(alpha: 0.8),
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
