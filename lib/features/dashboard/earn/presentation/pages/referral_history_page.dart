import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class ReferralHistory {
  final String name;
  final String statusLabel;
  final String status; // Missions, Reward, Jackpot, Conversion, Referral
  final String avatar; // Positive for earned, negative for spent
  final String? coins; // Positive for earned, negative for spent
  final DateTime date;

  ReferralHistory({
    required this.name,
    required this.statusLabel,
    required this.status,
    required this.avatar,
     this.coins,
    required this.date,
  });
}

class ReferralHistoryPage extends StatefulWidget {
  ReferralHistoryPage({super.key});

  @override
  State<ReferralHistoryPage> createState() => _ReferralHistoryPageState();
}

class _ReferralHistoryPageState extends State<ReferralHistoryPage> {



  final referrals = [
    // October 2025
    ReferralHistory(
      avatar: "assets/avatar/1.png",
      coins: "assets/images/one_50.png",
      name: "Oladipupo Paul",
      statusLabel: "Joined",
      status: 'Pending',
      date: DateTime(2025, 10, 16),
    ),
    ReferralHistory(
      avatar: "assets/avatar/2.png",
      name: "Oladipupo Paul",
      statusLabel: "Joined",
      status: 'Joined',
      date: DateTime(2025, 10, 16),
    ),
    ReferralHistory(
      avatar: "assets/avatar/3.png",
      name: "Oladipupo Paul",
      statusLabel: "Joined",
      status: 'Declined',
      date: DateTime(2025, 10, 16),
    ),

    // August 2025
    ReferralHistory(
      avatar: "assets/avatar/4.png",
      name: "Oladipupo Paul",
      statusLabel: "Joined",
      status: 'Joined',
      date: DateTime(2025, 8, 16),
    ),
    ReferralHistory(
      avatar: "assets/avatar/5.png",
      name: "Oladipupo Paul",
      statusLabel: "Joined",
      status: 'Pending',
      date: DateTime(2025, 8, 16),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<ReferralHistory>>{};
    for (final tx in referrals) {
      final key =
          '${_monthName(tx.date.month)} ${tx.date.year}'; // e.g. October 2025
      grouped.putIfAbsent(key, () => []).add(tx);
    }
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  child: const Icon(Icons.arrow_back, color: Colors.black87),
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: 10,),
                Text(
                  "Referral History",
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191919),
                    fontSize: 18,
                  ),
                ),
              ],
            ),),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        
              children: [
                TextField(
                  onChanged: (val) {},
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        color: Colors.grey,
                        size: 15.0,
                        strokeWidth: 2.5, // Custom stroke width
                      ),
                    ),
        
        
                    hintText: "Search",
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
        

                ...grouped.entries.map(
                  (entry) => _buildReferralCard(entry.key, entry.value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }
}

Widget _buildReferralCard(String month, List<ReferralHistory> items) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          month,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5F5F5F),
          ),
        ),
        SizedBox(height: 10,),
        ...items.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            child: Row(
              children: [
                CircleAvatar(radius: 22, backgroundImage: AssetImage(e.avatar)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.name,
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // status chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: e.status.toLowerCase() == "pending"
                              ? Color(0xFFE9E9E9)
                              : e.status.toLowerCase() == "joined"
                              ? Color(0xFFE3FAE1)
                              : Color(0xFFFFEBEB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          e.statusLabel,
                          style: GoogleFonts.manrope(
                            color: e.status.toLowerCase() == "pending"
                                ? Colors.black
                                : e.status.toLowerCase() == "joined"
                                ? Color(0xFF008753)
                                : Color(0xFFCC0000),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // right side small circle icon and time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  e.coins!=null? Image.asset(e.coins!,height: 22,):Container(),
                    const SizedBox(height: 8),
                    Text(
                      "2:14 PM",
                      style: GoogleFonts.manrope(
                        color: Color(0xFF767676),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}
