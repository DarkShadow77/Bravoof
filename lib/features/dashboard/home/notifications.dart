import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      "date": "Today",
      "items": [
        {
          "title": "Payment",
          "subtitle": "Payment Confirmation",
          "description":
              "Your Subscription to the Flowwa Pro Plan has been confirmed",
          "time": "4:24PM",
          "unread": true,
        },
        {
          "title": "Payment",
          "subtitle": "Payment Confirmation",
          "description":
              "Your Subscription to the Flowwa Pro Plan has been confirmed",
          "time": "4:24PM",
          "unread": false,
        },
        {
          "title": "Payment",
          "subtitle": "Payment Confirmation",
          "description":
              "Your Subscription to the Flowwa Pro Plan has been confirmed",
          "time": "4:24PM",
          "unread": true,
        },
        {
          "title": "Payment",
          "subtitle": "Payment Confirmation",
          "description":
              "Your Subscription to the Flowwa Pro Plan has been confirmed",
          "time": "4:24PM",
          "unread": false,
        },
      ],
    },
    {
      "date": "Yesterday",
      "items": [
        {
          "title": "Payment",
          "subtitle": "Payment Confirmation",
          "description":
              "Your Subscription to the Flowwa Pro Plan has been confirmed",
          "time": "4:24PM",
          "unread": true,
        },
        {
          "title": "Payment",
          "subtitle": "Payment Confirmation",
          "description":
              "Your Subscription to the Flowwa Pro Plan has been confirmed",
          "time": "4:24PM",
          "unread": true,
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft02),
              ),
              SizedBox(width: 8,),
              Text("Notifications",
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),),
            ],
          ),
        ),
        leadingWidth: 200,
        actions:  [
          GestureDetector(
            onTap: (){
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset position =
              button.localToGlobal(Offset.zero, ancestor: overlay);
              showCustomMenu(context, position);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.more_horiz,size: 16,),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          itemBuilder: (context, sectionIndex) {
            final section = notifications[sectionIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  section["date"],
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF767676),
                  ),
                ),
                const SizedBox(height: 5),
                ...section["items"].map<Widget>((item) {
                  return ListTile(
                    title:  Text(
                      item["title"],
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    subtitle:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          item["subtitle"],
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Color(0xFF2B2B2B),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item["description"],

                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF767676),
                          ),
                        ),
                      ],
                    ),
                    leading:  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: item["unread"]
                              ? Colors.purple
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                     trailing: Text(
                       item["time"],
                       style: GoogleFonts.manrope(
                         fontWeight: FontWeight.w700,
                         fontSize: 10,
                         color: Color(0xFF767676),
                       ),
                     ),
                     minLeadingWidth: 0,
                    minVerticalPadding: 10,
                    horizontalTitleGap: 10,
                    contentPadding: EdgeInsets.zero,
                  );


                }).toList(),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
  showCustomMenu(BuildContext context, Offset position) async {
    var selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + 20, // shift to the right
        position.dy + 100, // slight down shift
        15,
        0,
      ),
      color:Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem<String>(
          value: 'read',
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              children:  [
                HugeIcon(icon: HugeIcons.strokeRoundedMailOpen02),
                SizedBox(width: 10),
                Text('Mark as read',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFF5F5F5F),
                  ),),
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'clear',
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150),
            child: Row(
              children:  [
               HugeIcon(icon: HugeIcons.strokeRoundedDelete04),
                SizedBox(width: 10),
                Text('Clear all',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Color(0xFF5F5F5F),
                  ),),
              ],
            ),
          ),
        ),
      ],
      elevation: 8.0,
    );
    // Handle selected option
    if (selected == 'read') {
      // _switchTheme();
    } else if (selected == 'clear') {
      // showLogoutDialog(context);
    }
  }
}
