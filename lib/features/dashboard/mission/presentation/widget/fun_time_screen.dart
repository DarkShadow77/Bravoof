/*
import 'dart:async';

import 'package:Bravoo/features/mission/data/bloc/mission_cubit.dart';
import 'package:Bravoo/features/mission/data/model/quiz_response.dart';
import 'package:Bravoo/features/mission/data/model/trivia_response.dart';
import 'package:Bravoo/features/mission/presentation/widget/players.dart';
import 'package:Bravoo/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import 'game_success.dart';

class Question {
  final String question;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}

class FunTimeScreen extends StatefulWidget {
  List<Quiz> quiz = [];

  FunTimeScreen({required this.quiz, Key? key}) : super(key: key);

  @override
  State<FunTimeScreen> createState() => _FunTimeScreenState();
}

class _FunTimeScreenState extends State<FunTimeScreen> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _hasAnswered = false;
  int _timeLeft = 10;
  Timer? _timer;
  int _score = 0;
  late MissionCubit missionCubit;
  final sessionManager = SessionManager();
  List<Trivia> trivia = [];

  @override
  void initState() {
    missionCubit = MissionCubit();
    missionCubit.fetchTrivia();
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
    setState(() {
      _hasAnswered = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _selectAnswer(String answer) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _hasAnswered = true;
      _timer?.cancel();

      if (answer == widget.quiz[_currentQuestionIndex].correctAnswer) {
        _score += 1;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.quiz.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _hasAnswered = false;
      });
      _startTimer();
    } else {
      _showResults();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = null;
        _hasAnswered = false;
      });
      _startTimer();
    }
  }

  void _showResults() {
    missionCubit.updateReward({
      "name": "quiz",
      "reward_title": "quiz",
      "points": "${_score*2}",
      "user_id": sessionManager.userIdVal,
      "email": sessionManager.userEmailval,
    });
    _timer?.cancel();
    sessionManager.isFunTimeCompletedVal=true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => GameSuccess(score: _score, totalQuestion: widget.quiz.length),
    );
  }

  Color _getButtonColor(String option) {
    if (!_hasAnswered) {
      return Colors.white;
    }

    if (option == widget.quiz[_currentQuestionIndex].correctAnswer) {
      return const Color(0xFF4CAF50);
    }

    if (option == _selectedAnswer &&
        option != widget.quiz[_currentQuestionIndex].correctAnswer) {
      return const Color(0xFFEF4444);
    }

    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.quiz[_currentQuestionIndex];
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/earn_bg.png", fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
                    ),
                    SizedBox(width: 16),
                    BlocListener<MissionCubit, MissionState>(
                      bloc: missionCubit,
                      listener: (context, state) {
                        if (state is TriviaLoaded) {
                          setState(() {
                            trivia = state.triviaResponse.trivia!;
                          });
                          // print(userProfile.toJson());
                        }
                      },
                      child: GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          barrierColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          // important for blur
                          builder: (_) => Players(trivia:trivia),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/bg.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                              child: Text(
                                "Players",
                                style: GoogleFonts.manrope(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  padding: EdgeInsets.only(top: 1),
                  shrinkWrap: true,
                  children: [
                    // Header
                    const SizedBox(height: 24),

                    // Question Card
                    Container(
                      height: 241,
                      width: 289,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                "assets/images/quote_bg.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/timer_bg.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '$_timeLeft',
                                    style: GoogleFonts.manrope(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFF77A38),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Question Text
                              Center(
                                child: Text(
                                  currentQuestion.question.toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Navigation Buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _buildNavButton('Previous', Icons.arrow_back, _previousQuestion, _currentQuestionIndex == 0),
                    //     const SizedBox(width: 16),
                    //     Container(
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: 16,
                    //         vertical: 16,
                    //       ),
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Colors.white,
                    //         border: Border.all(
                    //           color: Colors.black.withOpacity(0.1),
                    //         ),
                    //       ),
                    //       child: HugeIcon(icon: HugeIcons.strokeRoundedShuffle),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     _buildNavButton('Next', Icons.arrow_forward, _nextQuestion, !_hasAnswered),
                    //   ],
                    // ),
                    const SizedBox(height: 24),

                    // Answer Options
                    Container(
                      height: 239,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF9013FE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              "assets/images/fun_bg.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: currentQuestion.quizAnswers!
                                .expand((quizAnswer) => quizAnswer.options!)
                                .map(
                                  (option) => Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selectAnswer(
                                          option,
                                        ); // <-- Use the single option string
                                        Future.delayed(
                                          const Duration(seconds: 2),
                                          () => _nextQuestion(),
                                        );
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        width: double.infinity,
                                        height: 43,
                                        decoration: BoxDecoration(
                                          color: _getButtonColor(option),
                                          // <-- Option is a String
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _getButtonColor(
                                                option,
                                              ).withOpacity(0.3),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            option,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color:
                                                  _hasAnswered &&
                                                      (option ==
                                                              widget
                                                                  .quiz[_currentQuestionIndex]
                                                                  .correctAnswer ||
                                                          option ==
                                                              _selectedAnswer)
                                                  ? Colors.white
                                                  : const Color(0xFF1A1F36),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Feedback Text
                    if (_hasAnswered)
                      AnimatedOpacity(
                        opacity: _hasAnswered ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Center(
                          child: Text(
                            _selectedAnswer == currentQuestion.correctAnswer
                                ? 'Correct! ✓'
                                : 'Wrong..',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w500,
                              fontSize: 39,
                              color:
                                  _selectedAnswer ==
                                      currentQuestion.correctAnswer
                                  ? const Color(0xFF008753)
                                  : const Color(0xFFCC0000),
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    String label,
    IconData icon,
    VoidCallback onPressed,
    bool isDisabled,
  ) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: isDisabled ? null : onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          // width: 103,
          // height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              if (label == 'Previous')
                Icon(icon, size: 20, color: const Color(0xFF1A1F36)),
              if (label == 'Previous') const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
              if (label == 'Next') const SizedBox(width: 8),
              if (label == 'Next')
                Icon(icon, size: 20, color: const Color(0xFF1A1F36)),
            ],
          ),
        ),
      ),
    );
  }
}
*/
