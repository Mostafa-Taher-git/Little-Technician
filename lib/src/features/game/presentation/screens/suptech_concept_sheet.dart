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
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Head / Hood constants
    final headCY = -9 * s;
    final headR = 11 * s;
    final hoodPeakY = headCY - headR - 4 * s;
    final hoodBaseY = headCY + 4 * s;

    // Face constants
    final faceCY = headCY + 1.5 * s;
    final faceW = 24 * s;
    final faceH = 18 * s;

    // Body constants
    final bodyTopY = hoodBaseY - 1 * s;
    final bodyBotY = 13 * s;
    final bodyShoulderW = 20 * s;
    final bodyWaistW = 16 * s;
    final bodyBaseW = 22 * s;

    // Eye constants
    final eyeY = faceCY - 0.5 * s;
    final eyeSpacing = 3 * s;
    final eyeR = 3.2 * s;

    // Drop shadow
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, bodyBotY + 2 * s), width: 20 * s, height: 3 * s),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..style = PaintingStyle.fill,
    );

    // Cape
    if (skin.accessory == SupTechAccessory.cape) {
      final capePath = Path()
        ..moveTo(-10 * s, bodyTopY)
        ..quadraticBezierTo(-13 * s, bodyBotY * 0.5, -12 * s, bodyBotY + 1 * s)
        ..lineTo(12 * s, bodyBotY + 1 * s)
        ..quadraticBezierTo(13 * s, bodyBotY * 0.5, 10 * s, bodyTopY)
        ..close();
      canvas.drawPath(capePath, accentPaint);
      canvas.drawPath(capePath, outlinePaint);
    }

    // Body (sitting cross-legged, robe draped)
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

    // Robe fold lines
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

    // Collar
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

    // Hands (clasped in front)
    final handY = bodyTopY + 6 * s;
    final handPaint = Paint()
      ..color = skin.bodyColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
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

    // Hood (smooth dome)
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

    // Hood folds
    final hoodDrapePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(-6 * s, hoodBaseY), Offset(-4 * s, hoodPeakY + 2 * s), hoodDrapePaint);
    canvas.drawLine(
        Offset(6 * s, hoodBaseY), Offset(4 * s, hoodPeakY + 2 * s), hoodDrapePaint);

    // Face shadow (pure black void)
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, faceCY), width: faceW, height: faceH),
      Paint()
        ..color = const Color(0xFF050505)
        ..style = PaintingStyle.fill,
    );

    // Round eyes with glow + highlight dots
    for (final dx in [-eyeSpacing, eyeSpacing]) {
      final eyeCenter = Offset(dx, eyeY);

      // Outer glow
      canvas.drawCircle(
        eyeCenter,
        eyeR + 4 * s,
        Paint()
          ..shader = RadialGradient(colors: [
            skin.accentColor.withValues(alpha: 0.5),
            skin.accentColor.withValues(alpha: 0.0),
          ]).createShader(
              Rect.fromCircle(center: eyeCenter, radius: eyeR + 6 * s)),
      );

      // Inner glow
      canvas.drawCircle(
        eyeCenter,
        eyeR + 1.5 * s,
        Paint()
          ..shader = RadialGradient(colors: [
            Colors.white.withValues(alpha: 0.3),
            skin.accentColor.withValues(alpha: 0.7),
            skin.accentColor.withValues(alpha: 0.0),
          ]).createShader(
              Rect.fromCircle(center: eyeCenter, radius: eyeR + 3 * s)),
      );

      // Main iris
      canvas.drawCircle(eyeCenter, eyeR, accentPaint);

      // Large white highlight (upper-right)
      canvas.drawCircle(
        Offset(dx + eyeR * 0.35, eyeY - eyeR * 0.35),
        eyeR * 0.28,
        Paint()..color = Colors.white.withValues(alpha: 0.9),
      );

      // Small white highlight (lower-left)
      canvas.drawCircle(
        Offset(dx - eyeR * 0.35, eyeY + eyeR * 0.35),
        eyeR * 0.14,
        Paint()..color = Colors.white.withValues(alpha: 0.7),
      );
    }

    // Glow
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset.zero, width: 84 * s, height: 84 * s),
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.18),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(
            Rect.fromCircle(center: Offset.zero, radius: 42 * s)),
    );
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

    // Hood (smooth dome)
    final headR = 8 * s;
    const headCY = 0.0;
    final hoodPeakY = headCY - headR - 3 * s;
    final hoodBaseY = headCY + 3 * s;

    final hoodPath = Path()
      ..moveTo(-11 * s, hoodBaseY)
      ..quadraticBezierTo(-11 * s, headCY - headR + 1 * s,
          -headR + 1 * s, hoodPeakY + 1.5 * s)
      ..quadraticBezierTo(-headR / 2, hoodPeakY - 0.5 * s, 0, hoodPeakY)
      ..quadraticBezierTo(headR / 2, hoodPeakY - 0.5 * s,
          headR - 1 * s, hoodPeakY + 1.5 * s)
      ..quadraticBezierTo(11 * s, headCY - headR + 1 * s,
          11 * s, hoodBaseY)
      ..quadraticBezierTo(6 * s, hoodBaseY + 1.5 * s, 0, hoodBaseY + 1 * s)
      ..quadraticBezierTo(-6 * s, hoodBaseY + 1.5 * s, -11 * s, hoodBaseY)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Hood folds
    final hoodDrapePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(-4 * s, hoodBaseY), Offset(-3 * s, hoodPeakY + 1 * s), hoodDrapePaint);
    canvas.drawLine(
        Offset(4 * s, hoodBaseY), Offset(3 * s, hoodPeakY + 1 * s), hoodDrapePaint);

    // Face shadow (pure black)
    final faceCY = headCY + 0.5 * s;
    final faceW = 20 * s;
    final faceH = 15 * s;
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(0, faceCY), width: faceW, height: faceH),
      Paint()
        ..color = const Color(0xFF050505)
        ..style = PaintingStyle.fill,
    );

    // Eyes (expression-based, round with glow + highlights)
    _drawEyes(canvas, skin, faceCY, s, expression);

    canvas.restore();
  }

  void _drawEyes(Canvas canvas, SkinDefinition skin, double faceCY,
      double s, int expression) {
    final eyeY = faceCY - 0.3 * s;
    final eyeSpacing = 2.8 * s;
    final eyeR = 2.6 * s;
    final accentPaint = Paint()
      ..color = skin.accentColor
      ..style = PaintingStyle.fill;

    switch (expression) {
      case 0: // Neutral — full round eyes
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          _drawRoundEye(canvas, accentPaint, dx, eyeY, eyeR, s);
        }
        break;
      case 1: // Happy — curved arc eyes
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          _drawHappyEye(canvas, accentPaint, dx, eyeY, s);
        }
        break;
      case 2: // Angry — angled round eyes
        _drawAngryEye(canvas, accentPaint, -eyeSpacing, eyeY, eyeR, s, true);
        _drawAngryEye(canvas, accentPaint, eyeSpacing, eyeY, eyeR, s, false);
        break;
      case 3: // Surprised — larger round eyes
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          _drawRoundEye(canvas, accentPaint, dx, eyeY, eyeR * 1.2, s);
        }
        break;
      case 4: // Determined — half-lidded round eyes
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          _drawDeterminedEye(canvas, accentPaint, dx, eyeY, eyeR, s);
        }
        break;
      case 5: // Wink — one closed, one round
        _drawWinkEye(canvas, accentPaint, -eyeSpacing, eyeY, s);
        _drawRoundEye(canvas, accentPaint, eyeSpacing, eyeY, eyeR, s);
        break;
    }
  }

  void _drawRoundEye(Canvas canvas, Paint paint, double cx, double cy,
      double r, double s) {
    final center = Offset(cx, cy);

    // Outer glow
    canvas.drawCircle(
      center,
      r + 3 * s,
      Paint()
        ..shader = RadialGradient(colors: [
          paint.color.withValues(alpha: 0.5),
          paint.color.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: center, radius: r + 4 * s)),
    );

    // Inner glow
    canvas.drawCircle(
      center,
      r + 1 * s,
      Paint()
        ..shader = RadialGradient(colors: [
          Colors.white.withValues(alpha: 0.3),
          paint.color.withValues(alpha: 0.7),
          paint.color.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: center, radius: r + 2 * s)),
    );

    // Main iris
    canvas.drawCircle(center, r, paint);

    // Large white highlight (upper-right)
    canvas.drawCircle(
      Offset(cx + r * 0.35, cy - r * 0.35),
      r * 0.28,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // Small white highlight (lower-left)
    canvas.drawCircle(
      Offset(cx - r * 0.35, cy + r * 0.35),
      r * 0.14,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  void _drawHappyEye(Canvas canvas, Paint paint, double cx, double cy,
      double s) {
    canvas.drawPath(
      Path()
        ..moveTo(cx - 2.2 * s, cy + 0.3 * s)
        ..quadraticBezierTo(cx, cy - 1.5 * s, cx + 2.2 * s, cy + 0.3 * s),
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawAngryEye(Canvas canvas, Paint paint, double cx, double cy,
      double r, double s, bool left) {
    final center = Offset(cx, cy);

    // Outer glow
    canvas.drawCircle(
      center,
      r + 3 * s,
      Paint()
        ..shader = RadialGradient(colors: [
          paint.color.withValues(alpha: 0.5),
          paint.color.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: center, radius: r + 4 * s)),
    );

    // Main iris
    canvas.drawCircle(center, r, paint);

    // Angry brow line
    final browPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    if (left) {
      canvas.drawLine(
          Offset(cx - r, cy - r - 0.5 * s),
          Offset(cx + r, cy - r + 0.5 * s),
          browPaint);
    } else {
      canvas.drawLine(
          Offset(cx - r, cy - r + 0.5 * s),
          Offset(cx + r, cy - r - 0.5 * s),
          browPaint);
    }

    // Highlights
    canvas.drawCircle(
      Offset(cx + r * 0.35, cy - r * 0.35),
      r * 0.28,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
    canvas.drawCircle(
      Offset(cx - r * 0.35, cy + r * 0.35),
      r * 0.14,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  void _drawDeterminedEye(Canvas canvas, Paint paint, double cx, double cy,
      double r, double s) {
    final center = Offset(cx, cy);

    // Outer glow
    canvas.drawCircle(
      center,
      r + 3 * s,
      Paint()
        ..shader = RadialGradient(colors: [
          paint.color.withValues(alpha: 0.5),
          paint.color.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: center, radius: r + 4 * s)),
    );

    // Main iris
    canvas.drawCircle(center, r, paint);

    // Half-lid line (horizontal across top half)
    canvas.drawLine(
      Offset(cx - r, cy - r * 0.3),
      Offset(cx + r, cy - r * 0.3),
      Paint()
        ..color = const Color(0xFF050505)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s
        ..strokeCap = StrokeCap.round,
    );

    // Highlights
    canvas.drawCircle(
      Offset(cx + r * 0.35, cy - r * 0.1),
      r * 0.25,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
    canvas.drawCircle(
      Offset(cx - r * 0.35, cy + r * 0.35),
      r * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.7),
    );
  }

  void _drawWinkEye(Canvas canvas, Paint paint, double cx, double cy,
      double s) {
    canvas.drawPath(
      Path()
        ..moveTo(cx - 2 * s, cy)
        ..quadraticBezierTo(cx, cy - 0.8 * s, cx + 2 * s, cy),
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ExpressionPainter old) =>
      old.skin.id != skin.id || old.expression != expression;
}
