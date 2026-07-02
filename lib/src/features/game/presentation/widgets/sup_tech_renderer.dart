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
  drawSupTechAngryEye(canvas, skin, -eyeSpacing, eyeY, eyeR, s, true);
  drawSupTechAngryEye(canvas, skin, eyeSpacing, eyeY, eyeR, s, false);
}

void drawSupTechAngryEye(Canvas canvas, SkinDefinition skin, double cx, double cy, double r, double s, bool left) {
  final center = Offset(cx, cy);

  canvas.drawOval(
    Rect.fromCenter(center: center, width: (r + 4 * s) * 2, height: (r + 4 * s) * 2.5),
    Paint()
      ..shader = RadialGradient(colors: [
        skin.accentColor.withValues(alpha: 0.5),
        skin.accentColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCenter(center: center, width: (r + 6 * s) * 2, height: (r + 6 * s) * 2.5)),
  );

  final Path eyePath;
  if (left) {
    eyePath = Path()
      ..moveTo(cx - r * 0.7, cy + r * 0.5)
      ..lineTo(cx + r * 0.7, cy - r * 0.8)
      ..quadraticBezierTo(cx + r * 0.4, cy + r * 0.6, cx - r * 0.7, cy + r * 0.5)
      ..close();
  } else {
    eyePath = Path()
      ..moveTo(cx + r * 0.7, cy + r * 0.5)
      ..lineTo(cx - r * 0.7, cy - r * 0.8)
      ..quadraticBezierTo(cx - r * 0.4, cy + r * 0.6, cx + r * 0.7, cy + r * 0.5)
      ..close();
  }
  canvas.drawPath(eyePath, Paint()..color = Colors.white);
}

void drawSupTechSurprisedEyes(Canvas canvas, SkinDefinition skin, double s, double eyeY, double eyeSpacing, double eyeR) {
  for (final dx in [-eyeSpacing, eyeSpacing]) {
    final center = Offset(dx, eyeY);
    final r = eyeR * 1.05;
    canvas.drawCircle(center, r + 3 * s,
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.5),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: center, radius: r + 4 * s)),
    );
    canvas.drawCircle(center, r, Paint()..color = Colors.white);
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
  final bandPaint = Paint()..color = skin.accentColor;
  final bandRect = Rect.fromLTWH(-headR - 2 * s, bandY - 1.5 * s, headR * 2 + 4 * s, 3 * s);
  canvas.drawRect(bandRect, bandPaint);
  canvas.drawRect(bandRect, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.5 * s);
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final tailOutline = Paint()
    ..color = isLight ? const Color(0xFF94A3B8) : Colors.black87
    ..style = PaintingStyle.stroke..strokeWidth = 0.5 * s;
  final tailPath = Path()
    ..moveTo(-headR - 2 * s, bandY + 1.5 * s)
    ..quadraticBezierTo(-headR - 6 * s, bandY + 8 * s, -headR - 3 * s, bandY + 12 * s);
  canvas.drawPath(tailPath, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1 * s);
  canvas.drawPath(tailPath, tailOutline);
  final tailPath2 = Path()
    ..moveTo(headR + 2 * s, bandY + 1.5 * s)
    ..quadraticBezierTo(headR + 6 * s, bandY + 8 * s, headR + 3 * s, bandY + 12 * s);
  canvas.drawPath(tailPath2, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1 * s);
  canvas.drawPath(tailPath2, tailOutline);
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
  final hornPaint = Paint()..color = skin.accentColor;
  final hornBaseY = hoodPeakY - 1 * s;
  for (final dir in [-1, 1]) {
    final hornPath = Path()
      ..moveTo(dir * headR * 0.4, hornBaseY)
      ..quadraticBezierTo(dir * headR * 0.9, hornBaseY - 6 * s, dir * headR * 0.6, hornBaseY - 10 * s)
      ..quadraticBezierTo(dir * headR * 0.4, hornBaseY - 7 * s, dir * headR * 0.25, hornBaseY - 1 * s);
    canvas.drawPath(hornPath, hornPaint);
    canvas.drawPath(hornPath, Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
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

void _drawHeadset(Canvas canvas, SkinDefinition skin, double s, double headCY, double headR) {
  final bandPaint = Paint()..color = skin.accentColor..style = PaintingStyle.fill;
  final isLightBody = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlinePaint = Paint()
    ..color = isLightBody ? const Color(0xFF94A3B8) : Colors.black87
    ..style = PaintingStyle.stroke..strokeWidth = 0.75 * s..strokeCap = StrokeCap.round;
  final bandPath = Path()
    ..addOval(Rect.fromCenter(center: Offset(0, headCY - 1 * s), width: headR * 2 + 6 * s, height: 3.5 * s))
    ..addOval(Rect.fromCenter(center: Offset(0, headCY - 1 * s), width: headR * 2 - 1 * s, height: 1.2 * s));
  canvas.drawPath(bandPath, bandPaint);
  canvas.drawPath(bandPath, outlinePaint);
  final cupPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.85)..style = PaintingStyle.fill;
  for (final dx in [-headR - 4 * s, headR + 4 * s]) {
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
  final isLight = ThemeData.estimateBrightnessForColor(skin.bodyColor) == Brightness.light;
  final outlineColor = isLight ? const Color(0xFF94A3B8) : Colors.black87;
  final neckY = headCY + headR * 0.6;
  final scarfRect = RRect.fromRectAndRadius(Rect.fromLTWH(-headR - 1 * s, neckY - 2 * s, headR * 2 + 2 * s, 5 * s), Radius.circular(2 * s));
  canvas.drawRRect(scarfRect, scarfPaint);
  canvas.drawRRect(scarfRect, Paint()..color = outlineColor..style = PaintingStyle.stroke..strokeWidth = 0.5 * s);
  final tailPath = Path()
    ..moveTo(-headR, neckY + 3 * s)
    ..quadraticBezierTo(-headR - 5 * s, neckY + 8 * s, -headR - 3 * s, neckY + 14 * s);
  canvas.drawPath(tailPath, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 1.75 * s..strokeCap = StrokeCap.round);
  canvas.drawPath(tailPath, Paint()..color = outlineColor..style = PaintingStyle.stroke..strokeWidth = 0.5 * s);
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
  SupTechEarAccessory accessory,
) {
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
