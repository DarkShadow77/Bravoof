import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RewardTransaction {
  final String title;
  final String subtitle;
  final String type; // Missions, Reward, Jackpot, Conversion, Referral
  final String amount; // Positive for earned, negative for spent
  final DateTime date;

  RewardTransaction({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.amount,
    required this.date,
  });
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      // October 2025
      RewardTransaction(
        title: 'Completed Community Mission',
        subtitle: 'Today, 2:14 PM',
        type: 'Missions',
        amount: '+500',
        date: DateTime(2025, 10, 16),
      ),
      RewardTransaction(
        title: 'Redeemed \$5 Gift Card',
        subtitle: 'Today, 2:14 PM',
        type: 'Reward',
        amount: '-5,000',
        date: DateTime(2025, 10, 16),
      ),
      RewardTransaction(
        title: 'Entered Bravoo Jackpot',
        subtitle: 'Today, 2:14 PM',
        type: 'Jackpot',
        amount: '-100',
        date: DateTime(2025, 10, 16),
      ),

      // August 2025
      RewardTransaction(
        title: 'Redeemed 10,000 Coins to ₦1,000',
        subtitle: 'Today, 2:14 PM',
        type: 'Conversion',
        amount: '-10,000',
        date: DateTime(2025, 8, 16),
      ),
      RewardTransaction(
        title: 'Referral Bonus 2 new members joined',
        subtitle: 'Today, 2:14 PM',
        type: 'Referral',
        amount: '+400',
        date: DateTime(2025, 8, 16),
      ),
    ];

    // Group transactions by month/year
    final grouped = <String, List<RewardTransaction>>{};
    for (final tx in transactions) {
      final key =
          '${_monthName(tx.date.month)} ${tx.date.year}'; // e.g. October 2025
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    return Container(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16, right: 16, left: 16),
        children: [
          _buildStatsRow(context),
          const SizedBox(height: 20),
          ...grouped.entries.map(
            (entry) => _buildMonthSection(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard(
          Image.asset("assets/images/one_50.png", height: 22),
          '16,120',
          'Total Coins\nEarned',
        ),
        _buildStatCard(
          Image.asset("assets/images/gift_with_money.png"),
          '8',
          'Rewards\nRedeemed',
        ),
        _buildStatCard(
          Image.asset("assets/images/fire.png"),
          '12',
          'Active\nStreak',
        ),
      ],
    );
  }

  Widget _buildStatCard(Widget icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            icon,
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,

              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF767676),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSection(String month, List<RewardTransaction> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            month,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF5F5F5F),
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(_buildTransactionCard).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(RewardTransaction tx) {
    final colorMap = {
      'Missions': Color(0xFF005F3E),
      'Reward': Color(0xFFF77A38),
      'Jackpot': Color(0xFF9013FE),
      'Conversion': Color(0xFF1C52D1),
      'Referral': Color(0xFFF76593),
    };

    final iconMap = {
      'Missions': Image.asset("assets/images/one_50.png"),
      'Reward': Image.asset(
        "assets/images/gift_with_money.png",
        fit: BoxFit.cover,
      ),
      'Jackpot': Image.asset("assets/images/flying_coins.png"),
      'Conversion': Image.asset("assets/images/blue_cards.png"),
      'Referral': Image.asset("assets/images/frends.png"),
    };

    final color = colorMap[tx.type] ?? Colors.grey;
    Widget icon = iconMap[tx.type] ?? Icons.info as Widget;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(right: 10, left: 10, bottom: 15, top: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white, child: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 90,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(2),
                  ),
                ),
                child: Text(
                  tx.type,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),

                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tx.amount.toString(),
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                tx.subtitle,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5F5F5F),
                ),
              ),
            ],
          ),
        ],
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
