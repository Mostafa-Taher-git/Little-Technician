import 'dart:math';

import 'package:flutter/material.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';

class SupTechConceptSheet extends StatelessWidget {
  final SkinDefinition skin;

  const SupTechConceptSheet({super.key, required this.skin});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Concept Sheet: ${skin.name}'),
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Front View'),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 220,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: CustomPaint(
                  painter: _ConceptPainter(skin: skin),
                  size: const Size(220, 260),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _sectionHeader('Expressions'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) {
                return Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: CustomPaint(
                        painter:
                            _ExpressionPainter(skin: skin, expression: i),
                        size: const Size(64, 64),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _expressionName(i),
                      style: TextStyle(
                        fontSize: 10,
                        color:
                            scheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 32),
            _sectionHeader('Color Palette'),
            const SizedBox(height: 12),
            Row(
              children: [
                _colorSwatch('Robe', skin.bodyColor),
                const SizedBox(width: 12),
                _colorSwatch('Glow', skin.accentColor),
              ],
            ),
            const SizedBox(height: 32),
            _sectionHeader('Accessory'),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: skin.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: skin.accentColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_accessoryIcon(skin.accessory),
                      size: 16, color: skin.accentColor),
                  const SizedBox(width: 8),
                  Text(
                    _accessoryName(skin.accessory),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _colorSwatch(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade400,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  static String _expressionName(int i) {
    switch (i) {
      case 0:
        return 'Neutral';
      case 1:
        return 'Happy';
      case 2:
        return 'Angry';
      case 3:
        return 'Surprised';
      case 4:
        return 'Determined';
      case 5:
        return 'Wink';
      default:
        return '';
    }
  }

  static String _accessoryName(SupTechAccessory a) {
    switch (a) {
      case SupTechAccessory.none:
        return 'None';
      case SupTechAccessory.antenna:
        return 'Antenna';
      case SupTechAccessory.headband:
        return 'Headband';
      case SupTechAccessory.crown:
        return 'Crown';
      case SupTechAccessory.visor:
        return 'Visor';
      case SupTechAccessory.pointedHat:
        return 'Pointed Hat';
      case SupTechAccessory.cape:
        return 'Cape';
      case SupTechAccessory.gear:
        return 'Gear';
    }
  }

  static IconData _accessoryIcon(SupTechAccessory a) {
    switch (a) {
      case SupTechAccessory.none:
        return Icons.block;
      case SupTechAccessory.antenna:
        return Icons.cell_tower;
      case SupTechAccessory.headband:
        return Icons.horizontal_rule;
      case SupTechAccessory.crown:
        return Icons.account_tree;
      case SupTechAccessory.visor:
        return Icons.visibility;
      case SupTechAccessory.pointedHat:
        return Icons.architecture;
      case SupTechAccessory.cape:
        return Icons.checkroom;
      case SupTechAccessory.gear:
        return Icons.settings;
    }
  }
}

// ─────────────────────────────────────────────────────
// Hooded Chibi Concept Painter (full body)
// ─────────────────────────────────────────────────────

class _ConceptPainter extends CustomPainter {
  final SkinDefinition skin;

  _ConceptPainter({required this.skin});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
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

    // Drop shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, 18 * s), width: 14 * s, height: 3 * s),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );

    // Cape
    if (skin.accessory == SupTechAccessory.cape) {
      final capePath = Path()
        ..moveTo(-7 * s, -14 * s)
        ..quadraticBezierTo(-10 * s, -2 * s, -9 * s, 17 * s)
        ..lineTo(9 * s, 17 * s)
        ..quadraticBezierTo(10 * s, -2 * s, 7 * s, -14 * s)
        ..close();
      canvas.drawPath(capePath, accentPaint);
      canvas.drawPath(capePath, outlinePaint);
    }

    // Robe
    final robeTopY = 0 * s;
    final robeBotY = 17 * s;
    final robeTopW = 12 * s;
    final robeBotW = 18 * s;
    final robePath = Path()
      ..moveTo(-robeTopW / 2, robeTopY)
      ..lineTo(robeTopW / 2, robeTopY)
      ..lineTo(robeBotW / 2, robeBotY)
      ..quadraticBezierTo(
          robeBotW / 4, robeBotY + 2 * s, 0, robeBotY + 1 * s)
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
    canvas.drawLine(Offset(-2 * s, robeTopY + 2 * s),
        Offset(-3 * s, robeBotY - 1 * s), foldPaint);
    canvas.drawLine(Offset(2 * s, robeTopY + 2 * s),
        Offset(3 * s, robeBotY - 1 * s), foldPaint);

    // Belt
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

    // Feet
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

    // Hood
    final headCY = -10 * s;
    final headR = 11 * s;
    canvas.drawCircle(Offset(0, headCY), headR, bodyPaint);
    canvas.drawCircle(Offset(0, headCY), headR, outlinePaint);

    // Face shadow
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

    // Glowing eyes
    final eyeY = faceCY - 1 * s;
    final eyeSpacing = 3.5 * s;
    final eyeW = 3.5 * s;
    final eyeH = 1.5 * s;

    for (final dx in [-eyeSpacing, eyeSpacing]) {
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(dx, eyeY),
            width: eyeW + 3 * s,
            height: eyeH + 3 * s),
        Paint()
          ..shader = RadialGradient(
            colors: [
              skin.accentColor.withValues(alpha: 0.4),
              skin.accentColor.withValues(alpha: 0.0),
            ],
          ).createShader(Rect.fromCenter(
              center: Offset(dx, eyeY),
              width: eyeW + 6 * s,
              height: eyeH + 6 * s)),
      );
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(dx, eyeY), width: eyeW, height: eyeH),
        accentPaint,
      );
    }

    // Accessories
    _drawAccessory(
        canvas, skin, headCY, headR, s, accentPaint, outlinePaint);

    // Glow
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
  bool shouldRepaint(covariant _ConceptPainter old) =>
      old.skin.id != skin.id;
}

// ─────────────────────────────────────────────────────
// Hooded Chibi Expression Painter (head close-ups)
// ─────────────────────────────────────────────────────

class _ExpressionPainter extends CustomPainter {
  final SkinDefinition skin;
  final int expression;

  _ExpressionPainter({required this.skin, required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    canvas.save();
    final s = size.width / 20;
    canvas.translate(size.width / 2, size.height / 2 + 1 * s);

    final bodyPaint = Paint()
      ..color = skin.bodyColor
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;

    // Hood
    final headR = 8 * s;
    canvas.drawCircle(const Offset(0, 0), headR, bodyPaint);
    canvas.drawCircle(const Offset(0, 0), headR, outlinePaint);

    // Face shadow
    final faceCY = 1.5 * s;
    final faceW = headR * 1.4;
    final faceH = headR * 1.0;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, faceCY), width: faceW, height: faceH),
      Paint()
        ..color = const Color(0xFF0D1117)
        ..style = PaintingStyle.fill,
    );

    // Eyes (varies by expression)
    _drawEyes(canvas, skin, faceCY, s, expression);

    canvas.restore();
  }

  void _drawEyes(Canvas canvas, SkinDefinition skin, double faceCY,
      double s, int expression) {
    final eyeY = faceCY - 0.8 * s;
    final eyeSpacing = 2.8 * s;
    final accentPaint = Paint()
      ..color = skin.accentColor
      ..style = PaintingStyle.fill;

    switch (expression) {
      case 0: // Neutral
        _drawSlitEye(canvas, accentPaint, -eyeSpacing, eyeY, 2.8 * s, 1.2 * s);
        _drawSlitEye(canvas, accentPaint, eyeSpacing, eyeY, 2.8 * s, 1.2 * s);
        break;
      case 1: // Happy (curved up)
        _drawHappyEye(canvas, accentPaint, -eyeSpacing, eyeY, s);
        _drawHappyEye(canvas, accentPaint, eyeSpacing, eyeY, s);
        break;
      case 2: // Angry (angled down)
        _drawAngryEye(canvas, accentPaint, -eyeSpacing, eyeY, s, true);
        _drawAngryEye(canvas, accentPaint, eyeSpacing, eyeY, s, false);
        break;
      case 3: // Surprised (larger)
        _drawSlitEye(canvas, accentPaint, -eyeSpacing, eyeY, 3.0 * s, 1.8 * s);
        _drawSlitEye(canvas, accentPaint, eyeSpacing, eyeY, 3.0 * s, 1.8 * s);
        break;
      case 4: // Determined (narrower)
        _drawSlitEye(canvas, accentPaint, -eyeSpacing, eyeY, 3.0 * s, 0.8 * s);
        _drawSlitEye(canvas, accentPaint, eyeSpacing, eyeY, 3.0 * s, 0.8 * s);
        break;
      case 5: // Wink (one closed)
        _drawWinkEye(canvas, accentPaint, -eyeSpacing, eyeY, s);
        _drawSlitEye(canvas, accentPaint, eyeSpacing, eyeY, 2.8 * s, 1.2 * s);
        break;
    }
  }

  void _drawSlitEye(Canvas canvas, Paint paint, double cx, double cy,
      double w, double h) {
    // Glow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(cx, cy), width: w + 2 * s, height: h + 2 * s),
      Paint()
        ..shader = RadialGradient(
          colors: [
            paint.color.withValues(alpha: 0.4),
            paint.color.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCenter(
            center: Offset(cx, cy), width: w + 4 * s, height: h + 4 * s)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: w, height: h),
      paint,
    );
  }

  double s = 1;

  void _drawHappyEye(Canvas canvas, Paint paint, double cx, double cy,
      double s) {
    final path = Path()
      ..moveTo(cx - 2 * s, cy + 0.5 * s)
      ..quadraticBezierTo(cx, cy - 1.5 * s, cx + 2 * s, cy + 0.5 * s);
    canvas.drawPath(
      path,
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawAngryEye(Canvas canvas, Paint paint, double cx, double cy,
      double s, bool left) {
    final path = Path()
      ..moveTo(cx - (left ? 2 : -2) * s, cy - 1 * s)
      ..lineTo(cx + (left ? -2 : 2) * s, cy + 0.5 * s);
    canvas.drawPath(
      path,
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawWinkEye(Canvas canvas, Paint paint, double cx, double cy,
      double s) {
    canvas.drawPath(
      Path()
        ..moveTo(cx - 2 * s, cy)
        ..lineTo(cx + 2 * s, cy),
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ExpressionPainter old) =>
      old.skin.id != skin.id || old.expression != expression;
}
