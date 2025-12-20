import 'package:flowva/app/styles/text_styles.dart';
import 'package:flowva/core/constants/app_assets.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowvaAppBar extends StatefulWidget {
  String title;
  FlowvaAppBar({this.title = '', Function? apply, super.key});

  @override
  State<FlowvaAppBar> createState() => _FlowvaAppBarState();
}

class _FlowvaAppBarState extends State<FlowvaAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            spacing: 8.w,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                spacing: 4.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsPngImages.jackpot,
                    height: 18.h,
                    width: 18.w,
                    fit: BoxFit.contain,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "x${SessionManager().jackpotVal.toString()}",
                      style: TextStyles.normalSemibold14(context),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 4.w,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/one_50.png", height: 18),
                  RichText(
                    text: TextSpan(
                      text: SessionManager().pointsVal.toString(),
                      style: TextStyles.normalSemibold14(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
