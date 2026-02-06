import 'dart:developer';
import 'dart:io';

import 'package:Bravoo/features/common/app_enum.dart';
import 'package:Bravoo/features/common/data/constants.dart';
import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:Bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:Bravoo/features/onbaording/data/bloc/user_cubit.dart';
import 'package:Bravoo/features/onbaording/data/model/user_profile.dart';
import 'package:Bravoo/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../otp/presentation/verify_otp_page.dart';
import 'data/convert_asset_file.dart';
import 'data/data.dart';

class OnbaordSecondStage extends StatefulWidget {
  Map<String, dynamic>? data;

  OnbaordSecondStage({this.data, super.key});

  @override
  State<OnbaordSecondStage> createState() => _OnbaordSecondStageState();
}

class _OnbaordSecondStageState extends State<OnbaordSecondStage>
    with UIToolMixin {
  ValueNotifier<bool> isSending = ValueNotifier(false);
  List<String> goals = [];
  List<String> selectedTools = [];
  List<Map<String, dynamic>> selected = [];
  String? selectedOption;
  late UserCubit userCubit;
  Set<String> selectedOption1 = {};
  Set<String> selectedOption2 = {};
  List<Map<String, dynamic>> sortedTeck = [];
  List<Map<String, dynamic>> tecky = [];
  List<Map<String, dynamic>> sortedTools = [];
  List<Map<String, dynamic>> tools = [];

  final username = TextEditingController();
  final _pageController = PageController(initialPage: 0);
  final ImagePicker _picker = ImagePicker();
  UserProfile profile = UserProfile.empty();
  String? pickedImage;
  int currentPage = 0;
  String? selectedToConvert;
  bool _isTapped = false;
  int? selectedAvatar;
  final colors = [
    Color(0xFFF9E2D1),
    Color(0xFFFECBD7),
    Color(0xFFC0E9FC),
    Color(0xFFBAF0C2),

    Color(0xFFFFD69F),
    Color(0xFFD6CBFB),
    Color(0xFFD4D3D5),
    Color(0xFFBAF0C2),

    Color(0xFFFFE69D),
    Color(0xFFFFC0CD),
    Color(0xFFE2E8EB),
    Color(0xFFFFE69D),
    Color(0xFFC0E9FC),
    Color(0xFFD0BDB5),
  ];
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

  @override
  void initState() {
    sortedTeck = options2;
    tecky = options2;
    sortedTools = options3;
    tools = options3;
    username.addListener(() {
      setState(() {}); // rebuild whenever text changes
    });
    userCubit = UserCubit();
    super.initState();

    intiData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    username.dispose();
    super.dispose();
  }

  intiData() async {
    profile = UserProfile.fromJson(await Constants().getUser());
    username.text = profile.name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar:
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
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
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.06),

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
                      SizedBox(width: 60),
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
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
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
                    itemCount: 5,
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
                            value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                          }

                          return Opacity(
                            opacity: value,
                            child: Transform.scale(scale: value, child: child),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: MyPageContent(
                            index,
                          ), // Replace this with actual page UI
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocListener<UserCubit, UserState>(
              bloc: userCubit,
              listener: (context, state) {
                if (state is UserLoading) {
                  setState(() {
                    isSending.value = true;
                  });
                }

                if (state is UserSuccess) {
                  setState(() {
                    isSending.value = false;
                  });
                  showMessage(
                    "An email has been sent to your email address",
                    context,
                    color: Colors.green,
                    styleColor: Colors.white,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerifyOtpPage()),
                  );
                  SessionManager().firstTimeUserVal = "YES";
                } else if (state is UserFailure) {
                  setState(() {
                    isSending.value = false;
                  });
                  showMessage(
                    state.error,
                    context,
                    color: Colors.white,
                    styleColor: Colors.black,
                    status: true,
                  );
                }
              },
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: isSending,

                  builder: (context, val, _) {
                    print(val);
                    return FlowvaButton.blueButton(
                      buttonState: val
                          ? AppButtonState.loading
                          : AppButtonState.idle,
                      name: "Looks good,next",
                      apply: () async {
                        log(
                          "Sign Up Data ${widget.data}, Referral Code ${widget.data!['referral_code']}",
                        );
                        if (currentPage == 1 && username.text.isEmpty)
                          return showMessage(
                            "Please Choose a user name to continue",
                            context,
                            color: Colors.white,
                            styleColor: Colors.black,
                            iconColor: Colors.red,
                            status: true,
                          );
                        if (currentPage == 2) {
                          if (selectedToConvert == null && pickedImage == null)
                            return showMessage(
                              "Add or select an image to continue",
                              context,
                              color: Colors.white,
                              styleColor: Colors.black,
                              iconColor: Colors.red,
                              status: true,
                            );
                          else {
                            final profile = UserProfile.empty();
                            userCubit.signup(
                              userProfile: profile.copyWith(
                                name: username.text,
                                email: widget.data!['email'],
                                referralCode: widget.data!['referral_code'],
                                pass: widget.data!['pass'],
                                isLogin: widget.data!['isLogin'],
                                goals: goals,
                                profilePic: selectedAvatar != null
                                    ? await assetToFile(selectedToConvert!)
                                    : pickedImage,
                              ),
                            );
                          }
                        } else {
                          setState(() {
                            _isTapped = true;
                          });
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                          Future.delayed(
                            Duration(milliseconds: 200),
                            () => setState(() {
                              _isTapped = false;
                            }),
                          );
                        }
                      },
                      isTapped: _isTapped,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
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
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: selectedOption1.contains(e["label"])
                            ? Border.all(width: 0.5, color: Colors.purple)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextFormField(
                controller: username,
                onEditingComplete: () {
                  selected.add({'username': username.text});
                },
                validator: RequiredValidator(
                  errorText: "Please This field is required",
                ).call,
                onFieldSubmitted: (v) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: "",
                  border: InputBorder.none,

                  suffixIcon: username.text.isEmpty
                      ? null
                      : GestureDetector(
                          onTap: () {
                            username.clear(); // clear the text
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
                          color: Colors.black.withOpacity(0.08),
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
                color: Colors.white.withOpacity(0.6),
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
                              color: const Color(0xFF7C4DFF).withOpacity(0.3),
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
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
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
