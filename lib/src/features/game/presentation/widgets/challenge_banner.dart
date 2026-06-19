import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/challenges.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

class ChallengeBanner extends StatelessWidget {
  final VoidCallback onDailyTap;
  final VoidCallback onWeeklyTap;

  const ChallengeBanner({
    super.key,
    required this.onDailyTap,
    required this.onWeeklyTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final daily = ChallengeManager.getDailyChallenge();
    final weekly = ChallengeManager.getWeeklyBoss();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Daily challenge
          _ChallengeRow(
            icon: Icons.wb_sunny_rounded,
            iconColor: const Color(0xFFF59E0B),
            iconBgColor: const Color(0xFFF59E0B).withValues(alpha: 0.12),
            title: daily.title,
            subtitle: '+${daily.bonusPoints} pts bonus',
            subtitleColor: const Color(0xFFF59E0B),
            onTap: onDailyTap,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 1,
            color: scheme.outline.withValues(alpha: 0.1),
          ),
          // Weekly challenge
          _ChallengeRow(
            icon: Icons.calendar_month_rounded,
            iconColor: const Color(0xFFEF4444),
            iconBgColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
            title: 'Weekly Raid: ${GameData.worlds[weekly.worldIndex].name}',
            subtitle: '+${weekly.bonusPoints} pts • ${weekly.specialRule}',
            subtitleColor: scheme.onSurface.withValues(alpha: 0.5),
            onTap: onWeeklyTap,
          ),
        ],
      ),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final VoidCallback onTap;

  const _ChallengeRow({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: scheme.onSurface.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
