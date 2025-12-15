import 'dart:ui';

import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/dashboard/settings/presentation/widgets/connected_device_widget.dart';
import 'package:flowva/features/dashboard/settings/presentation/widgets/create_password.dart';
import 'package:flowva/features/dashboard/settings/presentation/widgets/deactivate_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({Key? key}) : super(key: key);

  @override
  State<NotificationSettingPage> createState() => _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool biometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading:GestureDetector(
          onTap:() =>Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        // leadingWidth: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // Logging in section
          const SectionTitle(title: "Rewards and missions"),

          CustomTile(
              title: "Suggestions and Offers",
              subtitle: "On: email and Push",
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: 18,
                color: Colors.black54,
              ),
              apply:(){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    // important for blur
                    builder: (_) =>NotificationWidget()
                );
              }
          ),
          const SizedBox(height: 5),
          CustomTile(
              title: "Offers",
              subtitle: "On: Email and Push",
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: 18,
                color: Colors.black54,
              ),
              apply:(){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    // important for blur
                    builder: (_) =>NotificationWidget()
                );
              }
          ),

          const SizedBox(height: 16),

          // Social Accounts
          const SectionTitle(title: "Payment and Payout"),
          CustomTile(
              title: "Payment",
              subtitle: "On email and Push ",
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: 18,
                color: Colors.black54,
              ),
              apply:(){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    // important for blur
                    builder: (_) =>ConnectedDeviceWidget()
                );
              }
          ),

          const SizedBox(height: 16),


          // Account section
          const SectionTitle(title: "Flowva updates"),
          CustomTile(
              title: "Payment",
              subtitle: "On email and Push ",
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: 18,
                color: Colors.black54,
              ),
              apply:(){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    // important for blur
                    builder: (_) =>ConnectedDeviceWidget()
                );
              }
          ),
          const SizedBox(height: 5),
          CustomTile(
              title: "News and Programs",
              subtitle: "On email and Push ",
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: 18,
                color: Colors.black54,
              ),
              apply:(){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    // important for blur
                    builder: (_) =>ConnectedDeviceWidget()
                );
              }
          ),
          const SizedBox(height: 5),
          CustomTile(
              title: "Feedback",
              subtitle: "On email and Push ",
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: 18,
                color: Colors.black54,
              ),
              apply:(){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    // important for blur
                    builder: (_) =>ConnectedDeviceWidget()
                );
              }
          ),
          const SizedBox(height: 16),
          const SectionTitle(title: "Flowva updates"),
          const SizedBox(height: 5),
          CustomTile(
              title: "Subscription Reminders",
              subtitle: "On email and Push ",
              trailing: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                size: 18,
                color: Colors.black54,
              ),
              apply:(){
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    // important for blur
                    builder: (_) =>ConnectedDeviceWidget()
                );
              }
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF767676),
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  Function() apply;

  CustomTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leading, required  this.apply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: leading,
        title: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5F5F5F),
          ),

        ),
        subtitle:Text(
          subtitle!,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF191919),
          ),
        ),
        trailing: trailing,
        onTap: apply,
      ),
    );
  }
}

class NotificationWidget extends StatefulWidget {
  NotificationWidget({super.key});

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {

  bool emailEnabled = false;
  bool biometricEnabled = true;

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
          initialChildSize: 0.46,
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
                    SizedBox(height: 30),
                    Container(

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

                        title: Text(
                          "Push notifications",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF191919),
                          ),

                        ),

                        trailing:   Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: biometricEnabled,
                            onChanged: (v) => setState(() => biometricEnabled = v),


                            activeTrackColor: Color(0xFF9013FE),
                            inactiveTrackColor: Colors.white,// background when off
                          ),
                        ),
                        onTap: (){},
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

                        title: Text(
                          "Email",
                          style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF191919),
                          ),

                        ),

                        trailing:   Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: emailEnabled,
                            onChanged: (v) => setState(() => emailEnabled = v),


                            activeTrackColor: Color(0xFF9013FE),
                            inactiveTrackColor: Colors.white,// background when off
                            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {

                              if (states.contains(WidgetState.selected)) {
                                print(states);
                                return CupertinoColors.black.withOpacity(.88);
                              }
                              return null; // Use the default color.
                            }),// background when off
                          ),
                        ),
                        onTap: (){},
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
