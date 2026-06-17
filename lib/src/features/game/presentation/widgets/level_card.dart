import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

class LevelCard extends StatelessWidget {
  final LevelDef level;
  final bool isCompleted;
  final bool isLocked;
  final int completedSteps;
  final int totalSteps;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    this.isCompleted = false,
    this.isLocked = false,
    this.completedSteps = 0,
    this.totalSteps = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isLocked ? AppColors.surfaceVariant : AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isCompleted
                  ? AppColors.success.withValues(alpha: 0.4)
                  : isLocked
                      ? AppColors.border
                      : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withValues(alpha: 0.1)
                      : isLocked
                          ? Colors.grey.withValues(alpha: 0.1)
                          : AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : isLocked
                          ? Icons.lock_outline
                          : Icons.help_outline,
                  color: isCompleted
                      ? AppColors.success
                      : isLocked
                          ? Colors.grey
                          : AppColors.accent,
                  size: 22,
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isLocked ? Colors.grey : AppColors.onSurface,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      level.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isLocked
                            ? Colors.grey.withValues(alpha: 0.7)
                            : AppColors.onSurfaceMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${level.points}pts',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
              if (!isLocked) ...[
                const Gap(4),
                const Icon(Icons.chevron_right, color: AppColors.onSurfaceMuted, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
