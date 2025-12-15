import 'package:flutter/material.dart';

class SplitSplashScreen extends StatelessWidget {
  const SplitSplashScreen({
    super.key,
    required this.controller,
    required this.moveAnim,
    required this.fadeAnim,
  });

  final AnimationController controller;
  final Animation<double> moveAnim;
  final Animation<double> fadeAnim;

  Widget _buildQuadrant(
      Alignment alignment, Offset offset, Rect clipRect, BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Align(
          alignment: alignment,
          child: Transform.translate(
            offset: offset * moveAnim.value,
            child: Opacity(
              opacity: fadeAnim.value,
              child: ClipRect(
                clipper: _QuadrantClipper(clipRect),
                child: Image.asset(
                  "assets/images/splash.png",
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final halfW = size.width / 2;
    final halfH = size.height / 2;

    return Stack(
      children: [
        _buildQuadrant(
          Alignment.topLeft,
          const Offset(-1, -1),
          Rect.fromLTWH(0, 0, halfW, halfH),
          context,
        ),
        _buildQuadrant(
          Alignment.topRight,
          const Offset(1, -1),
          Rect.fromLTWH(halfW, 0, halfW, halfH),
          context,
        ),
        _buildQuadrant(
          Alignment.bottomLeft,
          const Offset(-1, 1),
          Rect.fromLTWH(0, halfH, halfW, halfH),
          context,
        ),
        _buildQuadrant(
          Alignment.bottomRight,
          const Offset(1, 1),
          Rect.fromLTWH(halfW, halfH, halfW, halfH),
          context,
        ),
      ],
    );
  }
}

class _QuadrantClipper extends CustomClipper<Rect> {
  final Rect rect;

  _QuadrantClipper(this.rect);

  @override
  Rect getClip(Size size) => rect;

  @override
  bool shouldReclip(_QuadrantClipper oldClipper) => rect != oldClipper.rect;
}
