import 'package:electra/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedOrb extends StatefulWidget {
  final double size;
  final Color baseColor;

  const AnimatedOrb({
    super.key,
    this.size = 250,
    this.baseColor = AppColors.primary, // const Color(0xFF7DE9E6), // Soft cyan
  });

  @override
  State<AnimatedOrb> createState() => _AnimatedOrbState();
}

class _AnimatedOrbState extends State<AnimatedOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // Smooth breathing speed
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: WhiteCoreOrbPainter(
              animationValue: _controller.value,
              baseColor: widget.baseColor,
            ),
          );
        },
      ),
    );
  }
}

class WhiteCoreOrbPainter extends CustomPainter {
  final double animationValue;
  final Color baseColor;

  WhiteCoreOrbPainter({required this.animationValue, required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.45;

    // Very soft outer halo
    for (int i = 0; i < 6; i++) {
      final paint = Paint()
        ..color = baseColor.withValues(alpha: 0.08 - i * 0.01)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 50 + i * 18.0);

      canvas.drawCircle(center, radius + i * 22, paint);
    }

    // Main orb body (soft cyan glass look)
    final bodyGradient = RadialGradient(
      center: const Alignment(-0.4, -0.4),
      radius: 1.2,
      colors: [
        Colors.white.withValues(alpha: 0.9),
        baseColor.withValues(alpha: 0.75),
        baseColor.withValues(alpha: 0.35),
        Colors.transparent,
      ],
      stops: const [0.1, 0.5, 0.8, 1.0],
    );

    final bodyPaint = Paint()
      ..shader = bodyGradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, bodyPaint);

    // === ANIMATED WHITE BRIGHT AREA (The main focus) ===
    final whitePulse =
        0.68 +
        0.32 * math.sin(animationValue * math.pi * 3.2); // Breathing effect

    final whiteCoreRadius = radius * whitePulse;

    final whiteCorePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 35);

    canvas.drawCircle(center, whiteCoreRadius, whiteCorePaint);

    // Secondary smaller white highlight (moves gently)
    final highlightAngle = animationValue * math.pi * 4;
    final highlightOffset = Offset(
      center.dx - radius * 0.35 * math.cos(highlightAngle),
      center.dy - radius * 0.38 * math.sin(highlightAngle * 1.1),
    );

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawCircle(highlightOffset, radius * 0.22, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant WhiteCoreOrbPainter oldDelegate) => true;
}
