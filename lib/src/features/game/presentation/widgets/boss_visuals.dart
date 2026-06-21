import 'dart:math';
import 'package:flutter/material.dart';

class BossVisuals {
  BossVisuals._();

  static const Map<int, Color> _colors = {
    1: Color(0xFFE94560),
    2: Color(0xFF6BB5FF),
    3: Color(0xFF7B2D8B),
    4: Color(0xFF4A90D9),
    5: Color(0xFF2D6A4F),
    6: Color(0xFFFF6B35),
    7: Color(0xFF8B0000),
    8: Color(0xFFFFD700),
    9: Color(0xFF9B30FF),
    10: Color(0xFF00E5FF),
    11: Color(0xFFFF6B35),
    12: Color(0xFF00E5FF),
    13: Color(0xFFFF00FF),
    14: Color(0xFF00FF88),
  };

  static Color color(int visualType) =>
      _colors[visualType] ?? const Color(0xFFE94560);

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
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    switch (visualType) {
      case 1: // Bone Colossus - triangle
        final path = Path()
          ..moveTo(cx, cy - 10 * s)
          ..lineTo(cx - 9 * s, cy + 8 * s)
          ..lineTo(cx + 9 * s, cy + 8 * s)
          ..close();
        canvas.drawPath(path, paint);
      case 2: // Memory Wraith - ghostly wave
        final path = Path()
          ..moveTo(cx - 8 * s, cy + 8 * s)
          ..quadraticBezierTo(cx - 10 * s, cy - 4 * s, cx, cy - 10 * s)
          ..quadraticBezierTo(cx + 10 * s, cy - 4 * s, cx + 8 * s, cy + 8 * s)
          ..close();
        canvas.drawPath(path, paint);
      case 3: // Lich Lord - circle with crown
        canvas.drawCircle(Offset(cx, cy - 2 * s), 8 * s, paint);
        paint.color = const Color(0xFF00FF88);
        canvas.drawCircle(Offset(cx - 3 * s, cy - 4 * s), 1.5 * s, paint);
        canvas.drawCircle(Offset(cx + 3 * s, cy - 4 * s), 1.5 * s, paint);
      case 4: // Static Specter - rectangle
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, cy), width: 14 * s, height: 16 * s),
            Radius.circular(3 * s),
          ),
          paint,
        );
      case 5: // Goblin King - circle with ears
        canvas.drawCircle(Offset(cx, cy), 8 * s, paint);
        final earPaint = Paint()..color = color;
        final earPath = Path()
          ..moveTo(cx - 6 * s, cy - 7 * s)
          ..lineTo(cx - 10 * s, cy - 12 * s)
          ..lineTo(cx - 3 * s, cy - 8 * s)
          ..close();
        canvas.drawPath(earPath, earPaint);
        final earPath2 = Path()
          ..moveTo(cx + 6 * s, cy - 7 * s)
          ..lineTo(cx + 10 * s, cy - 12 * s)
          ..lineTo(cx + 3 * s, cy - 8 * s)
          ..close();
        canvas.drawPath(earPath2, earPaint);
      case 6: // The Glitch - jagged shape
        final path = Path()
          ..moveTo(cx - 8 * s, cy + 6 * s)
          ..lineTo(cx - 4 * s, cy - 8 * s)
          ..lineTo(cx + 2 * s, cy - 4 * s)
          ..lineTo(cx + 8 * s, cy - 10 * s)
          ..lineTo(cx + 6 * s, cy + 6 * s)
          ..close();
        canvas.drawPath(path, paint);
      case 7: // Data Dragon - dragon silhouette
        final path = Path()
          ..moveTo(cx - 8 * s, cy + 8 * s)
          ..lineTo(cx - 10 * s, cy - 2 * s)
          ..quadraticBezierTo(cx, cy - 12 * s, cx + 10 * s, cy - 2 * s)
          ..lineTo(cx + 8 * s, cy + 8 * s)
          ..close();
        canvas.drawPath(path, paint);
      case 8: // Void Disk - concentric circles
        canvas.drawCircle(Offset(cx, cy), 10 * s, paint);
        paint.color = const Color(0xFF1A1A1A);
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(cx, cy), 4 * s, paint);
      case 9: // Beholder - floating eye
        for (var i = 3; i >= 0; i--) {
          paint
            ..color = color.withValues(alpha: 0.15 + i * 0.05)
            ..style = PaintingStyle.fill;
          canvas.drawCircle(Offset(cx, cy), (10 - i * 2) * s, paint);
        }
        paint.color = Colors.white;
        canvas.drawCircle(Offset(cx, cy - 1 * s), 3 * s, paint);
        paint.color = const Color(0xFFFF00FF);
        canvas.drawCircle(Offset(cx, cy - 1 * s), 1.5 * s, paint);
      case 10: // Battery Wraith - battery shape
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, cy), width: 8 * s, height: 14 * s),
            Radius.circular(2 * s),
          ),
          paint,
        );
        paint.color = color;
        canvas.drawRect(
          Rect.fromCenter(center: Offset(cx, cy - 8 * s), width: 4 * s, height: 2 * s),
          paint,
        );
      case 11: // Lag Dragon - dragon with glitch
        final path = Path()
          ..moveTo(cx - 8 * s, cy + 8 * s)
          ..lineTo(cx - 10 * s, cy - 2 * s)
          ..quadraticBezierTo(cx, cy - 12 * s, cx + 10 * s, cy - 2 * s)
          ..lineTo(cx + 8 * s, cy + 8 * s)
          ..close();
        canvas.drawPath(path, paint);
        paint
          ..color = const Color(0xFFFF6B35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5 * s;
        for (var i = 0; i < 3; i++) {
          final y = cy - 6 * s + i * 5 * s;
          canvas.drawLine(
            Offset(cx - 6 * s, y),
            Offset(cx + 6 * s, y),
            paint,
          );
        }
      case 12: // Static Phantom - hub shape
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, cy), width: 12 * s, height: 14 * s),
            Radius.circular(3 * s),
          ),
          paint,
        );
      case 13: // Malware Beast - amorphous with tentacles
        canvas.drawCircle(Offset(cx, cy - 1 * s), 8 * s, paint);
        paint.color = color.withValues(alpha: 0.5);
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 1.5 * s;
        for (var i = -1; i <= 1; i++) {
          canvas.drawLine(
            Offset(cx + i * 5 * s, cy + 6 * s),
            Offset(cx + i * 7 * s, cy + 10 * s),
            paint,
          );
        }
      case 14: // Network Hydra - three heads
        for (var i = -1; i <= 1; i++) {
          canvas.drawCircle(Offset(cx + i * 7 * s, cy - 3 * s), 4 * s, paint);
          paint.style = PaintingStyle.stroke;
          paint.strokeWidth = 1 * s;
          canvas.drawLine(
            Offset(cx + i * 7 * s, cy + 1 * s),
            Offset(cx + i * 3 * s, cy + 6 * s),
            paint,
          );
          paint.style = PaintingStyle.fill;
        }
      default:
        canvas.drawCircle(Offset(cx, cy), 8 * s, paint);
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
