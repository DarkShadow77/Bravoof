import 'dart:developer';
import 'dart:io';

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
  List<Map<String, dynamic>> selected = [];
  Set<String> selectedOption1 = {};
  Set<String> selectedOption2 = {};

  final _usernameController = TextEditingController();

  final _pageController = PageController(initialPage: 0);
  final ImagePicker _picker = ImagePicker();
  UserProfile profile = UserProfile.empty();
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
  Country country = Country(
    name: "United States",
    flag: "🇺🇸",
    isoCode: "US",
    currency: "USD",
    phoneCode: "+1",
    longitude: "-97.00000000",
    latitude: "38.00000000",
  );

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
        color: Colors.white,
        styleColor: Colors.black,
        iconColor: Colors.red,
        status: true,
      );
    }

    if (currentPage == 2) {
      if (selectedToConvert == null && pickedImage == null) {
        return showMessage(
          "Add or select an image to continue",
          context,
          color: Colors.white,
          styleColor: Colors.black,
          iconColor: Colors.red,
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
              },
            ),
          ),
        );
      } /*on TimeoutException catch (e) {
        log("Timeout error in _proceedToOnboard: $e");
        showMessage(
          "File processing took too long. Please try again.",
          context,
          status: true,
        );
      } */ on FileSystemException catch (e) {
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (currentPage == 0) {
            _pageController.previousPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
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
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: List.generate(
                                3,
                                (index) => GestureDetector(
                                  onTap: () => _pageController.previousPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  ),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width: 60,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: index == currentPage
                                          ? AppColors.black
                                          : AppColors.black20,
                                      borderRadius: BorderRadius.circular(3),
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
                          controller: _pageController,
                          itemCount: 3,
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
            SizedBox(height: 20),
            // Title
            Text(
              "Whats your main goal?",
              style: GoogleFonts.dmSans(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select at least one to tailor your workspace.",
              style: GoogleFonts.dmSans(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options1.length,
                padding: EdgeInsets.only(bottom: 120),
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
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.white50,
                        borderRadius: BorderRadius.circular(16),
                        border: selectedOption1.contains(e["label"])
                            ? Border.all(width: 1, color: Colors.purple)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black10,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(e["icon"]),
                          const SizedBox(height: 12),
                          Text(
                            e["label"],
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ); // Your actual widgets

      case 1:
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 0),
          children: [
            SizedBox(height: 20),
            Text(
              "What should we call you?",
              style: GoogleFonts.dmSans(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter the name you would like to go by.",
              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 40),

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
                onEditingComplete: () {
                  selected.add({'username': _usernameController.text});
                },
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
                            padding: const EdgeInsets.all(12.0),
                            // optional padding
                            child: Image.asset("assets/images/clear_text.png"),
                          ),
                        ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        );
      case 2:
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 0),
          children: [
            const SizedBox(height: 20),
            Text(
              "Choose how you show up",
              style: GoogleFonts.manrope(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Pick your look: avatar or photo",
              style: GoogleFonts.manrope(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 32),
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
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      avatars[selectedAvatar!],
                      fit: BoxFit.contain,
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
                    child: Image.file(File(pickedImage!), fit: BoxFit.contain),
                  )
                : Container(
                    height: 126.r,
                    width: 126.r,
                    padding: EdgeInsets.all(30),
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
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedUser03,
                      strokeWidth: 1.5,
                    ),
                  ),

            const SizedBox(height: 24),

            // Camera and Gallery buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _optionButton(
                  SvgPicture.asset("assets/images/camera-01.svg"),
                  "Camera",
                  apply: () {
                    pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(width: 20),
                _optionButton(
                  SvgPicture.asset("assets/images/gallery.svg"),
                  "Gallery",
                  apply: () {
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select an Avatar",
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),

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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 20,
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
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF7C4DFF),
                                width: 2,
                              )
                            : null,
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: const Color(
                                0xFF7C4DFF,
                              ).withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(avatars[index], fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40),
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
        width: 120,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.white50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.black10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
