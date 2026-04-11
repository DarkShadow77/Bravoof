import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

mixin UIToolMixin {
  void showMessage(
    String message,
    BuildContext context, {
    Color color = Colors.red,
    styleColor = Colors.white,
    iconColor = Colors.black,
    bool status = false,
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              color: Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFCDCDCD)),
            ),
            child: Row(
              children: [
                status
                    ? Container(
                        height: 20,
                        width: 20,
                        color: Colors.white,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedCancel01,
                          strokeWidth: 4,
                          color: Color(0xFFB60000),
                        ),
                      )
                    : Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF191919),
                    ),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 3)).then((_) => entry.remove());
  }
}
