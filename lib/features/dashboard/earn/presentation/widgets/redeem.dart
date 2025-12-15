import 'dart:async';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/invite_earn.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/jackpot_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RedeemOverviewPage extends StatefulWidget {
   RedeemOverviewPage({this.campaign,super.key});
  Campaign? campaign;
  @override
  State<RedeemOverviewPage> createState() => _RedeemOverviewPageState();
}

class _RedeemOverviewPageState extends State<RedeemOverviewPage>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  final _pageController = PageController(initialPage: 0);
  double _pageHeight = 300;
  int _currentPage = 0;
  Timer? _timer;
  Duration? _remainingTime;
  bool _isExpired = false;


  @override
  void initState() {
    super.initState();
    _remainingTime=Duration(
      days:widget.campaign!.campaignEndDate!.day,
      hours: widget.campaign!.campaignEndDate!.hour,
      minutes: widget.campaign!.campaignEndDate!.minute,
      seconds: widget.campaign!.campaignEndDate!.second,
    );
    _startCountdown();
  }

  void _startCountdown() {
    // Calculate initial remaining time
    _updateRemainingTime();

    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final difference = widget.campaign!.campaignEndDate!.difference(now);

    if (difference.isNegative) {
      setState(() {
        _isExpired = true;
        _remainingTime = Duration.zero;
      });
      _timer?.cancel();
    } else {
      setState(() {
        _remainingTime = difference;
        _isExpired = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _remainingTime!.inDays;
    final hours = _remainingTime!.inHours.remainder(24);
    final minutes = _remainingTime!.inMinutes.remainder(60);
    final seconds = _remainingTime!.inSeconds.remainder(60);


    return SingleChildScrollView(
      child: Column(
        // shrinkWrap: true,
        // padding: EdgeInsets.only(top: 16),
        // physics: const ClampingScrollPhysics(),
        children: [
          const SizedBox(height: 20),
          // 🎁 Giveaway Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/oraimo.png"),
                      SizedBox(width: 8),
                      Text(
                        'Oraimo OpenSnap Contest',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 250,
                          child: Text(
                            'Refer to win Oraimo OpenSnap Airpod!',
                            style: GoogleFonts.baloo2(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFAB7A7A),
                            ),
                          ),
                        ),
                      ),

                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(
                            0xFFFF8687,
                          ).withOpacity(0.19),
                          child: Image.asset(
                            "assets/images/ear_pod.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // SvgPicture.asset("assets/images/ear_pod.svg",height: 40,),
                    ],
                  ),
                  Container(
                    height: 100,

                    alignment: Alignment.bottomCenter,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // White container
                        Positioned(
                          bottom: 40, // lift the white box slightly
                          child: Container(
                            width: 290,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Ends in ',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF191919),
                                  ),
                                ),
                                _timerBox('$days days'),
                                const Icon(
                                  Icons.more_vert,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                _timerBox('${hours}h'),
                                const Icon(
                                  Icons.more_vert,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                _timerBox('${minutes}m'),
                                const Icon(
                                  Icons.more_vert,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                _timerBox('${seconds}s'),
                              ],
                            ),
                          ),
                        ),

                        // Button overlapping the white box bottom
                        Positioned(
                          bottom: -20,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 330,
                            clipBehavior: Clip.hardEdge,
                            child: FlowvaButton.noneOutlineBlackButton(
                              name: "Refer your friends",
                              fontSize: 16,
                              apply: () =>
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => InviteAndEarnPage(),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 💡 Info Box
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.black),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keep engaging to unlock more rewards',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          child: Text(
                            'How to earn more coin?',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF9013FE),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(

                children: [
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        _pageController.jumpTo(0);
                        print(_pageHeight);
                      },
                      child: Text(
                        'JACKPOT & GIVEAWAYS',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  _currentPage == 0 ? Container(
                    height: 2,
                    width: 165,
                    color: Color(0xFF9013FE),
                  ) : Container()
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        _pageController.jumpToPage(1);
                        print(_pageHeight);
                      },
                      child: Text(
                        'GIFTS & VIRTUAL CARDS',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  _currentPage == 1 ? Container(
                    height: 2,
                    width: 165,
                    color: Color(0xFF9013FE),
                  ) : Container()
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 💰 Jackpot Cards
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _pageHeight,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: PageView(
                controller: _pageController,
                // physics: ClampingScrollPhysics(),
                onPageChanged: (index) {
                  print(index);
                  setState(() {
                    _currentPage = index;
                    // 👇 set different heights for different pages
                    _pageHeight = index == 0 ? 300 : MediaQuery
                        .of(context)
                        .size
                        .height * 0.85;
                  });
                },
                children: [
                  // First tab placeholder
                  _rewardCard(
                    icon: Icons.savings,
                    title: 'Bravoo Jackpot 🏆',
                    subtitle: SizedBox(
                      width: 255,
                      child: RichText(
                        // textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Your chance to win',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2B2B2B),
                              ),
                            ),
                            TextSpan(
                              text: ' 20,000 coins',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF9013FE),
                              ),
                            ),
                            TextSpan(
                              text:
                              '  is here. Invite your friends and let the adventure begin!',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2B2B2B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    cost: '100 Coins',
                    tag: 'Hot',
                    tagColor: Color(0xFFFE5613),
                    buttonText: 'Enter Jackpot',
                    active: false,
                  ),

                  // Second tab: Gifts & Virtual Cards
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.70,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [

                      buildRewardCard(
                        title: "Paypal",
                        imagePath: "assets/images/slant_visa.png",
                        coins: "20,000 Coins",
                        isActive: true,
                      ),
                      buildRewardCard(
                        title: "Airtime",
                        imagePath: "assets/images/dollar.png",
                        coins: "10,000 Coins",
                        isActive: false,
                      ),
                      buildRewardCard(
                        title: "Data",
                        imagePath: "assets/images/slant_visa.png",
                        coins: "5,000 Coins",
                        isActive: true,
                        isHot: true,
                      ),
                      buildRewardCard(
                        title: "Giftcard",
                        imagePath: "assets/images/giftCard.png",
                        coins: "5,000 Coins",
                        isActive: true,
                        isHot: true,
                      ),

                    ],
                  ),
                ],
              )
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }

  Widget buildRewardCard({
    required String title,
    required String imagePath,
    required String coins,
    required bool isActive,
    bool isHot = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F7FF).withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔥 Hot badge + Image
          Stack(
            alignment: Alignment.topRight,
            children: [
              Center(
                child: Image.asset(imagePath, height: 50, fit: BoxFit.contain),
              ),
              if (isHot)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  margin: const EdgeInsets.only(right: 5, top: 3),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "🔥Hot",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFF5EBFF),
              borderRadius: BorderRadius.circular(30),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.06),
              //     blurRadius: 6,
              //   ),
              // ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/one_50.png", height: 12),
                const SizedBox(width: 6),
                Text(
                  ' 10,000 coins',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: Color(0xFF9013FE),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Claim Button
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: FlowvaButton.shortBlackButtonNoOutline(
                name: "Claim now",
                buttonColor: isActive ? Colors.black : Colors.grey,
                isActive:isActive
            ),
          ),
          Divider(color: Color(0xFF767676), thickness: 0.1),

        ],
      ),
    );
  }

  Widget _rewardCard({
    required IconData icon,
    required String title,
    required Widget subtitle,
    required String cost,
    required String buttonText,
    required bool active,
    String? tag,
    Color? tagColor,
  }) {
    return Container(
      height: 200,

      padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            spreadRadius: -3,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(

          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (tag != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tagColor?.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: Color(0xFFFE5613),
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          tag,
                          style: TextStyle(
                            color: tagColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            Image.asset("assets/images/flying_coins.png"),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            subtitle,
            active
                ? FlowvaButton.jackpotButton(
              name: "Play the Jackot",
              color: Colors.white,
              apply: () =>
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => JackpotScreen()),
                  ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: FlowvaButton.noneOutlineBlackButton(
                name: "Invite your friends",
                apply: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => InviteAndEarnPage()),
                    ),
              ),
            ),

            Text(
              "Invite 5+ friends every month to unluck the jackpot",
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF767676),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerBox(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191919),
        ),
      ),
    );
  }
}
