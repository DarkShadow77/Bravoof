import 'dart:async';

import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/dashboard/earn/presentation/pages/referral_contest_screen.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/draw_end_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/di/service_locator.dart';
import '../../data/bloc/campaign_cubit.dart';

class ToolCardCarousel extends StatefulWidget {
  List<Campaign>? campaign;
  ToolCardCarousel({this.campaign, Key? key}) : super(key: key);

  @override
  State<ToolCardCarousel> createState() => _ToolCardCarouselState();
}

class _ToolCardCarouselState extends State<ToolCardCarousel> {
  final _pageController = PageController(viewportFraction: 1);
  Timer? _timer;
  Duration? _remainingTime;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();

    if (widget.campaign!.isNotEmpty) {
      _remainingTime = Duration(
        days: widget.campaign!.first.campaignEndDate!.day,
        hours: widget.campaign!.first.campaignEndDate!.hour,
        minutes: widget.campaign!.first.campaignEndDate!.minute,
        seconds: widget.campaign!.first.campaignEndDate!.second,
      );
    }
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
    final difference = widget.campaign!.isNotEmpty
        ? widget.campaign!.first.campaignEndDate!.difference(now)
        : null;

    if (difference!.isNegative) {
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

  int currentPage = 0;
  final List<String> backgroundImages = [
    'assets/images/top_tool_bg.png',
    'assets/images/top_user_b.png',
    'assets/images/quote_bg.png',
  ];

  final List<Map<String, dynamic>> data = [
    {
      'title': "Top User Spotlight",
      'name': "James Martins",
      'subtitle': "Top user",
      'image': "assets/avatar/2.png",
    },
    {
      'title': "Top User Spotlight",
      'name': "James Martins",
      'subtitle': "Top user",
      'image': "assets/avatar/2.png",
      'listOfImages': [
        "assets/images/one_50.png",
        "assets/images/one_50.png",
        "assets/images/one_50.png",
      ],
    },
    {
      'title':
          "“Progress isn’t always loud, sometimes it’s just steady. Your pace is enough.“",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // PageView of cards
        Container(
          height: 235,

          // width: MediaQuery.of(context).size.width,
          child: PageView.builder(
            controller: _pageController,

            itemCount: 3, // number of cards
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                child: _buildToolCard(
                  index,
                  backgroundImages[index],
                  data[index],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),

        // Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            3, // number of indicators
            (index) => GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 16,
                height: 4,
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? Color(0xFF400387)
                      : Color(0xFF400387).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolCard(
    int index,
    String backgroundImag,
    Map<String, dynamic> data,
  ) {
    final days = _remainingTime!.inDays;
    final hours = _remainingTime!.inHours.remainder(24);
    final minutes = _remainingTime!.inMinutes.remainder(60);
    final seconds = _remainingTime!.inSeconds.remainder(60);

    return Container(
      // height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      child: Stack(
        children: [
          // SVG background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(backgroundImag, fit: BoxFit.cover),
            ),
          ),
          // Card content
          index == 0 && widget.campaign!.isNotEmpty
              ? Container(
                  child: Stack(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            "assets/images/giveaway_card.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/images/oraimo.png"),
                                SizedBox(width: 8),
                                Text(
                                  widget.campaign!.first.name.toString(),
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: 250,
                                    child: Text(
                                      widget.campaign!.first.title.toString(),
                                      style: GoogleFonts.baloo2(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFDCB5FF),
                                      ),
                                    ),
                                  ),
                                ),

                                CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.08,
                                  ),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.white.withOpacity(
                                      0.3,
                                    ),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Color(0xFFDEC4FF),
                                      child: Image.network(
                                        widget.campaign!.first.url.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                // SvgPicture.asset("assets/images/ear_pod.svg",height: 40,),
                              ],
                            ),
                            Container(
                              height: 90,

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
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.80),
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
                                    bottom: 0,
                                    child: GestureDetector(
                                      //ReferralContestScreen() //DrawEndPage()
                                      onTap: () {
                                        final now = DateTime.now();

                                        if (now.isAfter(
                                          widget
                                              .campaign!
                                              .first
                                              .campaignEndDate!,
                                        )) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) => DrawEndPage(),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider<CampaignCubit>(
                                                    create: (_) =>
                                                        sl<CampaignCubit>(
                                                          param1:
                                                              widget
                                                                  .campaign
                                                                  ?.first
                                                                  .id ??
                                                              0,
                                                        ),
                                                    child: ReferralContestScreen(
                                                      campaignEndDate:
                                                          widget
                                                              .campaign
                                                              ?.first
                                                              .campaignEndDate ??
                                                          DateTime.now(),
                                                    ),
                                                  ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        width: 320,

                                        child: Center(
                                          child: Text(
                                            'Join the draw',
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF2B2B2B),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    data['image'] == null
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              // border: Border.all(color: Colors.black.withOpacity(0.08))
                            ),
                            child: Center(
                              child: Text(
                                data['title'],
                                style: GoogleFonts.manrope(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(
                              12,
                            ), // Keep this if you want inner spacing
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  data['title'],
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset(
                                        data['image'],
                                        height: 85,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['name'],
                                            style: GoogleFonts.manrope(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                data['subtitle'],
                                                style: GoogleFonts.manrope(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              data['listOfImages'] != null
                                                  ? SizedBox(
                                                      height: 28,
                                                      width:
                                                          80, // adjust based on number of avatars
                                                      child: Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          _buildToolIcon(
                                                            data['listOfImages'][0],
                                                            0,
                                                          ),
                                                          _buildToolIcon(
                                                            data['listOfImages'][1],
                                                            20,
                                                          ),
                                                          _buildToolIcon(
                                                            data['listOfImages'][2],
                                                            40,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                data['listOfImages'] != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 100,

                                            decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/cheer.png",
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Awesome",
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 160,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      '10',
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Mission',
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ],
                                                ),

                                                Column(
                                                  children: [
                                                    Text(
                                                      '3',
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Coins',
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ],
                                                ),

                                                Column(
                                                  children: [
                                                    Text(
                                                      '50',
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                    Text(
                                                      'Earned',
                                                      style:
                                                          GoogleFonts.manrope(
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _timerBox(String text) {
    return Container(
      // margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF191919),
        ),
      ),
    );
  }

  Widget _buildToolIcon(String asset, double left) {
    return Positioned(
      left: left,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // white border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(asset, fit: BoxFit.cover, height: 25),
          ),
        ),
      ),
    );
  }
}
