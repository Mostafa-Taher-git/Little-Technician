import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

class LevelCard extends StatelessWidget {
  final LevelDef level;
  final bool isCompleted;
  final bool isLocked;
  final int totalSteps;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    this.isCompleted = false,
    this.isLocked = false,
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
                                  style: theme.textTheme.titleSmall?.copyWith(
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
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
                        ),
                        border: Border.all(
                          color: const Color(0xFFDAA520),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.secondary.withValues(alpha: 0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${level.points}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF3E2723),
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
            ..._buildRivets(scheme.outline),
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
