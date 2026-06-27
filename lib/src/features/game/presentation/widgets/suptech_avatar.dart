import 'dart:math';

import 'package:flutter/material.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';

class SupTechAvatar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SkinPainter(
          skinId: skinId,
          isGlowing: isGlowing,
        ),
      ),
    );
  }
}

class _SkinPainter extends CustomPainter {
  final String? skinId;
  final bool isGlowing;

  _SkinPainter({
    required this.skinId,
    required this.isGlowing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final skin = SkinTierManager.fromId(skinId);

    canvas.save();
    final s = size.width / 60;
    canvas.translate(size.width / 2, size.height / 2 - 2 * s);

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
    final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
    final outlinePaint = Paint()
      ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // === HEAD / HOOD CONSTANTS ===
    final headCY = -9 * s;
    final headR = 11 * s;
    final hoodPeakY = headCY - headR - 4 * s;
    final hoodBaseY = headCY + 4 * s;

    // === FACE CONSTANTS ===
    final faceCY = headCY + 1.5 * s;
    final faceW = 24 * s;
    final faceH = 18 * s;

    // === BODY CONSTANTS ===
    final bodyTopY = hoodBaseY - 1 * s;
    final bodyBotY = 13 * s;
    final bodyShoulderW = 20 * s;
    final bodyWaistW = 16 * s;
    final bodyBaseW = 22 * s;

    // === EYE CONSTANTS ===
    final eyeY = faceCY - 0.5 * s;
    final eyeSpacing = 3 * s;
    final eyeR = 3.2 * s;

    // === DROP SHADOW ===
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, bodyBotY + 2 * s),
          width: 20 * s,
          height: 3 * s),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill,
    );

    // === CAPE (behind robe) ===
    if (skin.accessory == SupTechAccessory.cape) {
      final capePath = Path()
        ..moveTo(-10 * s, bodyTopY)
        ..quadraticBezierTo(-13 * s, bodyBotY * 0.5, -12 * s, bodyBotY + 1 * s)
        ..lineTo(12 * s, bodyBotY + 1 * s)
        ..quadraticBezierTo(13 * s, bodyBotY * 0.5, 10 * s, bodyTopY)
        ..close();
      canvas.drawPath(capePath, accentPaint);
      canvas.drawPath(capePath, outlinePaint);

      final capeFoldPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8 * s;
      canvas.drawLine(
          Offset(-5 * s, bodyTopY), Offset(-6 * s, bodyBotY), capeFoldPaint);
      canvas.drawLine(
          Offset(0, bodyTopY - 1 * s), Offset(0, bodyBotY + 1 * s), capeFoldPaint);
      canvas.drawLine(
          Offset(5 * s, bodyTopY), Offset(6 * s, bodyBotY), capeFoldPaint);
    }

    // === BODY (sitting cross-legged, robe draped) ===
    final bodyPath = Path()
      ..moveTo(-bodyShoulderW / 2, bodyTopY)
      ..quadraticBezierTo(
          -bodyWaistW / 2, bodyTopY + (bodyBotY - bodyTopY) * 0.4,
          -bodyBaseW / 2, bodyBotY)
      ..quadraticBezierTo(-bodyBaseW / 4, bodyBotY + 2 * s, 0, bodyBotY + 1 * s)
      ..quadraticBezierTo(bodyBaseW / 4, bodyBotY + 2 * s, bodyBaseW / 2, bodyBotY)
      ..quadraticBezierTo(
          bodyWaistW / 2, bodyTopY + (bodyBotY - bodyTopY) * 0.4,
          bodyShoulderW / 2, bodyTopY)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, outlinePaint);

    // Robe fold lines (suggesting thick fabric over crossed legs)
    final foldPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(-2 * s, bodyTopY + 2 * s), Offset(-5 * s, bodyBotY), foldPaint);
    canvas.drawLine(
        Offset(2 * s, bodyTopY + 2 * s), Offset(5 * s, bodyBotY), foldPaint);
    canvas.drawLine(
        Offset(0, bodyTopY), Offset(0, bodyBotY + 1 * s), foldPaint);
    // Crossed legs suggestion — two curved lines at bottom
    final legPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(-1 * s, bodyBotY - 2 * s)
        ..quadraticBezierTo(-5 * s, bodyBotY + 1 * s, -8 * s, bodyBotY - 1 * s),
      legPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(1 * s, bodyBotY - 2 * s)
        ..quadraticBezierTo(5 * s, bodyBotY + 1 * s, 8 * s, bodyBotY - 1 * s),
      legPaint,
    );

    // === COLLAR (wrapped fabric around neck) ===
    final collarPaint = Paint()
      ..color = skin.bodyColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    final collarPath = Path()
      ..moveTo(-bodyShoulderW / 2 + 1 * s, bodyTopY + 1 * s)
      ..quadraticBezierTo(-8 * s, bodyTopY - 2 * s, 0, bodyTopY - 1 * s)
      ..quadraticBezierTo(8 * s, bodyTopY - 2 * s,
          bodyShoulderW / 2 - 1 * s, bodyTopY + 1 * s)
      ..quadraticBezierTo(8 * s, bodyTopY + 3 * s, 0, bodyTopY + 4 * s)
      ..quadraticBezierTo(-8 * s, bodyTopY + 3 * s,
          -bodyShoulderW / 2 + 1 * s, bodyTopY + 1 * s)
      ..close();
    canvas.drawPath(collarPath, collarPaint);
    canvas.drawPath(collarPath, outlinePaint);

    // Collar fold lines
    final collarFoldPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 * s;
    canvas.drawLine(
        Offset(-3 * s, bodyTopY), Offset(-2 * s, bodyTopY + 3 * s), collarFoldPaint);
    canvas.drawLine(
        Offset(3 * s, bodyTopY), Offset(2 * s, bodyTopY + 3 * s), collarFoldPaint);

    // === HANDS (clasped in front) ===
    final handY = bodyTopY + 6 * s;
    final handPaint = Paint()
      ..color = skin.bodyColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    // Left hand
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(-1.5 * s, handY), width: 3.5 * s, height: 2.5 * s),
      handPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(-1.5 * s, handY), width: 3.5 * s, height: 2.5 * s),
      outlinePaint,
    );
    // Right hand
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(1.5 * s, handY), width: 3.5 * s, height: 2.5 * s),
      handPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(1.5 * s, handY), width: 3.5 * s, height: 2.5 * s),
      outlinePaint,
    );
    // Fingers suggestion — small lines
    final fingerPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(-2.5 * s, handY - 0.5 * s), Offset(-2.5 * s, handY + 0.5 * s), fingerPaint);
    canvas.drawLine(
        Offset(-1.5 * s, handY - 0.8 * s), Offset(-1.5 * s, handY + 0.8 * s), fingerPaint);
    canvas.drawLine(
        Offset(-0.5 * s, handY - 0.5 * s), Offset(-0.5 * s, handY + 0.5 * s), fingerPaint);
    canvas.drawLine(
        Offset(0.5 * s, handY - 0.5 * s), Offset(0.5 * s, handY + 0.5 * s), fingerPaint);
    canvas.drawLine(
        Offset(1.5 * s, handY - 0.8 * s), Offset(1.5 * s, handY + 0.8 * s), fingerPaint);
    canvas.drawLine(
        Offset(2.5 * s, handY - 0.5 * s), Offset(2.5 * s, handY + 0.5 * s), fingerPaint);

    // === HOOD (smooth dome shape) ===
    final hoodPath = Path()
      ..moveTo(-14 * s, hoodBaseY)
      ..quadraticBezierTo(-14 * s, headCY - headR + 2 * s,
          -headR + 2 * s, hoodPeakY + 2 * s)
      ..quadraticBezierTo(-headR / 2, hoodPeakY - 0.5 * s, 0, hoodPeakY)
      ..quadraticBezierTo(headR / 2, hoodPeakY - 0.5 * s,
          headR - 2 * s, hoodPeakY + 2 * s)
      ..quadraticBezierTo(14 * s, headCY - headR + 2 * s,
          14 * s, hoodBaseY)
      ..quadraticBezierTo(8 * s, hoodBaseY + 2 * s, 0, hoodBaseY + 1 * s)
      ..quadraticBezierTo(-8 * s, hoodBaseY + 2 * s, -14 * s, hoodBaseY)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Hood subtle fabric folds
    final hoodDrapePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(-6 * s, hoodBaseY), Offset(-4 * s, hoodPeakY + 2 * s), hoodDrapePaint);
    canvas.drawLine(
        Offset(6 * s, hoodBaseY), Offset(4 * s, hoodPeakY + 2 * s), hoodDrapePaint);

    // === FACE SHADOW (pure black void, wide oval) ===
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, faceCY), width: faceW, height: faceH),
      Paint()
        ..color = const Color(0xFF050505)
        ..style = PaintingStyle.fill,
    );

    // === GLOWING ROUND EYES ===
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      final eyeCenter = Offset(dx, eyeY);

      // 1. Outer glow ring (soft, diffuse)
      canvas.drawCircle(
        eyeCenter,
        eyeR + 4 * s,
        Paint()
          ..shader = RadialGradient(
            colors: [
              skin.accentColor.withValues(alpha: 0.5),
              skin.accentColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: eyeCenter, radius: eyeR + 6 * s)),
      );

      // 2. Inner glow ring (brighter core)
      canvas.drawCircle(
        eyeCenter,
        eyeR + 1.5 * s,
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withValues(alpha: 0.3),
              skin.accentColor.withValues(alpha: 0.7),
              skin.accentColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCircle(center: eyeCenter, radius: eyeR + 3 * s)),
      );

      // 3. Main iris circle (solid bright fill)
      canvas.drawCircle(eyeCenter, eyeR, accentPaint);

      // 4. Large white highlight dot (upper-right)
      canvas.drawCircle(
        Offset(dx + eyeR * 0.35, eyeY - eyeR * 0.35),
        eyeR * 0.28,
        Paint()..color = Colors.white.withValues(alpha: 0.9),
      );

      // 5. Small white highlight dot (lower-left)
      canvas.drawCircle(
        Offset(dx - eyeR * 0.35, eyeY + eyeR * 0.35),
        eyeR * 0.14,
        Paint()..color = Colors.white.withValues(alpha: 0.7),
      );
    }

    // === ACCESSORIES ===
    _drawAccessory(canvas, skin, headCY, headR, s, accentPaint, outlinePaint);

    // === OUTER GLOW ===
    if (isGlowing) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            skin.accentColor.withValues(alpha: 0.18),
            skin.accentColor.withValues(alpha: 0.0),
          ],
        ).createShader(
            Rect.fromCircle(center: Offset.zero, radius: 42 * s));
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset.zero, width: 84 * s, height: 84 * s),
        glowPaint,
      );
    }
  }

  void _drawAccessory(Canvas canvas, SkinDefinition skin, double headCY,
      double headR, double s, Paint accentPaint, Paint outlinePaint) {
    switch (skin.accessory) {
      case SupTechAccessory.none:
        break;
      case SupTechAccessory.antenna:
        final peakY = headCY - headR - 2 * s;
        canvas.drawLine(
          Offset(0, peakY),
          Offset(0, peakY - 6 * s),
          Paint()
            ..color = Colors.black87
            ..strokeWidth = 2.0 * s
            ..strokeCap = StrokeCap.round,
        );
        canvas.drawCircle(Offset(0, peakY - 6 * s), 2.0 * s, accentPaint);
        canvas.drawCircle(
            Offset(0, peakY - 6 * s), 2.0 * s, outlinePaint);
        break;
      case SupTechAccessory.headband:
        final bandPaint = Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.fill;
        final bandPath = Path()
          ..addOval(Rect.fromCenter(
              center: Offset(0, headCY - 1 * s),
              width: headR * 2 + 6 * s,
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
          ..lineTo(0, headCY - headR - 5 * s)
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
            Offset(0, headCY - headR - 5 * s), 0.8 * s, jewelPaint);
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
                center: Offset(0, headCY + 1.5 * s),
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
          Offset(-headR + 3 * s, headCY + 1.5 * s),
          Offset(-headR + 7 * s, headCY + 1.5 * s),
          reflectPaint,
        );
        break;
      case SupTechAccessory.pointedHat:
        final hatPaint = Paint()
          ..color = skin.bodyColor
          ..style = PaintingStyle.fill;
        final peakY = headCY - headR - 2 * s;
        final hatPath = Path()
          ..moveTo(-headR - 1 * s, headCY - headR + 2 * s)
          ..lineTo(0, peakY - 9 * s)
          ..lineTo(headR + 1 * s, headCY - headR + 2 * s)
          ..close();
        canvas.drawPath(hatPath, hatPaint);
        canvas.drawPath(hatPath, outlinePaint);
        canvas.drawRect(
            Rect.fromLTWH(-headR - 1 * s, headCY - headR + 1 * s,
                headR * 2 + 2 * s, 2.5 * s),
            accentPaint);
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
      old.isGlowing != isGlowing;
}
