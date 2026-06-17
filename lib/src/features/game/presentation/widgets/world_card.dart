import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

class WorldCard extends StatelessWidget {
  final WorldDef world;
  final int completedLevels;
  final int totalLevels;
  final bool isLocked;
  final VoidCallback onTap;

  const WorldCard({
    super.key,
    required this.world,
    required this.completedLevels,
    required this.totalLevels,
    this.isLocked = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalLevels > 0 ? completedLevels / totalLevels : 0.0;

    return Material(
      color: isLocked ? AppColors.surfaceVariant : AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isLocked ? AppColors.border : AppColors.accent.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isLocked
                          ? Colors.grey.withValues(alpha: 0.1)
                          : AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      world.icon,
                      color: isLocked ? Colors.grey : AppColors.accent,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  if (isLocked)
                    const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
                ],
              ),
              const Gap(16),
              Text(
                world.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isLocked ? Colors.grey : AppColors.onSurface,
                ),
              ),
              const Gap(4),
              Text(
                world.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceMuted,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isLocked ? Colors.grey : AppColors.accent,
                  ),
                  minHeight: 6,
                ),
              ),
              const Gap(6),
              Text(
                '$completedLevels / $totalLevels',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isLocked ? Colors.grey : AppColors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}
