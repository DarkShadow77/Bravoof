import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class DeactivationPage extends StatelessWidget {
  const DeactivationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: ()=>Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title: Text(
          "Deactivate account?",
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,

      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(16.0),
            child: Text("phantombliss7@gmail.com",
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),),
          ),
          ListTile(
            leading: HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle02),
            subtitle: Text("Your profile, tools, stack and subscriptions on this account will dissappear",
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5F5F5F),
              ),
            ),
          ),
          ListTile(
            leading: HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkCircle02),
            subtitle: Text("Your profile, tools, stack and subscriptions on this account will dissappear",
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5F5F5F),
              ),
            ),
          ),
          Spacer(),
          // SizedBox(
          //   height: 120,
          //   child: Stack(
          //     children: [
          //       Positioned(
          //         left: 16,
          //         top: 50,
          //         bottom:20,
          //         child: Opacity(
          //           opacity: 0.24, // same as CSS opacity: 0.24
          //           child: Container(
          //             width: 343,
          //             height: 56,
          //             decoration: BoxDecoration(
          //               color: Colors.black, // change this to your desired base color
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             child: TextButton(
          //               onPressed: () {
          //                 // Your button action here
          //               },
          //               style: TextButton.styleFrom(
          //                 padding: EdgeInsets.zero,
          //                 alignment: Alignment.centerLeft, // aligns like flex-start
          //               ),
          //               child: const Padding(
          //                 padding: EdgeInsets.symmetric(horizontal: 16),
          //                 child: Center(
          //                   child: Text(
          //                     "Continue",
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 16,
          //                       fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //
          //     ],
          //   ),
          // ),
          Text("Deactivate Account",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),),
          SizedBox(height: 25,)
        ],
      ),
    );
  }
}
