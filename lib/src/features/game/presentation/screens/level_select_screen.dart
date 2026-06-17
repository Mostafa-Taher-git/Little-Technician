import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(world.name),
        actions: [
          BlocBuilder<GameCubit, GameState>(
            builder: (_, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, color: AppColors.accent, size: 16),
                    const Gap(4),
                    Text(
                      '${state.totalPoints}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
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

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                world.description,
                style: const TextStyle(
                  color: AppColors.onSurfaceMuted,
                  fontSize: 14,
                ),
              ),
              const Gap(20),
              ...world.levels.map((level) {
                final isCompleted =
                    state.progress.completedLevelIds.contains(level.id);
                final isLocked = !isCompleted &&
                    !_isPreviousCompleted(state, world, level);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
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
                );
              }),
              const Gap(20),
              // Boss card
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade900,
                      Colors.red.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: allLevelsCompleted
                        ? () {
                            context.read<GameCubit>().selectWorld(world);
                            context.read<GameCubit>().startBoss();
                            Nav.push(
                              context,
                              BossScreen(world: world),
                            );
                          }
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'BOSS',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  world.boss.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  '${world.boss.hp} HP • ${world.boss.points}pts',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!allLevelsCompleted)
                            const Icon(Icons.lock_outline, color: Colors.white54),
                          if (allLevelsCompleted)
                            const Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
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
