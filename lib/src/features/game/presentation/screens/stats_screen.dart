import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/auth/data/models/user_model.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';
import 'package:littletech/src/features/game/constants/streak_tracker.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Character Sheet'),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<UserModel?>(
        future: AuthService.getCurrentUser(),
        builder: (_, snap) {
          final user = snap.data;
          return BlocBuilder<GameCubit, GameState>(
            builder: (_, state) {
              final p = state.progress;
              final earnedRewards = p.earnedRewardIds
                  .map((id) => RewardPool.byId(id))
                  .whereType<RewardDef>()
                  .length;
              final totalLevels = GameData.worlds.fold(0, (s, w) => s + w.levels.length);
              final worldsCompleted = GameData.worlds
                  .where((w) => w.levels.every((l) => p.completedLevelIds.contains(l.id)))
                  .length;
              final currentSkin = SkinTierManager.skinForLevelsCleared(p.levelsCleared);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          scheme.primary,
                          scheme.primary.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          user?.username ?? 'Player',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Gap(4),
                        if (currentSkin != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: currentSkin.color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              currentSkin.tierLabel,
                              style: TextStyle(
                                color: currentSkin.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      _StatSquare(icon: Icons.checklist, label: 'Levels', value: '${p.levelsCleared}/$totalLevels', scheme: scheme),
                      const Gap(10),
                      _StatSquare(icon: Icons.shield, label: 'Bosses', value: '${p.bossesDefeated}', scheme: scheme),
                      const Gap(10),
                      _StatSquare(icon: Icons.public, label: 'Worlds', value: '$worldsCompleted/${GameData.worlds.length}', scheme: scheme),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      _StatSquare(icon: Icons.monetization_on, label: 'Points', value: '${p.points}', scheme: scheme),
                      const Gap(10),
                      _StatSquare(icon: Icons.card_giftcard, label: 'Rewards', value: '$earnedRewards', scheme: scheme),
                      const Gap(10),
                      _StatSquare(icon: Icons.auto_awesome, label: 'Skins', value: '${p.unlockedSkinIds.length}', scheme: scheme),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      _StatSquare(
                        icon: Icons.speed,
                        label: 'Accuracy',
                        value: p.totalAnswers > 0 ? '${(p.correctAnswers * 100 / p.totalAnswers).round()}%' : '—',
                        scheme: scheme,
                      ),
                      const Gap(10),
                      _StatSquare(
                        icon: Icons.local_fire_department,
                        label: 'Streak',
                        value: '${StreakTracker.calculateStreak(p.playDates)} days',
                        scheme: scheme,
                      ),
                      const Gap(10),
                      _StatSquare(
                        icon: Icons.timer,
                        label: 'Play Time',
                        value: p.totalPlayTimeSeconds > 3600
                            ? '${(p.totalPlayTimeSeconds / 3600).round()}h'
                            : '${(p.totalPlayTimeSeconds / 60).round()}m',
                        scheme: scheme,
                      ),
                    ],
                  ),
                  const Gap(24),
                  Text(
                    'Familiar',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(12),
                  ...SkinTierManager.skins.map((skin) {
                    final unlocked = p.levelsCleared >= skin.levelsRequired;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: unlocked
                            ? skin.color.withValues(alpha: 0.05)
                            : scheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: unlocked
                              ? skin.color.withValues(alpha: 0.3)
                              : scheme.outline.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: skin.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(skin.previewIcon, color: skin.color, size: 18),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  skin.name,
                                  style: TextStyle(
                                    color: unlocked ? skin.color : scheme.onSurface.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  skin.description,
                                  style: TextStyle(
                                    color: scheme.onSurface.withValues(alpha: 0.4),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (unlocked)
                            Icon(Icons.check_circle, color: skin.color, size: 18)
                          else
                            Text(
                              '${p.levelsCleared}/${skin.levelsRequired}',
                              style: TextStyle(
                                color: scheme.onSurface.withValues(alpha: 0.3),
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _StatSquare extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme scheme;

  const _StatSquare({
    required this.icon,
    required this.label,
    required this.value,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: scheme.secondary, size: 22),
            const Gap(6),
            Text(
              value,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
