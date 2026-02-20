import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../app/styles/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../utility/ui_tool_mix.dart';

class DiscoverPerks extends StatefulWidget {
  DiscoverPerks({super.key});

  @override
  State<DiscoverPerks> createState() => _DiscoverPerksState();
}

class _DiscoverPerksState extends State<DiscoverPerks> with UIToolMixin {
  final _pageController = PageController(viewportFraction: 1, initialPage: 0);

  double _currentPage = 0;
  int currentPage = 0;

  List perks = [
    {
      "discount": 20,
      "title": "Enjoy Pro Access to Jotform",
      "valid": "Valid for 1 Year",
      "color": Color(0xffFF6100).withValues(alpha: .48),
      "image": "assets/images/jotform.png",
      "link": "https://www.jotform.com/ai/agents/?partner=flowvahub-WOAEEuoEob",
    },
    {
      "discount": 20,
      "title": "Enjoy Pro Access to Reclaim",
      "valid": "Valid for 3 Year",
      "color": Color(0xff5263F3).withValues(alpha: .48),
      "image": "assets/images/reclaim_trans.png",
      "link": "https://go.reclaim.ai/8dk5zw39uhfg-0titjs",
    },
    /*{
      "discount": 10,
      "title": "Enjoy Pro Access to Ad Creative AI",
      "valid": "Valid forever",
      "color": Color(0xff000A3A).withValues(alpha: .48),
      "image": "assets/images/perk_stack.png",
      "link": "https://go.reclaim.ai/8dk5zw39uhfg-0titjs",
    },*/
  ];

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  Future<void> openLink(String link) async {
    if (!link.startsWith('http')) {
      link = 'https://$link';
    }
    final uri = Uri.parse(link);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      showMessage(
        "Could not launch",
        context,
        color: Colors.red,
        styleColor: Colors.white,
        status: true,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170.h,
          child: PageView.builder(
            padEnds: true,
            controller: _pageController,
            physics: BouncingScrollPhysics(),

            allowImplicitScrolling: true,
            scrollDirection: Axis.horizontal,
            itemCount: perks.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              double scaleFactor = .8;
              double height = 130.h;
              Matrix4 matrix = Matrix4.identity();

              if (index == _currentPage.floor()) {
                var currScale = 1 - (_currentPage - index) * (1 - scaleFactor);
                var currTrans = height * (1 - currScale) / 2;
                matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                  ..setTranslationRaw(0, currTrans, 0);
              } else if (index == _currentPage.floor() + 1) {
                var currScale =
                    scaleFactor +
                    (_currentPage - index + 1) * (1 - scaleFactor);

                var currTrans = height * (1 - currScale) / 2;
                matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                  ..setTranslationRaw(0, currTrans, 0);
              } else if (index == _currentPage.floor() - 1) {
                var currScale = 1 - (_currentPage - index) * (1 - scaleFactor);
                var currTrans = height * (1 - currScale) / 2;
                matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                  ..setTranslationRaw(0, currTrans, 0);
              } else {
                var currScale = .8;
                matrix = Matrix4.diagonal3Values(1.0, currScale, 1.0)
                  ..setTranslationRaw(0, height * (1 - scaleFactor) / 2, 0);
              }

              final perk = perks[index];
              return Transform(
                transform: matrix,
                child: Container(
                  height: 170.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 20.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                          ),
                          Container(
                            width: 20.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6.w,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 170.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    spacing: 8.w,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: "Discover Perks Made for You",
                                          style: TextStyles.smallCardSemibold8(
                                            context,
                                          ).copyWith(color: AppColors.grey400),
                                        ),
                                      ),
                                      Column(
                                        spacing: 4.h,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  "Claim ${perk["discount"]}% OFF",
                                              style:
                                                  TextStyles.bodyRegular16(
                                                    context,
                                                  ).copyWith(
                                                    height: 1.h,
                                                    fontFamily: AppFonts.baloo,
                                                  ),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "${perk["title"]}",
                                              style:
                                                  TextStyles.cardSemibold10(
                                                    context,
                                                  ).copyWith(
                                                    color: AppColors.grey550,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: "${perk["valid"]}",
                                          style: TextStyles.smallCardSemibold8(
                                            context,
                                          ).copyWith(color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconTextButton(
                                    height: 33,
                                    textSize: 11,
                                    text: "Redeem offer",
                                    color: AppColors.black,
                                    textColor: AppColors.white,
                                    onPressed: () => openLink(perk["link"]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 170.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: perk["color"],
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Image.asset(
                                  perk["image"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        // Page Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            perks.length,
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
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                width: index == currentPage ? 18.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: index == currentPage
                      ? AppColors.darkPrimary
                      : AppColors.darkPrimary20,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
