import 'dart:math' as math;

import 'package:entre_tempos/core/Colors.dart';
import 'package:flutter/material.dart';

class EnvelopeOpeningAnimation extends StatefulWidget {
  final String letterTitle;
  final VoidCallback onOpen;

  const EnvelopeOpeningAnimation({
    super.key,
    required this.letterTitle,
    required this.onOpen,
  });

  @override
  State<EnvelopeOpeningAnimation> createState() =>
      _EnvelopeOpeningAnimationState();
}

class _EnvelopeOpeningAnimationState extends State<EnvelopeOpeningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> flapRotation;
  late Animation<double> letterSlide;
  late Animation<double> letterScale;
  late Animation<double> envelopeScale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    flapRotation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    letterSlide = Tween<double>(begin: 0.0, end: -250.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack),
      ),
    );

    letterScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    envelopeScale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );

    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        widget.onOpen();
      }
    });

    Future<dynamic>.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DefaultColors.pageColor,
      child: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, _) {
            return SizedBox(
              width: 300,
              height: 400,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(0, letterSlide.value),
                    child: Transform.scale(
                      scale: letterScale.value,
                      child: _letter(),
                    ),
                  ),
                  Transform.scale(
                    scale: envelopeScale.value,
                    child: _envelope(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _letter() {
    return Container(
      width: 260,
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DefaultColors.cardLight,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: DefaultColors.primary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.letterTitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: DefaultColors.text,
            ),
          ),
          const SizedBox(height: 20),
          Container(height: 4, width: 100, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          Container(height: 4, width: 200, color: Colors.grey.shade200),
          const SizedBox(height: 10),
          Container(height: 4, width: 180, color: Colors.grey.shade200),
        ],
      ),
    );
  }

  Widget _envelope() {
    return SizedBox(
      width: 300,
      height: 200,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: DefaultColors.colorTest,
                borderRadius: BorderRadius.circular(15),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: DefaultColors.primary.withValues(alpha: 0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(flapRotation.value),
              child: CustomPaint(
                size: const Size(300, 100),
                painter: FlapPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = DefaultColors.colorTest.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height * 0.85)
      ..close();

    canvas.drawPath(path, paint);

    final Paint highlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, highlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
