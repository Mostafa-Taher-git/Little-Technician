import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

class LevelCard extends StatelessWidget {
  final LevelDef level;
  final bool isCompleted;
  final bool isLocked;
  final int completedSteps;
  final int totalSteps;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    this.isCompleted = false,
    this.isLocked = false,
    this.completedSteps = 0,
    this.totalSteps = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: isLocked
                  ? scheme.surface.withValues(alpha: 0.3)
                  : scheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted
                    ? scheme.secondary.withValues(alpha: 0.3)
                    : isLocked
                        ? scheme.outline.withValues(alpha: 0.2)
                        : scheme.outline.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: [
                if (!isLocked)
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
                    const Gap(4),
                    _DungeonDoor(
                      isCompleted: isCompleted,
                      isLocked: isLocked,
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              if (isCompleted)
                                Icon(Icons.check_circle,
                                    size: 16, color: scheme.secondary),
                              if (isCompleted) const Gap(6),
                              Flexible(
                                child: Text(
                                  level.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isLocked
                                        ? scheme.onSurface.withValues(alpha: 0.3)
                                        : scheme.onSurface,
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
                              Text(
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(4),
                    _DungeonTorch(isLit: !isLocked && !isCompleted),
                    const Gap(4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.secondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: scheme.secondary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        '${level.points}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: scheme.secondary,
                        ),
                      ),
                    ),
                    const Gap(8),
                  ],
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
        ),
      ),
    );
  }
}

class _DoorArchPainter extends CustomPainter {
  final Color doorColor;
  final bool isCompleted;
  final bool isLocked;

  _DoorArchPainter({
    required this.doorColor,
    required this.isCompleted,
    required this.isLocked,
  });

  @override
  void paint(Canvas canvas, Size size) {
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

  @override
  bool shouldRepaint(covariant _DoorArchPainter old) =>
      old.doorColor != doorColor || old.isCompleted != isCompleted;
}

class _DungeonTorch extends StatelessWidget {
  final bool isLit;

  const _DungeonTorch({required this.isLit});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = isLit ? scheme.secondary : scheme.outline.withValues(alpha: 0.2);

    return Container(
      width: 20,
      height: 48,
      alignment: Alignment.center,
      child: CustomPaint(
        painter: _TorchPainter(isLit: isLit, color: color),
        size: const Size(20, 48),
      ),
    );
  }
}

class _TorchPainter extends CustomPainter {
  final bool isLit;
  final Color color;

  _TorchPainter({required this.isLit, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stickPaint = Paint()
      ..color = const Color(0xFF8B4513).withValues(alpha: isLit ? 0.8 : 0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width / 2, size.height * 0.6),
      Offset(size.width / 2, size.height),
      stickPaint,
    );

    if (isLit) {
      final flamePaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      final flamePath = Path()
        ..moveTo(size.width / 2 - 4, size.height * 0.55)
        ..quadraticBezierTo(
          size.width / 2 - 2, size.height * 0.3,
          size.width / 2, size.height * 0.15,
        )
        ..quadraticBezierTo(
          size.width / 2 + 2, size.height * 0.3,
          size.width / 2 + 4, size.height * 0.55,
        )
        ..close();

      canvas.drawPath(flamePath, flamePaint);

      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.35),
        8,
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
  bool shouldRepaint(covariant _TorchPainter old) => old.isLit != isLit;
}
