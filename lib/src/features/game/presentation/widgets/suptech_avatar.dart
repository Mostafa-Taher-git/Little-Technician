import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';

class SupTechAvatar extends StatefulWidget {
  final double size;
  final bool isGlowing;
  final String? skinId;
  final AvatarState state;

  const SupTechAvatar({
    super.key,
    this.size = 56,
    this.isGlowing = true,
    this.skinId,
    this.state = const AvatarState(),
  });

  @override
  State<SupTechAvatar> createState() => _SupTechAvatarState();
}

class _SupTechAvatarState extends State<SupTechAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _blinkTimer;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _scheduleBlink();
  }

  void _scheduleBlink() {
    _blinkTimer = Timer(
      Duration(milliseconds: 4000 + Random().nextInt(4000)),
      () {
        if (!mounted) return;
        setState(() => _isBlinking = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (!mounted) return;
          setState(() => _isBlinking = false);
          _scheduleBlink();
        });
      },
    );
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
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
        builder: (_, __) {
          return CustomPaint(
            painter: _SkinPainter(
              skinId: widget.skinId,
              isGlowing: widget.isGlowing,
              animationValue: _controller.value,
              isBlinking: _isBlinking,
              state: widget.state,
            ),
          );
        },
      ),
    );
  }
}

class _SkinPainter extends CustomPainter {
  final String? skinId;
  final bool isGlowing;
  final double animationValue;
  final bool isBlinking;
  final AvatarState state;

  _SkinPainter({
    required this.skinId,
    required this.isGlowing,
    required this.animationValue,
    required this.isBlinking,
    required this.state,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final skin = SkinTierManager.fromId(skinId);

    canvas.save();
    final s = size.width / 60;
    canvas.translate(size.width / 2, size.height / 2 - 2 * s);

    // Breathing float
    final floatOffset = sin(animationValue * pi) * 0.5 * s;
    canvas.translate(0, floatOffset);

    // ── GEOMETRY — Reference-Matched (single tweak point) ──
    final headCY        = -10 * s;
    final headR         = 13 * s;
    final hoodBaseY     = -3 * s;
    final hoodTopR      = 10 * s;
    final hoodBottomR   = 13 * s;
    final hoodPeakY     = -28 * s;
    final faceCY        = -8 * s;
    final faceW         = 16 * s;
    final faceH         = 21 * s;
    final bodyTopY      = -1 * s;
    final bodyBotY      = 12 * s;
    final robeShoulderW = 16 * s;
    final robeBaseW     = 22 * s;
    final eyeY          = -8.5 * s;
    final eyeSpacing    =  3 * s;
    final eyeR          =  3 * s;

    _drawBody(canvas, skin, s, bodyTopY, bodyBotY, robeShoulderW, robeBaseW);
    _drawHead(canvas, skin, s, headCY, headR, hoodBaseY, hoodTopR, hoodBottomR, hoodPeakY);
    _drawFace(canvas, skin, s, faceCY, faceW, faceH);
    _drawEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR, faceCY);
    _drawMouth(canvas, skin, s, faceCY);
    _drawHeadAccessory(canvas, skin, s, headCY, headR, hoodPeakY);
    _drawEarAccessory(canvas, skin, s, headCY, headR);
    _drawChestAccessory(canvas, skin, s, bodyTopY, bodyBotY);
    _drawGlow(canvas, skin, s);

    canvas.restore();
  }

  // ─────────────────────────────────────────────
  // Body / Robe (short, wide, no hands/collar/legs)
  // ─────────────────────────────────────────────

  void _drawBody(Canvas canvas, SkinDefinition skin, double s,
      double bodyTopY, double bodyBotY, double robeShoulderW, double robeBaseW) {
    final bodyPaint = Paint()
      ..color = skin.bodyColor
      ..style = PaintingStyle.fill;
    final isLightBody =
        ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Drop shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, bodyBotY + 2 * s), width: 22 * s, height: 2.5 * s),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.10)
        ..style = PaintingStyle.fill,
    );

    // Robe body (concept sheet shape)
    final robePath = Path()
      ..moveTo(-robeShoulderW / 2, bodyTopY)
      ..lineTo(robeShoulderW / 2, bodyTopY)
      ..quadraticBezierTo(10 * s, 6 * s, robeBaseW / 2, bodyBotY)
      ..quadraticBezierTo(5.5 * s, bodyBotY + 2 * s, 0, bodyBotY + 1 * s)
      ..quadraticBezierTo(-5.5 * s, bodyBotY + 2 * s, -robeBaseW / 2, bodyBotY)
      ..quadraticBezierTo(-10 * s, 6 * s, -robeShoulderW / 2, bodyTopY)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Robe fold lines
    final foldPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * s
      ..strokeCap = StrokeCap.round;
    final midY = bodyTopY + (bodyBotY - bodyTopY) * 0.5;
    canvas.drawPath(
      Path()
        ..moveTo(-2.5 * s, bodyTopY + 1 * s)
        ..quadraticBezierTo(-3.5 * s, midY, -5.5 * s, bodyBotY),
      foldPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(2.5 * s, bodyTopY + 1 * s)
        ..quadraticBezierTo(3.5 * s, midY, 5.5 * s, bodyBotY),
      foldPaint,
    );

    // Blue glow at robe bottom
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, bodyBotY + 1.5 * s), width: 20 * s, height: 4 * s),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [skin.accentColor.withValues(alpha: 0.0), skin.accentColor],
        ).createShader(Rect.fromCenter(center: Offset(0, bodyBotY + 1.5 * s), width: 20 * s, height: 4 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  // ─────────────────────────────────────────────
  // Head / Hood (bell-shaped, semicircular dome)
  // ─────────────────────────────────────────────

  void _drawHead(Canvas canvas, SkinDefinition skin, double s,
      double headCY, double headR, double hoodBaseY,
      double hoodTopR, double hoodBottomR, double hoodPeakY) {
    final bodyPaint = Paint()
      ..color = skin.bodyColor
      ..style = PaintingStyle.fill;
    final isLightBody =
        ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Smooth dome hood (cubic bezier matching concept sheet)
    final hoodPath = Path()
      ..moveTo(-hoodBottomR, hoodBaseY)
      ..cubicTo(-hoodBottomR, hoodBaseY - 15 * s,
          -hoodTopR, hoodPeakY + 1 * s, 0, hoodPeakY)
      ..cubicTo(hoodTopR, hoodPeakY + 1 * s,
          hoodBottomR, hoodBaseY - 15 * s, hoodBottomR, hoodBaseY)
      ..quadraticBezierTo(7 * s, 1 * s, 0, -0.5 * s)
      ..quadraticBezierTo(-7 * s, 1 * s, -hoodBottomR, hoodBaseY)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Draw vertical hood stripe at the top center (charcoal/dark color)
    final stripePaint = Paint()
      ..color = isLightBody ? const Color(0xFF64748B) : const Color(0xFF2D3748)
      ..style = PaintingStyle.fill;
    final stripePath = Path()
      ..moveTo(-1.5 * s, hoodPeakY)
      ..lineTo(1.5 * s, hoodPeakY)
      ..lineTo(1.5 * s, hoodPeakY + 5 * s)
      ..lineTo(-1.5 * s, hoodPeakY + 5 * s)
      ..close();
    canvas.drawPath(stripePath, stripePaint);
    canvas.drawPath(stripePath, outlinePaint);

    // Inner shadow along hood edges
    final innerShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round;
    final innerPath = Path()
      ..moveTo(-hoodBottomR + 2 * s, hoodBaseY - 1 * s)
      ..quadraticBezierTo(-hoodBottomR + 2 * s, hoodBaseY - 16 * s,
          -hoodTopR + 2 * s, hoodPeakY + 5 * s)
      ..quadraticBezierTo(-8 * s, hoodPeakY + 1 * s, 0, hoodPeakY + 1 * s)
      ..quadraticBezierTo(8 * s, hoodPeakY + 1 * s,
          hoodTopR - 2 * s, hoodPeakY + 5 * s)
      ..quadraticBezierTo(hoodBottomR - 2 * s, hoodBaseY - 16 * s,
          hoodBottomR - 2 * s, hoodBaseY - 1 * s);
    canvas.drawPath(innerPath, innerShadowPaint);

    // Subtle highlight along top of hood dome
    final highlightPaint = Paint()
      ..color = skin.accentColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(-8 * s, hoodPeakY + 3 * s)
        ..quadraticBezierTo(-headR / 2, hoodPeakY - 1.5 * s, 0, hoodPeakY - 0.5 * s)
        ..quadraticBezierTo(headR / 2, hoodPeakY - 1.5 * s, 8 * s, hoodPeakY + 3 * s),
      highlightPaint,
    );
  }

  // ─────────────────────────────────────────────
  // Face void (large dark opening)
  // ─────────────────────────────────────────────

  void _drawFace(Canvas canvas, SkinDefinition skin, double s,
      double faceCY, double faceW, double faceH) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, faceCY), width: faceW, height: faceH),
      Paint()
        ..color = const Color(0xFF050505)
        ..style = PaintingStyle.fill,
    );
  }

  // ─────────────────────────────────────────────
  // Eyes (expression-based)
  // ─────────────────────────────────────────────

  void _drawEyes(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing, double eyeR, double faceCY) {
    if (isBlinking) {
      _drawBlinkLines(canvas, skin, s, eyeY, eyeSpacing);
      return;
    }

    switch (state.expression) {
      case SupTechExpression.neutral:
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          _drawRoundEye(canvas, skin, dx, eyeY, eyeR, s);
        }
        break;
      case SupTechExpression.happy:
        _drawHappyEyes(canvas, skin, s, eyeY, eyeSpacing);
        break;
      case SupTechExpression.angry:
        _drawAngryEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
        break;
      case SupTechExpression.surprised:
        _drawSurprisedEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
        break;
      case SupTechExpression.determined:
        _drawDeterminedEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
        break;
      case SupTechExpression.wink:
        _drawWinkEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
        break;
      case SupTechExpression.sleep:
        _drawSleepEyes(canvas, skin, s, eyeY, eyeSpacing);
        break;
      case SupTechExpression.error:
        _drawErrorEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
        break;
    }
  }

  void _drawBlinkLines(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing) {
    final linePaint = Paint()
      ..color = skin.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round;
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      canvas.drawLine(
        Offset(dx - 3 * s, eyeY),
        Offset(dx + 3 * s, eyeY),
        linePaint,
      );
    }
  }

  void _drawHappyEyes(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing) {
    // Downward-curving crescents (like closed happy eyes smiling downward)
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      final path = Path()
        ..moveTo(dx - 2.8 * s, eyeY - 0.5 * s)
        ..quadraticBezierTo(dx, eyeY + 2.8 * s, dx + 2.8 * s, eyeY - 0.5 * s);
      // Glow
      canvas.drawPath(
        path,
        Paint()
          ..color = skin.accentColor.withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0 * s
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 * s),
      );
      // Core
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * s
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawAngryEyes(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing, double eyeR) {
    _drawAngryEye(canvas, skin, -eyeSpacing, eyeY, eyeR, s, true);
    _drawAngryEye(canvas, skin, eyeSpacing, eyeY, eyeR, s, false);
  }

  void _drawAngryEye(Canvas canvas, SkinDefinition skin, double cx, double cy, double r, double s, bool left) {
    final center = Offset(cx, cy);

    // Glow layer
    canvas.drawOval(
      Rect.fromCenter(center: center, width: (r + 4 * s) * 2, height: (r + 4 * s) * 2.5),
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.5),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: center, width: (r + 6 * s) * 2, height: (r + 6 * s) * 2.5)),
    );

    // Sharp angular wedge eye: pointed on the inner/top corner
    // Left eye: top-left corner is raised, giving angry inner slant
    // Right eye: top-right corner is raised (mirror)
    final Path eyePath;
    if (left) {
      // Left eye: pointed top-right corner (inner), flat bottom-left
      eyePath = Path()
        ..moveTo(cx - r * 0.7, cy + r * 0.5)        // bottom-left
        ..lineTo(cx + r * 0.7, cy - r * 0.8)        // top-right (sharp inner point)
        ..quadraticBezierTo(cx + r * 0.4, cy + r * 0.6, cx - r * 0.7, cy + r * 0.5)  // curve to bottom
        ..close();
    } else {
      // Right eye: pointed top-left corner (inner), flat bottom-right
      eyePath = Path()
        ..moveTo(cx + r * 0.7, cy + r * 0.5)        // bottom-right
        ..lineTo(cx - r * 0.7, cy - r * 0.8)        // top-left (sharp inner point)
        ..quadraticBezierTo(cx - r * 0.4, cy + r * 0.6, cx + r * 0.7, cy + r * 0.5)  // curve to bottom
        ..close();
    }
    canvas.drawPath(eyePath, Paint()..color = Colors.white);
  }

  void _drawSurprisedEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing, double eyeR) {
    // Mockup: large white circles, NO eyebrows, slightly wider
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      final center = Offset(dx, eyeY);
      final r = eyeR * 1.05;
      // Glow
      canvas.drawCircle(
        center,
        r + 3 * s,
        Paint()
          ..shader = RadialGradient(colors: [
            skin.accentColor.withValues(alpha: 0.5),
            skin.accentColor.withValues(alpha: 0.0),
          ]).createShader(Rect.fromCircle(center: center, radius: r + 4 * s)),
      );
      // White circle core
      canvas.drawCircle(center, r, Paint()..color = Colors.white);
    }
  }

  void _drawDeterminedEyes(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing, double eyeR) {
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      final center = Offset(dx, eyeY);
      final r = eyeR;
      // Glow
      canvas.drawOval(
        Rect.fromCenter(center: center, width: (r + 4 * s) * 2, height: (r + 4 * s) * 2.5),
        Paint()
          ..shader = RadialGradient(colors: [
            skin.accentColor.withValues(alpha: 0.5),
            skin.accentColor.withValues(alpha: 0.0),
          ]).createShader(Rect.fromCenter(center: center, width: (r + 6 * s) * 2, height: (r + 6 * s) * 2.5)),
      );
      // White capsule
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: 6.5 * s, height: 2.2 * s),
          Radius.circular(1.1 * s),
        ),
        Paint()..color = Colors.white,
      );
    }
  }

  void _drawWinkEyes(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing, double eyeR) {
    // Left eye is winked (downward-curving crescent like happy)
    final dxLeft = -eyeSpacing;
    final path = Path()
      ..moveTo(dxLeft - 2.8 * s, eyeY - 0.5 * s)
      ..quadraticBezierTo(dxLeft, eyeY + 2.8 * s, dxLeft + 2.8 * s, eyeY - 0.5 * s);
    // Left eye glow
    canvas.drawPath(
      path,
      Paint()
        ..color = skin.accentColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 * s
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 * s),
    );
    // Left eye core
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * s
        ..strokeCap = StrokeCap.round,
    );

    // Right eye is normal round/oval eye
    _drawRoundEye(canvas, skin, eyeSpacing, eyeY, eyeR, s);
  }

  void _drawSleepEyes(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing) {
    final linePaint = Paint()
      ..color = skin.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round;
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      canvas.drawLine(
        Offset(dx - 2.5 * s, eyeY),
        Offset(dx + 2.5 * s, eyeY),
        linePaint,
      );
    }
    // Z letters
    final zPaint = Paint()
      ..color = skin.accentColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * s
      ..strokeCap = StrokeCap.round;
    _drawZ(canvas, 6 * s, eyeY - 3 * s, 2.0 * s, zPaint);
    _drawZ(canvas, 8 * s, eyeY - 6 * s, 1.4 * s, zPaint);
  }

  void _drawZ(Canvas canvas, double x, double y, double scale, Paint paint) {
    canvas.drawPath(
      Path()
        ..moveTo(x, y)
        ..lineTo(x + 3 * scale, y)
        ..lineTo(x, y + 3 * scale)
        ..lineTo(x + 3 * scale, y + 3 * scale),
      paint,
    );
  }

  void _drawErrorEyes(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing, double eyeR) {
    final xPaint = Paint()
      ..color = skin.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * s
      ..strokeCap = StrokeCap.round;
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      canvas.drawLine(
        Offset(dx - eyeR * 0.6, eyeY - eyeR * 0.6),
        Offset(dx + eyeR * 0.6, eyeY + eyeR * 0.6),
        xPaint,
      );
      canvas.drawLine(
        Offset(dx + eyeR * 0.6, eyeY - eyeR * 0.6),
        Offset(dx - eyeR * 0.6, eyeY + eyeR * 0.6),
        xPaint,
      );
    }
  }

  void _drawRoundEye(Canvas canvas, SkinDefinition skin, double cx, double cy,
      double r, double s) {
    final center = Offset(cx, cy);
    final rx = r * 0.65;
    final ry = r;

    // Outer glow
    canvas.drawOval(
      Rect.fromCenter(center: center, width: (r + 4 * s) * 2, height: (r + 4 * s) * 2.5),
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.5),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: center, width: (r + 6 * s) * 2, height: (r + 6 * s) * 2.5)),
    );

    // Inner glow
    canvas.drawOval(
      Rect.fromCenter(center: center, width: (r + 1.5 * s) * 2, height: (r + 1.5 * s) * 2.5),
      Paint()
        ..shader = RadialGradient(colors: [
          Colors.white.withValues(alpha: 0.3),
          skin.accentColor.withValues(alpha: 0.7),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: center, width: (r + 3 * s) * 2, height: (r + 3 * s) * 2.5)),
    );

    // Main iris (tall oval)
    canvas.drawOval(
      Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
      Paint()..color = Colors.white,
    );

    // Large highlight
    canvas.drawCircle(
      Offset(cx + rx * 0.35, cy - ry * 0.35),
      rx * 0.28,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // Small highlight
    canvas.drawCircle(
      Offset(cx - rx * 0.35, cy + ry * 0.35),
      rx * 0.14,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  // ─────────────────────────────────────────────
  // Mouth
  // ─────────────────────────────────────────────

  void _drawMouth(Canvas canvas, SkinDefinition skin, double s, double faceCY) {
    final mouthY = faceCY + 8 * s;
    final mouthPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * s
      ..strokeCap = StrokeCap.round;

    switch (state.expression) {
      case SupTechExpression.happy:
        mouthPaint.color = skin.accentColor.withValues(alpha: 0.6);
        canvas.drawPath(
          Path()
            ..moveTo(-2.5 * s, mouthY)
            ..quadraticBezierTo(0, mouthY + 2.5 * s, 2.5 * s, mouthY),
          mouthPaint,
        );
        break;
      case SupTechExpression.surprised:
        mouthPaint.color = skin.accentColor.withValues(alpha: 0.5);
        canvas.drawOval(
          Rect.fromCenter(
              center: Offset(0, mouthY + 1 * s), width: 2.5 * s, height: 3 * s),
          mouthPaint,
        );
        break;
      case SupTechExpression.angry:
        mouthPaint.color = skin.accentColor.withValues(alpha: 0.5);
        canvas.drawPath(
          Path()
            ..moveTo(-2.5 * s, mouthY + 1 * s)
            ..quadraticBezierTo(0, mouthY - 1 * s, 2.5 * s, mouthY + 1 * s),
          mouthPaint,
        );
        break;
      case SupTechExpression.error:
        mouthPaint.color = skin.accentColor.withValues(alpha: 0.5);
        canvas.drawLine(
          Offset(-2 * s, mouthY + 1 * s),
          Offset(2 * s, mouthY + 1 * s),
          mouthPaint,
        );
        break;
      default:
        mouthPaint.color = Colors.black.withValues(alpha: 0.25);
        canvas.drawLine(
          Offset(-2 * s, mouthY + 1 * s),
          Offset(2 * s, mouthY + 1 * s),
          mouthPaint,
        );
        break;
    }
  }

  // ─────────────────────────────────────────────
  // Head Accessory (antenna)
  // ─────────────────────────────────────────────

  void _drawHeadAccessory(Canvas canvas, SkinDefinition skin, double s,
      double headCY, double headR, double hoodPeakY) {
    switch (skin.headAccessory) {
      case SupTechHeadAccessory.none:
        return;
      case SupTechHeadAccessory.antenna:
        _drawAntenna(canvas, skin, s, hoodPeakY);
      case SupTechHeadAccessory.crown:
        _drawCrown(canvas, skin, s, hoodPeakY);
      case SupTechHeadAccessory.wizardHat:
        _drawWizardHat(canvas, skin, s, hoodPeakY);
      case SupTechHeadAccessory.ninjaHeadband:
        _drawHeadband(canvas, skin, s, headCY, headR, hoodPeakY);
      case SupTechHeadAccessory.visor:
        _drawVisor(canvas, skin, s, headCY, headR);
      case SupTechHeadAccessory.horns:
        _drawHorns(canvas, skin, s, headCY, headR, hoodPeakY);
      case SupTechHeadAccessory.crest:
        _drawCrest(canvas, skin, s, hoodPeakY);
    }
  }

  void _drawAntenna(Canvas canvas, SkinDefinition skin, double s, double hoodPeakY) {
    final peakY = hoodPeakY - 1 * s;
    canvas.drawLine(
      Offset(0, peakY),
      Offset(0, peakY - 7 * s),
      Paint()..color = Colors.black87..strokeWidth = 2.0 * s..strokeCap = StrokeCap.round,
    );
    final tipCenter = Offset(0, peakY - 7 * s);
    canvas.drawCircle(tipCenter, 2.5 * s,
      Paint()..shader = RadialGradient(colors: [
        skin.accentColor, skin.accentColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCircle(center: tipCenter, radius: 3 * s)));
    canvas.drawCircle(tipCenter, 1.5 * s, Paint()..color = skin.accentColor);
  }

  void _drawCrown(Canvas canvas, SkinDefinition skin, double s, double hoodPeakY) {
    final peakY = hoodPeakY - 2 * s;
    final crownPaint = Paint()..color = skin.accentColor;
    final jewelPaint = Paint()..color = const Color(0xFFE11D48);
    final path = Path()
      ..moveTo(-6 * s, peakY)
      ..lineTo(-5 * s, peakY - 6 * s)
      ..lineTo(-3 * s, peakY - 3 * s)
      ..lineTo(0, peakY - 8 * s)
      ..lineTo(3 * s, peakY - 3 * s)
      ..lineTo(5 * s, peakY - 6 * s)
      ..lineTo(6 * s, peakY);
    canvas.drawPath(path, crownPaint..style = PaintingStyle.fill);
    canvas.drawPath(path, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 1 * s);
    canvas.drawCircle(Offset(0, peakY - 8 * s), 1.2 * s, jewelPaint);
  }

  void _drawWizardHat(Canvas canvas, SkinDefinition skin, double s, double hoodPeakY) {
    final peakY = hoodPeakY - 2 * s;
    final hatPaint = Paint()..color = const Color(0xFF1E293B);
    final bandPaint = Paint()..color = skin.accentColor;
    final cone = Path()
      ..moveTo(-6 * s, peakY)
      ..lineTo(6 * s, peakY)
      ..lineTo(0, peakY - 14 * s);
    canvas.drawPath(cone, hatPaint);
    canvas.drawPath(cone, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 1 * s);
    canvas.drawRect(Rect.fromLTWH(-6 * s, peakY - 1.5 * s, 12 * s, 2.5 * s), bandPaint);
    // Star on tip
    canvas.drawCircle(Offset(0, peakY - 14 * s), 1.5 * s, Paint()..color = skin.accentColor);
  }

  void _drawHeadband(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR, double hoodPeakY) {
    final bandY = headCY - headR * 0.3;
    final bandPaint = Paint()..color = skin.accentColor;
    canvas.drawRect(Rect.fromLTWH(-headR - 2 * s, bandY - 1.5 * s, headR * 2 + 4 * s, 3 * s), bandPaint);
    // Tails
    final tailPath = Path()
      ..moveTo(-headR - 2 * s, bandY + 1.5 * s)
      ..quadraticBezierTo(-headR - 6 * s, bandY + 8 * s, -headR - 3 * s, bandY + 12 * s)
      ..moveTo(headR + 2 * s, bandY + 1.5 * s)
      ..quadraticBezierTo(headR + 6 * s, bandY + 8 * s, headR + 3 * s, bandY + 12 * s);
    canvas.drawPath(tailPath, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 2 * s);
  }

  void _drawVisor(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR) {
    final visorY = headCY + headR * 0.15;
    final visorPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.7);
    final visorPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, visorY), width: headR * 1.6, height: headR * 0.7),
        Radius.circular(3 * s),
      ));
    canvas.drawPath(visorPath, visorPaint);
    // Lens glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, visorY), width: headR * 1.2, height: headR * 0.35),
        Radius.circular(2 * s),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.15),
    );
  }

  void _drawHorns(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR, double hoodPeakY) {
    final hornPaint = Paint()..color = skin.accentColor;
    final hornBaseY = hoodPeakY - 1 * s;
    for (final dir in [-1, 1]) {
      final hornPath = Path()
        ..moveTo(dir * headR * 0.4, hornBaseY)
        ..quadraticBezierTo(dir * headR * 0.9, hornBaseY - 6 * s, dir * headR * 0.6, hornBaseY - 10 * s)
        ..quadraticBezierTo(dir * headR * 0.4, hornBaseY - 7 * s, dir * headR * 0.25, hornBaseY - 1 * s);
      canvas.drawPath(hornPath, hornPaint);
      canvas.drawPath(hornPath, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);
    }
  }

  void _drawCrest(Canvas canvas, SkinDefinition skin, double s, double hoodPeakY) {
    final peakY = hoodPeakY - 1 * s;
    final crestPaint = Paint()..color = skin.accentColor;
    final crestPath = Path()
      ..moveTo(0, peakY - 8 * s)
      ..lineTo(-3 * s, peakY)
      ..lineTo(0, peakY - 2 * s)
      ..lineTo(3 * s, peakY);
    canvas.drawPath(crestPath, crestPaint);
    canvas.drawPath(crestPath, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);
  }

  // ─────────────────────────────────────────────
  // Ear Accessory (headset)
  // ─────────────────────────────────────────────

  void _drawEarAccessory(Canvas canvas, SkinDefinition skin, double s,
      double headCY, double headR) {
    switch (skin.earAccessory) {
      case SupTechEarAccessory.none:
        return;
      case SupTechEarAccessory.headset:
        _drawHeadset(canvas, skin, s, headCY, headR);
      case SupTechEarAccessory.scarf:
        _drawScarf(canvas, skin, s, headCY, headR);
      case SupTechEarAccessory.earGlow:
        _drawEarGlow(canvas, skin, s, headCY, headR);
    }
  }

  void _drawHeadset(Canvas canvas, SkinDefinition skin, double s,
      double headCY, double headR) {
    final bandPaint = Paint()..color = skin.accentColor..style = PaintingStyle.fill;
    final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke..strokeWidth = 1.5 * s..strokeCap = StrokeCap.round;
    final bandPath = Path()
      ..addOval(Rect.fromCenter(center: Offset(0, headCY - 1 * s), width: headR * 2 + 6 * s, height: 3.5 * s))
      ..addOval(Rect.fromCenter(center: Offset(0, headCY - 1 * s), width: headR * 2 - 1 * s, height: 1.2 * s));
    canvas.drawPath(bandPath, bandPaint);
    canvas.drawPath(bandPath, outlinePaint);
    final cupPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.85)..style = PaintingStyle.fill;
    for (final dx in [-headR - 2 * s, headR + 2 * s]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(dx, headCY + 1 * s), width: 3 * s, height: 5 * s), Radius.circular(1.5 * s)),
        cupPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(dx, headCY + 1 * s), width: 3 * s, height: 5 * s), Radius.circular(1.5 * s)),
        outlinePaint,
      );
    }
  }

  void _drawScarf(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR) {
    final scarfPaint = Paint()..color = skin.accentColor;
    final neckY = headCY + headR * 0.6;
    // Wrap around neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-headR - 1 * s, neckY - 2 * s, headR * 2 + 2 * s, 5 * s),
        Radius.circular(2 * s),
      ),
      scarfPaint,
    );
    // Tail
    final tailPath = Path()
      ..moveTo(-headR, neckY + 3 * s)
      ..quadraticBezierTo(-headR - 5 * s, neckY + 8 * s, -headR - 3 * s, neckY + 14 * s);
    canvas.drawPath(tailPath, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 3.5 * s..strokeCap = StrokeCap.round);
    canvas.drawPath(tailPath, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 1 * s);
  }

  void _drawEarGlow(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR) {
    final glowPaint = Paint();
    for (final dx in [-headR * 0.7, headR * 0.7]) {
      final center = Offset(dx, headCY);
      canvas.drawCircle(center, 3 * s,
        glowPaint..shader = RadialGradient(colors: [
          skin.accentColor,
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: center, radius: 3 * s)));
      canvas.drawCircle(center, 1.5 * s, Paint()..color = skin.accentColor);
    }
  }

  // ─────────────────────────────────────────────
  // Chest Accessory (badge + ST logo)
  // ─────────────────────────────────────────────

  void _drawChestAccessory(Canvas canvas, SkinDefinition skin, double s,
      double bodyTopY, double bodyBotY) {
    switch (skin.chestAccessory) {
      case SupTechChestAccessory.none:
        return;
      case SupTechChestAccessory.badge:
        _drawBadge(canvas, skin, s, bodyTopY, bodyBotY);
      case SupTechChestAccessory.cape:
        _drawCape(canvas, skin, s, bodyTopY, bodyBotY);
      case SupTechChestAccessory.codeScroll:
        _drawCodeScroll(canvas, skin, s, bodyTopY, bodyBotY);
      case SupTechChestAccessory.gear:
        _drawGear(canvas, skin, s, bodyTopY, bodyBotY);
      case SupTechChestAccessory.flameEmblem:
        _drawFlameEmblem(canvas, skin, s, bodyTopY, bodyBotY);
      case SupTechChestAccessory.staff:
        _drawStaff(canvas, skin, s, bodyTopY, bodyBotY);
    }
  }

  void _drawBadge(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
    final badgeY = bodyTopY + (bodyBotY - bodyTopY) * 0.45;
    if (skin.showLogo) {
      final textSpan = TextSpan(
        text: 'ST',
        style: TextStyle(
          fontSize: 9 * s,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontFamily: 'Montserrat',
          shadows: [
            Shadow(color: skin.accentColor, blurRadius: 6 * s),
            Shadow(color: skin.accentColor, blurRadius: 2 * s),
          ],
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, badgeY - textPainter.height / 2),
      );
    }
  }

  void _drawCape(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
    final capePaint = Paint()..color = skin.bodyColor.withValues(alpha: 0.7);
    final capePath = Path()
      ..moveTo(-6 * s, bodyTopY + 2 * s)
      ..lineTo(-8 * s, bodyBotY)
      ..lineTo(8 * s, bodyBotY)
      ..lineTo(6 * s, bodyTopY + 2 * s);
    canvas.drawPath(capePath, capePaint);
    canvas.drawPath(capePath, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);
  }

  void _drawCodeScroll(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
    final scrollY = bodyTopY + (bodyBotY - bodyTopY) * 0.4;
    final scrollPaint = Paint()..color = const Color(0xFFFEF3C7);
    final scrollRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(0, scrollY), width: 6 * s, height: 8 * s),
      Radius.circular(1 * s),
    );
    canvas.drawRRect(scrollRect, scrollPaint);
    canvas.drawRRect(scrollRect, Paint()..color = Colors.brown..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);
    // Code lines
    for (var i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(-2 * s, scrollY - 2 * s + i * 2.5 * s),
        Offset(-2 * s + 3 * s, scrollY - 2 * s + i * 2.5 * s),
        Paint()..color = Colors.black54..strokeWidth = 0.8 * s..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawGear(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
    final gearY = bodyTopY + (bodyBotY - bodyTopY) * 0.45;
    final gearPaint = Paint()..color = skin.accentColor;
    // Center circle
    canvas.drawCircle(Offset(0, gearY), 4 * s, gearPaint..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(0, gearY), 4 * s, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);
    // Teeth
    for (var i = 0; i < 6; i++) {
      final angle = i * 3.14159 / 3;
      final cx = 5.5 * s * cos(angle);
      final cy = 5.5 * s * sin(angle);
      canvas.drawCircle(Offset(cx, cy + gearY), 1.5 * s, gearPaint..style = PaintingStyle.fill);
    }
    // Inner hole
    canvas.drawCircle(Offset(0, gearY), 1.5 * s, Paint()..color = Colors.black87);
  }

  void _drawFlameEmblem(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
    final flameY = bodyTopY + (bodyBotY - bodyTopY) * 0.45;
    final flamePaint = Paint()..color = const Color(0xFFF97316);
    final flamePath = Path()
      ..moveTo(0, flameY - 5 * s)
      ..quadraticBezierTo(3 * s, flameY - 1 * s, 4 * s, flameY + 1 * s)
      ..quadraticBezierTo(2 * s, flameY + 3 * s, 0, flameY + 4 * s)
      ..quadraticBezierTo(-2 * s, flameY + 3 * s, -4 * s, flameY + 1 * s)
      ..quadraticBezierTo(-3 * s, flameY - 1 * s, 0, flameY - 5 * s);
    canvas.drawPath(flamePath, flamePaint);
    canvas.drawPath(flamePath, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);
    // Inner glow
    final innerFlame = Path()
      ..moveTo(0, flameY - 2 * s)
      ..quadraticBezierTo(1.5 * s, flameY, 2 * s, flameY + 1 * s)
      ..quadraticBezierTo(1 * s, flameY + 2 * s, 0, flameY + 2.5 * s)
      ..quadraticBezierTo(-1 * s, flameY + 2 * s, -2 * s, flameY + 1 * s)
      ..quadraticBezierTo(-1.5 * s, flameY, 0, flameY - 2 * s);
    canvas.drawPath(innerFlame, Paint()..color = const Color(0xFFFDE68A));
  }

  void _drawStaff(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
    final staffX = 6 * s;
    // Staff shaft
    canvas.drawLine(
      Offset(staffX, bodyTopY + 2 * s),
      Offset(staffX, bodyBotY - 2 * s),
      Paint()..color = const Color(0xFF78350F)..strokeWidth = 1.5 * s..strokeCap = StrokeCap.round,
    );
    // Top crystal
    final crystalCenter = Offset(staffX, bodyTopY + 1 * s);
    canvas.drawCircle(crystalCenter, 2 * s, Paint()..color = skin.accentColor);
    canvas.drawCircle(crystalCenter, 3 * s,
      Paint()..shader = RadialGradient(colors: [
        skin.accentColor.withValues(alpha: 0.4),
        skin.accentColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCircle(center: crystalCenter, radius: 3 * s)));
  }

  // ─────────────────────────────────────────────
  // Glow (3-layer: core, soft, ambient pulse)
  // ─────────────────────────────────────────────

  void _drawGlow(Canvas canvas, SkinDefinition skin, double s) {
    if (!isGlowing) return;

    final pulseAlpha = 0.12 + animationValue * 0.08;
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 84 * s, height: 84 * s),
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: pulseAlpha),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(
            Rect.fromCircle(center: Offset.zero, radius: 42 * s)),
    );
  }

  @override
  bool shouldRepaint(covariant _SkinPainter old) =>
      old.skinId != skinId ||
      old.isGlowing != isGlowing ||
      old.animationValue != animationValue ||
      old.isBlinking != isBlinking ||
      old.state.expression != state.expression;
}
