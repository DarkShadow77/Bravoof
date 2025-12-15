import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstScreen extends StatelessWidget {
  const  FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 140),
         Image.asset("assets/images/first_slide.png",fit: BoxFit.cover,filterQuality: FilterQuality.low,),
          Center(
            child: Text(
              "Grow through small \nmissions.",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
            ),
          ),
          // const SizedBox(height: 3),
          Center(
            child: Text(
              "Level up your skills one mission at a time.",
              style: GoogleFonts.manrope(fontSize: 16,fontWeight: FontWeight.w400, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 20),
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