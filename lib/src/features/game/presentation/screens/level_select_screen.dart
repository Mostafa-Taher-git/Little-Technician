import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/problem_screen.dart';
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
                          context.read<GameCubit>().selectLevel(level);
                          Nav.push(
                            context,
                            ProblemScreen(world: world, level: level),
                          );
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
                  '$levelsCleared / $totalLevels chambers cleared',
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
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height * 0.5)
      ..lineTo(size.width / 2 + 20, size.height * 0.5)
      ..lineTo(size.width / 2 + 20, size.height);

    canvas.drawPath(path, paint);

    for (var i = 0; i < 3; i++) {
      final dashY = size.height * 0.15 + i * size.height * 0.3;
      canvas.drawCircle(
        Offset(size.width / 2, dashY),
        1.5,
        Paint()..color = color.withValues(alpha: 0.3),
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
            ? LinearGradient(
                colors: [
                  Colors.red.shade900,
                  Colors.red.shade700,
                  Colors.red.shade800,
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
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
        border: Border.all(
          color: isUnlocked
              ? Colors.red.shade400.withValues(alpha: 0.5)
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUnlocked
                            ? Colors.white.withValues(alpha: 0.1)
                            : scheme.outline.withValues(alpha: 0.05),
                      ),
                    ),
                    CustomPaint(
                      size: const Size(40, 40),
                      painter: _MiniBossSkullPainter(
                        color: isUnlocked ? Colors.red.shade300 : scheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
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
                                  ? Colors.red.shade200
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
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
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

class _MiniBossSkullPainter extends CustomPainter {
  final Color color;

  _MiniBossSkullPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.7)
      ..lineTo(size.width * 0.3, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.1,
        size.width * 0.7, size.height * 0.35,
      )
      ..lineTo(size.width * 0.7, size.height * 0.7)
      ..close();

    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.45),
      size.width * 0.06,
      paint..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.45),
      size.width * 0.06,
      paint,
    );

    paint.style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.6, size.height * 0.65),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniBossSkullPainter old) =>
      old.color != color;
}
