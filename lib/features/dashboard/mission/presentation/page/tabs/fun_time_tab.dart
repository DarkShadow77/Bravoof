/*
import 'dart:async';
import 'dart:ui';

import 'package:Bravoo/features/common/flowva_button.dart';
import 'package:Bravoo/features/mission/data/bloc/mission_cubit.dart';
import 'package:Bravoo/features/mission/data/model/quiz_response.dart';
import 'package:Bravoo/features/mission/presentation/widget/fun_time_screen.dart';
import 'package:Bravoo/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TriviaPage extends StatefulWidget {
  const TriviaPage({Key? key}) : super(key: key);

  @override
  State<TriviaPage> createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  late MissionCubit missionCubit;
  int _timeLeft = 5;
  bool init=true;
List<Quiz>quiz=[];
  Timer? _timer;
@override
  void initState() {
    missionCubit=MissionCubit();
    missionCubit.fetchQuiz();
    super.initState();

  }
  void _startTimer() {
    _timeLeft = 10;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    _timer?.cancel();


    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
       Navigator.push(context, MaterialPageRoute(builder: (ctx)=>FunTimeScreen(quiz:quiz)));

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MissionCubit, MissionState>(
      bloc: missionCubit,
      listener: (context, state) {
        if (state is QuizLoaded) {
          setState(() {
            init = false;
          });
          setState(() {
            quiz = state.quizResponse.quiz!;
          });
          // print(userProfile.toJson());
        }
      },

  child:init? Center(
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
  ):Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 475,
          // width: 343,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
           color: Color(0xFF82053E),
            borderRadius: BorderRadius.circular(20),
            // boxShadow: [
            //   BoxShadow(
            //     color: colors[0].withOpacity(0.4),
            //     blurRadius: 12,
            //     offset: const Offset(0, 6),
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trivia',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset("assets/images/one_50.png",height: 22,),
                        const SizedBox(width: 8),
                        Text(
                          '10',
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 28),
                  Image.asset("assets/images/money_move.png",),
                  const SizedBox(height: 16),
                  Text(
                    'Money Moves',
                    style: GoogleFonts.baloo2(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 60),
                SessionManager().isFunTimeCompletedVal? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Game Completed", style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191919),
                    ),),
                  ): GestureDetector(
                    onTap:(){

                      Navigator.push(context, MaterialPageRoute(builder: (ctx)=>FunTimeScreen(quiz:quiz)));

                      // _startTimer();
                      // showModalBottomSheet(
                      //   context: context,
                      //   isScrollControlled: true,
                      //   barrierColor: Colors.transparent,
                      //   backgroundColor: Colors.transparent,
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.vertical(
                      //       top: Radius.circular(30),
                      //     ),
                      //   ),
                      //   builder: (_) => StatefulBuilder(
                      //       builder: (context, setSheetState) {
                      //
                      //         // Update BOTH states during countdown
                      //         _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                      //           if (_timeLeft > 0) {
                      //             setState(() {});          // update parent
                      //             setSheetState(() {});
                      //           }
                      //         });
                      //     return Stack(
                      //       alignment: Alignment.center,
                      //       children: [
                      //         // Blur Background
                      //         BackdropFilter(
                      //           filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      //           child: Container(color: Colors.black.withOpacity(0.2)),
                      //         ),
                      //
                      //         // Dialog with Confetti Stack
                      //         Dialog(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(24),
                      //           ),
                      //           backgroundColor: Colors.transparent,
                      //           insetPadding: const EdgeInsets.all(10),
                      //           child:  Container(
                      //             padding: const EdgeInsets.only(left: 10, right: 10,),
                      //             decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(12),
                      //
                      //             ),
                      //             child: Column(
                      //               mainAxisAlignment:MainAxisAlignment.center,
                      //               children: [
                      //                 Container(
                      //                   width: 100,
                      //                   height: 100,
                      //                   decoration: BoxDecoration(
                      //
                      //                     image: DecorationImage(image: AssetImage("assets/images/timer_bg.png"),fit: BoxFit.cover),
                      //
                      //                   ),
                      //                   child: Center(
                      //                     child: Text(
                      //                       '$_timeLeft',
                      //                       style: GoogleFonts.manrope(
                      //                           fontSize: 50,
                      //                           fontWeight: FontWeight.w500,
                      //                           color: Color(0xFFF77A38)
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //
                      //         ),
                      //
                      //
                      //       ],
                      //     );
                      //   }),
                      // );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("Ready, Set, Guess!", style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191919),
                      ),),
                    ),
                  )
                ],
              ),


            ],
          ),
        ),

        // const SizedBox(height: 24),

        // Info Section
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Icon(Icons.info_outline),
              SizedBox(width: 2,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Trivia drops every Wednesday. Show up, go wild, win big .️',
                      style: GoogleFonts.manrope(
                        color: Color(0xFF767676),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ' Get each question correct and score 2 points!🤓⚡',
                      style: GoogleFonts.manrope(
                        color: Color(0xFF767676),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
);
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 8;
    const dashSpace = 6;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}*/
