import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FlowvaAppBar extends StatefulWidget {
  String title;
   FlowvaAppBar({this. title = '',Function? apply,super.key});

  @override
  State<FlowvaAppBar> createState() => _FlowvaAppBarState();
}

class _FlowvaAppBarState extends State<FlowvaAppBar> {
  @override
  Widget build(BuildContext context) {

      return   Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title ,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Image.asset("assets/images/one_50.png",height: 18,),
                SizedBox(width: 4,),
                Text(
                  SessionManager().pointsVal.toString(),
                  style: GoogleFonts.baloo2(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  }
}

