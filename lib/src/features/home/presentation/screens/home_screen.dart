import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:littletech/src/features/solutions/presentation/screens/saved_solutions_screen.dart';
import 'package:littletech/src/features/solutions/presentation/screens/categories_screen.dart';
import 'package:littletech/src/features/solutions/presentation/screens/search_screen.dart';
import 'package:littletech/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:littletech/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/world_select_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/profile_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/presentation/widgets/sup_tech_avatar_wrapper.dart';
import 'package:littletech/src/features/game/presentation/widgets/framed_username.dart';
import 'package:littletech/src/features/game/presentation/widgets/challenge_banner.dart';
import 'package:littletech/src/features/game/presentation/screens/challenge_screen.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/constants/streak_tracker.dart';
import 'package:littletech/src/features/game/constants/achievements.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and actions
              _Header(),
              const Gap(16),

              // Player stats row (points, streak, title)
              _PlayerStatsRow(),
              const Gap(16),

              // Earned Honors & Badges
              BlocBuilder<GameCubit, GameState>(
                builder: (_, state) {
                  final progress = state.progress;
                  final earnedIds = progress.earnedRewardIds;

                  final earnedAchievements = AchievementManager.all.where((a) {
                    final progressVal = switch (a.type) {
                      AchievementType.levels => progress.levelsCleared,
                      AchievementType.bosses => progress.bossesDefeated,
                      AchievementType.points => progress.points,
                      AchievementType.rewards => earnedIds.length,
                      AchievementType.streak => StreakTracker.calculateStreak(progress.playDates),
                      AchievementType.categories => progress.completedCategoryIds.length,
                      AchievementType.weeklyBosses => progress.weeklyBossesDefeated,
                    };
                    return progressVal >= a.requirement;
                  }).toList();

                  final earnedBadges = RewardPool.badges.where((b) => earnedIds.contains(b.id)).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.emoji_events, color: scheme.secondary, size: 18),
                          const Gap(6),
                          Text(
                            'Honors & Badges',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const Gap(12),
                      if (earnedAchievements.isEmpty && earnedBadges.isEmpty)
                        Text(
                          'Complete levels to earn honors and badges!',
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 13,
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...earnedAchievements.map((a) => Tooltip(
                              message: a.name,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                                ),
                                child: Icon(a.icon, color: Colors.green.shade300, size: 18),
                              ),
                            )),
                            ...earnedBadges.map((b) => Tooltip(
                              message: b.displayName,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: b.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: b.color.withValues(alpha: 0.3)),
                                ),
                                child: Icon(b.icon, color: b.color, size: 18),
                              ),
                            )),
                          ],
                        ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
                },
              ),
              const Gap(16),

              // Stats card with gradient
              _StatsCard(),
              const Gap(20),

              // Challenge banner
              BlocBuilder<GameCubit, GameState>(
                builder: (_, state) {
                  final streak = StreakTracker.calculateStreak(state.progress.playDates);
                  return ChallengeBanner(
                    streak: streak,
                    onDailyTap: () => Nav.push(context, const ChallengeScreen()),
                    onWeeklyTap: () => Nav.push(context, const ChallengeScreen()),
                  );
                },
              ),
              const Gap(24),

              // Quick actions section
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                  letterSpacing: -0.2,
                ),
              ),
              const Gap(12),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.grid_view_rounded,
                      label: 'Categories',
                      color: scheme.primary,
                      onTap: () => Nav.push(context, const CategoriesScreen()),
                      scheme: scheme,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.search_rounded,
                      label: 'Search',
                      color: scheme.secondary,
                      onTap: () => Nav.push(context, const SearchScreen()),
                      scheme: scheme,
                    ),
                  ),
                ],
              ),
              const Gap(28),

              // CTA buttons
              Row(
                children: [
                  Expanded(
                    child: _CTAButton(
                      icon: Icons.bookmark_outline_rounded,
                      label: 'Browse Solutions',
                      isPrimary: false,
                      onTap: () => Nav.push(context, const CategoriesScreen()),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _CTAButton(
                      icon: Icons.castle_rounded,
                      label: 'Enter Dungeon',
                      isPrimary: true,
                      onTap: () {
                        context.read<GameCubit>().loadGame();
                        Nav.push(context, const WorldSelectScreen());
                      },
                    ),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.15),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Avatar and greeting
        Expanded(
          child: Builder(
            builder: (context) {
              final authState = context.watch<AuthCubit>().state;
              final user = (authState is LoginSuccess) ? authState.user : (authState is RegisterSuccess) ? authState.user : null;
              return Row(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FramedUsername(
                          username: user?.username ?? 'User',
                          fontSize: 16,
                          fontColor: scheme.onSurface,
                        ),
                        const Gap(2),
                        Text(
                          'Ready to troubleshoot?',
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const Gap(8),

        // SupTech avatar with container
        BlocBuilder<GameCubit, GameState>(
          builder: (_, state) {
            return SupTechAvatarWrapper(
              size: 56,
              onTap: () => Nav.push(context, const ProfileScreen()),
              child: SupTechAvatar(
                size: 56,
                skinId: state.progress.activeSkinId,
              ),
            );
          },
        ),
        const Gap(4),

        // Saved solutions
        _IconButton(
          icon: Icons.bookmark_outline_rounded,
          onTap: () => Nav.push(context, const SavedSolutionsScreen()),
        ),
        const Gap(4),

        // Settings
        _IconButton(
          icon: Icons.settings_outlined,
          onTap: () => Nav.push(context, const SettingsScreen()),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, size: 18, color: scheme.onSurface.withValues(alpha: 0.7)),
        ),
      ),
    );
  }
}

/// Helper to calculate player title based on achievements
class _PlayerTitle {
  static String getTitle(int levelsCleared, int bossesDefeated, int points) {
    if (levelsCleared >= 20 && bossesDefeated >= 8) return 'Tech Legend';
    if (levelsCleared >= 20) return 'Master Technician';
    if (levelsCleared >= 10) return 'Skilled Repairer';
    if (levelsCleared >= 5) return 'Apprentice Technician';
    if (levelsCleared >= 1) return 'Novice';
    return 'Beginner';
  }

  static IconData getIcon(int levelsCleared, int bossesDefeated) {
    if (levelsCleared >= 20 && bossesDefeated >= 8) return Icons.workspace_premium;
    if (levelsCleared >= 20) return Icons.star;
    if (levelsCleared >= 10) return Icons.star_half;
    if (levelsCleared >= 5) return Icons.star_border;
    return Icons.person_outline;
  }
}

class _PlayerStatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<GameCubit, GameState>(
      builder: (_, state) {
        final progress = state.progress;
        final streak = StreakTracker.calculateStreak(progress.playDates);
        final title = _PlayerTitle.getTitle(
          progress.levelsCleared,
          progress.bossesDefeated,
          progress.points,
        );
        final titleIcon = _PlayerTitle.getIcon(
          progress.levelsCleared,
          progress.bossesDefeated,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.15)),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Points
              _StatItem(
                icon: Icons.monetization_on_rounded,
                iconColor: scheme.secondary,
                value: '${progress.points}',
                label: 'Points',
                scheme: scheme,
              ),
              Container(
                width: 1,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: scheme.outline.withValues(alpha: 0.15),
              ),
              // Streak
              _StatItem(
                icon: Icons.local_fire_department_rounded,
                iconColor: const Color(0xFFF59E0B),
                value: '$streak',
                label: 'Day Streak',
                scheme: scheme,
              ),
              Container(
                width: 1,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: scheme.outline.withValues(alpha: 0.15),
              ),
              // Title
              Expanded(
                child: _StatItem(
                  icon: titleIcon,
                  iconColor: scheme.primary,
                  value: title,
                  label: 'Rank',
                  scheme: scheme,
                  isExpanded: true,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final ColorScheme scheme;
  final bool isExpanded;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.scheme,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: isExpanded ? MainAxisSize.min : MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const Gap(8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: scheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    return isExpanded ? content : content;
  }
}

class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.primary.withValues(alpha: 0.03),
            scheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                color: scheme.secondary,
                size: 18,
              ),
              const Gap(6),
              Text(
                'Problems Resolved',
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BlocBuilder<CounterCubit, int>(
                builder: (_, count) {
                  return Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                      height: 1,
                      letterSpacing: -2,
                    ),
                  );
                },
              ),
              const Gap(12),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.secondary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.celebration, size: 14, color: scheme.secondary),
                      const Gap(4),
                      Text(
                        'Great job!',
                        style: TextStyle(
                          color: scheme.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08);
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Gap(14),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CTAButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _CTAButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: isPrimary ? scheme.secondary : scheme.primary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              if (isPrimary)
                BoxShadow(
                  color: scheme.secondary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isPrimary ? scheme.onSecondary : scheme.onPrimary,
              ),
              const Gap(8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? scheme.onSecondary : scheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
