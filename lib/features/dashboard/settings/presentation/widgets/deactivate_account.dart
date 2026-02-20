import 'dart:ui';

import 'package:bravoo/features/common/flowva_button.dart';
import 'package:bravoo/features/dashboard/settings/presentation/pages/delete_account_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class DeactivateAccountWidget extends StatefulWidget {
  DeactivateAccountWidget({super.key});

  @override
  State<DeactivateAccountWidget> createState() =>
      _DeactivateAccountWidgetState();
}

class _DeactivateAccountWidgetState extends State<DeactivateAccountWidget> {
  final items = [
    {"label": "I have safety or privacy concerns"},
    {"label": "I don’t need it anymore "},
    {"label": "I cant comply to Flowva’s term of rule"},
    {"label": "Other"},
  ];
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            color: Colors.black.withOpacity(0.5), // Optional dark overlay
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.58,
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
                          'Connected Accounts',
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
                              color: Colors.black.withOpacity(0.6),
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
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOption = items[i]["label"];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(8),

                                // border: selectedOption == items[i]["label"]
                                //     ? Border.all(width: 0.5, color: Colors.purple)
                                //     : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      items[i]["label"]!,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 2,
                                      ),
                                      color: selectedOption == items[i]["label"]
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    child: selectedOption == items[i]["label"]
                                        ? Center(
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FlowvaButton.blueButton(
                        name: "Confirm Changes",
                        apply: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => DeleteAccountPage(reason: ""),
                            ),
                          );
                        },
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
