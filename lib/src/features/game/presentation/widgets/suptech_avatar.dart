import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';
import 'package:littletech/src/features/game/domain/cubit/suptech_customization_cubit.dart';
import 'package:littletech/src/features/game/domain/models/suptech_customization.dart';

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
    final customization = context.watch<SupTechCustomizationCubit?>()?.state;
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
              customization: customization,
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
  final SupTechCustomization? customization;

  _SkinPainter({
    required this.skinId,
    required this.isGlowing,
    required this.animationValue,
    required this.isBlinking,
    required this.state,
    this.customization,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final skin = SkinTierManager.fromId(skinId);

    final c = customization;
    final resolvedExpression = c?.expression ?? state.expression;
    final resolvedHeadAccessory = c?.headAccessory ?? skin.headAccessory;
    final resolvedEarAccessory = c?.earAccessory ?? skin.earAccessory;
    final resolvedChestAccessory = c?.chestAccessory ?? skin.chestAccessory;
    final resolvedPose = c?.pose;

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
    final faceCY        = -8.8 * s;
    final faceW         = 23.5 * s;
    final faceH         = 14.5 * s;
    final bodyTopY      = -1 * s;
    final bodyBotY      = 12 * s;
    final robeShoulderW = 16 * s;
    final robeBaseW     = 22 * s;
    final eyeY          = -8.5 * s;
    final eyeSpacing    =  5.2 * s;
    final eyeR          =  3.1 * s;

    switch (skin.variant) {
      case SkinVariant.ninja:
        _drawNinjaVariant(canvas, skin, s);
        break;
      case SkinVariant.wizard:
        _drawWizardVariant(canvas, skin, s);
        break;
      case SkinVariant.tech:
        _drawTechVariant(canvas, skin, s);
        break;
      case SkinVariant.armored:
        _drawArmoredVariant(canvas, skin, s);
        break;
      case SkinVariant.phoenix:
        _drawPhoenixVariant(canvas, skin, s);
        break;
      case SkinVariant.void_:
        _drawVoidVariant(canvas, skin, s);
        break;
      case SkinVariant.default_:
        _drawBody(canvas, skin, s, bodyTopY, bodyBotY, robeShoulderW, robeBaseW);
        _drawHead(canvas, skin, s, headCY, headR, hoodBaseY, hoodTopR, hoodBottomR, hoodPeakY);
        break;
    }
    _drawFace(canvas, skin, s, faceCY, faceW, faceH);

    final resolvedState = AvatarState(
      expression: resolvedExpression,
      blinking: isBlinking,
      lookDirection: state.lookDirection,
    );
    _drawEyesWithOverride(canvas, skin, s, eyeY, eyeSpacing, eyeR, faceCY,
        resolvedState, resolvedPose);
    _drawMouth(canvas, skin, s, faceCY, resolvedExpression);
    _drawHeadAccessoryValue(canvas, skin, s, headCY, headR, hoodPeakY,
        resolvedHeadAccessory);
    _drawEarAccessoryValue(canvas, skin, s, headCY, headR,
        resolvedEarAccessory);
    _drawChestAccessoryValue(canvas, skin, s, bodyTopY, bodyBotY,
        resolvedChestAccessory);
    _drawUniqueDetail(canvas, skin, s);
    _drawPoseOverlay(canvas, skin, s, resolvedPose, eyeY, eyeSpacing);
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

  // ─────────────────────────────────────────────
  // VARIANT: Ninja — slim body, tight flat hood
  // ─────────────────────────────────────────────

  void _drawNinjaVariant(Canvas canvas, SkinDefinition skin, double s) {
    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke..strokeWidth = 2.5 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

    // Shadow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 14 * s), width: 18 * s, height: 2 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.fill);

    // Slim robe body
    final robePath = Path()
      ..moveTo(-6 * s, -1 * s)
      ..lineTo(6 * s, -1 * s)
      ..quadraticBezierTo(8 * s, 5 * s, 9 * s, 12 * s)
      ..quadraticBezierTo(4.5 * s, 13.5 * s, 0, 13 * s)
      ..quadraticBezierTo(-4.5 * s, 13.5 * s, -9 * s, 12 * s)
      ..quadraticBezierTo(-8 * s, 5 * s, -6 * s, -1 * s)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Tight flat hood — lower dome, wider base
    final hoodPath = Path()
      ..moveTo(-12 * s, -2 * s)
      ..cubicTo(-12 * s, -14 * s, -9 * s, -22 * s, 0, -24 * s)
      ..cubicTo(9 * s, -22 * s, 12 * s, -14 * s, 12 * s, -2 * s)
      ..quadraticBezierTo(6 * s, 1 * s, 0, 0.5 * s)
      ..quadraticBezierTo(-6 * s, 1 * s, -12 * s, -2 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Fold lines
    final foldPaint = Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.stroke..strokeWidth = 1.0 * s..strokeCap = StrokeCap.round;
    canvas.drawPath(Path()..moveTo(-2 * s, 0)..quadraticBezierTo(-3 * s, 6 * s, -5 * s, 12 * s), foldPaint);
    canvas.drawPath(Path()..moveTo(2 * s, 0)..quadraticBezierTo(3 * s, 6 * s, 5 * s, 12 * s), foldPaint);

    // Bottom glow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 13.5 * s), width: 16 * s, height: 3 * s),
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [skin.accentColor.withValues(alpha: 0.0), skin.accentColor],
      ).createShader(Rect.fromCenter(center: Offset(0, 13.5 * s), width: 16 * s, height: 3 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
  }

  // ─────────────────────────────────────────────
  // VARIANT: Wizard — wide flowing robes, tall pointed hat area
  // ─────────────────────────────────────────────

  void _drawWizardVariant(Canvas canvas, SkinDefinition skin, double s) {
    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke..strokeWidth = 2.5 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

    // Shadow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 15 * s), width: 26 * s, height: 2.5 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.fill);

    // Wide flowing robe
    final robePath = Path()
      ..moveTo(-8 * s, -1 * s)
      ..lineTo(8 * s, -1 * s)
      ..quadraticBezierTo(12 * s, 5 * s, 14 * s, 13 * s)
      ..quadraticBezierTo(7 * s, 15 * s, 0, 14 * s)
      ..quadraticBezierTo(-7 * s, 15 * s, -14 * s, 13 * s)
      ..quadraticBezierTo(-12 * s, 5 * s, -8 * s, -1 * s)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Stars pattern on robe
    final starPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.3)..style = PaintingStyle.fill;
    for (final pos in [Offset(-4 * s, 5 * s), Offset(3 * s, 8 * s), Offset(-2 * s, 11 * s)]) {
      _drawStar(canvas, pos, 1.2 * s, starPaint);
    }

    // Tall hood with pointed top
    final hoodPath = Path()
      ..moveTo(-13 * s, -3 * s)
      ..cubicTo(-13 * s, -16 * s, -8 * s, -28 * s, 0, -32 * s)
      ..cubicTo(8 * s, -28 * s, 13 * s, -16 * s, 13 * s, -3 * s)
      ..quadraticBezierTo(7 * s, 1 * s, 0, -0.5 * s)
      ..quadraticBezierTo(-7 * s, 1 * s, -13 * s, -3 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Fold lines
    final foldPaint = Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.stroke..strokeWidth = 1.0 * s..strokeCap = StrokeCap.round;
    canvas.drawPath(Path()..moveTo(-3 * s, 0)..quadraticBezierTo(-5 * s, 6 * s, -7 * s, 13 * s), foldPaint);
    canvas.drawPath(Path()..moveTo(3 * s, 0)..quadraticBezierTo(5 * s, 6 * s, 7 * s, 13 * s), foldPaint);

    // Bottom glow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 14.5 * s), width: 24 * s, height: 4 * s),
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [skin.accentColor.withValues(alpha: 0.0), skin.accentColor],
      ).createShader(Rect.fromCenter(center: Offset(0, 14.5 * s), width: 24 * s, height: 4 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
  }

  void _drawStar(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = i * 2 * pi / 5 - pi / 2;
      final innerAngle = angle + pi / 5;
      final outerR = r;
      final innerR = r * 0.4;
      if (i == 0) {
        path.moveTo(center.dx + outerR * cos(angle), center.dy + outerR * sin(angle));
      } else {
        path.lineTo(center.dx + outerR * cos(angle), center.dy + outerR * sin(angle));
      }
      path.lineTo(center.dx + innerR * cos(innerAngle), center.dy + innerR * sin(innerAngle));
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  // ─────────────────────────────────────────────
  // VARIANT: Tech — hoodie-style hood, slim-medium body
  // ─────────────────────────────────────────────

  void _drawTechVariant(Canvas canvas, SkinDefinition skin, double s) {
    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke..strokeWidth = 2.5 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

    // Shadow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 14 * s), width: 22 * s, height: 2.5 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.fill);

    // Medium robe
    final robePath = Path()
      ..moveTo(-7 * s, -1 * s)
      ..lineTo(7 * s, -1 * s)
      ..quadraticBezierTo(9 * s, 5 * s, 10 * s, 12 * s)
      ..quadraticBezierTo(5 * s, 14 * s, 0, 13 * s)
      ..quadraticBezierTo(-5 * s, 14 * s, -10 * s, 12 * s)
      ..quadraticBezierTo(-9 * s, 5 * s, -7 * s, -1 * s)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Circuit lines on robe
    final circuitPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.25)..style = PaintingStyle.stroke..strokeWidth = 0.8 * s..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-3 * s, 2 * s), Offset(-3 * s, 8 * s), circuitPaint);
    canvas.drawLine(Offset(-3 * s, 8 * s), Offset(0, 10 * s), circuitPaint);
    canvas.drawLine(Offset(3 * s, 3 * s), Offset(3 * s, 7 * s), circuitPaint);
    canvas.drawLine(Offset(3 * s, 7 * s), Offset(1 * s, 9 * s), circuitPaint);
    // Circuit nodes
    for (final pos in [Offset(-3 * s, 8 * s), Offset(0, 10 * s), Offset(3 * s, 7 * s), Offset(1 * s, 9 * s)]) {
      canvas.drawCircle(pos, 0.8 * s, Paint()..color = skin.accentColor.withValues(alpha: 0.4));
    }

    // Hoodie hood — slightly wider, with hood lip at bottom
    final hoodPath = Path()
      ..moveTo(-13 * s, -3 * s)
      ..cubicTo(-13 * s, -17 * s, -10 * s, -26 * s, 0, -28 * s)
      ..cubicTo(10 * s, -26 * s, 13 * s, -17 * s, 13 * s, -3 * s)
      ..quadraticBezierTo(7 * s, 1.5 * s, 0, 1 * s)
      ..quadraticBezierTo(-7 * s, 1.5 * s, -13 * s, -3 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Hood lip / collar line
    canvas.drawPath(
      Path()
        ..moveTo(-10 * s, -2 * s)
        ..quadraticBezierTo(-5 * s, 2 * s, 0, 1 * s)
        ..quadraticBezierTo(5 * s, 2 * s, 10 * s, -2 * s),
      Paint()..color = skin.accentColor.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 1.5 * s..strokeCap = StrokeCap.round,
    );

    // Bottom glow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 13.5 * s), width: 18 * s, height: 3.5 * s),
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [skin.accentColor.withValues(alpha: 0.0), skin.accentColor],
      ).createShader(Rect.fromCenter(center: Offset(0, 13.5 * s), width: 18 * s, height: 3.5 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
  }

  // ─────────────────────────────────────────────
  // VARIANT: Armored — bulky body, shoulder plates, helmet hood
  // ─────────────────────────────────────────────

  void _drawArmoredVariant(Canvas canvas, SkinDefinition skin, double s) {
    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke..strokeWidth = 2.5 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final platePaint = Paint()..color = skin.accentColor.withValues(alpha: 0.3)..style = PaintingStyle.fill;
    final plateOutline = Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.8 * s;

    // Shadow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 15 * s), width: 26 * s, height: 3 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.fill);

    // Bulky robe
    final robePath = Path()
      ..moveTo(-9 * s, -1 * s)
      ..lineTo(9 * s, -1 * s)
      ..quadraticBezierTo(11 * s, 6 * s, 12 * s, 13 * s)
      ..quadraticBezierTo(6 * s, 15 * s, 0, 14 * s)
      ..quadraticBezierTo(-6 * s, 15 * s, -12 * s, 13 * s)
      ..quadraticBezierTo(-11 * s, 6 * s, -9 * s, -1 * s)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Shoulder plates
    for (final dir in [-1, 1]) {
      final platePath = Path()
        ..moveTo(dir * 8 * s, 0)
        ..lineTo(dir * 13 * s, 1 * s)
        ..lineTo(dir * 12 * s, 5 * s)
        ..lineTo(dir * 8 * s, 4 * s)
        ..close();
      canvas.drawPath(platePath, platePaint);
      canvas.drawPath(platePath, plateOutline);
    }

    // Chest plate
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, 4 * s), width: 8 * s, height: 6 * s), Radius.circular(1.5 * s)),
      platePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, 4 * s), width: 8 * s, height: 6 * s), Radius.circular(1.5 * s)),
      plateOutline,
    );

    // Helmet hood — angular, armored
    final hoodPath = Path()
      ..moveTo(-14 * s, -3 * s)
      ..lineTo(-12 * s, -20 * s)
      ..lineTo(-4 * s, -28 * s)
      ..lineTo(0, -29 * s)
      ..lineTo(4 * s, -28 * s)
      ..lineTo(12 * s, -20 * s)
      ..lineTo(14 * s, -3 * s)
      ..quadraticBezierTo(7 * s, 1 * s, 0, -0.5 * s)
      ..quadraticBezierTo(-7 * s, 1 * s, -14 * s, -3 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Helmet ridge
    canvas.drawLine(Offset(0, -29 * s), Offset(0, -10 * s),
      Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 2 * s..strokeCap = StrokeCap.round);

    // Bottom glow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 14.5 * s), width: 22 * s, height: 4 * s),
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [skin.accentColor.withValues(alpha: 0.0), skin.accentColor],
      ).createShader(Rect.fromCenter(center: Offset(0, 14.5 * s), width: 22 * s, height: 4 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
  }

  // ─────────────────────────────────────────────
  // VARIANT: Phoenix — wing cape, flame-like edges
  // ─────────────────────────────────────────────

  void _drawPhoenixVariant(Canvas canvas, SkinDefinition skin, double s) {
    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke..strokeWidth = 2.5 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

    // Shadow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 14 * s), width: 24 * s, height: 2.5 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.fill);

    // Wing cape (behind body)
    final wingPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.35)..style = PaintingStyle.fill;
    // Left wing
    final leftWing = Path()
      ..moveTo(-7 * s, 0)
      ..quadraticBezierTo(-18 * s, -5 * s, -20 * s, 5 * s)
      ..quadraticBezierTo(-16 * s, 10 * s, -10 * s, 12 * s)
      ..close();
    canvas.drawPath(leftWing, wingPaint);
    canvas.drawPath(leftWing, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);
    // Right wing
    final rightWing = Path()
      ..moveTo(7 * s, 0)
      ..quadraticBezierTo(18 * s, -5 * s, 20 * s, 5 * s)
      ..quadraticBezierTo(16 * s, 10 * s, 10 * s, 12 * s)
      ..close();
    canvas.drawPath(rightWing, wingPaint);
    canvas.drawPath(rightWing, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);

    // Flame-like robe bottom
    final robePath = Path()
      ..moveTo(-7 * s, -1 * s)
      ..lineTo(7 * s, -1 * s)
      ..quadraticBezierTo(9 * s, 5 * s, 10 * s, 11 * s)
      ..quadraticBezierTo(7 * s, 13 * s, 4 * s, 11 * s)
      ..quadraticBezierTo(2 * s, 14 * s, 0, 12 * s)
      ..quadraticBezierTo(-2 * s, 14 * s, -4 * s, 11 * s)
      ..quadraticBezierTo(-7 * s, 13 * s, -10 * s, 11 * s)
      ..quadraticBezierTo(-9 * s, 5 * s, -7 * s, -1 * s)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Default dome hood
    final hoodPath = Path()
      ..moveTo(-13 * s, -3 * s)
      ..cubicTo(-13 * s, -18 * s, -10 * s, -27 * s, 0, -28 * s)
      ..cubicTo(10 * s, -27 * s, 13 * s, -18 * s, 13 * s, -3 * s)
      ..quadraticBezierTo(7 * s, 1 * s, 0, -0.5 * s)
      ..quadraticBezierTo(-7 * s, 1 * s, -13 * s, -3 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Bottom glow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 13 * s), width: 20 * s, height: 4 * s),
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [skin.accentColor.withValues(alpha: 0.0), skin.accentColor],
      ).createShader(Rect.fromCenter(center: Offset(0, 13 * s), width: 20 * s, height: 4 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
  }

  // ─────────────────────────────────────────────
  // VARIANT: Void — ethereal wisps, semi-transparent edges
  // ─────────────────────────────────────────────

  void _drawVoidVariant(Canvas canvas, SkinDefinition skin, double s) {
    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke..strokeWidth = 2.5 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

    // Shadow
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 14 * s), width: 22 * s, height: 2.5 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.fill);

    // Wispy robe — irregular bottom edge
    final robePath = Path()
      ..moveTo(-7 * s, -1 * s)
      ..lineTo(7 * s, -1 * s)
      ..quadraticBezierTo(10 * s, 5 * s, 11 * s, 10 * s)
      ..quadraticBezierTo(8 * s, 12 * s, 5 * s, 10 * s)
      ..quadraticBezierTo(2 * s, 14 * s, 0, 11 * s)
      ..quadraticBezierTo(-2 * s, 14 * s, -5 * s, 10 * s)
      ..quadraticBezierTo(-8 * s, 12 * s, -11 * s, 10 * s)
      ..quadraticBezierTo(-10 * s, 5 * s, -7 * s, -1 * s)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Void wisps (floating particles)
    final wispPaint = Paint()..style = PaintingStyle.fill;
    final rng = skin.id.length;
    for (var i = 0; i < 5; i++) {
      final wx = (-6 + i * 3) * s;
      final wy = (2 + (rng + i) % 5 * 2) * s;
      final wr = (0.8 + (i % 3) * 0.4) * s;
      wispPaint.color = skin.accentColor.withValues(alpha: 0.2 + (i % 3) * 0.1);
      canvas.drawCircle(Offset(wx, wy), wr, wispPaint);
    }

    // Default dome hood
    final hoodPath = Path()
      ..moveTo(-13 * s, -3 * s)
      ..cubicTo(-13 * s, -18 * s, -10 * s, -27 * s, 0, -28 * s)
      ..cubicTo(10 * s, -27 * s, 13 * s, -18 * s, 13 * s, -3 * s)
      ..quadraticBezierTo(7 * s, 1 * s, 0, -0.5 * s)
      ..quadraticBezierTo(-7 * s, 1 * s, -13 * s, -3 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Bottom glow (extra ethereal)
    canvas.drawOval(Rect.fromCenter(center: Offset(0, 13 * s), width: 22 * s, height: 5 * s),
      Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [skin.accentColor.withValues(alpha: 0.0), skin.accentColor.withValues(alpha: 0.6)],
      ).createShader(Rect.fromCenter(center: Offset(0, 13 * s), width: 22 * s, height: 5 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
  }

  // ─────────────────────────────────────────────
  // Face void (large dark opening)
  // ─────────────────────────────────────────────

  void _drawFace(Canvas canvas, SkinDefinition skin, double s,
      double faceCY, double faceW, double faceH) {
    final faceRect = Rect.fromCenter(
      center: Offset(0, faceCY),
      width: faceW,
      height: faceH,
    );

    canvas.drawOval(
      faceRect.inflate(1.2 * s),
      Paint()
        ..shader = RadialGradient(
          colors: [
            skin.accentColor.withValues(alpha: 0.13),
            Colors.black.withValues(alpha: 0.0),
          ],
        ).createShader(faceRect.inflate(4 * s)),
    );

    canvas.drawOval(
      faceRect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0.05, -0.05),
          radius: 0.95,
          colors: [
            Color(0xFF1B2633),
            Color(0xFF05070B),
            Color(0xFF020306),
          ],
          stops: [0.0, 0.52, 1.0],
        ).createShader(faceRect)
        ..style = PaintingStyle.fill,
    );
  }

  // ─────────────────────────────────────────────
  // Eyes (expression-based)
  // ─────────────────────────────────────────────

  void _drawEyesWithOverride(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing, double eyeR, double faceCY,
      AvatarState resolvedState, SupTechPose? pose) {
    if (pose == SupTechPose.working) {
      _drawFocusedEyes(canvas, s, eyeY, eyeSpacing);
      return;
    }
    if (resolvedState.blinking) {
      _drawBlinkLines(canvas, skin, s, eyeY, eyeSpacing);
      return;
    }
    _drawEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR, faceCY, resolvedState);
  }

  void _drawEyes(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing, double eyeR, double faceCY,
      [AvatarState? resolvedState]) {
    final effectiveState = resolvedState ?? state;
    if (effectiveState.blinking) {
      _drawBlinkLines(canvas, skin, s, eyeY, eyeSpacing);
      return;
    }

    switch (effectiveState.expression) {
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
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      final path = Path()
        ..moveTo(dx - 2.4 * s, eyeY + 0.1 * s)
        ..quadraticBezierTo(dx, eyeY - 2.0 * s, dx + 2.4 * s, eyeY + 0.1 * s);
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
    final dxLeft = -eyeSpacing;
    final path = Path()
      ..moveTo(dxLeft - 2.4 * s, eyeY + 0.1 * s)
      ..quadraticBezierTo(dxLeft, eyeY - 1.6 * s, dxLeft + 2.4 * s, eyeY + 0.1 * s);
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

  void _drawMouth(Canvas canvas, SkinDefinition skin, double s, double faceCY,
      [SupTechExpression? overrideExpression]) {
    final effectiveExpression = overrideExpression ?? state.expression;
    final mouthY = faceCY + 8 * s;
    final mouthPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * s
      ..strokeCap = StrokeCap.round;

    switch (effectiveExpression) {
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

  void _drawHeadAccessoryValue(Canvas canvas, SkinDefinition skin, double s,
      double headCY, double headR, double hoodPeakY,
      SupTechHeadAccessory accessory) {
    switch (accessory) {
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

  void _drawEarAccessoryValue(Canvas canvas, SkinDefinition skin, double s,
      double headCY, double headR,
      SupTechEarAccessory accessory) {
    switch (accessory) {
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

  void _drawChestAccessoryValue(Canvas canvas, SkinDefinition skin, double s,
      double bodyTopY, double bodyBotY,
      SupTechChestAccessory accessory) {
    switch (accessory) {
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
  // Focused eyes (for working pose)
  // ─────────────────────────────────────────────

  void _drawFocusedEyes(Canvas canvas, double s, double eyeY, double eyeSpacing) {
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(-eyeSpacing - 2 * s, eyeY - 0.5 * s),
      Offset(-eyeSpacing + 2 * s, eyeY + 0.5 * s),
      eyePaint,
    );
    canvas.drawLine(
      Offset(eyeSpacing - 2 * s, eyeY - 0.5 * s),
      Offset(eyeSpacing + 2 * s, eyeY + 0.5 * s),
      eyePaint,
    );
  }

  // ─────────────────────────────────────────────
  // Pose overlay (wave arm, thinking hands, working screen)
  // ─────────────────────────────────────────────

  void _drawPoseOverlay(Canvas canvas, SkinDefinition skin, double s,
      SupTechPose? pose, double eyeY, double eyeSpacing) {
    if (pose == null || pose == SupTechPose.none || pose == SupTechPose.neutral) return;

    final isLightBody =
        ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round;

    switch (pose) {
      case SupTechPose.wave:
        canvas.drawPath(
          Path()
            ..moveTo(-8 * s, -15 * s)
            ..quadraticBezierTo(-12 * s, -20 * s, -14 * s, -25 * s),
          Paint()
            ..color = skin.bodyColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5 * s
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawCircle(Offset(-14 * s, -27 * s), 1.2 * s, Paint()..color = skin.bodyColor);
        canvas.drawCircle(Offset(-14 * s, -27 * s), 1.2 * s, outlinePaint);
        final wavePaint = Paint()
          ..color = skin.accentColor.withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8 * s
          ..strokeCap = StrokeCap.round;
        for (final i in [0, 1, 2]) {
          final radius = (3 + i * 1.5) * s;
          canvas.drawArc(
            Rect.fromCenter(
              center: Offset(-14 * s, -27 * s),
              width: radius * 2,
              height: radius * 2,
            ),
            -pi * 0.2,
            pi * 0.6,
            false,
            wavePaint,
          );
        }
      case SupTechPose.thinking:
        final handY = -11 * s;
        final handPaint = Paint()..color = skin.bodyColor;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(-2 * s, handY), width: 3 * s, height: 2.5 * s),
          handPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(2 * s, handY), width: 3 * s, height: 2.5 * s),
          handPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(0, handY + 1.5 * s), width: 4 * s, height: 3 * s),
          handPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(0, handY + 1.5 * s), width: 4 * s, height: 3 * s),
          outlinePaint,
        );
      case SupTechPose.working:
        final screenY = -14 * s;
        final screenRect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(0, screenY), width: 16 * s, height: 11 * s),
          Radius.circular(1.2 * s),
        );
        canvas.drawRRect(
          screenRect,
          Paint()..color = skin.accentColor.withValues(alpha: 0.18),
        );
        canvas.drawRRect(
          screenRect,
          Paint()
            ..color = outlinePaint.color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2 * s,
        );
        for (final lineY in [screenY - 3 * s, screenY, screenY + 3 * s]) {
          canvas.drawLine(
            Offset(-5 * s, lineY),
            Offset(5 * s, lineY),
            Paint()
              ..color = skin.accentColor.withValues(alpha: 0.45)
              ..strokeWidth = 0.7 * s,
          );
        }
      case SupTechPose.none:
      case SupTechPose.neutral:
        break;
    }
  }

  // ─────────────────────────────────────────────
  // Unique detail per skin
  // ─────────────────────────────────────────────

  void _drawUniqueDetail(Canvas canvas, SkinDefinition skin, double s) {
    switch (skin.id) {
      case 'hacker': _drawHackerDetail(canvas, skin, s); break;
      case 'ninja': _drawNinjaDetail(canvas, skin, s); break;
      case 'wizard': _drawWizardDetail(canvas, skin, s); break;
      case 'golden': _drawGoldenDetail(canvas, skin, s); break;
      case 'engineer': _drawEngineerDetail(canvas, skin, s); break;
      case 'grandmaster': _drawGrandmasterDetail(canvas, skin, s); break;
      case 'cyber': _drawCyberDetail(canvas, skin, s); break;
      case 'shadow': _drawShadowDetail(canvas, skin, s); break;
      case 'neon': _drawNeonDetail(canvas, skin, s); break;
      case 'phoenix': _drawPhoenixDetail(canvas, skin, s); break;
      case 'titan': _drawTitanDetail(canvas, skin, s); break;
      case 'void_': _drawVoidDetail(canvas, skin, s); break;
      case 'glitch': _drawGlitchDetail(canvas, skin, s); break;
      case 'frost': _drawFrostDetail(canvas, skin, s); break;
      case 'chrono': _drawChronoDetail(canvas, skin, s); break;
      case 'spectre': _drawSpectreDetail(canvas, skin, s); break;
      case 'viper': _drawViperDetail(canvas, skin, s); break;
      case 'spark': _drawSparkDetail(canvas, skin, s); break;
      case 'rookie': _drawRookieDetail(canvas, skin, s); break;
      default: break;
    }
  }

  void _drawHackerDetail(Canvas canvas, SkinDefinition skin, double s) {
    final promptPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.8 * s..strokeCap = StrokeCap.round;
    final py = -2 * s;
    canvas.drawLine(Offset(-3 * s, py), Offset(-1 * s, py), promptPaint);
    canvas.drawLine(Offset(-1 * s, py), Offset(-1 * s, py + 2 * s), promptPaint);
  }

  void _drawNinjaDetail(Canvas canvas, SkinDefinition skin, double s) {
    final starPaint = Paint()..color = skin.accentColor..style = PaintingStyle.fill;
    _drawStar(canvas, Offset(6 * s, 6 * s), 1.0 * s, starPaint);
  }

  void _drawWizardDetail(Canvas canvas, SkinDefinition skin, double s) {
    final moonPaint = Paint()..color = skin.accentColor..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(-5 * s, -18 * s), width: 3 * s, height: 3 * s),
      -pi * 0.3, pi * 1.4, false, moonPaint);
  }

  void _drawGoldenDetail(Canvas canvas, SkinDefinition skin, double s) {
    canvas.drawCircle(Offset(0, -20 * s), 4 * s,
      Paint()..shader = RadialGradient(colors: [
        skin.accentColor.withValues(alpha: 0.4), skin.accentColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCircle(center: Offset(0, -20 * s), radius: 5 * s)));
  }

  void _drawEngineerDetail(Canvas canvas, SkinDefinition skin, double s) {
    final wrenchPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1.2 * s..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(5 * s, 3 * s), Offset(5 * s, 9 * s), wrenchPaint);
    canvas.drawCircle(Offset(5 * s, 3 * s), 1.5 * s, Paint()..style = PaintingStyle.stroke..color = skin.accentColor..strokeWidth = 1 * s);
  }

  void _drawGrandmasterDetail(Canvas canvas, SkinDefinition skin, double s) {
    final glowPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.2);
    canvas.drawCircle(Offset(0, -22 * s), 6 * s, glowPaint);
  }

  void _drawCyberDetail(Canvas canvas, SkinDefinition skin, double s) {
    final scanPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.2)..style = PaintingStyle.stroke..strokeWidth = 0.6 * s;
    for (var i = 0; i < 3; i++) {
      final y = -4 * s + i * 3 * s;
      canvas.drawLine(Offset(-6 * s, y), Offset(6 * s, y), scanPaint);
    }
  }

  void _drawShadowDetail(Canvas canvas, SkinDefinition skin, double s) {
    final shadowPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.15);
    canvas.drawOval(Rect.fromCenter(center: Offset(2 * s, -4 * s), width: 12 * s, height: 16 * s), shadowPaint);
  }

  void _drawNeonDetail(Canvas canvas, SkinDefinition skin, double s) {
    final neonPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1.5 * s..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1 * s);
    canvas.drawLine(Offset(-6 * s, 2 * s), Offset(-6 * s, 10 * s), neonPaint);
    canvas.drawLine(Offset(6 * s, 2 * s), Offset(6 * s, 10 * s), neonPaint);
  }

  void _drawPhoenixDetail(Canvas canvas, SkinDefinition skin, double s) {
    final flamePaint = Paint()..color = skin.accentColor;
    for (final dx in [-4, 0, 4]) {
      final fh = (2 + (dx.abs() ~/ 2)) * s;
      canvas.drawPath(
        Path()
          ..moveTo(dx * s, 12 * s)
          ..quadraticBezierTo(dx * s + 1 * s, 12 * s - fh * 0.6, dx * s, 12 * s - fh)
          ..quadraticBezierTo(dx * s - 1 * s, 12 * s - fh * 0.6, dx * s, 12 * s),
        flamePaint,
      );
    }
  }

  void _drawTitanDetail(Canvas canvas, SkinDefinition skin, double s) {
    final boltPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1.2 * s..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-2 * s, -15 * s), Offset(0, -13 * s), boltPaint);
    canvas.drawLine(Offset(0, -13 * s), Offset(2 * s, -15 * s), boltPaint);
  }

  void _drawVoidDetail(Canvas canvas, SkinDefinition skin, double s) {
    final portalPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 1 * s;
    canvas.drawCircle(Offset(0, 4 * s), 3 * s, portalPaint);
    canvas.drawCircle(Offset(0, 4 * s), 1.5 * s, Paint()..color = skin.accentColor.withValues(alpha: 0.15));
  }

  void _drawGlitchDetail(Canvas canvas, SkinDefinition skin, double s) {
    final glitchPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 1 * s;
    canvas.drawLine(Offset(-6 * s, -2 * s), Offset(6 * s, -2 * s), glitchPaint);
    canvas.drawLine(Offset(-4 * s, 3 * s), Offset(4 * s, 3 * s), glitchPaint);
    canvas.drawLine(Offset(-2 * s, 8 * s), Offset(2 * s, 8 * s), glitchPaint);
  }

  void _drawFrostDetail(Canvas canvas, SkinDefinition skin, double s) {
    final icePaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1 * s..strokeCap = StrokeCap.round;
    for (final dx in [-4, 0, 4]) {
      final iy = 12 * s + (dx.abs() % 2) * 1.5 * s;
      canvas.drawLine(Offset(dx * s, iy), Offset(dx * s, iy + 2 * s), icePaint);
    }
  }

  void _drawChronoDetail(Canvas canvas, SkinDefinition skin, double s) {
    final clockPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1 * s;
    canvas.drawCircle(Offset(0, 4 * s), 3 * s, clockPaint);
    canvas.drawLine(Offset(0, 4 * s), Offset(0, 2 * s), clockPaint);
    canvas.drawLine(Offset(0, 4 * s), Offset(2 * s, 4 * s), clockPaint);
  }

  void _drawSpectreDetail(Canvas canvas, SkinDefinition skin, double s) {
    final ghostPaint = Paint()..color = Colors.white.withValues(alpha: 0.15);
    canvas.drawOval(Rect.fromCenter(center: const Offset(0, 0), width: 14 * s, height: 20 * s), ghostPaint);
  }

  void _drawViperDetail(Canvas canvas, SkinDefinition skin, double s) {
    final venomPaint = Paint()..color = skin.accentColor..style = PaintingStyle.fill;
    for (final pos in [Offset(-3 * s, 10 * s), Offset(3 * s, 11 * s), Offset(0, 12 * s)]) {
      canvas.drawCircle(pos, 0.6 * s, venomPaint);
    }
  }

  void _drawSparkDetail(Canvas canvas, SkinDefinition skin, double s) {
    final sparkPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1 * s..strokeCap = StrokeCap.round;
    for (final dx in [-5, 5]) {
      canvas.drawLine(Offset(dx * s, -2 * s), Offset((dx - 1) * s, 1 * s), sparkPaint);
      canvas.drawLine(Offset((dx - 1) * s, 1 * s), Offset((dx + 1) * s, 3 * s), sparkPaint);
    }
  }

  void _drawRookieDetail(Canvas canvas, SkinDefinition skin, double s) {
    final dotPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.3);
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(Offset((-2 + i * 2) * s, 6 * s), 0.6 * s, dotPaint);
    }
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
      old.state.expression != state.expression ||
      old.customization != customization;
}
