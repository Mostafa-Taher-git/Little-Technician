import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/quiz_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/review_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/boss_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/level_card.dart';

class LevelSelectScreen extends StatelessWidget {
  final WorldDef world;

  const LevelSelectScreen({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(world.name),
        backgroundColor: Colors.transparent,
        actions: [
          BlocBuilder<GameCubit, GameState>(
            builder: (_, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on,
                        color: scheme.secondary, size: 16),
                    const Gap(4),
                    Text(
                      '${state.totalPoints}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (_, state) {
          final allLevelsCompleted = world.levels
              .every((l) => state.progress.completedLevelIds.contains(l.id));

          final listView = ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _DungeonHeader(
                description: world.description,
                levelsCleared: world.levels
                    .where((l) =>
                        state.progress.completedLevelIds.contains(l.id))
                    .length,
                totalLevels: world.levels.length,
              ),
              const Gap(24),
              ...world.levels.asMap().entries.map((entry) {
                final i = entry.key;
                final level = entry.value;
                final isCompleted =
                    state.progress.completedLevelIds.contains(level.id);
                final isLocked = !isCompleted &&
                    !_isPreviousCompleted(state, world, level);

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (i > 0)
                      _DungeonConnector(
                        isCompleted: isCompleted ||
                            state.progress.completedLevelIds
                                .contains(world.levels[i - 1].id),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: LevelCard(
                        level: level,
                        isCompleted: isCompleted,
                        isLocked: isLocked,
                        totalSteps: level.steps.length,
                        onTap: () {
                          context.read<GameCubit>().selectLevel(level, worldOverride: world);
                          if (isCompleted) {
                            Nav.push(context, ReviewScreen(world: world, level: level));
                          } else {
                            Nav.push(context, QuizScreen(world: world, level: level));
                          }
                        },
                      ),
                    ),
                  ],
                );
              }),
              const Gap(32),
              _BossDungeonDoor(
                boss: world.boss,
                isUnlocked: allLevelsCompleted,
                points: state.totalPoints,
                onEnter: () {
                  context.read<GameCubit>().selectWorld(world);
                  context.read<GameCubit>().startBoss();
                  Nav.push(context, BossScreen(world: world));
                },
              ),
            ],
          );
          return listView;
        },
      ),
    );
  }

  bool _isPreviousCompleted(GameState state, WorldDef world, LevelDef level) {
    final idx = world.levels.indexOf(level);
    if (idx <= 0) return true;
    return state.progress.completedLevelIds
        .contains(world.levels[idx - 1].id);
  }
}

class _DungeonHeader extends StatelessWidget {
  final String description;
  final int levelsCleared;
  final int totalLevels;

  const _DungeonHeader({
    required this.description,
    required this.levelsCleared,
    required this.totalLevels,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.map_rounded, color: scheme.secondary, size: 24),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const Gap(4),
                Text(
                  '$levelsCleared / $totalLevels dungeon rooms cleared',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: scheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DungeonConnector extends StatelessWidget {
  final bool isCompleted;

  const _DungeonConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 20,
      child: CustomPaint(
        painter: _ConnectorLinePainter(
          color: isCompleted
              ? scheme.secondary.withValues(alpha: 0.3)
              : scheme.outline.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}

class _ConnectorLinePainter extends CustomPainter {
  final Color color;

  _ConnectorLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    for (var i = 0; i < 4; i++) {
      final linkY = size.height * 0.15 + i * size.height * 0.2;
      final linkPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, linkY),
            width: 6,
            height: 4,
          ),
          const Radius.circular(2),
        ),
        linkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ConnectorLinePainter old) =>
      old.color != color;
}

class _BossDungeonDoor extends StatelessWidget {
  final BossDef boss;
  final bool isUnlocked;
  final int points;
  final VoidCallback onEnter;

  const _BossDungeonDoor({
    required this.boss,
    required this.isUnlocked,
    required this.points,
    required this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isUnlocked
            ? const LinearGradient(
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF2D2D44),
                  Color(0xFF1A1A2E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  scheme.surface,
                  scheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ]
            : null,
        border: Border.all(
          color: isUnlocked
              ? const Color(0xFF4A4A6A).withValues(alpha: 0.6)
              : scheme.outline.withValues(alpha: 0.15),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: isUnlocked ? onEnter : null,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CustomPaint(
                  size: const Size(56, 56),
                  painter: _IronGatePainter(
                    isUnlocked: isUnlocked,
                    scheme: scheme,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'BOSS',
                            style: TextStyle(
                              color: isUnlocked
                                  ? const Color(0xFFDC143C)
                                  : scheme.onSurface.withValues(alpha: 0.2),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                          if (!isUnlocked) ...[
                            const Gap(8),
                            Icon(Icons.lock_outline,
                                size: 14,
                                color: scheme.onSurface.withValues(alpha: 0.2)),
                          ],
                        ],
                      ),
                      const Gap(4),
                      Text(
                        boss.name,
                        style: TextStyle(
                          color: isUnlocked
                              ? Colors.white
                              : scheme.onSurface.withValues(alpha: 0.3),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(2),
                      Text(
                        '${boss.hp} HP  •  ${boss.points} pts',
                        style: TextStyle(
                          color: isUnlocked
                              ? Colors.white.withValues(alpha: 0.6)
                              : scheme.onSurface.withValues(alpha: 0.15),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUnlocked)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFDC143C).withValues(alpha: 0.2),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFFDC143C),
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IronGatePainter extends CustomPainter {
  final bool isUnlocked;
  final ColorScheme scheme;

  _IronGatePainter({required this.isUnlocked, required this.scheme});

  @override
  void paint(Canvas canvas, Size size) {
    final color = isUnlocked
        ? const Color(0xFF4A4A6A)
        : scheme.outline.withValues(alpha: 0.2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(3, 3, size.width - 6, size.height - 6),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2, 3),
      Offset(size.width / 2, size.height - 3),
      paint,
    );
    canvas.drawLine(
      Offset(3, size.height / 2),
      Offset(size.width - 3, size.height / 2),
      paint,
    );

    final skullColor = isUnlocked
        ? const Color(0xFFDC143C).withValues(alpha: 0.6)
        : scheme.outline.withValues(alpha: 0.15);
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.35),
      6,
      Paint()..color = skullColor,
    );
  }

  @override
  bool shouldRepaint(covariant _IronGatePainter old) =>
      old.isUnlocked != isUnlocked;
}


