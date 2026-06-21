import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/presentation/widgets/boss_visuals.dart';

class WorldCard extends StatelessWidget {
  final WorldDef world;
  final int completedLevels;
  final int totalLevels;
  final bool isLocked;
  final int bossesDefeated;
  final int totalBosses;
  final int bossVisualType;
  final VoidCallback onTap;

  const WorldCard({
    super.key,
    required this.world,
    required this.completedLevels,
    required this.totalLevels,
    this.isLocked = false,
    this.bossesDefeated = 0,
    this.totalBosses = 14,
    this.bossVisualType = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = totalLevels > 0 ? completedLevels / totalLevels : 0.0;
    final bossColor = BossVisuals.color(bossVisualType);
    final allBossesDefeated = bossesDefeated >= totalBosses && totalBosses > 0;
    final hasBossProgress = bossesDefeated > 0;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isLocked
                  ? scheme.outline.withValues(alpha: 0.15)
                  : allBossesDefeated
                      ? bossColor.withValues(alpha: 0.6)
                      : hasBossProgress
                          ? bossColor.withValues(alpha: 0.3)
                          : scheme.secondary.withValues(alpha: 0.3),
              width: allBossesDefeated ? 2 : 1,
            ),
            boxShadow: [
              if (!isLocked && hasBossProgress)
                BoxShadow(
                  color: bossColor.withValues(alpha: allBossesDefeated ? 0.25 : 0.1),
                  blurRadius: allBossesDefeated ? 16 : 8,
                  spreadRadius: allBossesDefeated ? 2 : 0,
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: CustomPaint(
              painter: _ParchmentTexturePainter(
                color: scheme.surface,
                accent: hasBossProgress
                    ? bossColor.withValues(alpha: 0.05)
                    : scheme.secondary.withValues(alpha: 0.05),
              ),
              foregroundPainter: _ScrollEdgePainter(
                color: scheme.outline.withValues(alpha: 0.15),
                shadow: scheme.shadow.withValues(alpha: 0.06),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isLocked
                                      ? Colors.grey.withValues(alpha: 0.1)
                                      : hasBossProgress
                                          ? bossColor.withValues(alpha: 0.12)
                                          : scheme.secondary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  world.icon,
                                  color: isLocked
                                      ? Colors.grey
                                      : hasBossProgress
                                          ? bossColor
                                          : scheme.secondary,
                                  size: 24,
                                ),
                              ),
                              const Spacer(),
                              CustomPaint(
                                size: const Size(28, 28),
                                painter: _CompassRosePainter(
                                  primary: hasBossProgress
                                      ? bossColor
                                      : scheme.secondary,
                                  faded: scheme.outline.withValues(alpha: 0.3),
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),
                          Text(
                            world.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isLocked
                                  ? scheme.onSurface.withValues(alpha: 0.3)
                                  : scheme.onSurface,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            world.description,
                            style: TextStyle(
                              fontSize: 11,
                              color: isLocked
                                  ? scheme.onSurface.withValues(alpha: 0.2)
                                  : scheme.onSurface.withValues(alpha: 0.5),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor:
                                  scheme.outline.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isLocked
                                    ? Colors.grey
                                    : hasBossProgress
                                        ? bossColor
                                        : scheme.secondary,
                              ),
                              minHeight: 5,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            '$completedLevels / $totalLevels',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isLocked
                                  ? scheme.onSurface.withValues(alpha: 0.2)
                                  : scheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          if (totalBosses > 0) ...[
                            const Gap(6),
                            Row(
                              children: [
                                Icon(
                                  Icons.shield,
                                  size: 12,
                                  color: isLocked
                                      ? Colors.grey.withValues(alpha: 0.3)
                                      : bossColor.withValues(alpha: 0.7),
                                ),
                                const Gap(4),
                                Text(
                                  '$bossesDefeated / $totalBosses bosses',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isLocked
                                        ? scheme.onSurface.withValues(alpha: 0.2)
                                        : allBossesDefeated
                                            ? bossColor
                                            : scheme.onSurface
                                                .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (allBossesDefeated && !isLocked)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: BossDefeatedBadge(size: 24),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}

class _ParchmentTexturePainter extends CustomPainter {
  final Color color;
  final Color accent;

  _ParchmentTexturePainter({required this.color, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = color;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final rng = Random(42);
    for (var i = 0; i < 20; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final w = 6 + rng.nextDouble() * 12;
      final h = 2 + rng.nextDouble() * 4;
      final paint = Paint()
        ..color = accent.withValues(alpha: 0.3 + rng.nextDouble() * 0.3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, w, h),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParchmentTexturePainter old) =>
      old.color != color;
}

class _CompassRosePainter extends CustomPainter {
  final Color primary;
  final Color faded;

  _CompassRosePainter({required this.primary, required this.faded});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width / 28;

    for (var i = 0; i < 4; i++) {
      final angle = i * pi / 2;
      final isCardinal = i % 2 == 0;
      final color = isCardinal ? primary : faded;
      final len = isCardinal ? 10 * s : 7 * s;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(cx, cy)
        ..lineTo(cx + cos(angle - 0.15) * len, cy + sin(angle - 0.15) * len)
        ..lineTo(cx + cos(angle) * len * 0.4, cy + sin(angle) * len * 0.4)
        ..lineTo(cx + cos(angle + 0.15) * len, cy + sin(angle + 0.15) * len)
        ..close();
      canvas.drawPath(path, paint);
    }

    final centerPaint = Paint()
      ..color = primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 2 * s, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _CompassRosePainter old) =>
      old.primary != primary;
}

class _ScrollEdgePainter extends CustomPainter {
  final Color color;
  final Color shadow;

  _ScrollEdgePainter({required this.color, required this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final shadowPaint = Paint()
      ..color = shadow
      ..style = PaintingStyle.fill;

    final s = size.width / 100;

    for (final corner in [
      const Offset(0, 0),
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ]) {
      final dx = corner.dx == 0 ? 1.0 : -1.0;
      final dy = corner.dy == 0 ? 1.0 : -1.0;

      final path = Path()
        ..moveTo(corner.dx + dx * 4 * s, corner.dy)
        ..lineTo(corner.dx, corner.dy)
        ..lineTo(corner.dx, corner.dy + dy * 4 * s);
      canvas.drawPath(path, paint);

      final shadowPath = Path()
        ..moveTo(corner.dx + dx * 2 * s, corner.dy + dy * 2 * s)
        ..lineTo(corner.dx + dx * 6 * s, corner.dy + dy * 2 * s)
        ..lineTo(corner.dx + dx * 2 * s, corner.dy + dy * 6 * s)
        ..close();
      canvas.drawPath(shadowPath, shadowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScrollEdgePainter old) =>
      old.color != color || old.shadow != shadow;
}
