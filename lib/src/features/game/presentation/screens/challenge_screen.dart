import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/challenges.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_select_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/problem_screen.dart';

class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final daily = ChallengeManager.getDailyChallenge();
    final weekly = ChallengeManager.getWeeklyBoss();

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Quests & Raids'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ChallengeCard(
            title: 'Daily Quest',
            icon: Icons.wb_sunny,
            subtitle: daily.title,
            description: daily.description,
            bonusPoints: daily.bonusPoints,
            pointsMultiplier: daily.pointsMultiplier,
            color: Colors.orange,
            onTap: () {
              final level = GameData.worlds
                  .expand((w) => w.levels)
                  .firstWhere((l) => l.id == daily.levelId);
              final world = GameData.worlds.firstWhere((w) => w.levels.contains(level));
              context.read<GameCubit>()
                ..selectLevel(level)
                ..setPointsMultiplier(daily.pointsMultiplier);
              Nav.push(context, ProblemScreen(world: world, level: level));
            },
          ),
          const Gap(16),
          _ChallengeCard(
            title: 'Weekly Raid',
            icon: Icons.calendar_month,
            subtitle: GameData.worlds[weekly.worldIndex].name,
            description: weekly.specialRule,
            bonusPoints: weekly.bonusPoints,
            pointsMultiplier: weekly.pointsMultiplier,
            color: Colors.red,
            onTap: () {
              final world = GameData.worlds[weekly.worldIndex];
              context.read<GameCubit>()
                ..selectWorld(world)
                ..setBossMultiplier(2)
                ..setPointsMultiplier(weekly.pointsMultiplier);
              Nav.push(context, LevelSelectScreen(world: world));
            },
          ),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final String description;
  final int bonusPoints;
  final int pointsMultiplier;
  final Color color;
  final VoidCallback onTap;

  const _ChallengeCard({
    required this.title,
    required this.icon,
    required this.subtitle,
    required this.description,
    required this.bonusPoints,
    required this.pointsMultiplier,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            letterSpacing: 1,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${pointsMultiplier}x pts',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      description,
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.05);
  }
}
