import 'dart:math';
import 'package:flutter/material.dart';

class BossVisuals {
  BossVisuals._();

  static const Map<int, Color> _colors = {
    1: Color(0xFFCC3344), // Bone Colossus — crimson
    2: Color(0xFF00CCDD), // Memory Devourer — cyan
    3: Color(0xFF00FF88), // Kernel Wraith — emerald
    4: Color(0xFFFF8800), // Feedback Phantom — orange
    5: Color(0xFFFFCC00), // Input Overlord — yellow
    6: Color(0xFFFF4444), // Dependency Demon — red
    7: Color(0xFF00CCDD), // Latency Leviathan — cyan
    8: Color(0xFFFFD700), // Bit Rot Behemoth — gold
    9: Color(0xFFFF00FF), // Pixel Punisher — magenta
    10: Color(0xFF00E5FF), // Battery Banshee — ice-blue
    11: Color(0xFFFF6600), // Lag Dragon — orange
    12: Color(0xFF00E5FF), // Static Phantom — cyan
    13: Color(0xFFFF00FF), // Exploit Emperor — magenta
    14: Color(0xFF00FF88), // Packet Storm — green
  };

  static Color color(int visualType) =>
      _colors[visualType] ?? const Color(0xFFCC3344);

  static Color particleColor(int visualType) => color(visualType);

  static Color glowColor(int visualType) =>
      color(visualType).withValues(alpha: 0.3);
}

class BossDefeatedBadge extends StatelessWidget {
  final double size;
  const BossDefeatedBadge({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
        ),
        border: Border.all(color: const Color(0xFFDAA520), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.4),
            blurRadius: 6,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.emoji_events,
        color: const Color(0xFF3E2723),
        size: size * 0.55,
      ),
    );
  }
}

class BossMiniPainter extends CustomPainter {
  final int visualType;
  final bool isDefeated;

  BossMiniPainter({required this.visualType, this.isDefeated = false});

  static const _outline = Color(0xFF1A1A1A);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width / 24;

    if (isDefeated) {
      final paint = Paint()
        ..color = Colors.grey.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(cx, cy), 10 * s, paint);
      paint
        ..color = Colors.grey.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 * s;
      canvas.drawLine(
        Offset(cx - 5 * s, cy - 5 * s),
        Offset(cx + 5 * s, cy + 5 * s),
        paint,
      );
      canvas.drawLine(
        Offset(cx + 5 * s, cy - 5 * s),
        Offset(cx - 5 * s, cy + 5 * s),
        paint,
      );
      return;
    }

    final color = BossVisuals.color(visualType);
    final fill = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    final outline = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * s;

    switch (visualType) {
      case 1: // Bone Colossus — broad triangular torso
        final path = Path()
          ..moveTo(cx, cy - 10 * s)
          ..lineTo(cx - 9 * s, cy + 8 * s)
          ..lineTo(cx + 9 * s, cy + 8 * s)
          ..close();
        canvas.drawPath(path, fill);
        canvas.drawPath(path, outline);
        // two small horns
        canvas.drawLine(
            Offset(cx - 4 * s, cy - 9 * s), Offset(cx - 7 * s, cy - 11 * s), outline);
        canvas.drawLine(
            Offset(cx + 4 * s, cy - 9 * s), Offset(cx + 7 * s, cy - 11 * s), outline);
        // three eyes
        final eyePaint = Paint()..color = const Color(0xFFCC3344);
        canvas.drawCircle(Offset(cx - 3 * s, cy - 3 * s), 1 * s, eyePaint);
        canvas.drawCircle(Offset(cx, cy - 4.5 * s), 1 * s, eyePaint);
        canvas.drawCircle(Offset(cx + 3 * s, cy - 3 * s), 1 * s, eyePaint);

      case 2: // Memory Devourer — shark jaw
        final jaw = Path()
          ..moveTo(cx - 9 * s, cy - 4 * s)
          ..quadraticBezierTo(cx - 10 * s, cy + 4 * s, cx - 4 * s, cy + 8 * s)
          ..lineTo(cx + 4 * s, cy + 8 * s)
          ..quadraticBezierTo(cx + 10 * s, cy + 4 * s, cx + 9 * s, cy - 4 * s)
          ..quadraticBezierTo(cx, cy - 11 * s, cx - 9 * s, cy - 4 * s)
          ..close();
        canvas.drawPath(jaw, fill);
        canvas.drawPath(jaw, outline);
        // dorsal fin
        final fin = Path()
          ..moveTo(cx - 2 * s, cy - 9 * s)
          ..lineTo(cx + 1 * s, cy - 12 * s)
          ..lineTo(cx + 4 * s, cy - 9 * s)
          ..close();
        canvas.drawPath(fin, fill);
        // teeth
        final teethPaint = Paint()..color = Colors.white;
        for (var i = -2; i <= 2; i++) {
          canvas.drawRect(
              Rect.fromCenter(
                  center: Offset(cx + i * 3 * s, cy + 3 * s),
                  width: 1.5 * s,
                  height: 3 * s),
              teethPaint);
        }

      case 3: // Kernel Wraith — hooded robe
        final robe = Path()
          ..moveTo(cx - 7 * s, cy + 9 * s)
          ..lineTo(cx - 10 * s, cy + 6 * s)
          ..quadraticBezierTo(cx - 11 * s, cy - 2 * s, cx - 5 * s, cy - 8 * s)
          ..quadraticBezierTo(cx, cy - 12 * s, cx + 5 * s, cy - 8 * s)
          ..quadraticBezierTo(cx + 11 * s, cy - 2 * s, cx + 10 * s, cy + 6 * s)
          ..lineTo(cx + 7 * s, cy + 9 * s)
          ..close();
        canvas.drawPath(robe, fill);
        canvas.drawPath(robe, outline);
        // hood
        final hood = Path()
          ..moveTo(cx - 6 * s, cy - 6 * s)
          ..quadraticBezierTo(cx, cy - 13 * s, cx + 6 * s, cy - 6 * s)
          ..close();
        canvas.drawPath(hood, fill);
        canvas.drawPath(hood, outline);
        // glowing eyes
        final eyePaint = Paint()..color = const Color(0xFF00FF88);
        canvas.drawCircle(Offset(cx - 3 * s, cy - 5 * s), 1.5 * s, eyePaint);
        canvas.drawCircle(Offset(cx + 3 * s, cy - 5 * s), 1.5 * s, eyePaint);

      case 4: // Feedback Phantom — speaker-cone mouth
        canvas.drawCircle(Offset(cx, cy), 9 * s, fill);
        canvas.drawCircle(Offset(cx, cy), 9 * s, outline);
        // concentric rings
        canvas.drawCircle(
            Offset(cx, cy + 2 * s),
            6 * s,
            Paint()
              ..color = const Color(0xFF1A1E28)
              ..style = PaintingStyle.fill);
        canvas.drawCircle(
            Offset(cx, cy + 2 * s),
            4 * s,
            Paint()..color = color);
        // eyes
        final eyePaint = Paint()..color = const Color(0xFFFFCC00);
        canvas.drawCircle(Offset(cx - 3 * s, cy - 4 * s), 1.8 * s, eyePaint);
        canvas.drawCircle(Offset(cx + 3 * s, cy - 4 * s), 1.8 * s, eyePaint);
        canvas.drawCircle(Offset(cx - 3 * s, cy - 4 * s), 0.8 * s, Paint()..color = _outline);
        canvas.drawCircle(Offset(cx + 3 * s, cy - 4 * s), 0.8 * s, Paint()..color = _outline);

      case 5: // Input Overlord — crab shape
        // body
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy + 2 * s), width: 14 * s, height: 10 * s),
            fill);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy + 2 * s), width: 14 * s, height: 10 * s),
            outline);
        // claws
        for (final side in [-1, 1]) {
          final claw = Path()
            ..moveTo(cx + side * 8 * s, cy)
            ..lineTo(cx + side * 12 * s, cy - 4 * s)
            ..lineTo(cx + side * 13 * s, cy - 1 * s)
            ..lineTo(cx + side * 12 * s, cy + 2 * s)
            ..lineTo(cx + side * 8 * s, cy + 3 * s)
            ..close();
          canvas.drawPath(claw, fill);
          canvas.drawPath(claw, outline);
        }
        // cyclops eye
        final eyePaint = Paint()..color = const Color(0xFFFFCC00);
        canvas.drawCircle(Offset(cx, cy - 2 * s), 3 * s, eyePaint);
        canvas.drawCircle(Offset(cx, cy - 2 * s), 1.5 * s, Paint()..color = _outline);

      case 6: // Dependency Demon — tiny imp with chain
        // head (oversized)
        canvas.drawCircle(Offset(cx, cy - 3 * s), 6 * s, fill);
        canvas.drawCircle(Offset(cx, cy - 3 * s), 6 * s, outline);
        // body (small)
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy + 6 * s), width: 8 * s, height: 6 * s),
            fill);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy + 6 * s), width: 8 * s, height: 6 * s),
            outline);
        // horns
        canvas.drawLine(
            Offset(cx - 4 * s, cy - 8 * s), Offset(cx - 7 * s, cy - 11 * s), outline);
        canvas.drawLine(
            Offset(cx + 4 * s, cy - 8 * s), Offset(cx + 7 * s, cy - 11 * s), outline);
        // eyes
        canvas.drawCircle(Offset(cx - 2.5 * s, cy - 4 * s), 1.5 * s,
            Paint()..color = const Color(0xFFFF4444));
        canvas.drawCircle(Offset(cx + 2.5 * s, cy - 4 * s), 1.5 * s,
            Paint()..color = const Color(0xFFFF4444));

      case 7: // Latency Leviathan — whale/squid
        // body
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy - 2 * s), width: 16 * s, height: 10 * s),
            fill);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy - 2 * s), width: 16 * s, height: 10 * s),
            outline);
        // tail
        final tail = Path()
          ..moveTo(cx - 8 * s, cy - 2 * s)
          ..lineTo(cx - 11 * s, cy - 6 * s)
          ..lineTo(cx - 11 * s, cy + 2 * s)
          ..close();
        canvas.drawPath(tail, fill);
        canvas.drawPath(tail, outline);
        // tentacles
        final tentPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 * s;
        for (var i = -1; i <= 1; i++) {
          final tent = Path()
            ..moveTo(cx + i * 3 * s, cy + 5 * s)
            ..quadraticBezierTo(cx + i * 5 * s, cy + 9 * s, cx + i * 4 * s, cy + 10 * s);
          canvas.drawPath(tent, tentPaint);
        }
        // eye
        canvas.drawCircle(Offset(cx + 4 * s, cy - 3 * s), 2 * s, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(cx + 4 * s, cy - 3 * s), 1 * s, Paint()..color = _outline);

      case 8: // Bit Rot Behemoth — armored turtle
        // shell
        canvas.drawCircle(Offset(cx, cy - 1 * s), 8 * s, fill);
        canvas.drawCircle(Offset(cx, cy - 1 * s), 8 * s, outline);
        // corruption cracks
        final crackPaint = Paint()
          ..color = const Color(0xFFDAA520)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8 * s;
        canvas.drawLine(Offset(cx - 3 * s, cy - 5 * s), Offset(cx + 2 * s, cy + 2 * s), crackPaint);
        canvas.drawLine(Offset(cx + 1 * s, cy - 6 * s), Offset(cx - 2 * s, cy + 4 * s), crackPaint);
        // head
        canvas.drawCircle(
            Offset(cx, cy + 7 * s),
            3.5 * s,
            Paint()..color = const Color(0xFF8B8000));
        canvas.drawCircle(Offset(cx, cy + 7 * s), 3.5 * s, outline);

      case 9: // Pixel Punisher — angular geometric
        final diamond = Path()
          ..moveTo(cx, cy - 10 * s)
          ..lineTo(cx + 8 * s, cy)
          ..lineTo(cx, cy + 10 * s)
          ..lineTo(cx - 8 * s, cy)
          ..close();
        canvas.drawPath(diamond, fill);
        canvas.drawPath(diamond, outline);
        // scanning eye
        final eyePaint = Paint()..color = const Color(0xFF1A1A1A);
        canvas.drawCircle(Offset(cx, cy), 3 * s, eyePaint);
        canvas.drawCircle(Offset(cx, cy), 2 * s, Paint()..color = color);
        // pixel grid lines
        final gridPaint = Paint()
          ..color = color.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5 * s;
        for (var i = -2; i <= 2; i++) {
          canvas.drawLine(
              Offset(cx + i * 3 * s, cy - 5 * s),
              Offset(cx + i * 3 * s, cy + 5 * s),
              gridPaint);
        }

      case 10: // Battery Banshee — thin elongated limbs
        // torso
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy - 1 * s), width: 7 * s, height: 10 * s),
            fill);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy - 1 * s), width: 7 * s, height: 10 * s),
            outline);
        // limbs
        final limbPaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 * s;
        // arms up (screaming)
        canvas.drawLine(
            Offset(cx - 4 * s, cy - 4 * s), Offset(cx - 8 * s, cy - 9 * s), limbPaint);
        canvas.drawLine(
            Offset(cx + 4 * s, cy - 4 * s), Offset(cx + 8 * s, cy - 9 * s), limbPaint);
        // legs
        canvas.drawLine(
            Offset(cx - 2 * s, cy + 5 * s), Offset(cx - 4 * s, cy + 10 * s), limbPaint);
        canvas.drawLine(
            Offset(cx + 2 * s, cy + 5 * s), Offset(cx + 4 * s, cy + 10 * s), limbPaint);
        // battery on chest
        canvas.drawRect(
            Rect.fromCenter(center: Offset(cx, cy - 1 * s), width: 4 * s, height: 5 * s),
            Paint()..color = const Color(0xFF1A1A1A));
        canvas.drawRect(
            Rect.fromCenter(center: Offset(cx, cy - 1 * s), width: 3 * s, height: 3 * s),
            Paint()..color = const Color(0xFF00E5FF));

      case 11: // Lag Dragon — winged silhouette
        // body
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy + 2 * s), width: 10 * s, height: 7 * s),
            fill);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy + 2 * s), width: 10 * s, height: 7 * s),
            outline);
        // head
        canvas.drawCircle(Offset(cx + 6 * s, cy - 2 * s), 4 * s, fill);
        canvas.drawCircle(Offset(cx + 6 * s, cy - 2 * s), 4 * s, outline);
        // wings
        final wingL = Path()
          ..moveTo(cx - 2 * s, cy - 1 * s)
          ..lineTo(cx - 10 * s, cy - 9 * s)
          ..lineTo(cx - 4 * s, cy - 3 * s)
          ..close();
        canvas.drawPath(wingL, fill);
        canvas.drawPath(wingL, outline);
        final wingR = Path()
          ..moveTo(cx + 2 * s, cy - 1 * s)
          ..lineTo(cx + 10 * s, cy - 9 * s)
          ..lineTo(cx + 4 * s, cy - 3 * s)
          ..close();
        canvas.drawPath(wingR, fill);
        canvas.drawPath(wingR, outline);
        // tail
        canvas.drawLine(
            Offset(cx - 5 * s, cy + 4 * s), Offset(cx - 9 * s, cy + 7 * s), outline);

      case 12: // Static Phantom — floating orb
        canvas.drawCircle(Offset(cx, cy), 8 * s, fill);
        canvas.drawCircle(Offset(cx, cy), 8 * s, outline);
        // wifi arcs
        final arcPaint = Paint()
          ..color = const Color(0xFF00E5FF).withValues(alpha: 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1 * s;
        for (var i = 1; i <= 3; i++) {
          canvas.drawArc(
              Rect.fromCenter(
                  center: Offset(cx, cy - 2 * s),
                  width: 8 * s * i,
                  height: 8 * s * i),
              -pi * 0.3,
              pi * 0.6,
              false,
              arcPaint);
        }
        // center dot
        canvas.drawCircle(Offset(cx, cy), 2 * s, Paint()..color = _outline);

      case 13: // Exploit Emperor — armored knight
        // helmet
        canvas.drawCircle(Offset(cx, cy - 4 * s), 5 * s, fill);
        canvas.drawCircle(Offset(cx, cy - 4 * s), 5 * s, outline);
        // visor slit
        canvas.drawRect(
            Rect.fromCenter(center: Offset(cx, cy - 4 * s), width: 6 * s, height: 1.5 * s),
            Paint()..color = _outline);
        // crown
        final crown = Path()
          ..moveTo(cx - 4 * s, cy - 9 * s)
          ..lineTo(cx - 3 * s, cy - 12 * s)
          ..lineTo(cx - 1 * s, cy - 10 * s)
          ..lineTo(cx, cy - 13 * s)
          ..lineTo(cx + 1 * s, cy - 10 * s)
          ..lineTo(cx + 3 * s, cy - 12 * s)
          ..lineTo(cx + 4 * s, cy - 9 * s)
          ..close();
        canvas.drawPath(crown, Paint()..color = const Color(0xFFFF00FF));
        canvas.drawPath(crown, outline);
        // body armor
        canvas.drawRect(
            Rect.fromCenter(center: Offset(cx, cy + 4 * s), width: 10 * s, height: 10 * s),
            fill);
        canvas.drawRect(
            Rect.fromCenter(center: Offset(cx, cy + 4 * s), width: 10 * s, height: 10 * s),
            outline);
        // gem
        canvas.drawCircle(Offset(cx, cy + 2 * s), 2 * s, Paint()..color = const Color(0xFFFF00FF));

      case 14: // Packet Storm — three-headed hydra
        final colors = [
          const Color(0xFFFF4444),
          const Color(0xFF00CCDD),
          const Color(0xFF00FF88),
        ];
        for (var i = -1; i <= 1; i++) {
          // head
          canvas.drawCircle(Offset(cx + i * 6 * s, cy - 5 * s), 3.5 * s,
              Paint()..color = colors[i + 1]);
          canvas.drawCircle(Offset(cx + i * 6 * s, cy - 5 * s), 3.5 * s, outline);
          // eye
          canvas.drawCircle(
              Offset(cx + i * 6 * s, cy - 5 * s), 1.2 * s, Paint()..color = _outline);
          // neck
          final neckPaint = Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2 * s;
          canvas.drawLine(
              Offset(cx + i * 6 * s, cy - 2 * s), Offset(cx + i * 2 * s, cy + 4 * s), neckPaint);
        }
        // shared body
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy + 6 * s), width: 12 * s, height: 6 * s),
            fill);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(cx, cy + 6 * s), width: 12 * s, height: 6 * s),
            outline);

      default:
        canvas.drawCircle(Offset(cx, cy), 8 * s, fill);
        canvas.drawCircle(Offset(cx, cy), 8 * s, outline);
    }
  }

  @override
  bool shouldRepaint(covariant BossMiniPainter old) =>
      old.visualType != visualType || old.isDefeated != isDefeated;
}

class BossParticlePainter extends CustomPainter {
  final double phase;
  final int visualType;

  BossParticlePainter({required this.phase, required this.visualType});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42 + visualType);
    final baseColor = BossVisuals.particleColor(visualType);

    for (var i = 0; i < 12; i++) {
      final driftX = sin(phase * 1.5 + i * 0.7) * 10;
      final driftY = cos(phase * 1.2 + i * 0.5) * 8;
      final x = (rng.nextDouble() * size.width + driftX) % size.width;
      final y = (rng.nextDouble() * size.height + phase * 30 + driftY) % size.height;
      final radius = rng.nextDouble() * 1.5 + 0.5;
      final alpha =
          ((rng.nextDouble() * 25 + 10) * (0.3 + 0.3 * sin(phase * 2 + i)))
              .toInt();

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = baseColor.withValues(alpha: alpha / 255),
      );
    }
  }

  @override
  bool shouldRepaint(covariant BossParticlePainter old) => old.phase != phase;
}
