import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/achievements.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/constants/streak_tracker.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Honors & Badges'),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (_, state) {
          final progress = state.progress;
          final earnedIds = progress.earnedRewardIds;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${progress.levelsCleared} levels cleared',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              const Gap(16),
              ...AchievementManager.all.map((a) {
                final progressVal = switch (a.type) {
                  AchievementType.levels => progress.levelsCleared,
                  AchievementType.bosses => progress.bossesDefeated,
                  AchievementType.points => progress.points,
                  AchievementType.rewards => earnedIds.length,
                  AchievementType.streak => StreakTracker.calculateStreak(progress.playDates),
                  AchievementType.worlds => progress.completedWorldIds.length,
                  AchievementType.categories => progress.completedCategoryIds.length,
                };
                final isDone = progressVal >= a.requirement;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDone
                        ? a.icon == Icons.workspace_premium
                            ? Colors.amber.withValues(alpha: 0.08)
                            : Colors.green.withValues(alpha: 0.05)
                        : scheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDone
                          ? Colors.green.withValues(alpha: 0.3)
                          : scheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDone
                              ? Colors.green.withValues(alpha: 0.1)
                              : scheme.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          a.icon,
                          color: isDone ? Colors.green : scheme.onSurface.withValues(alpha: 0.4),
                          size: 20,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a.name,
                              style: TextStyle(
                                color: isDone
                                    ? Colors.green.shade300
                                    : scheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              a.description,
                              style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isDone)
                        Icon(Icons.check_circle, color: Colors.green.shade400, size: 22)
                      else
                        Text(
                          '$progressVal/${a.requirement}',
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.4),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ).animate().fadeIn(delay: (30 * AchievementManager.all.indexOf(a)).ms);
              }),
              const Gap(24),
              Text(
                'Badges',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const Gap(12),
              ...RewardPool.badges.asMap().entries.map((entry) {
                final index = entry.key;
                final badge = entry.value;
                final isEarned = earnedIds.contains(badge.id);
                final delay = 30 * AchievementManager.all.length + 50 * index;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isEarned
                        ? badge.color.withValues(alpha: 0.08)
                        : scheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isEarned
                          ? badge.color.withValues(alpha: 0.3)
                          : scheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isEarned
                              ? badge.color.withValues(alpha: 0.1)
                              : scheme.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          badge.icon,
                          color: isEarned ? badge.color : scheme.onSurface.withValues(alpha: 0.3),
                          size: 20,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              badge.displayName,
                              style: TextStyle(
                                color: isEarned ? badge.color : scheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              isEarned ? 'Earned Badge' : 'Locked',
                              style: TextStyle(
                                color: isEarned ? badge.color.withValues(alpha: 0.7) : scheme.onSurface.withValues(alpha: 0.4),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isEarned)
                        Icon(Icons.check_circle, color: badge.color, size: 22)
                      else
                        const Icon(Icons.lock, color: Colors.grey, size: 22),
                    ],
                  ),
                ).animate().fadeIn(delay: delay.ms);
              }),
            ],
          );
        },
      ),
    );
  }
}