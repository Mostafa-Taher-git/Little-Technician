import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SupTechAvatar extends StatefulWidget {
  final int availableUses;
  final bool isGlowing;
  final double size;
  final VoidCallback? onTap;

  const SupTechAvatar({
    super.key,
    this.availableUses = 0,
    this.isGlowing = false,
    this.size = 40,
    this.onTap,
  });

  @override
  State<SupTechAvatar> createState() => _SupTechAvatarState();
}

class _SupTechAvatarState extends State<SupTechAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _armSwingAnimation;
  late Animation<double> _antennaBobAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 3000.ms,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _armSwingAnimation = Tween<double>(begin: -0.08, end: 0.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _antennaBobAnimation = Tween<double>(begin: -0.05, end: 0.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final isGlowing = widget.isGlowing;

    final avatar = AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: CustomPaint(
            size: Size(size, size),
            painter: _SupTechBodyPainter(
              isGlowing: isGlowing,
              armAngle: _armSwingAnimation.value,
              antennaBob: _antennaBobAnimation.value,
              blinkPhase: _controller.value,
            ),
          ),
        );
      },
    );

    final glowOverlay = isGlowing
        ? IgnorePointer(
            child: Container(
              width: size * 1.5,
              height: size * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.3),
                    blurRadius: size * 0.5,
                    spreadRadius: size * 0.15,
                  ),
                  BoxShadow(
                    color: Colors.cyan.withValues(alpha: 0.15),
                    blurRadius: size * 0.8,
                    spreadRadius: size * 0.1,
                  ),
                ],
              ),
            ),
          )
        : null;

    final badge = widget.availableUses > 0
        ? Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Color(0xFFF59E0B),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${widget.availableUses}',
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          )
        : null;

    final layered = Stack(
      clipBehavior: Clip.none,
      children: [
        if (glowOverlay != null)
          Center(child: glowOverlay),
        avatar,
        if (badge != null) badge,
      ],
    );

    final result = isGlowing
        ? layered
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1500.ms, color: Colors.white.withValues(alpha: 0.15))
        : layered;

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: result);
    }
    return result;
  }
}

class _SupTechBodyPainter extends CustomPainter {
  final bool isGlowing;
  final double armAngle;
  final double antennaBob;
  final double blinkPhase;

  _SupTechBodyPainter({
    required this.isGlowing,
    required this.armAngle,
    required this.antennaBob,
    required this.blinkPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 60;

    final bodyColor = isGlowing
        ? const Color(0xFF4A90D9)
        : const Color(0xFF2D3748);
    final accentColor = isGlowing
        ? const Color(0xFFF59E0B)
        : const Color(0xFF718096);
    final highlightColor = isGlowing
        ? const Color(0xFF63B3ED)
        : const Color(0xFFA0AEC0);

    canvas.save();
    canvas.translate(center.dx, center.dy);

    _drawAntenna(canvas, scale, accentColor, antennaBob);
    _drawLeftArm(canvas, scale, bodyColor, armAngle);
    _drawRightArm(canvas, scale, bodyColor, armAngle);
    _drawBody(canvas, scale, bodyColor, accentColor);
    _drawEyes(canvas, scale, highlightColor, blinkPhase);

    canvas.restore();

    if (isGlowing) {
      _drawParticles(canvas, scale, size);
    }
  }

  void _drawAntenna(Canvas canvas, double s, Color color, double bob) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2 * s
      ..style = PaintingStyle.stroke;

    final top = Offset(0, -20 * s + bob * s * 5);
    final base = Offset(0, -16 * s);
    canvas.drawLine(top, base, paint);

    final ballPaint = Paint()
      ..color = isGlowing ? const Color(0xFFF59E0B) : const Color(0xFF48BB78);
    canvas.drawCircle(top, 3 * s, ballPaint);
  }

  void _drawLeftArm(Canvas canvas, double s, Color color, double angle) {
    canvas.save();
    canvas.translate(-14 * s, -4 * s);
    canvas.rotate(-0.3 + angle);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(0, 12 * s), paint);

    final handPaint = Paint()..color = color.withValues(alpha: 0.7);
    canvas.drawCircle(Offset(0, 13 * s), 3 * s, handPaint);
    canvas.restore();
  }

  void _drawRightArm(Canvas canvas, double s, Color color, double angle) {
    canvas.save();
    canvas.translate(14 * s, -4 * s);
    canvas.rotate(0.3 - angle);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(0, 12 * s), paint);

    final handPaint = Paint()..color = color.withValues(alpha: 0.7);
    canvas.drawCircle(Offset(0, 13 * s), 3 * s, handPaint);
    canvas.restore();
  }

  void _drawBody(Canvas canvas, double s, Color bodyColor, Color accentColor) {
    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final bodyPath = Path()
      ..moveTo(-12 * s, -16 * s)
      ..lineTo(12 * s, -16 * s)
      ..lineTo(13 * s, -12 * s)
      ..lineTo(15 * s, 4 * s)
      ..quadraticBezierTo(15 * s, 12 * s, 12 * s, 14 * s)
      ..lineTo(-12 * s, 14 * s)
      ..quadraticBezierTo(-15 * s, 12 * s, -15 * s, 4 * s)
      ..lineTo(-13 * s, -12 * s)
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    final borderPaint = Paint()
      ..color = accentColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawPath(bodyPath, borderPaint);

    final chestPaint = Paint()
      ..color = isGlowing
          ? const Color(0xFFF59E0B).withValues(alpha: 0.3)
          : const Color(0xFF4A5568);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, -2 * s), width: 10 * s, height: 8 * s),
        Radius.circular(3 * s),
      ),
      chestPaint,
    );

    if (isGlowing) {
      final pulsePaint = Paint()
        ..color = const Color(0xFFF59E0B).withValues(alpha: 0.15 + 0.1 * sin(blinkPhase * pi * 2));
      canvas.drawCircle(Offset(0, -2 * s), 4 * s, pulsePaint);
    }
  }

  void _drawEyes(Canvas canvas, double s, Color highlightColor, double phase) {
    final isBlinking = (phase * 10).floor() % 10 == 0;
    final eyeSize = isBlinking ? 1.0 * s : 3.5 * s;

    for (final dx in [-4.5 * s, 4.5 * s]) {
      final eyePaint = Paint()
        ..color = isGlowing
            ? const Color(0xFF63B3ED)
            : Colors.white;
      canvas.drawCircle(Offset(dx, -10 * s), eyeSize, eyePaint);

      if (!isBlinking) {
        final pupilPaint = Paint()
          ..color = const Color(0xFF1A202C);
        canvas.drawCircle(Offset(dx + 1 * s, -10 * s), 1.8 * s, pupilPaint);

        final glowPaint = Paint()
          ..color = highlightColor.withValues(alpha: 0.3);
        canvas.drawCircle(Offset(dx - 0.5 * s, -11 * s), 1 * s, glowPaint);
      }
    }
  }

  void _drawParticles(Canvas canvas, double s, Size size) {
    final rng = Random(42);
    for (var i = 0; i < 8; i++) {
      final angle = rng.nextDouble() * pi * 2 + blinkPhase * 2;
      final dist = 18 * s + rng.nextDouble() * 8 * s;
      final x = cos(angle) * dist;
      final y = sin(angle) * dist - 2 * s;
      final r = 1.5 * s + rng.nextDouble() * 2 * s;

      final particlePaint = Paint()
        ..color = const Color(0xFFF59E0B)
            .withValues(alpha: 0.3 + 0.3 * sin(blinkPhase * pi + i.toDouble()))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(Offset(x, y), r, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SupTechBodyPainter oldDelegate) {
    return oldDelegate.isGlowing != isGlowing ||
        oldDelegate.armAngle != armAngle ||
        oldDelegate.blinkPhase != blinkPhase;
  }
}
