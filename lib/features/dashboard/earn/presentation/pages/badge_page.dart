import 'package:bravoo/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F7),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 70),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      customBorder: const CircleBorder(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: const Icon(Icons.arrow_back, size: 25),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Your Badges',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 5),
                    children: [
                      const SizedBox(height: 18),
                      // Master of Flow card
                      _buildMasterOfFlowCard(),

                      const SizedBox(height: 5),

                      _buildExpandableSection(
                        context,
                        'Explore Badges',
                        'Earned by trying tools, completing onboarding, discovering categories.',
                      ),
                      _buildExpandableSection(context, 'Growth Badges', ''),
                      _buildExpandableSection(context, 'Community Badges', ''),
                      _buildExpandableSection(context, 'Event Badges', ''),

                      const SizedBox(height: 32),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF6E4E6),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'View missions',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF020617),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterOfFlowCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F7FF).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9E9A9A).withValues(alpha: 0.1),
            blurRadius: 25,
            offset: const Offset(0, 6),
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Master of Flow',
            style: GoogleFonts.baloo2(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF977D80),
            ),
          ),
          const SizedBox(height: 5),
          Image.asset('assets/images/gold_badge.png', height: 80),
          const SizedBox(height: 5),
          Text(
            'Earned by completing 10 Growth Missions in a row',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF767676),
            ),
          ),
          const SizedBox(height: 10),
          FlowvaButton.whiteButton(
            color: Colors.black,
            name: 'Share achievement',
          ),
          Text(
            'You’re on fire! You completed 10 growth missions in a row.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191919),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
    BuildContext context,
    String title,
    String subTitle,
  ) {
    final badges = [
      {
        'title': 'Tool Tinkerer',
        'subtitle': 'Tried your first tool',
        'icon': Image.asset("assets/images/scholar.png"),
      },
      {
        'title': 'Stack Builder',
        'subtitle': 'Created 5 stacks',
        'icon': Image.asset("assets/images/scientist.png"),
      },
      {
        'title': 'Stack Builder',
        'subtitle': 'Create 5 stacks',
        'icon': Image.asset("assets/images/adventurer.png"),
      },
    ];
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        dense: true,
        // trailing:HugeIcon(icon: HugeIcons.strokeRoundedArrowUp01),
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        children: [
          Text(
            subTitle,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF767676),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 146,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final badge = badges[index];
              return Container(
                padding: EdgeInsets.only(top: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    badge['icon'] as Widget,

                    Text(
                      badge['title'].toString(),
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      badge['subtitle'].toString(),
                      style: GoogleFonts.manrope(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFA5A5A5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: badges.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 146,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final badge = badges[index];
              return Container(
                padding: EdgeInsets.only(top: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset("assets/images/hiddenReward2.png"),
              );
            },
          ),
        ],
      ),
    );
  }
}
