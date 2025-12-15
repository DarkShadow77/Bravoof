import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PedestalWithProduct extends StatelessWidget {
  final int position;
  final double height;
  final Color color; // local asset path (or use Image.network inside)

   PedestalWithProduct({
    super.key,
    required  this.position,
    required this. height,
    required  this.color,
  });

  @override
  Widget build(BuildContext context) {
    // final Color topFaceColor = lighten(color, 0.2);
    final Color frontFaceColor = color;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Front face (main block)
        Container(
          width: 108.1,
          height: height,
          decoration: BoxDecoration(
            color: position == 1 ? null : frontFaceColor,
            gradient: position == 1
                ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6312A8), Color(0xFF9720FC)],
            )
                : null,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(20),
            //   topRight: Radius.circular(5),
            // ),
          ),
          alignment: Alignment.bottomCenter,

          child: Text(
            '$position',
            style: GoogleFonts.baloo2(
              fontSize: 64,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),

        // Top face (angled using Transform)

        Positioned(
          top: 0,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.skewX(-0.4), // Skew to create 3D angle
            child: Container(
              width: 103.11,
              height: 20,
              decoration: BoxDecoration(
                color: Color(0xFFCA8DFD),
                borderRadius: BorderRadius.circular(6),
              ),

            ),
          ),
        ),
      ],
    );;
  }
}
