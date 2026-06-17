import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/features/auth/data/models/user_model.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/domain/cubit/theme_cubit.dart';
import 'package:littletech/src/features/game/presentation/widgets/reward_chip.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<UserModel?>(
        future: AuthService.getCurrentUser(),
        builder: (_, snap) {
          final user = snap.data;
          return BlocBuilder<GameCubit, GameState>(
            builder: (_, state) {
              final progress = state.progress;
              final earnedRewards = progress.earnedRewardIds
                  .map((id) => RewardPool.byId(id))
                  .whereType<RewardDef>()
                  .toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar and stats header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.darkGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SupTechAvatar(
                            availableUses: state.availableSupTechUses,
                            isGlowing: true,
                            size: 64,
                          ),
                          const Gap(12),
                          Text(
                            user?.username ?? 'Player',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Gap(4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.monetization_on,
                                  color: AppColors.accent, size: 18),
                              const Gap(6),
                              Text(
                                '${progress.points} points',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    // Stats
                    Row(
                      children: [
                        _StatCard(
                          icon: Icons.emoji_events,
                          label: 'Levels',
                          value: '${progress.levelsCleared}',
                        ),
                        const Gap(10),
                        _StatCard(
                          icon: Icons.warning,
                          label: 'Bosses',
                          value: '${progress.bossesDefeated}',
                        ),
                        const Gap(10),
                        _StatCard(
                          icon: Icons.redeem,
                          label: 'Rewards',
                          value: '${earnedRewards.length}',
                        ),
                      ],
                    ),
                    const Gap(24),
                    // Themes
                    const Text(
                      'Themes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ThemeChip(
                          label: 'Default',
                          icon: Icons.palette,
                          isActive: progress.themeId == null || progress.themeId == 'default',
                          onTap: () => _applyTheme(context, 'default'),
                        ),
                        _ThemeChip(
                          label: 'Midnight',
                          icon: Icons.dark_mode,
                          isActive: progress.themeId == 'dark',
                          onTap: () => _applyTheme(context, 'dark'),
                        ),
                        _ThemeChip(
                          label: 'Amber',
                          icon: Icons.light_mode,
                          isActive: progress.themeId == 'amber',
                          onTap: () => _applyTheme(context, 'amber'),
                        ),
                        _ThemeChip(
                          label: 'Ocean',
                          icon: Icons.water_drop,
                          isActive: progress.themeId == 'ocean',
                          onTap: () => _applyTheme(context, 'ocean'),
                        ),
                        _ThemeChip(
                          label: 'Neon',
                          icon: Icons.nights_stay,
                          isActive: progress.themeId == 'neon',
                          onTap: () => _applyTheme(context, 'neon'),
                        ),
                      ],
                    ),
                    const Gap(24),
                    // Rewards
                    const Text(
                      'Earned Rewards',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Gap(12),
                    if (earnedRewards.isEmpty)
                      const Text(
                        'Complete levels to earn rewards!',
                        style: TextStyle(color: AppColors.onSurfaceMuted),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: earnedRewards
                            .map((r) => RewardChip(reward: r))
                            .toList(),
                      ),
                    const Gap(24),
                    // Skins
                    const Text(
                      'SupTech Skins',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Gap(12),
                    if (progress.unlockedSkinIds.isEmpty)
                      const Text(
                        'Earn skins from rewards!',
                        style: TextStyle(color: AppColors.onSurfaceMuted),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: progress.unlockedSkinIds.map((skinId) {
                          return Chip(
                            avatar: const Icon(Icons.terminal, size: 16),
                            label: Text(skinId),
                            backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _applyTheme(BuildContext context, String themeId) {
    context.read<ThemeCubit>().applyTheme(themeId);
    context.read<GameCubit>().setThemeId(themeId == 'default' ? null : themeId);
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accent, size: 24),
            const Gap(8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.onSurfaceMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ThemeChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.accent.withValues(alpha: 0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.border,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isActive ? AppColors.accent : AppColors.onSurfaceMuted),
            const Gap(6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.accent : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
