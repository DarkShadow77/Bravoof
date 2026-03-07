import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../utility/in_app_review.dart';
import '../../../../../utility/ui_tool_mix.dart';
import 'feed_back.dart';

class HelpPage extends StatelessWidget with UIToolMixin {
  const HelpPage({super.key});

  Future<void> openWhatsApp() async {
    final phoneNumber = '15872872064';
    final message = 'Hello 👋';
    final encodedMessage = Uri.encodeComponent(message);

    final url = Uri.parse('https://wa.me/$phoneNumber?text=$encodedMessage');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  Widget buildTile(
    Widget icon,
    String title, {
    Color? iconColor,
    required Future Function() apply,
  }) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191919),
        ),
      ),
      trailing: HugeIcon(
        icon: HugeIcons.strokeRoundedArrowRight01,
        size: 18,
        color: Colors.black54,
      ),
      onTap: apply,
      horizontalTitleGap: 10,
      minVerticalPadding: 20,
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Get Help",
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                buildTile(
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedUserQuestion01,
                    // color: Colors.black,
                    strokeWidth: 2,
                    size: 20,
                  ),
                  "Visit the Help Center",
                  apply: () {
                    return showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      // important for blur
                      builder: (_) => HelpWidget(),
                    );
                  },
                ),
                const Divider(height: 1, color: Color(0xFFF1F1F1)),
                buildTile(
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedCustomerSupport,
                    color: Color(0xFF191919),
                    strokeWidth: 2,
                    size: 20,
                  ),
                  "Customer Support",
                  apply: () => openWhatsApp(),
                ),
                const Divider(height: 1, color: Color(0xFFF1F1F1)),
                buildTile(
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedMegaphone02,
                    strokeWidth: 2,
                    color: Color(0xFF191919),
                    size: 20,
                  ),
                  "Leave a Review",
                  apply: () async {
                    await requestAppRating();

                    showMessage(
                      "Thank you for rating our app! 🎉",
                      context,
                      color: Colors.green,
                      styleColor: Colors.white,
                    );

                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => BravooRatingPage()),
                    );*/

                    return;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HelpWidget extends StatefulWidget {
  HelpWidget({super.key});

  @override
  State<HelpWidget> createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  final items = [
    {"label": "Problem with Rewards"},
    {"label": "Customer Support"},
    {"label": "Issue with tools and Stack"},
    {"label": "Other"},
  ];
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(color: AppColors.black50),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.42,
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
                          'How may we help you today?',
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
                              color: Colors.black.withValues(alpha:0.6),
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
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => FeedbackPage(),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFF9F9F9),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.black.withValues(alpha:0.08),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      items[i]["label"]!,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF191919),
                                      ),
                                    ),
                                  ),
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedArrowRight01,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
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
