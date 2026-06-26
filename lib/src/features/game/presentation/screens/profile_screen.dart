import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';
import 'package:littletech/src/features/game/constants/streak_tracker.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/domain/cubit/theme_cubit.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/presentation/widgets/sup_tech_avatar_wrapper.dart';
import 'package:littletech/src/features/game/presentation/widgets/framed_username.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/presentation/screens/achievements_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/challenge_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/stats_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/suptech_concept_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
      ),
      body: Builder(
        builder: (context) {
          final authState = context.watch<AuthCubit>().state;
          final user = (authState is LoginSuccess) ? authState.user : (authState is RegisterSuccess) ? authState.user : null;
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
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
SupTechAvatarWrapper(
                            size: 64,
                            child: SupTechAvatar(
                              size: 64,
                              skinId: progress.activeSkinId,
                            ),
                          ),
                          const Gap(12),
                          FramedUsername(
                            username: user?.username ?? 'Player',
                            fontSize: 22,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(4),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.monetization_on, color: scheme.secondary, size: 18),
                                  const Gap(4),
                                  Text(
                                    '${progress.points} points',
                                    style: TextStyle(
                                      color: scheme.secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 18),
                                  const Gap(4),
                                  Text(
                                    '${StreakTracker.calculateStreak(progress.playDates)} day streak',
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(12),
                          GestureDetector(
                            onTap: () {
                              final skin = SkinTierManager.fromId(progress.activeSkinId);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SupTechConceptSheet(skin: skin),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: scheme.onPrimary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.description_outlined, size: 16, color: scheme.onPrimary),
                                  const Gap(6),
                                  Text(
                                    'Concept Sheet',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: scheme.onPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        _StatCard(
                          icon: Icons.emoji_events,
                          label: 'Dungeons',
                          value: '${progress.levelsCleared}',
                          scheme: scheme,
                        ),
                        const Gap(10),
                        _StatCard(
                          icon: Icons.warning,
                          label: 'Bosses',
                          value: '${progress.bossesDefeated}',
                          scheme: scheme,
                        ),
                        const Gap(10),
                        _StatCard(
                          icon: Icons.redeem,
                          label: 'Rewards',
                          value: '${earnedRewards.length}',
                          scheme: scheme,
                        ),
                      ],
                    ),
                    const Gap(24),
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileAction(
                            icon: Icons.emoji_events,
                            label: 'Honors & Badges',
                            onTap: () => Nav.push(context, const AchievementsScreen()),
                            scheme: scheme,
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: _ProfileAction(
                            icon: Icons.bar_chart,
                            label: 'Stats',
                            onTap: () => Nav.push(context, const StatsScreen()),
                            scheme: scheme,
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          child: _ProfileAction(
                            icon: Icons.wb_sunny,
                            label: 'Quests',
                            onTap: () => Nav.push(context, const ChallengeScreen()),
                            scheme: scheme,
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
                    Text(
                      'Themes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
const Gap(24),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ThemeChip(
                          label: 'Default',
                          icon: Icons.palette,
                          isActive: progress.themeId == null || progress.themeId == 'default',
                          unlocked: true,
                          onUnlockTap: null,
                          onTap: () => _applyTheme(context, 'default'),
                          scheme: scheme,
                        ),
                        _ThemeChip(
                          label: 'Midnight',
                          icon: Icons.dark_mode,
                          isActive: progress.themeId == 'dark',
                          unlocked: progress.earnedRewardIds.contains('theme_dark') || progress.purchasedItemIds.contains('theme_dark'),
                          onUnlockTap: () => context.read<GameCubit>().purchaseItem('theme_dark'),
                          onTap: () => _applyTheme(context, 'dark'),
                          scheme: scheme,
                        ),
                        _ThemeChip(
                          label: 'Amber',
                          icon: Icons.light_mode,
                          isActive: progress.themeId == 'amber',
                          unlocked: progress.earnedRewardIds.contains('theme_amber') || progress.purchasedItemIds.contains('theme_amber'),
                          onUnlockTap: () => context.read<GameCubit>().purchaseItem('theme_amber'),
                          onTap: () => _applyTheme(context, 'amber'),
                          scheme: scheme,
                        ),
                        _ThemeChip(
                          label: 'Ocean',
                          icon: Icons.water_drop,
                          isActive: progress.themeId == 'ocean',
                          unlocked: progress.earnedRewardIds.contains('theme_ocean') || progress.purchasedItemIds.contains('theme_ocean'),
                          onUnlockTap: () => context.read<GameCubit>().purchaseItem('theme_ocean'),
                          onTap: () => _applyTheme(context, 'ocean'),
                          scheme: scheme,
                        ),
                        _ThemeChip(
                          label: 'Neon',
                          icon: Icons.nights_stay,
                          isActive: progress.themeId == 'neon',
                          unlocked: progress.earnedRewardIds.contains('theme_neon') || progress.purchasedItemIds.contains('theme_neon'),
                          onUnlockTap: () => context.read<GameCubit>().purchaseItem('theme_neon'),
                          onTap: () => _applyTheme(context, 'neon'),
                          scheme: scheme,
                        ),
                        _ThemeChip(
                          label: 'Medieval',
                          icon: Icons.castle,
                          isActive: progress.themeId == 'medieval',
                          unlocked: progress.purchasedItemIds.contains('theme_medieval'),
                          onUnlockTap: () => context.read<GameCubit>().purchaseItem('theme_medieval'),
                          onTap: () => _applyTheme(context, 'medieval'),
                          scheme: scheme,
                        ),
                        _ThemeChip(
                          label: 'Dungeon',
                          icon: Icons.door_front_door,
                          isActive: progress.themeId == 'dungeon',
                          unlocked: progress.purchasedItemIds.contains('theme_dungeon'),
                          onUnlockTap: () => context.read<GameCubit>().purchaseItem('theme_dungeon'),
                          onTap: () => _applyTheme(context, 'dungeon'),
                          scheme: scheme,
                        ),
                        _ThemeChip(
                          label: 'Arcane',
                          icon: Icons.auto_awesome,
                          isActive: progress.themeId == 'arcane',
                          unlocked: progress.purchasedItemIds.contains('theme_arcane'),
                          onUnlockTap: () => context.read<GameCubit>().purchaseItem('theme_arcane'),
                          onTap: () => _applyTheme(context, 'arcane'),
                          scheme: scheme,
                        ),
                        _ThemeChip(
                          label: 'Dragon Fire',
                          icon: Icons.local_fire_department,
                          isActive: progress.themeId == 'dragon_fire',
                          unlocked: progress.purchasedItemIds.contains('theme_dragon_fire'),
                          onUnlockTap: () => context.read<GameCubit>().purchaseItem('theme_dragon_fire'),
                          onTap: () => _applyTheme(context, 'dragon_fire'),
                          scheme: scheme,
                        ),
],
                    ),
                    const Gap(24),
                    Text(
                      'Frames',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: RewardPool.all.where((r) => r.type == RewardType.nicknameFrame).map((frame) {
                        final earned = progress.earnedRewardIds.contains(frame.id);
                        final purchased = progress.purchasedItemIds.contains(frame.id);
                        final unlocked = earned || purchased;
                        final isActive = progress.activeFrameId == frame.id;
                        return GestureDetector(
                          onTap: unlocked
                              ? () => context.read<GameCubit>().setActiveFrame(isActive ? null : frame.id)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? frame.color.withValues(alpha: 0.2)
                                  : unlocked
                                      ? frame.color.withValues(alpha: 0.1)
                                      : scheme.surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? frame.color
                                    : unlocked
                                        ? frame.color.withValues(alpha: 0.3)
                                        : scheme.outline.withValues(alpha: 0.1),
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(frame.icon, color: unlocked ? frame.color : scheme.onSurface.withValues(alpha: 0.3), size: 18),
                                const Gap(8),
                                Text(
                                  unlocked ? frame.displayName : '${frame.displayName} · 1000 pts',
                                  style: TextStyle(
                                    color: unlocked ? frame.color : scheme.onSurface.withValues(alpha: 0.3),
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                if (isActive) ...[
                                  const Gap(6),
                                  Icon(Icons.check_circle, color: frame.color, size: 16),
                                ] else if (!unlocked) ...[
                                  const Gap(6),
                                  GestureDetector(
                                    onTap: () => context.read<GameCubit>().purchaseItem(frame.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: scheme.secondary.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Buy',
                                        style: TextStyle(color: scheme.secondary, fontSize: 10, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Gap(24),
                    Text(
                      'Icons',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: RewardPool.all.where((r) => r.type == RewardType.icon).map((iconReward) {
                        final earned = progress.earnedRewardIds.contains(iconReward.id);
                        final isActive = progress.activeIconId == iconReward.id;
                        return GestureDetector(
                          onTap: earned
                              ? () => context.read<GameCubit>().setActiveIcon(isActive ? null : iconReward.id)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? iconReward.color.withValues(alpha: 0.2)
                                  : earned
                                      ? iconReward.color.withValues(alpha: 0.1)
                                      : scheme.surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? iconReward.color
                                    : earned
                                        ? iconReward.color.withValues(alpha: 0.3)
                                        : scheme.outline.withValues(alpha: 0.1),
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  iconReward.value,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Gap(8),
                                Text(
                                  earned ? iconReward.displayName : '${iconReward.displayName} · Locked',
                                  style: TextStyle(
                                    color: earned ? iconReward.color : scheme.onSurface.withValues(alpha: 0.3),
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                if (isActive) ...[
                                  const Gap(6),
                                  Icon(Icons.check_circle, color: iconReward.color, size: 16),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Gap(24),
                    Text(
                      'Titles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: RewardPool.all.where((r) => r.type == RewardType.title).map((titleReward) {
                        final earned = progress.earnedRewardIds.contains(titleReward.id);
                        final isActive = progress.activeTitleId == titleReward.id;
                        return GestureDetector(
                          onTap: earned
                              ? () => context.read<GameCubit>().setActiveTitle(isActive ? null : titleReward.id)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? titleReward.color.withValues(alpha: 0.2)
                                  : earned
                                      ? titleReward.color.withValues(alpha: 0.1)
                                      : scheme.surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? titleReward.color
                                    : earned
                                        ? titleReward.color.withValues(alpha: 0.3)
                                        : scheme.outline.withValues(alpha: 0.1),
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(titleReward.icon, color: earned ? titleReward.color : scheme.onSurface.withValues(alpha: 0.3), size: 18),
                                const Gap(8),
                                Text(
                                  earned ? titleReward.value : '${titleReward.value} · Locked',
                                  style: TextStyle(
                                    color: earned ? titleReward.color : scheme.onSurface.withValues(alpha: 0.3),
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                if (isActive) ...[
                                  const Gap(6),
                                  Icon(Icons.check_circle, color: titleReward.color, size: 16),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const Gap(24),
                    Text(
                      'Skins',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const Gap(12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: SkinTierManager.skins.map((skin) {
                        final purchased = progress.purchasedItemIds.contains(skin.id);
                        final earnedAsReward = progress.earnedRewardIds.contains('skin_${skin.id}');
                        final unlocked = progress.unlockedSkinIds.contains(skin.id) || earnedAsReward || purchased;
                        final isActive = progress.activeSkinId == skin.id;
                        return GestureDetector(
                          onTap: unlocked
                              ? () => context.read<GameCubit>().setActiveSkin(skin.id)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? skin.color.withValues(alpha: 0.2)
                                  : unlocked
                                      ? scheme.surface
                                      : scheme.surface.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isActive
                                    ? skin.color
                                    : unlocked
                                        ? scheme.outline.withValues(alpha: 0.3)
                                        : scheme.outline.withValues(alpha: 0.1),
                                width: isActive ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(skin.previewIcon, color: unlocked ? skin.color : scheme.onSurface.withValues(alpha: 0.3), size: 18),
                                const Gap(8),
                                Text(
                                  skin.name,
                                  style: TextStyle(
                                    color: unlocked ? skin.color : scheme.onSurface.withValues(alpha: 0.3),
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                ),
                                if (isActive) ...[
                                  const Gap(6),
                                  Icon(Icons.check_circle, color: skin.color, size: 16),
                                ] else if (!unlocked) ...[
                                  const Gap(6),
                                  GestureDetector(
                                    onTap: () => context.read<GameCubit>().purchaseItem(skin.id),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: scheme.secondary.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Buy',
                                        style: TextStyle(color: scheme.secondary, fontSize: 10, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
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
  final ColorScheme scheme;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: scheme.secondary, size: 24),
            const Gap(8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: scheme.secondary, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool unlocked;
  final VoidCallback? onUnlockTap;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _ThemeChip({
    required this.label,
    required this.icon,
    required this.isActive,
    this.unlocked = true,
    this.onUnlockTap,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    final canTap = unlocked ? onTap : onUnlockTap;
    return GestureDetector(
      onTap: canTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? scheme.secondary.withValues(alpha: 0.15)
              : unlocked
                  ? scheme.surface
                  : scheme.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? scheme.secondary
                : unlocked
                    ? scheme.outline.withValues(alpha: 0.3)
                    : scheme.outline.withValues(alpha: 0.1),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? scheme.secondary : scheme.onSurface.withValues(alpha: 0.5),
            ),
            const Gap(6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? scheme.secondary : scheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (!unlocked) ...[
              const Gap(6),
              GestureDetector(
                onTap: onUnlockTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Buy',
                    style: TextStyle(color: scheme.secondary, fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
