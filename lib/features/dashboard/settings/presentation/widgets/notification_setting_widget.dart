import 'dart:ui';

import 'package:bravoo/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class NotificationSettingWidget extends StatefulWidget {
  NotificationSettingWidget({super.key});

  @override
  State<NotificationSettingWidget> createState() =>
      _NotificationSettingWidgetState();
}

class _NotificationSettingWidgetState extends State<NotificationSettingWidget> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withValues(alpha: 0.5), // Optional dark overlay
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.63,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (ctx, scrollController) {
            return ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // translucent
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // drag handle
                    Container(
                      width: 60,
                      height: 6,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    // Header with close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rewards and offers',
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          height: 36,
                          width: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(120),
                            border: Border.all(
                              width: 0.2,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedCancel01,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),

                                title: Text(
                                  "Push notifications",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF5F5F5F),
                                  ),
                                ),

                                trailing: Switch(
                                  value:
                                      _isSwitched, // Current state of the switch
                                  onChanged: (newValue) {
                                    // Callback function when the switch is toggled
                                    setState(() {
                                      _isSwitched =
                                          newValue; // Update the state
                                    });
                                  },
                                  activeThumbColor: Colors
                                      .green, // Color when the switch is ON
                                  inactiveThumbColor: Colors
                                      .white, // Color of the thumb when OFF
                                  inactiveTrackColor: Colors
                                      .grey
                                      .shade300, // Color of the track when OFF
                                ),
                                onTap: () {},
                              ),
                            ),
                            SizedBox(height: 16),

                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),

                                title: Text(
                                  "Email",
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF5F5F5F),
                                  ),
                                ),

                                trailing: Switch(
                                  value:
                                      _isSwitched, // Current state of the switch
                                  onChanged: (newValue) {
                                    // Callback function when the switch is toggled
                                    setState(() {
                                      _isSwitched =
                                          newValue; // Update the state
                                    });
                                  },
                                  activeThumbColor: Colors
                                      .green, // Color when the switch is ON
                                  inactiveThumbColor: Colors
                                      .grey, // Color of the thumb when OFF
                                  inactiveTrackColor: Colors
                                      .grey
                                      .shade300, // Color of the track when OFF
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FlowvaButton.blueButton(
                        name: "Confirm Changes",
                        apply: () {},
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
