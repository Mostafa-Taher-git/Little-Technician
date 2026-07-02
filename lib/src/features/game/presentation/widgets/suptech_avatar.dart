import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';
import 'package:littletech/src/features/game/domain/cubit/suptech_customization_cubit.dart';
import 'package:littletech/src/features/game/domain/models/suptech_customization.dart';
import 'package:littletech/src/features/game/presentation/widgets/sup_tech_renderer.dart';

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
      ..strokeWidth = 1.25 * s
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
      ..strokeWidth = 0.5 * s
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
      ..strokeWidth = 1.5 * s
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
      ..strokeWidth = 1 * s
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
      ..strokeWidth = 0.75 * s
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
      ..style = PaintingStyle.stroke..strokeWidth = 1.25 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

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
    final foldPaint = Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.stroke..strokeWidth = 0.5 * s..strokeCap = StrokeCap.round;
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
      ..style = PaintingStyle.stroke..strokeWidth = 1.25 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

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
    final foldPaint = Paint()..color = Colors.black.withValues(alpha: 0.10)..style = PaintingStyle.stroke..strokeWidth = 0.5 * s..strokeCap = StrokeCap.round;
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
      ..style = PaintingStyle.stroke..strokeWidth = 1.25 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

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
    final circuitPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.25)..style = PaintingStyle.stroke..strokeWidth = 0.4 * s..strokeCap = StrokeCap.round;
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
      Paint()..color = skin.accentColor.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 0.75 * s..strokeCap = StrokeCap.round,
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
      ..style = PaintingStyle.stroke..strokeWidth = 1.25 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final platePaint = Paint()..color = skin.accentColor.withValues(alpha: 0.3)..style = PaintingStyle.fill;
    final plateOutline = Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.4 * s;

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
      Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1 * s..strokeCap = StrokeCap.round);

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
      ..style = PaintingStyle.stroke..strokeWidth = 1.25 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

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
    canvas.drawPath(leftWing, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
    // Right wing
    final rightWing = Path()
      ..moveTo(7 * s, 0)
      ..quadraticBezierTo(18 * s, -5 * s, 20 * s, 5 * s)
      ..quadraticBezierTo(16 * s, 10 * s, 10 * s, 12 * s)
      ..close();
    canvas.drawPath(rightWing, wingPaint);
    canvas.drawPath(rightWing, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);

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
      ..style = PaintingStyle.stroke..strokeWidth = 1.25 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

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
    drawSupTechEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR, effectiveState.expression);
  }

  void _drawBlinkLines(Canvas canvas, SkinDefinition skin, double s,
      double eyeY, double eyeSpacing) {
    final linePaint = Paint()
      ..color = skin.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * s
      ..strokeCap = StrokeCap.round;
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      canvas.drawLine(
        Offset(dx - 3 * s, eyeY),
        Offset(dx + 3 * s, eyeY),
        linePaint,
      );
    }
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
      ..strokeWidth = 0.6 * s
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
    drawSupTechHeadAccessory(canvas, skin, s, headCY, headR, hoodPeakY, accessory);
  }

  // ─────────────────────────────────────────────
  // Ear Accessory (headset)
  // ─────────────────────────────────────────────

  void _drawEarAccessoryValue(Canvas canvas, SkinDefinition skin, double s,
      double headCY, double headR,
      SupTechEarAccessory accessory) {
    drawSupTechEarAccessory(canvas, skin, s, headCY, headR, accessory);
  }

  // ─────────────────────────────────────────────
  // Chest Accessory
  // ─────────────────────────────────────────────

  void _drawChestAccessoryValue(Canvas canvas, SkinDefinition skin, double s,
      double bodyTopY, double bodyBotY,
      SupTechChestAccessory accessory) {
    drawSupTechChestAccessory(canvas, skin, s, bodyTopY, bodyBotY, accessory);
  }

  // ─────────────────────────────────────────────
  // Focused eyes (for working pose)
  // ─────────────────────────────────────────────

  void _drawFocusedEyes(Canvas canvas, double s, double eyeY, double eyeSpacing) {
    drawSupTechFocusedEyes(canvas, s, eyeY, eyeSpacing);
  }

  // ─────────────────────────────────────────────
  // Pose overlay (wave arm, thinking hands, working screen)
  // ─────────────────────────────────────────────

  void _drawPoseOverlay(Canvas canvas, SkinDefinition skin, double s,
      SupTechPose? pose, double eyeY, double eyeSpacing) {
    if (pose == null || pose == SupTechPose.none || pose == SupTechPose.neutral) return;
    drawSupTechPoseOverlay(canvas, skin, s, pose, eyeY, eyeSpacing);
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
    final promptPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.4 * s..strokeCap = StrokeCap.round;
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
    final wrenchPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.6 * s..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(5 * s, 3 * s), Offset(5 * s, 9 * s), wrenchPaint);
    canvas.drawCircle(Offset(5 * s, 3 * s), 1.5 * s, Paint()..style = PaintingStyle.stroke..color = skin.accentColor..strokeWidth = 0.5 * s);
  }

  void _drawGrandmasterDetail(Canvas canvas, SkinDefinition skin, double s) {
    final glowPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.2);
    canvas.drawCircle(Offset(0, -22 * s), 6 * s, glowPaint);
  }

  void _drawCyberDetail(Canvas canvas, SkinDefinition skin, double s) {
    final scanPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.2)..style = PaintingStyle.stroke..strokeWidth = 0.3 * s;
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
    final neonPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.75 * s..strokeCap = StrokeCap.round
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
    final boltPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.6 * s..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-2 * s, -15 * s), Offset(0, -13 * s), boltPaint);
    canvas.drawLine(Offset(0, -13 * s), Offset(2 * s, -15 * s), boltPaint);
  }

  void _drawVoidDetail(Canvas canvas, SkinDefinition skin, double s) {
    final portalPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 0.5 * s;
    canvas.drawCircle(Offset(0, 4 * s), 3 * s, portalPaint);
    canvas.drawCircle(Offset(0, 4 * s), 1.5 * s, Paint()..color = skin.accentColor.withValues(alpha: 0.15));
  }

  void _drawGlitchDetail(Canvas canvas, SkinDefinition skin, double s) {
    final glitchPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.35)..style = PaintingStyle.stroke..strokeWidth = 0.5 * s;
    canvas.drawLine(Offset(-6 * s, -2 * s), Offset(6 * s, -2 * s), glitchPaint);
    canvas.drawLine(Offset(-4 * s, 3 * s), Offset(4 * s, 3 * s), glitchPaint);
    canvas.drawLine(Offset(-2 * s, 8 * s), Offset(2 * s, 8 * s), glitchPaint);
  }

  void _drawFrostDetail(Canvas canvas, SkinDefinition skin, double s) {
    final icePaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.5 * s..strokeCap = StrokeCap.round;
    for (final dx in [-4, 0, 4]) {
      final iy = 12 * s + (dx.abs() % 2) * 1.5 * s;
      canvas.drawLine(Offset(dx * s, iy), Offset(dx * s, iy + 2 * s), icePaint);
    }
  }

  void _drawChronoDetail(Canvas canvas, SkinDefinition skin, double s) {
    final clockPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.5 * s;
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
    final sparkPaint = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.5 * s..strokeCap = StrokeCap.round;
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
