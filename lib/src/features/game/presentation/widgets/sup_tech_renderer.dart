import 'dart:math';

import 'package:flutter/material.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';

// ═══════════════════════════════════════════════════════════════════
// Eye drawing – shared by _SkinPainter and _InteractiveConceptPainter
// ═══════════════════════════════════════════════════════════════════

void drawSupTechRoundEye(Canvas canvas, SkinDefinition skin, double cx, double cy, double r, double s) {
  final center = Offset(cx, cy);
  final rx = r * 0.65;
  final ry = r;

  canvas.drawOval(
    Rect.fromCenter(center: center, width: (r + 4 * s) * 2, height: (r + 4 * s) * 2.5),
    Paint()
      ..shader = RadialGradient(colors: [
        skin.accentColor.withValues(alpha: 0.5),
        skin.accentColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCenter(center: center, width: (r + 6 * s) * 2, height: (r + 6 * s) * 2.5)),
  );

  canvas.drawOval(
    Rect.fromCenter(center: center, width: (r + 1.5 * s) * 2, height: (r + 1.5 * s) * 2.5),
    Paint()
      ..shader = RadialGradient(colors: [
        Colors.white.withValues(alpha: 0.3),
        skin.accentColor.withValues(alpha: 0.7),
        skin.accentColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCenter(center: center, width: (r + 3 * s) * 2, height: (r + 3 * s) * 2.5)),
  );

  canvas.drawOval(
    Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
    Paint()..color = Colors.white,
  );

  canvas.drawCircle(Offset(cx + rx * 0.35, cy - ry * 0.35), rx * 0.28,
      Paint()..color = Colors.white.withValues(alpha: 0.9));

  canvas.drawCircle(Offset(cx - rx * 0.35, cy + ry * 0.35), rx * 0.14,
      Paint()..color = Colors.white.withValues(alpha: 0.7));
}

void drawSupTechHappyEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing) {
  for (final dx in [-eyeSpacing, eyeSpacing]) {
    final path = Path()
      ..moveTo(dx - 2.4 * s, eyeY + 0.1 * s)
      ..quadraticBezierTo(dx, eyeY - 2.0 * s, dx + 2.4 * s, eyeY + 0.1 * s);
    canvas.drawPath(
      path,
      Paint()
        ..color = skin.accentColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * s
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 * s),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.25 * s
        ..strokeCap = StrokeCap.round,
    );
  }
}

void drawSupTechAngryEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing, double eyeR) {
  final glowPaint = Paint()
    ..shader = RadialGradient(colors: [
      skin.accentColor.withValues(alpha: 0.5),
      skin.accentColor.withValues(alpha: 0.0),
    ]).createShader(Rect.fromCenter(
      center: Offset(0, eyeY),
      width: (eyeR + 6 * s) * 4,
      height: (eyeR + 6 * s) * 3,
    ));
  canvas.drawOval(
    Rect.fromCenter(center: Offset(0, eyeY), width: (eyeR + 5 * s) * 4, height: (eyeR + 5 * s) * 3),
    glowPaint,
  );

  for (final dx in [-eyeSpacing, eyeSpacing]) {
    Path wedgePath;
    if (dx < 0) {
      wedgePath = Path()
        ..moveTo(dx - 1.8 * s, eyeY - 2.2 * s)
        ..lineTo(dx + 1.8 * s, eyeY + 2.5 * s)
        ..lineTo(dx + 0.8 * s, eyeY + 1.2 * s)
        ..lineTo(dx - 1.2 * s, eyeY - 1.0 * s)
        ..close();
    } else {
      wedgePath = Path()
        ..moveTo(dx + 1.8 * s, eyeY - 2.2 * s)
        ..lineTo(dx - 1.8 * s, eyeY + 2.5 * s)
        ..lineTo(dx - 0.8 * s, eyeY + 1.2 * s)
        ..lineTo(dx + 1.2 * s, eyeY - 1.0 * s)
        ..close();
    }
    canvas.drawPath(wedgePath, Paint()..color = Colors.white);
  }
}

void drawSupTechSurprisedEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing, double eyeR) {
  for (final dx in [-eyeSpacing, eyeSpacing]) {
    final center = Offset(dx, eyeY);

    canvas.drawOval(
      Rect.fromCenter(center: center, width: (eyeR + 5 * s) * 2.6, height: (eyeR + 5 * s) * 2.8),
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.6),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: center, width: (eyeR + 6 * s) * 2.6, height: (eyeR + 6 * s) * 2.8)),
    );

    canvas.drawOval(
      Rect.fromCenter(center: center, width: (eyeR + 2 * s) * 2.2, height: (eyeR + 2 * s) * 2.4),
      Paint()
        ..shader = RadialGradient(colors: [
          Colors.white.withValues(alpha: 0.35),
          skin.accentColor.withValues(alpha: 0.6),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: center, width: (eyeR + 3 * s) * 2.2, height: (eyeR + 3 * s) * 2.4)),
    );

    canvas.drawOval(
      Rect.fromCenter(center: center, width: eyeR * 2.2, height: eyeR * 2.5),
      Paint()..color = Colors.white,
    );
  }
}

void drawSupTechDeterminedEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing, double eyeR) {
  for (final dx in [-eyeSpacing, eyeSpacing]) {
    final center = Offset(dx, eyeY);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: (eyeR + 4 * s) * 2, height: (eyeR + 4 * s) * 2.5),
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.5),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: center, width: (eyeR + 6 * s) * 2, height: (eyeR + 6 * s) * 2.5)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 6.5 * s, height: 2.2 * s),
        Radius.circular(1.1 * s),
      ),
      Paint()..color = Colors.white,
    );
  }
}

void drawSupTechWinkEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing, double eyeR) {
  final dxLeft = -eyeSpacing;
  final path = Path()
    ..moveTo(dxLeft - 2.4 * s, eyeY + 0.1 * s)
    ..quadraticBezierTo(dxLeft, eyeY - 1.6 * s, dxLeft + 2.4 * s, eyeY + 0.1 * s);
  canvas.drawPath(
    path,
    Paint()
      ..color = skin.accentColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 * s),
  );
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25 * s
      ..strokeCap = StrokeCap.round,
  );
  drawSupTechRoundEye(canvas, skin, eyeSpacing, eyeY, eyeR, s);
}

void drawSupTechSleepEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing) {
  final linePaint = Paint()
    ..color = skin.accentColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1 * s
    ..strokeCap = StrokeCap.round;
  for (final dx in [-eyeSpacing, eyeSpacing]) {
    canvas.drawLine(Offset(dx - 2.5 * s, eyeY), Offset(dx + 2.5 * s, eyeY), linePaint);
  }
  final zPaint = Paint()
    ..color = skin.accentColor.withValues(alpha: 0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.6 * s
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

void drawSupTechErrorEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing, double eyeR) {
  final xPaint = Paint()
    ..color = skin.accentColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1 * s
    ..strokeCap = StrokeCap.round;
  for (final dx in [-eyeSpacing, eyeSpacing]) {
    canvas.drawLine(Offset(dx - eyeR * 0.6, eyeY - eyeR * 0.6), Offset(dx + eyeR * 0.6, eyeY + eyeR * 0.6), xPaint);
    canvas.drawLine(Offset(dx + eyeR * 0.6, eyeY - eyeR * 0.6), Offset(dx - eyeR * 0.6, eyeY + eyeR * 0.6), xPaint);
  }
}

void drawSupTechEyes(
  Canvas canvas, SkinDefinition skin, double s,
  double eyeY, double eyeSpacing, double eyeR,
  SupTechExpression expression,
) {
  switch (expression) {
    case SupTechExpression.neutral:
      for (final dx in [-eyeSpacing, eyeSpacing]) {
        drawSupTechRoundEye(canvas, skin, dx, eyeY, eyeR, s);
      }
    case SupTechExpression.happy:
      drawSupTechHappyEyes(canvas, skin, s, eyeY, eyeSpacing);
    case SupTechExpression.angry:
      drawSupTechAngryEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
    case SupTechExpression.surprised:
      drawSupTechSurprisedEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
    case SupTechExpression.determined:
      drawSupTechDeterminedEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
    case SupTechExpression.wink:
      drawSupTechWinkEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
    case SupTechExpression.sleep:
      drawSupTechSleepEyes(canvas, skin, s, eyeY, eyeSpacing);
    case SupTechExpression.error:
      drawSupTechErrorEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR);
  }
}

void drawSupTechFocusedEyes(Canvas canvas, double s, double eyeY, double eyeSpacing) {
  final eyePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.9 * s
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(Offset(-eyeSpacing - 2 * s, eyeY - 0.5 * s), Offset(-eyeSpacing + 2 * s, eyeY + 0.5 * s), eyePaint);
  canvas.drawLine(Offset(eyeSpacing - 2 * s, eyeY - 0.5 * s), Offset(eyeSpacing + 2 * s, eyeY + 0.5 * s), eyePaint);
}

// ═══════════════════════════════════════════════════════════════════
// Head accessories
// ═══════════════════════════════════════════════════════════════════

void _drawAntenna(Canvas canvas, SkinDefinition skin, double s, double hoodPeakY) {
  final peakY = hoodPeakY - 1 * s;
  canvas.drawLine(Offset(0, peakY), Offset(0, peakY - 7 * s),
    Paint()..color = Colors.black87..strokeWidth = 1 * s..strokeCap = StrokeCap.round);
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
  canvas.drawPath(path, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.5 * s);
  canvas.drawCircle(Offset(0, peakY - 8 * s), 1.2 * s, jewelPaint);
}

void _drawWizardHat(Canvas canvas, SkinDefinition skin, double s, double hoodPeakY) {
  final peakY = hoodPeakY - 2 * s;
  final hatPaint = Paint()..color = const Color(0xFF1E293B);
  final bandPaint = Paint()..color = skin.accentColor;
  final cone = Path()..moveTo(-6 * s, peakY)..lineTo(6 * s, peakY)..lineTo(0, peakY - 14 * s);
  canvas.drawPath(cone, hatPaint);
  canvas.drawPath(cone, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.5 * s);
  final bandRect = Rect.fromLTWH(-6 * s, peakY - 1.5 * s, 12 * s, 2.5 * s);
  canvas.drawRect(bandRect, bandPaint);
  canvas.drawRect(bandRect, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.5 * s);
  canvas.drawCircle(Offset(0, peakY - 14 * s), 1.5 * s, Paint()..color = skin.accentColor);
}

void _drawHeadband(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR, double hoodPeakY) {
  final bandY = headCY - headR * 0.3;
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlineColor = isLight ? const Color(0xFF94A3B8) : Colors.black87;
  final outline = Paint()..color = outlineColor..style = PaintingStyle.stroke..strokeWidth = 0.5 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

  final bandH = 3 * s;
  final bandW = headR * 2 + 4 * s;

  // Dark cloth band with rounded corners
  final bandRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(-headR - 2 * s, bandY - bandH / 2, bandW, bandH),
    Radius.circular(0.6 * s),
  );
  canvas.drawRRect(bandRect, Paint()..color = const Color(0xFF1A1A2E));
  canvas.drawRRect(bandRect, outline);

  // Accent trim — small angular chevrons at band ends
  final accentPaint = Paint()..color = skin.accentColor..style = PaintingStyle.fill;
  for (final dir in [-1, 1]) {
    final cx = dir * (headR + 1.5 * s);
    canvas.drawPath(
      Path()..moveTo(cx - 1 * s, bandY - bandH / 2)..lineTo(cx, bandY - bandH / 2 - 0.8 * s)..lineTo(cx + 1 * s, bandY - bandH / 2)..close(),
      accentPaint,
    );
    canvas.drawPath(
      Path()..moveTo(cx - 0.8 * s, bandY + bandH / 2)..lineTo(cx, bandY + bandH / 2 + 0.6 * s)..lineTo(cx + 0.8 * s, bandY + bandH / 2)..close(),
      accentPaint,
    );
  }

  // Filled tails with V-notch
  final tailFill = Paint()..color = const Color(0xFF1A1A2E)..style = PaintingStyle.fill;
  final tailTrim = Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.3 * s..strokeCap = StrokeCap.round;

  // Left tail
  final leftTail = Path()
    ..moveTo(-headR - 2 * s, bandY + bandH / 2)
    ..quadraticBezierTo(-headR - 5 * s, bandY + 5 * s, -headR - 4.5 * s, bandY + 10 * s)
    ..quadraticBezierTo(-headR - 3.5 * s, bandY + 9 * s, -headR - 2.5 * s, bandY + 3 * s)
    ..close();
  canvas.drawPath(leftTail, tailFill);
  canvas.drawPath(leftTail, outline);
  canvas.drawLine(Offset(-headR - 2 * s, bandY + bandH / 2 + 0.3 * s), Offset(-headR - 4 * s, bandY + 8 * s), tailTrim);

  // Right tail
  final rightTail = Path()
    ..moveTo(headR + 2 * s, bandY + bandH / 2)
    ..quadraticBezierTo(headR + 5 * s, bandY + 5 * s, headR + 4.5 * s, bandY + 10 * s)
    ..quadraticBezierTo(headR + 3.5 * s, bandY + 9 * s, headR + 2.5 * s, bandY + 3 * s)
    ..close();
  canvas.drawPath(rightTail, tailFill);
  canvas.drawPath(rightTail, outline);
  canvas.drawLine(Offset(headR + 2 * s, bandY + bandH / 2 + 0.3 * s), Offset(headR + 4 * s, bandY + 8 * s), tailTrim);
}

void _drawVisor(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR) {
  final visorY = headCY + headR * 0.15;
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlineColor = isLight ? const Color(0xFF94A3B8) : Colors.black87;
  final visorRect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(0, visorY), width: headR * 1.6, height: headR * 0.7),
    Radius.circular(3 * s),
  );
  canvas.drawRRect(visorRect, Paint()..color = skin.accentColor.withValues(alpha: 0.35));
  canvas.drawRRect(visorRect, Paint()..color = outlineColor..style = PaintingStyle.stroke..strokeWidth = 0.5 * s);
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(0, visorY), width: headR * 1.2, height: headR * 0.35),
      Radius.circular(2 * s),
    ),
    Paint()..color = Colors.white.withValues(alpha: 0.2),
  );
}

void _drawHorns(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR, double hoodPeakY) {
  final hornBaseY = hoodPeakY - 1 * s;
  final accent = skin.accentColor;
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlineColor = isLight ? const Color(0xFF94A3B8) : Colors.black87;
  final outline = Paint()..color = outlineColor..style = PaintingStyle.stroke..strokeWidth = 0.4 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

  // Cosmic glow between horns
  final glowCenter = Offset(0, hornBaseY - 4 * s);
  canvas.drawCircle(
    glowCenter, 8 * s,
    Paint()..shader = RadialGradient(
      colors: [accent.withValues(alpha: 0.25), accent.withValues(alpha: 0.0)],
    ).createShader(Rect.fromCircle(center: glowCenter, radius: 8 * s)),
  );

  for (final dir in [-1, 1]) {
    // Filled horn path — thicker and more curved
    final hornPaint = Paint()..color = accent;
    final hornPath = Path()
      ..moveTo(dir * headR * 0.35, hornBaseY)
      ..quadraticBezierTo(dir * headR * 1.0, hornBaseY - 6 * s, dir * headR * 0.7, hornBaseY - 11 * s)
      ..quadraticBezierTo(dir * headR * 0.55, hornBaseY - 9 * s, dir * headR * 0.45, hornBaseY - 1 * s)
      ..close();
    canvas.drawPath(hornPath, hornPaint);
    canvas.drawPath(hornPath, outline);

    // Inner glow line on horn
    canvas.drawPath(
      Path()
        ..moveTo(dir * headR * 0.4, hornBaseY - 2 * s)
        ..quadraticBezierTo(dir * headR * 0.75, hornBaseY - 7 * s, dir * headR * 0.6, hornBaseY - 10 * s),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke..strokeWidth = 0.3 * s..strokeCap = StrokeCap.round,
    );

    // Mystical dot at tip
    canvas.drawCircle(
      Offset(dir * headR * 0.7, hornBaseY - 11 * s),
      0.4 * s,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
    );
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
  canvas.drawPath(crestPath, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
}

void drawSupTechHeadAccessory(
  Canvas canvas, SkinDefinition skin, double s,
  double headCY, double headR, double hoodPeakY,
  SupTechHeadAccessory accessory,
) {
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

// ═══════════════════════════════════════════════════════════════════
// Ear accessories
// ═══════════════════════════════════════════════════════════════════

void _drawHeadset(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR, double hoodPeakY) {
  final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final accent = skin.accentColor;
  final outlineColor = isLightBody ? const Color(0xFF94A3B8) : Colors.black87;
  final fillPaint = Paint()..color = accent;
  final outlinePaint = Paint()
    ..color = outlineColor
    ..style = PaintingStyle.stroke..strokeWidth = 0.6 * s..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

  final cupW = 2.8 * s;
  final cupH = 4.5 * s;
  final cupOffset = headR + 3 * s;

  // Headband arc — thin curve from left cup over the hood peak to right cup
  final bandPaint = Paint()
    ..color = accent
    ..style = PaintingStyle.stroke..strokeWidth = 1.2 * s..strokeCap = StrokeCap.round;
  final bandPath = Path()
    ..moveTo(-cupOffset, headCY)
    ..cubicTo(-cupOffset, hoodPeakY - 6 * s, cupOffset, hoodPeakY - 6 * s, cupOffset, headCY);
  canvas.drawPath(bandPath, bandPaint);
  canvas.drawPath(bandPath, outlinePaint);

  // Ear cups (left and right)
  for (final dx in [-cupOffset, cupOffset]) {
    final cupRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(dx, headCY), width: cupW, height: cupH),
      Radius.circular(1.2 * s),
    );
    canvas.drawRRect(cupRect, fillPaint..style = PaintingStyle.fill);
    canvas.drawRRect(cupRect, outlinePaint);

    // Inner ear cushion
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(dx, headCY), width: cupW * 0.55, height: cupH * 0.65),
      Radius.circular(0.6 * s),
    );
    canvas.drawRRect(innerRect, Paint()..color = Colors.black.withValues(alpha: 0.2));
  }

  // Microphone boom from left ear cup toward mouth
  final micPaint = Paint()
    ..color = accent
    ..style = PaintingStyle.stroke..strokeWidth = 0.6 * s..strokeCap = StrokeCap.round;
  final micPath = Path()
    ..moveTo(-cupOffset - 0.5 * s, headCY + 0.5 * s)
    ..cubicTo(-cupOffset - 2 * s, headCY + 3 * s, -cupOffset - 1 * s, headCY + 5 * s, -cupOffset + 1 * s, headCY + 6 * s);
  canvas.drawPath(micPath, micPaint);
  canvas.drawPath(micPath, outlinePaint);

  // Mic tip
  final micTip = Offset(-cupOffset + 1 * s, headCY + 6 * s);
  canvas.drawCircle(micTip, 0.8 * s, Paint()..color = accent);
  canvas.drawCircle(micTip, 0.8 * s, outlinePaint);
}

void _drawEarGlow(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR) {
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlineColor = isLight ? skin.accentColor.withValues(alpha: 0.6) : Colors.black87;
  final glowPaint = Paint();
  for (final dx in [-headR * 0.7, headR * 0.7]) {
    final center = Offset(dx, headCY);
    canvas.drawCircle(center, 3 * s,
      glowPaint..shader = RadialGradient(colors: [
        skin.accentColor, skin.accentColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCircle(center: center, radius: 3 * s)));
    canvas.drawCircle(center, 1.5 * s, Paint()..color = skin.accentColor);
    canvas.drawCircle(center, 1.5 * s, Paint()..color = outlineColor..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
  }
}

void drawSupTechEarAccessory(
  Canvas canvas, SkinDefinition skin, double s,
  double headCY, double headR,
  SupTechEarAccessory accessory, {
  double? hoodPeakY,
}) {
  switch (accessory) {
    case SupTechEarAccessory.none:
      return;
    case SupTechEarAccessory.headset:
      _drawHeadset(canvas, skin, s, headCY, headR, hoodPeakY ?? headCY - 20 * s);
    case SupTechEarAccessory.earGlow:
      _drawEarGlow(canvas, skin, s, headCY, headR);
  }
}

// ═══════════════════════════════════════════════════════════════════
// Chest accessories
// ═══════════════════════════════════════════════════════════════════

void _drawBadge(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
  final badgeY = bodyTopY + (bodyBotY - bodyTopY) * 0.45;
  if (skin.showLogo) {
    final textSpan = TextSpan(
      text: 'ST',
      style: TextStyle(
        fontSize: 9 * s, fontWeight: FontWeight.w800, color: Colors.white,
        fontFamily: 'Montserrat',
        shadows: [
          Shadow(color: skin.accentColor, blurRadius: 6 * s),
          Shadow(color: skin.accentColor, blurRadius: 2 * s),
        ],
      ),
    );
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, badgeY - textPainter.height / 2));
  }
}

void _drawCape(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlineColor = isLight ? const Color(0xFF94A3B8) : Colors.black87;
  final capePaint = Paint()..color = skin.bodyColor.withValues(alpha: 0.7);
  final capePath = Path()
    ..moveTo(-6 * s, bodyTopY + 2 * s)
    ..lineTo(-8 * s, bodyBotY)
    ..lineTo(8 * s, bodyBotY)
    ..lineTo(6 * s, bodyTopY + 2 * s);
  canvas.drawPath(capePath, capePaint);
  canvas.drawPath(capePath, Paint()..color = outlineColor..style = PaintingStyle.stroke..strokeWidth = 0.75 * s);
}

void _drawCodeScroll(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
  final scrollY = bodyTopY + (bodyBotY - bodyTopY) * 0.4;
  final scrollPaint = Paint()..color = const Color(0xFFFEF3C7);
  final scrollRect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(0, scrollY), width: 6 * s, height: 8 * s),
    Radius.circular(1 * s),
  );
  canvas.drawRRect(scrollRect, scrollPaint);
  canvas.drawRRect(scrollRect, Paint()..color = Colors.brown..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
  for (var i = 0; i < 3; i++) {
    canvas.drawLine(
      Offset(-2 * s, scrollY - 2 * s + i * 2.5 * s),
      Offset(-2 * s + 3 * s, scrollY - 2 * s + i * 2.5 * s),
      Paint()..color = Colors.black54..strokeWidth = 0.4 * s..strokeCap = StrokeCap.round,
    );
  }
}

void _drawGear(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
  final gearY = bodyTopY + (bodyBotY - bodyTopY) * 0.45;
  final gearPaint = Paint()..color = skin.accentColor;
  canvas.drawCircle(Offset(0, gearY), 4 * s, gearPaint..style = PaintingStyle.fill);
  canvas.drawCircle(Offset(0, gearY), 4 * s, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
  for (var i = 0; i < 6; i++) {
    final angle = i * 3.14159 / 3;
    final cx = 5.5 * s * cos(angle);
    final cy = 5.5 * s * sin(angle);
    canvas.drawCircle(Offset(cx, cy + gearY), 1.5 * s, gearPaint..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(cx, cy + gearY), 1.5 * s, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.3 * s);
  }
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
  canvas.drawPath(flamePath, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
  final innerFlame = Path()
    ..moveTo(0, flameY - 2 * s)
    ..quadraticBezierTo(1.5 * s, flameY, 2 * s, flameY + 1 * s)
    ..quadraticBezierTo(1 * s, flameY + 2 * s, 0, flameY + 2.5 * s)
    ..quadraticBezierTo(-1 * s, flameY + 2 * s, -2 * s, flameY + 1 * s)
    ..quadraticBezierTo(-1.5 * s, flameY, 0, flameY - 2 * s);
  canvas.drawPath(innerFlame, Paint()..color = const Color(0xFFFDE68A));
  canvas.drawPath(innerFlame, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.3 * s);
}

void _drawStaff(Canvas canvas, SkinDefinition skin, double s, double bodyTopY, double bodyBotY) {
  final staffX = 6 * s;
  canvas.drawLine(Offset(staffX, bodyTopY + 2 * s), Offset(staffX, bodyBotY - 2 * s),
    Paint()..color = const Color(0xFF78350F)..strokeWidth = 0.75 * s..strokeCap = StrokeCap.round);
  final crystalCenter = Offset(staffX, bodyTopY + 1 * s);
  canvas.drawCircle(crystalCenter, 2 * s, Paint()..color = skin.accentColor);
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  canvas.drawCircle(crystalCenter, 2 * s,
    Paint()..color = isLight ? const Color(0xFF94A3B8) : Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
  canvas.drawCircle(crystalCenter, 3 * s,
    Paint()..shader = RadialGradient(colors: [
      skin.accentColor.withValues(alpha: 0.4), skin.accentColor.withValues(alpha: 0.0),
    ]).createShader(Rect.fromCircle(center: crystalCenter, radius: 3 * s)));
}

void drawSupTechChestAccessory(
  Canvas canvas, SkinDefinition skin, double s,
  double bodyTopY, double bodyBotY,
  SupTechChestAccessory accessory,
) {
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

// ═══════════════════════════════════════════════════════════════════
// Pose overlay (wave, thinking, working)
// ═══════════════════════════════════════════════════════════════════

void drawSupTechPoseOverlay(
  Canvas canvas, SkinDefinition skin, double s,
  SupTechPose pose, double eyeY, double eyeSpacing,
) {
  final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlinePaint = Paint()
    ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.25 * s
    ..strokeCap = StrokeCap.round;

  switch (pose) {
    case SupTechPose.wave:
      final armStartX = -8 * s;
      final armStartY = -1 * s;
      final handX = -15 * s;
      final handY = -25 * s;
      final armPath = Path()
        ..moveTo(armStartX, armStartY)
        ..quadraticBezierTo(armStartX - 4 * s, (armStartY + handY) / 2, handX, handY);
      canvas.drawPath(
        armPath,
        Paint()
          ..color = skin.bodyColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * s
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawPath(armPath, outlinePaint);
      canvas.drawCircle(Offset(handX, handY - 2 * s), 2.5 * s, Paint()..color = skin.bodyColor);
      canvas.drawCircle(Offset(handX, handY - 2 * s), 2.5 * s, outlinePaint);
      final wavePaint = Paint()
        ..color = skin.accentColor.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.4 * s
        ..strokeCap = StrokeCap.round;
      for (final i in [0, 1, 2]) {
        final radius = (3 + i * 1.5) * s;
        canvas.drawArc(
          Rect.fromCenter(center: Offset(handX, handY - 2 * s), width: radius * 2, height: radius * 2),
          -pi * 0.2, pi * 0.6, false, wavePaint,
        );
      }
    case SupTechPose.thinking:
      final handY = -1 * s;
      final handPaint = Paint()..color = skin.bodyColor;
      canvas.drawOval(Rect.fromCenter(center: Offset(-2.5 * s, handY), width: 4 * s, height: 3.5 * s), handPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(-2.5 * s, handY), width: 4 * s, height: 3.5 * s), outlinePaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(2.5 * s, handY), width: 4 * s, height: 3.5 * s), handPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(2.5 * s, handY), width: 4 * s, height: 3.5 * s), outlinePaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(0, handY + 2 * s), width: 5.5 * s, height: 4 * s), handPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(0, handY + 2 * s), width: 5.5 * s, height: 4 * s), outlinePaint);
    case SupTechPose.working:
      final screenY = -17 * s;
      final screenRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, screenY), width: 16 * s, height: 11 * s),
        Radius.circular(1.2 * s),
      );
      canvas.drawRRect(screenRect, Paint()..color = skin.accentColor.withValues(alpha: 0.18));
      canvas.drawRRect(
        screenRect,
        Paint()
          ..color = outlinePaint.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6 * s,
      );
      for (final lineY in [screenY - 3 * s, screenY, screenY + 3 * s]) {
        canvas.drawLine(
          Offset(-5 * s, lineY), Offset(5 * s, lineY),
          Paint()..color = skin.accentColor.withValues(alpha: 0.45)..strokeWidth = 0.35 * s,
        );
      }
    case SupTechPose.none:
    case SupTechPose.neutral:
      break;
  }
}

void drawNinjaFaceScarf(Canvas canvas, SkinDefinition skin, double s,
    double faceCY, double faceW, double faceH) {
  final color = skin.accentColor;
  final darker = Color.lerp(color, Colors.black, 0.15)!;
  final lighter = Color.lerp(color, Colors.white, 0.08)!;
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlineColor = isLight ? const Color(0xFF94A3B8) : Colors.black87;
  final outline = Paint()
    ..color = outlineColor
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.4 * s
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  // Face-geometry constants
  //   Face oval: center (0, faceCY), rx=faceW/2, ry=faceH/2
  //   Eye bottom: faceCY + (eyeY - faceCY) + eyeR ≈ faceCY + 3.4*s
  final rx = faceW / 2;          // 11.75 * s
  final ry = faceH / 2;          //  7.25 * s
  final upperY = faceCY + 3.2 * s;   // just below eyes
  final lowerY = faceCY + 7.0 * s;   // under chin

  // Helper: x-coordinate on the face oval at a given y-offset from center
  double faceEdgeX(double y) {
    final dy = (y - faceCY) / ry;
    if (dy.abs() >= 1) return 0;
    return rx * sqrt(1 - dy * dy);
  }

  final foldPaint = Paint()
    ..color = darker.withValues(alpha: 0.20)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.3 * s
    ..strokeCap = StrokeCap.round;

  // ────────────────────────────────────────────
  // Main cloth layer — tight wrap across cheeks
  //  Upper edge follows face oval, bottom edge
  //  has gentle undulations for fabric drape.
  // ────────────────────────────────────────────
  final mask = Path()
    ..moveTo(-faceEdgeX(upperY) - 0.3 * s, upperY)
    ..quadraticBezierTo(-faceEdgeX(upperY) * 0.45, upperY + 0.4 * s, 0, upperY + 0.15 * s)
    ..quadraticBezierTo(faceEdgeX(upperY) * 0.45, upperY + 0.4 * s, faceEdgeX(upperY) + 0.3 * s, upperY)
    ..quadraticBezierTo(faceEdgeX(upperY) + 1.2 * s, upperY + 2 * s, faceEdgeX(lowerY - 0.8 * s) + 0.8 * s, lowerY - 1.5 * s)
    ..quadraticBezierTo(faceEdgeX(lowerY) * 0.6, lowerY - 0.5 * s, faceEdgeX(lowerY) * 0.35, lowerY + 0.3 * s)
    ..quadraticBezierTo(0, lowerY + 0.8 * s, -faceEdgeX(lowerY) * 0.3, lowerY + 0.1 * s)
    ..quadraticBezierTo(-faceEdgeX(lowerY) * 0.6, lowerY - 0.4 * s, -faceEdgeX(lowerY) * 0.9, lowerY - 1 * s)
    ..quadraticBezierTo(-faceEdgeX(upperY) - 1.2 * s, upperY + 2.5 * s, -faceEdgeX(upperY) - 0.3 * s, upperY)
    ..close();
  canvas.drawPath(mask, Paint()..color = color);
  canvas.drawPath(mask, outline);

  // ────────────────────────────────────────────
  // Overlapping wrap — the visible edge where the
  //  cloth end was folded across the face.
  // ────────────────────────────────────────────
  final wrapCenter = (upperY + lowerY) / 2;
  final wrapEdgeX = faceEdgeX(wrapCenter) * 0.75;
  final wrapOverlap = Path()
    ..moveTo(-wrapEdgeX - 2 * s, lowerY - 1 * s)
    ..quadraticBezierTo(-wrapEdgeX, wrapCenter, 0, upperY + 0.5 * s)
    ..quadraticBezierTo(wrapEdgeX, wrapCenter + 1 * s, wrapEdgeX + 2.5 * s, upperY + 0.3 * s)
    ..quadraticBezierTo(wrapEdgeX + 2.8 * s, upperY + 1.5 * s, wrapEdgeX + 1.5 * s, lowerY - 1.5 * s)
    ..quadraticBezierTo(0, lowerY - 0.5 * s, -wrapEdgeX - 2 * s, lowerY - 1 * s)
    ..close();
  canvas.drawPath(wrapOverlap, Paint()..color = lighter.withValues(alpha: 0.18));
  canvas.drawPath(wrapOverlap, outline);

  // ────────────────────────────────────────────
  // Fabric folds & cheek-tension wrinkles
  // ────────────────────────────────────────────
  // Nose-bridge vertical dip
  canvas.drawPath(
    Path()..moveTo(0, upperY + 0.15 * s)..quadraticBezierTo(0.3 * s, upperY + 1.2 * s, -0.2 * s, faceCY + 2.3 * s),
    foldPaint,
  );
  // Left cheek tension pulling outward
  canvas.drawPath(
    Path()..moveTo(-3.2 * s, upperY + 0.5 * s)..quadraticBezierTo(-4.5 * s, upperY + 2.5 * s, -5.2 * s, faceCY + 4 * s),
    foldPaint,
  );
  // Right cheek tension pulling outward
  canvas.drawPath(
    Path()..moveTo(3.2 * s, upperY + 0.5 * s)..quadraticBezierTo(4.5 * s, upperY + 2.5 * s, 5.2 * s, faceCY + 4 * s),
    foldPaint,
  );
  // Bottom fabric drape folds
  canvas.drawPath(
    Path()..moveTo(-3 * s, faceCY + 5.5 * s)..quadraticBezierTo(-1.5 * s, faceCY + 6.5 * s, 0.5 * s, faceCY + 6.8 * s),
    foldPaint,
  );
  canvas.drawPath(
    Path()..moveTo(2.5 * s, faceCY + 5.5 * s)..quadraticBezierTo(1.5 * s, faceCY + 6.8 * s, 0, faceCY + 7 * s),
    foldPaint,
  );
  // Subtle horizontal wrap line across mid-face
  canvas.drawPath(
    Path()..moveTo(-5 * s, faceCY + 3.5 * s)..quadraticBezierTo(0, faceCY + 4 * s, 5 * s, faceCY + 3.5 * s),
    Paint()
      ..color = darker.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke..strokeWidth = 0.25 * s..strokeCap = StrokeCap.round,
  );

  // ────────────────────────────────────────────
  // Knot — right side, near the jaw hinge
  // ────────────────────────────────────────────
  final knotX = faceEdgeX(faceCY + 4.2 * s) + 0.3 * s;
  final knotY = faceCY + 4.2 * s;
  canvas.drawCircle(Offset(knotX, knotY), 0.8 * s, Paint()..color = darker);
  canvas.drawCircle(Offset(knotX, knotY), 0.8 * s, outline);
  canvas.drawLine(
    Offset(knotX - 0.3 * s, knotY - 0.4 * s), Offset(knotX + 0.3 * s, knotY + 0.4 * s),
    Paint()..color = outlineColor..strokeWidth = 0.2 * s,
  );

  // ────────────────────────────────────────────
  // Hanging tails — two strips originating from
  //  the knot, swept downward and to the right.
  // ────────────────────────────────────────────
  final tailFill = Paint()..color = color..style = PaintingStyle.fill;
  final tailOut = Paint()
    ..color = outlineColor
    ..style = PaintingStyle.stroke..strokeWidth = 0.35 * s
    ..strokeCap = StrokeCap.round;

  // Tail 1 — long, vertical drape
  canvas.drawPath(
    Path()
      ..moveTo(knotX + 0.2 * s, knotY + 0.5 * s)
      ..cubicTo(knotX + 2.5 * s, knotY + 3 * s, knotX + 2.8 * s, knotY + 7 * s, knotX + 1.8 * s, knotY + 10 * s)
      ..quadraticBezierTo(knotX + 0.8 * s, knotY + 8 * s, knotX - 0.2 * s, knotY + 0.8 * s)
      ..close(),
    tailFill,
  );
  canvas.drawPath(
    Path()
      ..moveTo(knotX + 0.2 * s, knotY + 0.5 * s)
      ..cubicTo(knotX + 2.5 * s, knotY + 3 * s, knotX + 2.8 * s, knotY + 7 * s, knotX + 1.8 * s, knotY + 10 * s),
    tailOut,
  );
  // Tail 2 — shorter, swept more horizontally
  canvas.drawPath(
    Path()
      ..moveTo(knotX + 0.5 * s, knotY - 0.1 * s)
      ..cubicTo(knotX + 3.5 * s, knotY + 1.5 * s, knotX + 5 * s, knotY + 3 * s, knotX + 4.5 * s, knotY + 5 * s)
      ..quadraticBezierTo(knotX + 3 * s, knotY + 3 * s, knotX + 0.3 * s, knotY + 0.2 * s)
      ..close(),
    tailFill,
  );
  canvas.drawPath(
    Path()
      ..moveTo(knotX + 0.5 * s, knotY - 0.1 * s)
      ..cubicTo(knotX + 3.5 * s, knotY + 1.5 * s, knotX + 5 * s, knotY + 3 * s, knotX + 4.5 * s, knotY + 5 * s),
    tailOut,
  );
}
