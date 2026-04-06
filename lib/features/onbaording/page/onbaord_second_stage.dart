import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bravoo/app/styles/text_styles.dart';
import 'package:bravoo/app/view/widgets/button/icon_text_button.dart';
import 'package:bravoo/features/common/data/constants.dart';
import 'package:bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:bravoo/features/dashboard/profile/data/model/user_profile.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/view/widgets/bottom_modals/country_state_modal.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/convert_asset_file.dart';
import '../../auth/presentation/page/verify_otp_page.dart';
import '../data/model/data.dart';

class OnboardSecondStage extends StatefulWidget {
  final Map<String, dynamic> data;

  OnboardSecondStage({required this.data, super.key});

  @override
  State<OnboardSecondStage> createState() => _OnboardSecondStageState();
}

class _OnboardSecondStageState extends State<OnboardSecondStage>
    with UIToolMixin {
  List<String> goals = [];
  Set<String> selectedOption1 = {};
  Set<String> selectedOption2 = {};

  final _usernameController = TextEditingController();
  final _cityController = TextEditingController();

  final _pageController = PageController(initialPage: 0);
  final ImagePicker _picker = ImagePicker();
  UserProfile profile = UserProfile.empty();

  String? selectedCity;
  String? pickedImage;
  int currentPage = 0;
  String? selectedToConvert;
  int? selectedAvatar;
  final avatars = [
    "assets/avatar/1.png",
    "assets/avatar/2.png",
    "assets/avatar/3.png",
    "assets/avatar/4.png",
    "assets/avatar/5.png",
    "assets/avatar/6.png",
    "assets/avatar/7.png",
    "assets/avatar/8.png",
    "assets/avatar/9.png",
    "assets/avatar/10.png",
    "assets/avatar/11.png",
    "assets/avatar/12.png",
    "assets/avatar/13.png",
    "assets/avatar/14.png",
    "assets/avatar/15.png",
  ];

  List<Country> countriesList = [];
  Country? country;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {}); // rebuild whenever text changes
    });
    intiData();
    getCountries();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  intiData() async {
    profile = UserProfile.fromJson(await Constants().getUser());
    _usernameController.text = profile.name;
  }

  Future<void> getCountries() async {
    countriesList = await getAllCountries();
    setState(() {});
  }

  pickImage(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: imageSource);
      setState(() {
        pickedImage = pickedFile!.path;
        selectedAvatar = null;
      });
    } catch (e) {
      print(e);
      setState(() {
        // _pickImageError = e;
      });
    }
  }

  _proceedToOnboard() async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (currentPage == 1 && _usernameController.text.isEmpty) {
      return showMessage(
        "Please Choose a user name to continue",
        context,
        status: true,
      );
    }

    if (currentPage == 2) {
      if (country == null) {
        return showMessage("Please select your country", context, status: true);
      }
      if (selectedCity == null || selectedCity!.trim().isEmpty) {
        return showMessage("Please enter your city", context, status: true);
      }
    }

    if (currentPage == 3) {
      if (selectedToConvert == null && pickedImage == null) {
        return showMessage(
          "Add or select an image to continue",
          context,
          status: true,
        );
      }

      try {
        String? profilePic;

        if (selectedAvatar != null) {
          // Converting asset to file
          print('Converting asset to file: $selectedToConvert');
          profilePic = await assetToFile(selectedToConvert!);
          print('Asset converted successfully: $profilePic');
        } else if (pickedImage != null) {
          // Using picked image directly
          print('Using picked image: $pickedImage');
          profilePic = pickedImage;
        }

        if (profilePic == null) {
          throw Exception('No profile picture available');
        }

        // Verify file exists
        final file = File(profilePic);
        if (!await file.exists()) {
          throw Exception('Profile picture file does not exist');
        }

        print('Profile picture ready: $profilePic');

        if (!mounted) return;

        // Navigate to verify OTP page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpPage(
              data: {
                "name": _usernameController.text,
                "email": widget.data['email'],
                "referral_code": widget.data['referral_code'],
                "pass": widget.data['pass'],
                "goals": goals,
                "profilePic": profilePic,
                "country": country!.name,
                "city": selectedCity ?? "",
                "flag":
                    "https://flagcdn.com/${country!.isoCode.toLowerCase()}.svg",
                "country_code": "+${country!.phoneCode}",
                "country_code_iso2": country!.isoCode,
                "country_code_iso3": "",
              },
            ),
          ),
        );
      } on TimeoutException catch (e) {
        log("Timeout error in _proceedToOnboard: $e");
        showMessage(
          "File processing took too long. Please try again.",
          context,
          status: true,
        );
      } on FileSystemException catch (e) {
        log("File system error in _proceedToOnboard: $e");
        showMessage(
          "Could not save profile picture. Please try again.",
          context,
          status: true,
        );
      } catch (e, stackTrace) {
        log("Error in _proceedToOnboard: $e");
        log("Stack trace: $stackTrace");
        showMessage(
          "Something went wrong: ${e.toString()}",
          context,
          status: true,
        );
      }
    } else {
      _pageController.nextPage(
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentPage == 0,
      onPopInvokedWithResult: (canPop, result) {
        if (!canPop) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar:
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // PageView and content (scrollable area)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h + MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.black05,
                              child: GestureDetector(
                                onTap: () {
                                  _pageController.page == 0
                                      ? Navigator.pop(context)
                                      : _pageController.previousPage(
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.easeInOut,
                                        );
                                },
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowLeft02,
                                  color: Colors.black,
                                  size: 18.sp,
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(
                                4,
                                (index) => GestureDetector(
                                  onTap: () => _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  ),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    width: 50.w,
                                    height: 4.h,
                                    decoration: BoxDecoration(
                                      color: index == currentPage
                                          ? AppColors.black
                                          : AppColors.black20,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: 0,
                              child: CircleAvatar(
                                backgroundColor: AppColors.black05,
                                child: HugeIcon(
                                  icon: HugeIcons.strokeRoundedArrowLeft02,
                                  color: Colors.black,
                                  size: 18.sp,
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 20),
                      Expanded(
                        child: PageView.builder(
                          itemCount: 4,
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double value = 1.0;
                                if (_pageController.position.haveDimensions) {
                                  value = _pageController.page! - index;
                                  value = (1 - (value.abs() * 0.3)).clamp(
                                    0.0,
                                    1.0,
                                  );
                                }
                                return Opacity(
                                  opacity: value,
                                  child: Transform.scale(
                                    scale: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: MyPageContent(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Fixed button on top of scroll
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: IconTextButton(
                    onPressed: () => _proceedToOnboard(),
                    height: 56,
                    text: "Looks good",
                    color: AppColors.black,
                    textColor: AppColors.white,
                  ),
                ),
                SizedBox(
                  height: 20.h + MediaQuery.of(context).viewPadding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyPageContent(int index) {
    print(index);
    switch (index) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                text: "Whats your main goal?",
                style: TextStyles.titleSemiBold20(
                  context,
                ).copyWith(fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ),
            SizedBox(height: 8.h),
            RichText(
              text: TextSpan(
                text: "Select at least one to tailor your workspace.",
                style: TextStyles.normalRegular14(
                  context,
                  opacity: .5,
                ).copyWith(fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ),
            SizedBox(height: 20.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options1.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final e = options1[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedOption1.contains(e["label"])) {
                          selectedOption1.remove(e["label"]);
                          goals.remove(e['label']);
                        } else {
                          selectedOption1.add(e["label"]);
                          goals.add(e['label']);
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.white50,
                        borderRadius: BorderRadius.circular(16.r),
                        border: selectedOption1.contains(e["label"])
                            ? Border.all(width: 1, color: Colors.purple)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black10,
                            blurRadius: 8.r,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            e["icon"],
                            width: 60.w,
                            height: 60.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 12.h),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: e["label"],
                              style: TextStyles.normalRegular14(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      case 1:
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 0),
          children: [
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                text: "What should we call you?",
                style: TextStyles.titleSemiBold20(
                  context,
                ).copyWith(fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ),
            SizedBox(height: 8.h),
            RichText(
              text: TextSpan(
                text: "Enter the name you would like to go by.",
                style: TextStyles.normalRegular14(
                  context,
                  opacity: .5,
                ).copyWith(fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ),
            SizedBox(height: 40.h),
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.black03,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black05,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: _usernameController,
                validator: RequiredValidator(
                  errorText: "Please This field is required",
                ).call,
                onFieldSubmitted: (v) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: "",
                  border: InputBorder.none,
                  suffixIcon: _usernameController.text.isEmpty
                      ? null
                      : GestureDetector(
                          onTap: () {
                            _usernameController.clear(); // clear the text
                          },
                          child: Padding(
                            padding: EdgeInsets.all(12.r),
                            // optional padding
                            child: Image.asset("assets/images/clear_text.png"),
                          ),
                        ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                ),
              ),
            ),
          ],
        );
      case 2:
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                text: "Select your location",
                style: TextStyles.titleSemiBold20(
                  context,
                ).copyWith(fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ),
            SizedBox(height: 8.h),
            RichText(
              text: TextSpan(
                text: "Select your city and country from the drop down",
                style: TextStyles.normalRegular14(
                  context,
                  opacity: .5,
                ).copyWith(fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () {
                getCountries();
                countryStateModal(
                  title: "Country",
                  isPhone: false,
                  onPressed: (value) {
                    setState(() => country = value);
                  },
                  list: countriesList,
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.black03,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  children: [
                    if (country?.flag != null)
                      RichText(
                        text: TextSpan(
                          text: country!.flag,
                          style: TextStyles.titleRegular20(context),
                        ),
                      ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: country?.name ?? "Select a country",
                          style: TextStyles.normalRegular14(context).copyWith(
                            color: country == null
                                ? AppColors.black40
                                : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18.sp,
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.black03,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TextFormField(
                controller: _cityController,
                onChanged: (v) => setState(() => selectedCity = v),
                style: TextStyles.normalRegular14(context),
                decoration: InputDecoration(
                  hintText: "Enter your city",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                  hintStyle: TextStyles.normalRegular14(
                    context,
                  ).copyWith(color: AppColors.black40),
                ),
              ),
            ),
          ],
        );
      case 3:
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 0),
          children: [
            SizedBox(height: 20.h),
            RichText(
              text: TextSpan(
                text: "Choose how you show up",
                style: TextStyles.titleSemiBold20(
                  context,
                ).copyWith(fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ),
            SizedBox(height: 8.h),
            RichText(
              text: TextSpan(
                text: "Pick your look: avatar or photo",
                style: TextStyles.normalRegular14(
                  context,
                  opacity: .5,
                ).copyWith(fontFamily: GoogleFonts.dmSans().fontFamily),
              ),
            ),
            SizedBox(height: 32.h),
            // Profile placeholder
            selectedAvatar != null
                ? Container(
                    height: 126.r,
                    width: 126.r,
                    decoration: BoxDecoration(
                      color: AppColors.white50,
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(100),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Center(
                      child: Image.asset(
                        avatars[selectedAvatar!],
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : pickedImage != null
                ? Container(
                    height: 126.r,
                    width: 126.r,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.white50,
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Image.file(
                        File(pickedImage!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Container(
                    height: 126.r,
                    width: 126.r,
                    padding: EdgeInsets.all(30.r),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.white50,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black10,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedUser03,
                        size: 40.sp,
                        strokeWidth: 1.5,
                      ),
                    ),
                  ),
            SizedBox(height: 24.h),
            // Camera and Gallery buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _optionButton(
                  SvgPicture.asset(
                    "assets/images/camera-01.svg",
                    width: 25.w,
                    height: 25.h,
                    fit: BoxFit.contain,
                  ),
                  "Camera",
                  apply: () {
                    pickImage(ImageSource.camera);
                  },
                ),
                SizedBox(width: 20.w),
                _optionButton(
                  SvgPicture.asset(
                    "assets/images/gallery.svg",
                    width: 25.w,
                    height: 25.h,
                    fit: BoxFit.contain,
                  ),
                  "Gallery",
                  apply: () {
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Select an Avatar",
                  style: TextStyles.bodySemiBold16(context),
                ),
              ),
            ),
            SizedBox(height: 14.h),
            // Avatar grid
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white60,
                borderRadius: BorderRadius.circular(16),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: avatars.length,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 20.h,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedAvatar == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedAvatar = index);
                      pickedImage = null;
                      selectedToConvert = avatars[index];
                    },
                    child: Container(
                      width: 52.r,
                      height: 52.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF7C4DFF),
                                width: 2.w,
                              )
                            : null,
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: const Color(
                                0xFF7C4DFF,
                              ).withValues(alpha: 0.3),
                              blurRadius: 8.w,
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Center(
                          child: Image.asset(avatars[index], fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _optionButton(Widget icon, String label, {required Function() apply}) {
    return GestureDetector(
      onTap: apply,
      child: Container(
        width: 120.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: AppColors.white50,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.black10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(height: 6.h),
            RichText(
              text: TextSpan(
                text: label,
                style: TextStyles.cardMedium10(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
