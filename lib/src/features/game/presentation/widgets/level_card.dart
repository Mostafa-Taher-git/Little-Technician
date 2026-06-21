import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/presentation/widgets/boss_visuals.dart';

class LevelCard extends StatelessWidget {
  final LevelDef level;
  final bool isCompleted;
  final bool isLocked;
  final int totalSteps;
  final bool isBossLevel;
  final int bossVisualType;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    this.isCompleted = false,
    this.isLocked = false,
    this.totalSteps = 1,
    this.isBossLevel = false,
    this.bossVisualType = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bossColor = BossVisuals.color(bossVisualType);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: isLocked
                  ? scheme.surface.withValues(alpha: 0.3)
                  : isBossLevel
                      ? bossColor.withValues(alpha: 0.05)
                      : scheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isBossLevel && !isLocked
                    ? isCompleted
                        ? bossColor.withValues(alpha: 0.5)
                        : bossColor.withValues(alpha: 0.25)
                    : isCompleted
                        ? scheme.secondary.withValues(alpha: 0.3)
                        : isLocked
                            ? scheme.outline.withValues(alpha: 0.2)
                            : scheme.outline.withValues(alpha: 0.4),
                width: isBossLevel ? 1.5 : 1,
              ),
              boxShadow: [
                if (!isLocked && isBossLevel)
                  BoxShadow(
                    color: bossColor.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                if (!isLocked && !isBossLevel)
                  BoxShadow(
                    color: scheme.shadow.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: isLocked ? null : onTap,
                borderRadius: BorderRadius.circular(16),
                child: Row(
                  children: [
                    if (isBossLevel) ...[
                      const Gap(2),
                      _BossDoor(
                        visualType: bossVisualType,
                        isCompleted: isCompleted,
                        isLocked: isLocked,
                      ),
                    ] else ...[
                      const Gap(4),
                      _DungeonDoor(
                        isCompleted: isCompleted,
                        isLocked: isLocked,
                      ),
                    ],
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (isCompleted && isBossLevel)
                                Icon(Icons.emoji_events,
                                    size: 16, color: bossColor),
                              if (isCompleted && !isBossLevel)
                                Icon(Icons.check_circle,
                                    size: 16, color: scheme.secondary),
                              if (isCompleted) const Gap(6),
                              Flexible(
                                child: Text(
                                  level.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: isLocked
                                        ? scheme.onSurface.withValues(alpha: 0.3)
                                        : isBossLevel
                                            ? bossColor
                                            : scheme.onSurface,
                                    fontWeight: isBossLevel
                                        ? FontWeight.w800
                                        : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const Gap(4),
                          Row(
                            children: [
                              Icon(Icons.arrow_right_alt,
                                  size: 14,
                                  color: scheme.onSurface.withValues(alpha: 0.3)),
                              const Gap(2),
                              Flexible(
                                child: Text(
                                  level.description,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isLocked
                                        ? scheme.onSurface.withValues(alpha: 0.2)
                                        : scheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(4),
                    if (!isBossLevel) ...[
                      _DungeonTorch(isLit: !isLocked && !isCompleted),
                      const Gap(4),
                    ],
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isBossLevel
                            ? RadialGradient(
                                colors: [bossColor, bossColor.withValues(alpha: 0.6)],
                              )
                            : const RadialGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
                              ),
                        border: Border.all(
                          color: isBossLevel
                              ? bossColor.withValues(alpha: 0.7)
                              : const Color(0xFFDAA520),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (isBossLevel ? bossColor : scheme.secondary)
                                .withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${level.points}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isBossLevel
                              ? Colors.white
                              : const Color(0xFF3E2723),
                        ),
                      ),
                    ),
                    const Gap(8),
                  ],
                ),
              ),
            ),
          ),
          if (!isLocked)
            ..._buildRivets(isBossLevel ? bossColor : scheme.outline),
          if (!isLocked && !isBossLevel)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _ChainLinkPainter(
                    color: scheme.outline.withValues(alpha: 0.15),
                  ),
                ),
              ),
            ),
          if (isLocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withValues(alpha: 0.08),
                ),
                child: const Center(
                  child: Icon(Icons.lock_outline, color: Colors.white54, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildRivets(Color color) {
    final rivetColor = color.withValues(alpha: 0.3);
    return [
      Positioned(top: 6, left: 6, child: _Rivet(color: rivetColor)),
      Positioned(top: 6, right: 6, child: _Rivet(color: rivetColor)),
      Positioned(bottom: 6, left: 6, child: _Rivet(color: rivetColor)),
      Positioned(bottom: 6, right: 6, child: _Rivet(color: rivetColor)),
    ];
  }
}

class _Rivet extends StatelessWidget {
  final Color color;
  const _Rivet({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 0.5),
      ),
    );
  }
}

class _ChainLinkPainter extends CustomPainter {
  final Color color;

  _ChainLinkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    void drawLinks(Offset start, Offset end) {
      final dx = end.dx - start.dx;
      final dy = end.dy - start.dy;
      final dist = dx * dx + dy * dy;
      if (dist <= 0) return;
      final linkCount = (dist / 2500).ceil().clamp(2, 8);
      for (var i = 0; i < linkCount; i++) {
        final t = (i + 1) / (linkCount + 1);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(start.dx + dx * t, start.dy + dy * t),
            width: 7,
            height: 4,
          ),
          paint,
        );
      }
    }

    final w = size.width - 6;
    final h = size.height - 6;
    drawLinks(const Offset(6, 6), Offset(w, 6));
    drawLinks(Offset(w, 6), Offset(w, h));
    drawLinks(Offset(w, h), Offset(6, h));
    drawLinks(Offset(6, h), const Offset(6, 6));
  }

  @override
  bool shouldRepaint(covariant _ChainLinkPainter old) => old.color != color;
}

class _DungeonDoor extends StatelessWidget {
  final bool isCompleted;
  final bool isLocked;

  const _DungeonDoor({required this.isCompleted, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final doorColor = isCompleted
        ? scheme.secondary
        : isLocked
            ? scheme.outline.withValues(alpha: 0.3)
            : scheme.primary;

    return Container(
      width: 48,
      height: 64,
      decoration: BoxDecoration(
        color: isCompleted
            ? scheme.secondary.withValues(alpha: 0.1)
            : isLocked
                ? scheme.surface.withValues(alpha: 0.2)
                : scheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: doorColor.withValues(alpha: isLocked ? 0.2 : 0.4),
          width: 1.5,
        ),
      ),
      child: CustomPaint(
        painter: _DoorArchPainter(
          doorColor: doorColor,
          isCompleted: isCompleted,
          isLocked: isLocked,
          scheme: scheme,
        ),
      ),
    );
  }
}

class _BossDoor extends StatelessWidget {
  final int visualType;
  final bool isCompleted;
  final bool isLocked;

  const _BossDoor({
    required this.visualType,
    required this.isCompleted,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final bossColor = BossVisuals.color(visualType);

    return Container(
      width: 48,
      height: 64,
      decoration: BoxDecoration(
        color: isCompleted
            ? bossColor.withValues(alpha: 0.15)
            : isLocked
                ? Colors.grey.withValues(alpha: 0.05)
                : bossColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isLocked
              ? Colors.grey.withValues(alpha: 0.2)
              : bossColor.withValues(alpha: isCompleted ? 0.5 : 0.3),
          width: 1.5,
        ),
      ),
      child: CustomPaint(
        painter: _BossDoorPainter(
          visualType: visualType,
          isCompleted: isCompleted,
          isLocked: isLocked,
        ),
      ),
    );
  }
}

class _DoorArchPainter extends CustomPainter {
  final Color doorColor;
  final bool isCompleted;
  final bool isLocked;
  final ColorScheme scheme;

  _DoorArchPainter({
    required this.doorColor,
    required this.isCompleted,
    required this.isLocked,
    required this.scheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawStoneTexture(canvas, size);
    _drawIronHinges(canvas, size);

    final paint = Paint()
      ..color = doorColor.withValues(alpha: isLocked ? 0.2 : 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.05,
        size.width * 0.8, size.height * 0.3,
      )
      ..lineTo(size.width * 0.8, size.height);

    canvas.drawPath(path, paint);

    if (isCompleted) {
      final checkPaint = Paint()
        ..color = doorColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      final checkPath = Path()
        ..moveTo(size.width * 0.35, size.height * 0.55)
        ..lineTo(size.width * 0.48, size.height * 0.7)
        ..lineTo(size.width * 0.65, size.height * 0.4);
      canvas.drawPath(checkPath, checkPaint);
    }
  }

  void _drawStoneTexture(Canvas canvas, Size size) {
    final rng = Random(doorColor.hashCode);
    for (var i = 0; i < 8; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final w = 4 + rng.nextDouble() * 8;
      final h = 2 + rng.nextDouble() * 3;
      final stonePaint = Paint()
        ..color = scheme.primary.withValues(alpha: 0.04 + rng.nextDouble() * 0.04);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, w, h),
          const Radius.circular(1),
        ),
        stonePaint,
      );
    }
  }

  void _drawIronHinges(Canvas canvas, Size size) {
    final hingePaint = Paint()
      ..color = scheme.outline.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    const hingeW = 4.0;
    const hingeH = 3.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.15, size.height * 0.35, hingeW, hingeH),
        const Radius.circular(1),
      ),
      hingePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.15, size.height * 0.65, hingeW, hingeH),
        const Radius.circular(1),
      ),
      hingePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.7, size.height * 0.35, hingeW, hingeH),
        const Radius.circular(1),
      ),
      hingePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.7, size.height * 0.65, hingeW, hingeH),
        const Radius.circular(1),
      ),
      hingePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DoorArchPainter old) =>
      old.doorColor != doorColor || old.isCompleted != isCompleted;
}

class _BossDoorPainter extends CustomPainter {
  final int visualType;
  final bool isCompleted;
  final bool isLocked;

  _BossDoorPainter({
    required this.visualType,
    required this.isCompleted,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final color = BossVisuals.color(visualType);
    final paint = Paint()
      ..color = isLocked
          ? Colors.grey.withValues(alpha: 0.2)
          : color.withValues(alpha: isCompleted ? 0.8 : 0.5)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width / 48;

    if (isCompleted) {
      // Trophy icon
      final cupPaint = Paint()
        ..color = const Color(0xFFFFD700)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, cy - 2 * s), width: 16 * s, height: 14 * s),
          Radius.circular(3 * s),
        ),
        cupPaint,
      );
      // Cup handle left
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx - 10 * s, cy - 2 * s), width: 6 * s, height: 8 * s),
        -pi * 0.5, pi, false,
        Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * s,
      );
      // Cup handle right
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx + 10 * s, cy - 2 * s), width: 6 * s, height: 8 * s),
        pi * 0.5, pi, false,
        Paint()
          ..color = const Color(0xFFFFD700)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * s,
      );
      // Stem
      paint
        ..color = const Color(0xFFB8860B)
        ..strokeWidth = 2 * s
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(cx, cy + 5 * s), Offset(cx, cy + 10 * s), paint);
      // Base
      canvas.drawLine(Offset(cx - 6 * s, cy + 10 * s), Offset(cx + 6 * s, cy + 10 * s), paint);
      // Star
      paint
        ..color = Colors.white.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(cx, cy - 3 * s), 2.5 * s, paint);
    } else {
      // Monster skull
      paint.color = isLocked ? Colors.grey.withValues(alpha: 0.15) : color;
      // Skull shape
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy - 3 * s), width: 14 * s, height: 16 * s),
        paint,
      );
      // Jaw
      paint.color = isLocked ? Colors.grey.withValues(alpha: 0.12) : color.withValues(alpha: 0.7);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, cy + 8 * s), width: 10 * s, height: 6 * s),
          Radius.circular(2 * s),
        ),
        paint,
      );
      // Eyes
      final eyePaint = Paint()
        ..color = isLocked
            ? Colors.grey.withValues(alpha: 0.2)
            : isCompleted
                ? const Color(0xFFFFD700)
                : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(cx - 3 * s, cy - 5 * s), 2 * s, eyePaint);
      canvas.drawCircle(Offset(cx + 3 * s, cy - 5 * s), 2 * s, eyePaint);
      // Nose
      final nosePaint = Paint()
        ..color = isLocked ? Colors.black.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(cx, cy), 1 * s, nosePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BossDoorPainter old) =>
      old.visualType != visualType ||
      old.isCompleted != isCompleted ||
      old.isLocked != isLocked;
}

class _DungeonTorch extends StatefulWidget {
  final bool isLit;

  const _DungeonTorch({required this.isLit});

  @override
  State<_DungeonTorch> createState() => _DungeonTorchState();
}

class _DungeonTorchState extends State<_DungeonTorch>
    with SingleTickerProviderStateMixin {
  late AnimationController _flickerController;
  late Animation<double> _flickerAnimation;

  @override
  void initState() {
    super.initState();
    _flickerController = AnimationController(
      vsync: this,
      duration: 150.ms,
    )..repeat(reverse: true);
    _flickerAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _flickerController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _flickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = widget.isLit ? scheme.secondary : scheme.outline.withValues(alpha: 0.2);
    final stickColor = Color.lerp(scheme.primary, const Color(0xFF3E2723), 0.4) ?? const Color(0xFF3E2723);

    return Container(
      width: 20,
      height: 48,
      alignment: Alignment.center,
      child: widget.isLit
          ? AnimatedBuilder(
              animation: _flickerAnimation,
              builder: (_, child) {
                return CustomPaint(
                  painter: _TorchPainter(
                    isLit: widget.isLit,
                    color: color,
                    stickColor: stickColor,
                    flicker: _flickerAnimation.value,
                  ),
                  size: const Size(20, 48),
                );
              },
            )
          : CustomPaint(
              painter: _TorchPainter(
                isLit: widget.isLit,
                color: color,
                stickColor: stickColor,
                flicker: 1.0,
              ),
              size: const Size(20, 48),
            ),
    );
  }
}

class _TorchPainter extends CustomPainter {
  final bool isLit;
  final Color color;
  final Color stickColor;
  final double flicker;

  _TorchPainter({
    required this.isLit,
    required this.color,
    required this.stickColor,
    required this.flicker,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stickPaint = Paint()
      ..color = stickColor.withValues(alpha: isLit ? 0.8 : 0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.6),
      Offset(size.width / 2, size.height),
      stickPaint,
    );

    if (isLit) {
      final flamePaint = Paint()
        ..color = color.withValues(alpha: 0.6 * flicker)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      final flamePath = Path()
        ..moveTo(size.width / 2 - 4 * flicker, size.height * 0.55)
        ..quadraticBezierTo(
          size.width / 2 - 2 * flicker, size.height * 0.3,
          size.width / 2, size.height * 0.15 * (1 / flicker),
        )
        ..quadraticBezierTo(
          size.width / 2 + 2 * flicker, size.height * 0.3,
          size.width / 2 + 4 * flicker, size.height * 0.55,
        )
        ..close();

      canvas.drawPath(flamePath, flamePaint);

      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.15 * flicker)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.35),
        8 * flicker,
        glowPaint,
      );
    } else {
      final stubPaint = Paint()
        ..color = color
        ..strokeWidth = 2;
      canvas.drawLine(
        Offset(size.width / 2, size.height * 0.55),
        Offset(size.width / 2, size.height * 0.6),
        stubPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TorchPainter old) =>
      old.isLit != isLit || old.flicker != flicker;
}
