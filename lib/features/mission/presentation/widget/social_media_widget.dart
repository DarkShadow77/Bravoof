import 'dart:ui';

import 'package:flowva/features/common/Mission_success.dart';
import 'package:flowva/features/common/custom_success.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/common/helper.dart';
import 'package:flowva/features/common/ui_tool_mixin/ui_tool_mixin.dart';
import 'package:flowva/features/mission/data/bloc/mission_cubit.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as p;

class SocialMediaWidget extends StatefulWidget {
 String? title;
 String? text1;
 String? text2;
 String? link;
 SocialMediaWidget({this.title,this.text1,this.link,this.text2,super.key});

  @override
  State<SocialMediaWidget> createState() => _SocialMediaWidgetState();
}

class _SocialMediaWidgetState extends State<SocialMediaWidget> with UIToolMixin{
  final email=TextEditingController();
  late MissionCubit missionCubit;
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
    missionCubit=MissionCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MissionCubit, MissionState>(
      bloc: missionCubit,
      listener: (context, state) {
        if (state is MissionUpdateLoading) {
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
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF9013FE),
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
            ),
          );
        }

        if (state is MissionUpdated) {
          Navigator.pop(context);
          Navigator.pop(context);
          missionCubit.fetchSkillUpChallenge();
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
              bodyText: "Once we confirm it, your reward will be added to your account.",
              b_text: "Back to missions",
            ),
          );


        }
        if (state is MissionFailed) {
          Navigator.pop(context);
          showMessage(
            state.err,
            context,
            color: Colors.red,
            styleColor: Colors.white,
            status: true,
          );
        }
      },

      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          StatefulBuilder(
              builder: (context,s) {
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
                                widget.title.toString(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.baloo2(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 100,),
                              Container(
                                height: 36,
                                width: 36,

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
                                  icon: HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Image.asset("assets/images/verticalProgress3.png"),
                              SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  children: [
                                    // Step 1
                                    Container(
                                      height:100,
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: RichText(
                                          text:TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: widget.text1,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:widget.link,
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF9013FE),
                                                  ),
                                                ),

                                              ]
                                          ),

                                        )
                                    ),



                                    const SizedBox(height: 16),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        widget.text2.toString(),
                                        style: GoogleFonts.manrope(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),

                                    ),


                                    const SizedBox(height: 16),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Share a screenshot of the answer with us",
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
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: Color(0xFF5F5F5F),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              const SizedBox(height: 12),


                                              GestureDetector(
                                                onTap: ()=>pickImage(ImageSource.gallery),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF9F9F9),
                                                    borderRadius: BorderRadius.circular(8),
                                                    border: Border.all(color: Color(0xFFFE9E9E9)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        pickedImage!=null? '${shortenFileName( p.basename(pickedImage!), maxLength: 12)}' :"Upload screenshot",
                                                        style: GoogleFonts.manrope(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      HugeIcon(icon: HugeIcons.strokeRoundedImageCrop),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Claim Prize button
                          pickedImage!=null? FlowvaButton.blueButton(
                              name: "Mission complete",
                              apply: () {
                                missionCubit.saveAndUpdateSkillUp(
                                    {
                                      "title": widget.title,
                                      "user_id": SessionManager().userIdVal,
                                      "image_url":pickedImage,
                                      "completed":true
                                    }
                                );


                              }

                          ):FlowvaButton.inactiveButton(
                              name: "Mission complete"
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }


}
