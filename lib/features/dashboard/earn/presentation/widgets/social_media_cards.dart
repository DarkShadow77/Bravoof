import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialMediaCards extends StatelessWidget {
  Widget? icon;
  String? label;
  Color? color;
  Color? textColor;
   SocialMediaCards({super.key, this.color,this.textColor,this.icon, this. label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(height: 6),
          Text(
            label!,
            style: GoogleFonts.manrope(color:textColor, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
