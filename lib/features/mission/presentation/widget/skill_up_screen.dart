import 'dart:async';

import 'package:flowva/features/common/app_enum.dart';
import 'package:flowva/features/common/flowva_button.dart';
import 'package:flowva/features/mission/data/bloc/mission_cubit.dart';
import 'package:flowva/features/mission/data/model/skill_up_task_response.dart';
import 'package:flowva/features/mission/presentation/widget/share_creation.dart';
import 'package:flowva/features/mission/presentation/widget/skill_up_success.dart';
import 'package:flowva/features/onbaording/data/bloc/user_cubit.dart';
import 'package:flowva/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import 'game_success.dart';

class SkillUpScreen extends StatefulWidget {
  SkillUpTask? task;

  SkillUpScreen({required this.task, super.key});

  @override
  State<SkillUpScreen> createState() => _SkillUpScreenState();
}

class _SkillUpScreenState extends State<SkillUpScreen> {
  ValueNotifier<bool> isSending1 = ValueNotifier(false);
  ValueNotifier<bool> isSending2 = ValueNotifier(false);
  ValueNotifier<bool> isSending3 = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    print(widget.task);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Flexible(
                  child: Container(
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.48),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value:  SessionManager().isCompleted1Val?5:1 / 5,
                                          minHeight: 16,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                            Color(0xFFA259FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/one_50.png",
                                          height: 15,
                                        ),
                                        Text(
                                          "10-50",
                                          style: GoogleFonts.baloo2(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 9,
                                            color: Color(0xFF9013FE),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "Mission 1",
                                  style: GoogleFonts.baloo2(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.45,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Turn Words Into Visual",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.task!.firstMission!.subject.toString(),
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xFF191919),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                SessionManager().isCompleted1Val? SizedBox(
                                  height: 60,
                                  width: 300,
                                  child: FlowvaButton.inactiveButton(
                                      name: "Begin Mission",
                                      fontSize: 14,
                                      // button_bg: Colors.grey

                                  ),
                                ):  ValueListenableBuilder(
                                    valueListenable: isSending1,
                                    builder: (context, v, _) {
                                      return FlowvaButton.mediumBlack2Button(
                                        name: "Begin Mission",
                                        fontSize: 14,
                                        buttonState: v
                                            ? AppButtonState.loading
                                            : AppButtonState.idle,
                                        apply: () {
                                          setState(() {
                                            isSending1.value = true;
                                          });
                                          Future.delayed(
                                              Duration(seconds: 3), () {
                                            setState(() {
                                              isSending1.value = false;
                                              SessionManager().isCompleted1Val=true;
                                            });

                                            SessionManager().isLastMissionVal =
                                            widget.task!.firstMission != null
                                                ? false
                                                : false;
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        ContentOne(
                                                            skillUp: widget
                                                                .task!
                                                                .firstMission!,
                                                            skillUpTask: widget
                                                                .task!)));
                                          });
                                        },
                                      );
                                    }
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.48),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: SessionManager().isCompleted2Val?5:1 / 5,
                                          minHeight: 16,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                            Color(0xFFA259FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/one_50.png",
                                          height: 15,
                                        ),
                                        Text(
                                          "50",
                                          style: GoogleFonts.baloo2(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 9,
                                            color: Color(0xFF9013FE),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "Mission 2",
                                  style: GoogleFonts.baloo2(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.45,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Visualize a Scene",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.task!.secondMission!.subject
                                      .toString(),
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xFF191919),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                SessionManager().isCompleted2Val? SizedBox(
                                  height: 60,
                                  width: 300,
                                  child: FlowvaButton.mediumBlack2Button(
                                      name: "Begin Mission",
                                      fontSize: 14,
                                      button_bg: Colors.grey

                                  ),
                                ): ValueListenableBuilder(
                                    valueListenable: isSending2,
                                    builder: (context, v, _) {
                                      return FlowvaButton.mediumBlack2Button(
                                        name: "Begin Mission",
                                        fontSize: 14,
                                        buttonState: v
                                            ? AppButtonState.loading
                                            : AppButtonState.idle,
                                        apply: () {
                                          setState(() {
                                            isSending2.value = true;
                                          });
                                          Future.delayed(
                                              Duration(seconds: 3), () {
                                            setState(() {
                                              isSending1.value = false;
                                              SessionManager().isCompleted2Val=true;
                                            });
                                            SessionManager().isLastMissionVal =
                                            widget.task!.thirdMission == null
                                                ? true
                                                : false;
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                                builder: (ctx) =>
                                                    ContentOne(
                                                        skillUp: widget.task!
                                                            .secondMission!,
                                                        skillUpTask: widget
                                                            .task!)));
                                          });
                                        },
                                      );
                                    }
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        widget.task!.thirdMission != null ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.48),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: SessionManager().isCompleted3Val?5:1 / 5,
                                          minHeight: 16,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                            Color(0xFFA259FF),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/one_50.png",
                                          height: 15,
                                        ),
                                        Text(
                                          "50",
                                          style: GoogleFonts.baloo2(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 9,
                                            color: Color(0xFF9013FE),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "Mission 3",
                                  style: GoogleFonts.baloo2(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.45,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Reimagine Bravoo",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  widget.task!.thirdMission!.subject.toString(),
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xFF191919),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                SessionManager().isCompleted3Val? SizedBox(
                                  height: 60,
                                  width: 300,
                                  child: FlowvaButton.mediumBlack2Button(
                                    name: "Begin Mission",
                                    fontSize: 14,
                                      button_bg: Colors.grey

                                  ),
                                ): ValueListenableBuilder(
                                    valueListenable: isSending3,
                                    builder: (context, v, _) {
                                      return FlowvaButton.mediumBlack2Button(
                                        name: "Begin Mission",
                                        fontSize: 14,
                                        buttonState: v
                                            ? AppButtonState.loading
                                            : AppButtonState.idle,
                                        apply: () {
                                          setState(() {
                                            isSending3.value = true;
                                          });
                                          Future.delayed(
                                              Duration(seconds: 3), () {
                                            setState(() {
                                              isSending3.value = false;
                                              SessionManager().isCompleted2Val=true;
                                            });
                                            SessionManager().isLastMissionVal =
                                            widget.task!.thirdMission != null
                                                ? true
                                                : false;
                                            Navigator.push(
                                                context, MaterialPageRoute(
                                                builder: (ctx) =>
                                                    ContentOne(
                                                        skillUp: widget.task!
                                                            .thirdMission!,
                                                        skillUpTask: widget
                                                            .task!)));
                                          });
                                        },
                                      );
                                    }
                                ),
                              ],
                            ),
                          ),
                        ) : Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

    );
  }
}

class ContentOne extends StatelessWidget {
  final SkillUp skillUp;
  final SkillUpTask skillUpTask;

  ContentOne({required this.skillUp, required this.skillUpTask, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 2),
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.48),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 3 / 5,
                              minHeight: 16,
                              backgroundColor: Colors.grey[200],
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                Color(0xFFA259FF),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/one_50.png",
                              height: 15,
                            ),
                            Text(
                              "10-50",
                              style: GoogleFonts.baloo2(
                                fontWeight: FontWeight.w700,
                                fontSize: 9,
                                color: Color(0xFF9013FE),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      "📚 Learn the Basics",
                      style: GoogleFonts.baloo2(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.45,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      skillUp.contentOne!.title.toString(),
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      skillUp.contentOne!.content.toString(),
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF191919),
                        height: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    FlowvaButton.mediumBlack2Button(
                      name: "I'm ready",
                      fontSize: 14,
                      apply: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (
                              ctx) =>
                              ContentTwo(task: skillUp.contentTwo!,
                              skillUpTask: skillUpTask))),


                    ),
                    FlowvaButton.mediumWhiteButton(
                        name: "End Mission",
                        color: Colors.black,
                        fontSize: 14,
                        apply: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentTwo extends StatefulWidget {
  final Task? task;
  final SkillUpTask? skillUpTask;

  ContentTwo({this.task, super.key, required this.skillUpTask});

  @override
  State<ContentTwo> createState() => _ContentTwoState();
}

class _ContentTwoState extends State<ContentTwo> {
  ValueNotifier<bool> isSending = ValueNotifier(false);
  late MissionCubit missionCubit;
  final _pageController = PageController();

  @override
  void initState() {
    missionCubit = MissionCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MissionCubit, MissionState>(
        bloc: missionCubit,
        listener: (context, state) {
          if (state is MissionUpdateLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.black.withOpacity(0.3),
              builder: (_) =>
                  Center(
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
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              barrierColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              builder: (_) => SkillUpSuccess(skillUp: widget.skillUpTask,),
            );
            //
          }
          if (state is MissionFailed) {
            Navigator.pop(context);
          }
        },
        child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.48),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: 5 / 5,
                                  minHeight: 16,
                                  backgroundColor: Colors.grey[200],
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                    Color(0xFFA259FF),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/one_50.png",
                                  height: 15,
                                ),
                                Text(
                                  "10-50",
                                  style: GoogleFonts.baloo2(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 9,
                                    color: Color(0xFF9013FE),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Text(
                          "📚 Learn the Basics",
                          style: GoogleFonts.baloo2(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.45,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.task!.title.toString(),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.task!.content.toString(),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xFF191919),
                            height: 2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        FlowvaButton.mediumBlack2Button(
                          name: "Share your creation",
                          fontSize: 14,
                          apply: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              barrierColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              // important for blur
                              builder: (_) =>
                                  ShareCreation(
                                    apply: (val) {
                                      print(val);
                                      if (val != null) {
                                        missionCubit.saveAndUpdateSkillUp({
                                          "user_id":
                                          SessionManager().userIdVal,
                                          "title":
                                          widget.task!.title.toString(),
                                          "completed": true,
                                          "image_url": val,
                                        });
                                        Navigator.pop(context);
                                      }
                                      ;
                                    },
                                  ),
                            );
                          },
                        ),
                        FlowvaButton.mediumWhiteButton(
                            name: "End Mission",
                            color: Colors.black,
                            fontSize: 14,
                            apply:
                                () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }

                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
