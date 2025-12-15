import 'package:flowva/features/common/flowva_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BravooRatingPage extends StatefulWidget {
  const BravooRatingPage({Key? key}) : super(key: key);

  @override
  State<BravooRatingPage> createState() => _BravooRatingPageState();
}

class _BravooRatingPageState extends State<BravooRatingPage>
    with SingleTickerProviderStateMixin {
  int _currentRating = 4;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  final Map<int, RatingState> _ratingStates = {
    1: RatingState(
      emoji: EmojiType.terrible,
      text: 'Very bad!',
      color: const Color(0xFFD53951),
      progress: 0.2,
    ),
    2: RatingState(
      emoji: EmojiType.bad,
      text: 'Not good',
      color: const Color(0xFFD53951),
      progress: 0.4,
    ),
    3: RatingState(
      emoji: EmojiType.okay,
      text: "It's okay",
      color: const Color(0xFFF77A38),
      progress: 0.6,
    ),
    4: RatingState(
      emoji: EmojiType.good,
      text: 'Pretty good!',
      color: const Color(0xFF008753),
      progress: 0.8,
    ),
    5: RatingState(
      emoji: EmojiType.excellent,
      text: 'Love it!',
      color: const Color(0xFF9013FE),
      progress: 1.0,
    ),
  };

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _updateRating(int rating) {
    setState(() {
      _currentRating = rating;
    });
    _bounceController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final currentState = _ratingStates[_currentRating]!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
         color: Color(0xFFE8D4F8)
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Spacer(),
            const SizedBox(height: 160),
            Center(
              child: Text(
                "How's your Bravoo\njourney going?",
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              // constraints: const BoxConstraints(maxWidth: 480),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 38,
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _bounceAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _bounceAnimation.value),
                        child: child,
                      );
                    },
                    child: EmojiWidget(
                      type: currentState.emoji,
                      color: currentState.color,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: GoogleFonts.arima(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: currentState.color,
                    ),
                    child: Text(currentState.text),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return StarWidget(
                        index: index,
                        currentRating: _currentRating,
                        onTap: () => _updateRating(index + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  AnimatedProgressBar(
                    progress: currentState.progress,
                    currentRating: _currentRating,
                  ),
                  const SizedBox(height: 40),
                  FlowvaButton.blueButton(
                    name: "Leave a review for us",
                    apply: () {
                      print(_currentRating);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarWidget extends StatefulWidget {
  final int index;
  final int currentRating;
  final VoidCallback onTap;

  const StarWidget({
    Key? key,
    required this.index,
    required this.currentRating,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StarWidget> createState() => _StarWidgetState();
}

class _StarWidgetState extends State<StarWidget>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.index < widget.currentRating;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _scaleController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _scaleController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _isHovered ? 0.174533 : 0, // 10 degrees in radians
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              size: 52,
              color: isFilled ? const Color(0xFFFCD34D) : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final int currentRating;

  const AnimatedProgressBar({
    Key? key,
    required this.progress,
    required this.currentRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 6,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    return Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: index < currentRating
                            ? Colors.black
                            : const Color(0xFFE5E7EB),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum EmojiType { terrible, bad, okay, good, excellent }

class RatingState {
  final EmojiType emoji;
  final String text;
  final Color color;
  final double progress;

  RatingState({
    required this.emoji,
    required this.text,
    required this.color,
    required this.progress,
  });
}

class EmojiWidget extends StatelessWidget {
  final EmojiType type;
  final Color color;

  const EmojiWidget({Key? key, required this.type, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildEyes(), const SizedBox(height: 12), _buildMouth()],
      ),
    );
  }

  Widget _buildEyes() {
    switch (type) {
      case EmojiType.terrible:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ],
        );
      case EmojiType.bad:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 42,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(width: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 42,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        );
      case EmojiType.good:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 42,
              height: 30,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 42,
              height: 30,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ],
        );

      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: type == EmojiType.excellent ? 44 : 42,
              height: type == EmojiType.excellent ? 44 : 20,
              decoration: type == EmojiType.excellent
                  ? BoxDecoration(color: color, shape: BoxShape.circle)
                  : BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(15),
                    ),
            ),
            const SizedBox(width: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: type == EmojiType.excellent ? 44 : 42,
              height: type == EmojiType.excellent ? 44 : 20,
              decoration: type == EmojiType.excellent
                  ? BoxDecoration(color: color, shape: BoxShape.circle)
                  : BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(15),
                    ),
            ),
          ],
        );
    }
  }

  Widget _buildMouth() {
    switch (type) {
      case EmojiType.terrible:
        return Transform.translate(
          offset: const Offset(0, 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 50,
            height: 20,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: color, width: 4),
                left: BorderSide(color: color, width: 4),
                right: BorderSide(color: color, width: 4),
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              ),
            ),
          ),
        );
      case EmojiType.bad:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: 4),
              left: BorderSide(color: color, width: 4),
              right: BorderSide(color: color, width: 4),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
          ),
        );
      case EmojiType.okay:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      case EmojiType.good:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 40,
          height: 20,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: 4),
              left: BorderSide(color: color, width: 4),
              right: BorderSide(color: color, width: 4),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
        );
      case EmojiType.excellent:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 70,
          height: 35,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: 4),
              left: BorderSide(color: color, width: 4),
              right: BorderSide(color: color, width: 4),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60),
            ),
          ),
        );
    }
  }
}
