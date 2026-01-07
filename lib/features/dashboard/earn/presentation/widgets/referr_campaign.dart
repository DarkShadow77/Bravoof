import 'dart:async';

import 'package:flowva/features/dashboard/earn/presentation/pages/referral_contest_screen.dart';
import 'package:flowva/features/dashboard/home/data/model/campaign_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../home/presentation/bloc/campaign_cubit.dart';
import 'draw_end_page.dart';

class ReferCampaign extends StatefulWidget {
  List<CampaignModel> campaign = [];
  ReferCampaign({super.key, required this.campaign});

  @override
  State<ReferCampaign> createState() => _ReferCampaignState();
}

class _ReferCampaignState extends State<ReferCampaign> {
  Timer? _timer;
  Duration? _remainingTime;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    if (widget.campaign.isNotEmpty) {
      _remainingTime = Duration(
        days: widget.campaign.first.campaignEndDate!.day,
        hours: widget.campaign.first.campaignEndDate!.hour,
        minutes: widget.campaign.first.campaignEndDate!.minute,
        seconds: widget.campaign.first.campaignEndDate!.second,
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

  @override
  Widget build(BuildContext context) {
    final days = _remainingTime!.inDays;
    final hours = _remainingTime!.inHours.remainder(24);
    final minutes = _remainingTime!.inMinutes.remainder(60);
    final seconds = _remainingTime!.inSeconds.remainder(60);
    return Container(
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/oraimo.png"),
                    SizedBox(width: 8),
                    Text(
                      widget.campaign.first.name.toString(),
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
                      backgroundColor: Colors.white.withOpacity(0.08),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white.withOpacity(0.3),
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
                              widget.campaign.first.campaignEndDate!,
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
                                  builder: (_) => BlocProvider<CampaignCubit>(
                                    create: (_) => sl<CampaignCubit>(
                                      param1: widget.campaign.first.id ?? 0,
                                    ),
                                    child: ReferralContestScreen(
                                      campaignEndDate:
                                          widget
                                              .campaign
                                              .first
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
                              borderRadius: BorderRadius.circular(50),
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
}
