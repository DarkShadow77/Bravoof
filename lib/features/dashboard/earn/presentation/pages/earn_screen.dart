import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/flowva_colors.dart';
import 'package:flowva/features/common/model/campaign_response.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/earn_overview_screen.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/history.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/mission_hub.dart';
import 'package:flowva/features/dashboard/earn/presentation/widgets/redeem.dart';
import 'package:flowva/features/dashboard/home/data/bloc/home_cubit.dart';
import 'package:flowva/features/dashboard/home/widget/leader_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

class RewardScreen extends StatefulWidget {
  RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  late HomeCubit homeCubit;
  List<Campaign> campaign = [];
  var tab = [ "Redeem", "History"];
  final _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  int selectedIndex = 0;
  bool init = true;
  @override
  void initState() {
    homeCubit = HomeCubit();
    homeCubit.fetchCampaigns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          // 🔥 Gradient + soft blobs background
          // Container(child: Image.asset("assets/images/stacks.png")),

          BlocListener<HomeCubit, HomeState>(
          bloc: homeCubit,
          listener: (context, state) {
          print(state);
          if (state is CampaignLoaded) {
            setState(() {
              init = false;
            });
          campaign = state.campaignResponse.campaign!;
          }
          },

            child: init
                ? Center(
              child: Container(
                height: 400,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  backgroundColor: Color(0xff828282),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF9013FE),
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
            )
                :Container(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Redeem",
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset("assets/images/one_50.png",
                              height: 18,),
                            Text(
                              " 2,000",
                              style: GoogleFonts.baloo2(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tabs
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      height: 45,

                      width: double.infinity,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        itemCount: tab.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final isSelected2 = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedIndex = index);
                              _pageController.jumpToPage(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected2 ? Colors.white : null,
                                borderRadius: BorderRadius.circular(120),
                                border: isSelected2
                                    ? Border.all(
                                  width: 0.2,
                                  color: Colors.black.withOpacity(0.6),
                                )
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  tab[index],
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected2
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: PageView(
                      allowImplicitScrolling: false,

                      controller: _pageController,

                      onPageChanged: (index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      children: [

                        RedeemOverviewPage(campaign:campaign.first),
                        RewardsHistoryPage(),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}


