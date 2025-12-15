import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/dashboard/earn/data/models/mission_res.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MissionTile extends StatelessWidget {
  final Mission mission;
  final VoidCallback onClaim;

  const MissionTile({required this.mission, required this.onClaim, super.key});

  @override
  Widget build(BuildContext context) {
print(mission.rightIcon!);
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 2, right: 2, bottom: 2),
      decoration: BoxDecoration(
        color: mission.completed! ?Color(0xFFF6FDF5):Color(0xFFF6FDF5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          mission.icon,
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    mission.title!,
                    style: GoogleFonts.baloo2(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color:mission.id=="rate"?Colors.black.withOpacity(0.24): Colors.black.withOpacity(0.50),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                mission.completed!
                    ? Image.asset("assets/images/mark.png")
                    : Container()

                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 15),
                //   child: Stack(
                //     children: [
                //       ClipRRect(
                //         borderRadius: BorderRadius.circular(12),
                //         child: Stack(
                //           children: [
                //             // Background color (track)
                //             Container(
                //               height: 20,
                //               decoration: BoxDecoration(
                //                 color: Color(0xFFF1F1F1),
                //                 gradient: LinearGradient(
                //                   begin: Alignment.topCenter,
                //                   end: Alignment.bottomCenter,
                //                   colors: [
                //                     const Color(0xFFD9AEFF),
                //                     const Color(0xFF550AA9),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //
                //             // Gradient progress bar
                //             // LayoutBuilder(
                //             //   builder: (context, constraints) {
                //             //     return Container(
                //             //       height: 16,
                //             //       width: constraints.maxWidth * mission.progress!,
                //             //       // width proportional to value
                //             //       decoration: BoxDecoration(
                //             //         color: Color(0xFFF1F1F1),
                //             //         gradient:LinearGradient(
                //             //           begin: Alignment.topCenter,
                //             //           end: Alignment.bottomCenter,
                //             //           colors: [
                //             //             const Color(0xFFD9AEFF),
                //             //             const Color(0xFF550AA9),
                //             //           ],
                //             //         ),
                //             //       ),
                //             //     );
                //             //   },
                //             // ),
                //           ],
                //         ),
                //       ),
                //       // Positioned(
                //       //   left: 50,
                //       //   right: 50,
                //       //   top: -1,
                //       //
                //       //   child: Center(
                //       //     child: Text(
                //       //       progressTextFromValue(mission.progress!),
                //       //       style: GoogleFonts.baloo2(
                //       //         fontSize: 16,
                //       //         fontWeight: FontWeight.w700,
                //       //         color:Colors.white.withOpacity(0.42),
                //       //       ),
                //       //     ),
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 4),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: EdgeInsets.only(top: 8, right: 8, left: 8),
            // height: 80,
            width: 88,
            decoration: BoxDecoration(
              color: mission.completed! ?Color(0xFFF1F1F1):Color(0xFF9013FE).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mission.id==null?Image.asset(mission.rightIcon!,height: 22,):Image.network(mission.rightIcon!,height: 22,),
                    SizedBox(width: 5),
                    Text(
                      "${mission.points}",
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.34),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 5),
                // const SizedBox(height: 10),

               FlowvaButton.purpleButton(
                 color: mission.completed!?Colors.grey:null,
                  name: "${mission.subject}",
                  apply: onClaim
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String progressTextFromValue(int progress) {
  // simple mapping for demo: 0 -> 0/1, 1/3 -> 1/3, etc.
  if (progress == 1) return '0/1';
  if ((progress - 1 / 3).abs() < 0.01) return '1/3';
  // fallback
  return '${(progress * 1).round()}/${1}';
}