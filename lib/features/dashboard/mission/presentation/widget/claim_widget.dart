import 'dart:ui';

import 'package:Bravoo/features/common/Mission_success.dart';
import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:Bravoo/features/common/helper.dart';
import 'package:Bravoo/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../../common/flowva_text_field.dart';
import '../../data/bloc/mission_cubit.dart';
import '../bloc/community_mission_bloc.dart';

class ReclaimMissionPopup extends StatefulWidget {
  ReclaimMissionPopup({super.key});

  @override
  State<ReclaimMissionPopup> createState() => _ReclaimMissionPopupState();
}

class _ReclaimMissionPopupState extends State<ReclaimMissionPopup>
    with UIToolMixin {
  late MissionCubit missionCubit;
  final TextEditingController emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? pickedImage;

  pickImage(ImageSource imageSource) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: imageSource);

      setState(() {
        pickedImage = pickedFile!.path;
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
    missionCubit = MissionCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommunityMissionBloc, CommunityMissionState>(
      listener: (context, upperState) {
        if (upperState is CommunityMissionLoading &&
            upperState.type == CommunityMissionType.joinMission) {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.3),
            builder: (_) => Center(
              child: Container(
                height: 400,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  backgroundColor: Color(0xff828282),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9013FE)),
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
          );
        }

        if (upperState is CommunityMissionJoined) {
          Navigator.pop(context);
          Navigator.pop(context);
          missionCubit.fetchSkillUpChallenge();
          BlocProvider.of<CommunityMissionBloc>(
            context,
          ).add(LoadCommunityMission());
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            barrierColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            builder: (_) => MissionSuccess(
              title: "Thank you for your submission. ",
              bodyText:
                  "Once we confirm it, your reward will be added to your account.",
              b_text: "Back to missions",
            ),
          );
        }
        if (upperState is CommunityMissionError &&
            upperState.type == CommunityMissionType.joinMission) {
          Navigator.pop(context);
          showMessage(
            upperState.message,
            context,
            color: Colors.red,
            styleColor: Colors.white,
            status: true,
          );
        }
      },
      builder: (context, upperState) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            StatefulBuilder(
              builder: (context, s) {
                return Dialog(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  insetPadding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(16),

                    child: SingleChildScrollView(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Close button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Here’s how to join\nthis mission",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.baloo2(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                height: 36,
                                width: 36,
                                margin: EdgeInsets.only(left: 40, bottom: 30),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(120),
                                  border: Border.all(
                                    width: 0.2,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedCancel01,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Image.asset(
                                "assets/images/verticalProgress3.png",
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  children: [
                                    // Step 1
                                    _buildStep(
                                      number: "1",
                                      title: "Create a Reclaim account",
                                      icon: Image.asset(
                                        "assets/images/reclaim_rec.png",
                                        height: 50,
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Step 2
                                    _buildStep(
                                      number: "2",
                                      title:
                                          "Connect your google calendar to Reclaim or Create your first task",
                                      icon: Image.asset(
                                        "assets/images/note.png",
                                        height: 40,
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Share a screenshot of your reclaim profile with your task with us",
                                                style: GoogleFonts.manrope(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/mission_10.png',
                                                    height: 50,
                                                  ),

                                                  SizedBox(width: 10),
                                                  Image.asset(
                                                    'assets/images/one_50.png',
                                                    width: 30,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "+50 points",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color(0xFF5F5F5F),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              AppTextFeild(
                                                controller: emailController,
                                                hintText: "Email address",
                                                validator: MultiValidator([
                                                  RequiredValidator(
                                                    errorText:
                                                        "Email is required",
                                                  ),
                                                  EmailValidator(
                                                    errorText:
                                                        "Invalid email address",
                                                  ),
                                                ]).call,
                                              ),

                                              SizedBox(height: 12.h),
                                              GestureDetector(
                                                onTap: () => pickImage(
                                                  ImageSource.gallery,
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF9F9F9),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    border: Border.all(
                                                      color: Color(0xFFFE9E9E9),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        pickedImage != null
                                                            ? '${shortenFileName(p.basename(pickedImage!))}'
                                                            : "Upload screenshot",
                                                        style:
                                                            GoogleFonts.manrope(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                      HugeIcon(
                                                        icon: HugeIcons
                                                            .strokeRoundedImageCrop,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Claim Prize button
                          GetUtils.isEmail(emailController.text.trim()) &&
                                  pickedImage != null
                              ? FlowvaButton.blueButton(
                                  name: "Complete mission",
                                  apply: () {
                                    /*  BlocProvider.of<CommunityMissionBloc>(
                                      context,
                                    ).add(
                                      JoinCommunityMission(
                                        imageUrl: pickedImage,
                                        missionId: upperState.mission?.id ?? 0,
                                      ),
                                    );*/
                                    /*missionCubit.saveAndUpdateSkillUp({
                                        "title": "Reclaim mission",
                                        "user_id": SessionManager().userIdVal,
                                        "image_url": pickedImage,
                                        "completed": true,
                                      });*/
                                  },
                                )
                              : SizedBox(
                                  height: 60,
                                  child: FlowvaButton.inactiveButton(
                                    name: "Complete mission",
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required Widget icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          icon,
        ],
      ),
    );
  }
}
