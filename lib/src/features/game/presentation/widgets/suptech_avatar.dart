import 'dart:math';

import 'package:flutter/material.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';

class SupTechAvatar extends StatefulWidget {
  final double size;
  final bool isGlowing;
  final String? skinId;

  const SupTechAvatar({
    super.key,
    this.size = 56,
    this.isGlowing = true,
    this.skinId,
  });

  @override
  State<SupTechAvatar> createState() => _SupTechAvatarState();
}

class _SupTechAvatarState extends State<SupTechAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.isGlowing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SupTechAvatar old) {
    super.didUpdateWidget(old);
    if (widget.isGlowing && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isGlowing && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
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
        builder: (context, child) {
          return CustomPaint(
            painter: _SkinPainter(
              skinId: widget.skinId,
              isGlowing: widget.isGlowing,
              animationValue: _controller.value,
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

  _SkinPainter({
    required this.skinId,
    required this.isGlowing,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final skin = SkinTierManager.fromId(skinId);

    canvas.save();
    final s = size.width / 60;
    canvas.translate(size.width / 2, size.height / 2 + 4 * s);

    _drawHoodedChibi(canvas, skin, s);

    canvas.restore();
  }

  void _drawHoodedChibi(Canvas canvas, SkinDefinition skin, double s) {
    final bodyPaint = Paint()
      ..color = skin.bodyColor
      ..style = PaintingStyle.fill;
    final accentPaint = Paint()
      ..color = skin.accentColor
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // === DROP SHADOW ===
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, 18 * s), width: 14 * s, height: 3 * s),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );

    // === CAPE (behind robe) ===
    if (skin.accessory == SupTechAccessory.cape) {
      final capePath = Path()
        ..moveTo(-7 * s, -14 * s)
        ..quadraticBezierTo(-10 * s, -2 * s, -9 * s, 17 * s)
        ..lineTo(9 * s, 17 * s)
        ..quadraticBezierTo(10 * s, -2 * s, 7 * s, -14 * s)
        ..close();
      canvas.drawPath(capePath, accentPaint);
      canvas.drawPath(capePath, outlinePaint);

      final capeFoldPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8 * s;
      canvas.drawLine(
          Offset(-3 * s, -10 * s), Offset(-3.5 * s, 15 * s), capeFoldPaint);
      canvas.drawLine(
          Offset(0, -12 * s), Offset(0, 16 * s), capeFoldPaint);
      canvas.drawLine(
          Offset(3 * s, -10 * s), Offset(3.5 * s, 15 * s), capeFoldPaint);
    }

    // === ROBE (flowing garment) ===
    final robeTopY = 0 * s;
    final robeBotY = 17 * s;
    final robeTopW = 12 * s;
    final robeBotW = 18 * s;
    final robePath = Path()
      ..moveTo(-robeTopW / 2, robeTopY)
      ..lineTo(robeTopW / 2, robeTopY)
      ..lineTo(robeBotW / 2, robeBotY)
      ..quadraticBezierTo(robeBotW / 4, robeBotY + 2 * s, 0, robeBotY + 1 * s)
      ..quadraticBezierTo(
          -robeBotW / 4, robeBotY + 2 * s, -robeBotW / 2, robeBotY)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Robe fold lines
    final foldPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 * s;
    canvas.drawLine(
        Offset(-2 * s, robeTopY + 2 * s), Offset(-3 * s, robeBotY - 1 * s), foldPaint);
    canvas.drawLine(
        Offset(2 * s, robeTopY + 2 * s), Offset(3 * s, robeBotY - 1 * s), foldPaint);
    canvas.drawLine(
        Offset(0, robeTopY + 1 * s), Offset(0, robeBotY), foldPaint);

    // === BELT ===
    final beltY = 8 * s;
    final beltW = 14 * s;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(0, beltY), width: beltW, height: 2 * s),
        Radius.circular(1 * s),
      ),
      accentPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(0, beltY), width: beltW, height: 2 * s),
        Radius.circular(1 * s),
      ),
      outlinePaint,
    );

    // Belt buckle
    canvas.drawCircle(
      Offset(0, beltY),
      1.5 * s,
      Paint()..color = skin.accentColor.withValues(alpha: 0.7),
    );

    // === FEET (peeking from under robe) ===
    final footY = robeBotY + 1 * s;
    final footSpread = 4 * s;
    for (final dx in [-footSpread, footSpread]) {
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(dx, footY), width: 4 * s, height: 2 * s),
        accentPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(dx, footY), width: 4 * s, height: 2 * s),
        outlinePaint,
      );
    }

    // === HOOD (massive dome) ===
    final headCY = -10 * s;
    final headR = 11 * s;
    canvas.drawCircle(Offset(0, headCY), headR, bodyPaint);
    canvas.drawCircle(Offset(0, headCY), headR, outlinePaint);

    // Hood fold lines
    final hoodFoldPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 * s;
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(0, headCY), width: headR * 1.6, height: headR * 1.6),
      -0.5,
      0.3,
      false,
      hoodFoldPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
          center: Offset(0, headCY), width: headR * 1.6, height: headR * 1.6),
      -2.8,
      0.3,
      false,
      hoodFoldPaint,
    );

    // === FACE SHADOW (dark void inside hood) ===
    final faceCY = headCY + 2 * s;
    final faceW = headR * 1.4;
    final faceH = headR * 1.0;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, faceCY), width: faceW, height: faceH),
      Paint()
        ..color = const Color(0xFF0D1117)
        ..style = PaintingStyle.fill,
    );

    // === GLOWING EYES ===
    final eyeY = faceCY - 1 * s;
    final eyeSpacing = 3.5 * s;
    final eyeW = 3.5 * s;
    final eyeH = 1.5 * s;

    for (final dx in [-eyeSpacing, eyeSpacing]) {
      // Eye glow (soft halo)
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(dx, eyeY), width: eyeW + 3 * s, height: eyeH + 3 * s),
        Paint()
          ..shader = RadialGradient(
            colors: [
              skin.accentColor.withValues(alpha: 0.4),
              skin.accentColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCenter(
              center: Offset(dx, eyeY), width: eyeW + 6 * s, height: eyeH + 6 * s)),
      );

      // Eye slit
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(dx, eyeY), width: eyeW, height: eyeH),
        accentPaint,
      );
    }

    // === ACCESSORIES ===
    _drawAccessory(canvas, skin, headCY, headR, s, accentPaint, outlinePaint);

    // === ENERGY WISPS (animated) ===
    if (isGlowing) {
      _drawWisps(canvas, skin, s);
    }

    // === OUTER GLOW ===
    if (isGlowing) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            skin.accentColor.withValues(alpha: 0.15),
            skin.accentColor.withValues(alpha: 0.0),
          ],
        ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: 40 * s));
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: 80 * s, height: 80 * s),
        glowPaint,
      );
    }
  }

  void _drawWisps(Canvas canvas, SkinDefinition skin, double s) {
    final wispPaint = Paint()
      ..color = skin.accentColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;

    final anim = animationValue;
    final headCY = -10 * s;
    final headR = 11 * s;

    // Wisp 1: upper left
    final w1 = sin(anim * pi * 2) * 2 * s;
    canvas.drawPath(
      Path()
        ..moveTo(-3 * s, -2 * s + w1)
        ..quadraticBezierTo(-10 * s, -8 * s + w1, -14 * s, -4 * s + w1)
        ..quadraticBezierTo(-16 * s, -2 * s + w1, -12 * s, 2 * s + w1),
      wispPaint,
    );

    // Wisp 2: lower left
    final w2 = cos(anim * pi * 2) * 2 * s;
    canvas.drawPath(
      Path()
        ..moveTo(-3 * s, 4 * s + w2)
        ..quadraticBezierTo(-8 * s, 8 * s + w2, -12 * s, 6 * s + w2)
        ..quadraticBezierTo(-14 * s, 4 * s + w2, -10 * s, 0 * s + w2),
      wispPaint,
    );

    // Wisp 3: upper right
    final w3 = sin(anim * pi * 2 + 1) * 2 * s;
    canvas.drawPath(
      Path()
        ..moveTo(3 * s, -2 * s + w3)
        ..quadraticBezierTo(10 * s, -8 * s + w3, 14 * s, -4 * s + w3)
        ..quadraticBezierTo(16 * s, -2 * s + w3, 12 * s, 2 * s + w3),
      wispPaint,
    );

    // Wisp 4: lower right
    final w4 = cos(anim * pi * 2 + 1) * 2 * s;
    canvas.drawPath(
      Path()
        ..moveTo(3 * s, 4 * s + w4)
        ..quadraticBezierTo(8 * s, 8 * s + w4, 12 * s, 6 * s + w4)
        ..quadraticBezierTo(14 * s, 4 * s + w4, 10 * s, 0 * s + w4),
      wispPaint,
    );

    // Wisp 5: top center
    final w5 = sin(anim * pi * 2 + 2) * 1.5 * s;
    final wisp5Paint = Paint()
      ..color = skin.accentColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(0, headCY - headR + 1 * s + w5)
        ..quadraticBezierTo(
            -4 * s, headCY - headR - 5 * s + w5,
            -6 * s, headCY - headR - 2 * s + w5),
      wisp5Paint,
    );
  }

  void _drawAccessory(Canvas canvas, SkinDefinition skin, double headCY,
      double headR, double s, Paint accentPaint, Paint outlinePaint) {
    switch (skin.accessory) {
      case SupTechAccessory.none:
        break;
      case SupTechAccessory.antenna:
        canvas.drawLine(
          Offset(0, headCY - headR + 1 * s),
          Offset(0, headCY - headR - 6 * s),
          Paint()
            ..color = Colors.black87
            ..strokeWidth = 2.0 * s
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawCircle(
            Offset(0, headCY - headR - 6 * s), 2.0 * s, accentPaint);
        canvas.drawCircle(
            Offset(0, headCY - headR - 6 * s), 2.0 * s, outlinePaint);
        break;
      case SupTechAccessory.headband:
        final bandPaint = Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.fill;
        final bandPath = Path()
          ..addOval(Rect.fromCenter(
              center: Offset(0, headCY - 1 * s),
              width: headR * 2 + 3 * s,
              height: 3.5 * s))
          ..addOval(Rect.fromCenter(
              center: Offset(0, headCY - 1 * s),
              width: headR * 2 - 1 * s,
              height: 1.2 * s));
        canvas.drawPath(bandPath, bandPaint);
        canvas.drawPath(bandPath, outlinePaint);
        break;
      case SupTechAccessory.crown:
        final crownPaint = Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.fill;
        final crownPath = Path()
          ..moveTo(-headR + 1 * s, headCY - headR + 2 * s)
          ..lineTo(-headR + 2 * s, headCY - headR - 4 * s)
          ..lineTo(-headR / 2, headCY - headR + 1 * s)
          ..lineTo(0, headCY - headR - 6 * s)
          ..lineTo(headR / 2, headCY - headR + 1 * s)
          ..lineTo(headR - 2 * s, headCY - headR - 4 * s)
          ..lineTo(headR - 1 * s, headCY - headR + 2 * s)
          ..close();
        canvas.drawPath(crownPath, crownPaint);
        canvas.drawPath(crownPath, outlinePaint);
        final jewelPaint = Paint()..color = Colors.redAccent;
        canvas.drawCircle(
            Offset(-headR + 2 * s, headCY - headR - 2 * s),
            0.8 * s,
            jewelPaint);
        canvas.drawCircle(
            Offset(0, headCY - headR - 4 * s), 0.8 * s, jewelPaint);
        canvas.drawCircle(
            Offset(headR - 2 * s, headCY - headR - 2 * s),
            0.8 * s,
            jewelPaint);
        break;
      case SupTechAccessory.visor:
        final visorPaint = Paint()
          ..color = skin.accentColor.withValues(alpha: 0.7)
          ..style = PaintingStyle.fill;
        final visorPath = Path()
          ..addRRect(RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(0, headCY + 2 * s),
                width: headR * 2 - 2 * s,
                height: 3.5 * s),
            Radius.circular(1.5 * s),
          ));
        canvas.drawPath(visorPath, visorPaint);
        canvas.drawPath(visorPath, outlinePaint);
        final reflectPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0 * s;
        canvas.drawLine(
          Offset(-headR + 3 * s, headCY + 2 * s),
          Offset(-headR + 7 * s, headCY + 2 * s),
          reflectPaint,
        );
        break;
      case SupTechAccessory.pointedHat:
        final hatPaint = Paint()
          ..color = skin.bodyColor
          ..style = PaintingStyle.fill;
        final hatPath = Path()
          ..moveTo(-headR - 1 * s, headCY - headR + 2 * s)
          ..lineTo(0, headCY - headR - 12 * s)
          ..lineTo(headR + 1 * s, headCY - headR + 2 * s)
          ..close();
        canvas.drawPath(hatPath, hatPaint);
        canvas.drawPath(hatPath, outlinePaint);
        final bandPath2 = Path()
          ..addRect(Rect.fromLTWH(
            -headR - 1 * s,
            headCY - headR + 1 * s,
            headR * 2 + 2 * s,
            2.5 * s,
          ));
        canvas.drawPath(bandPath2, accentPaint);
        canvas.drawPath(bandPath2, outlinePaint);
        break;
      case SupTechAccessory.cape:
        break;
      case SupTechAccessory.gear:
        final gearPaint = Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.fill;
        const teeth = 8;
        final outerR = 4.0 * s;
        final innerR = 3.0 * s;
        final gearCenter =
            Offset(-headR - 3 * s, headCY - headR - 3 * s);
        final gearPath = Path();
        for (var i = 0; i < teeth; i++) {
          final a1 = (i / teeth) * 2 * pi;
          final a2 = ((i + 0.35) / teeth) * 2 * pi;
          final a3 = ((i + 0.65) / teeth) * 2 * pi;
          final a4 = ((i + 1) / teeth) * 2 * pi;
          final p1 =
              gearCenter + Offset(cos(a1) * outerR, sin(a1) * outerR);
          final p2 =
              gearCenter + Offset(cos(a2) * outerR, sin(a2) * outerR);
          final p3 =
              gearCenter + Offset(cos(a3) * innerR, sin(a3) * innerR);
          final p4 =
              gearCenter + Offset(cos(a4) * innerR, sin(a4) * innerR);
          if (i == 0) {
            gearPath.moveTo(p1.dx, p1.dy);
          } else {
            gearPath.lineTo(p1.dx, p1.dy);
          }
          gearPath.lineTo(p2.dx, p2.dy);
          gearPath.lineTo(p3.dx, p3.dy);
          gearPath.lineTo(p4.dx, p4.dy);
        }
        gearPath.close();
        canvas.drawPath(gearPath, gearPaint);
        canvas.drawPath(gearPath, outlinePaint);
        canvas.drawCircle(
            gearCenter, 1.2 * s, Paint()..color = skin.bodyColor);
        canvas.drawCircle(gearCenter, 1.2 * s, outlinePaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _SkinPainter old) =>
      old.skinId != skinId ||
      old.isGlowing != isGlowing ||
      old.animationValue != animationValue;
}
