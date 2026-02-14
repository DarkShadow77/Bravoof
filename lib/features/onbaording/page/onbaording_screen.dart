import 'package:Bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:Bravoo/features/onbaording/widget/first_screen.dart';
import 'package:Bravoo/features/onbaording/widget/second_screen.dart';
import 'package:Bravoo/features/onbaording/widget/third_screen.dart';
import 'package:Bravoo/utility/ui_tool_mix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/app_colors.dart';
import '../../auth/presentation/widget/authentication_modal.dart';

class OnboardingScreen extends StatefulWidget {
  // OnboardingScreen({super.key})
  var routeName = "/";

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with UIToolMixin {
  final PageController _pageController = PageController(initialPage: 0);

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [FirstScreen(), SecondScreen(), ThirdScreen()],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0x11111114),
                    // Use a clean light grey background
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // Optional: soften corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: Row(
                    spacing: 6.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: currentPage == index ? 18.w : 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? Colors.black
                              : Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: IconTextButton(
                height: 56,
                text: "Get started",
                onPressed: () async {
                  _pageController.page == 2
                      ? authenticationModal()
                      : _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                },
                color: AppColors.black,
                textColor: AppColors.white,
              ),
            ),
            SizedBox(height: 10.h + MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }
}
