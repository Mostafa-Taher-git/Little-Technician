import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
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
    final scheme = Theme.of(context).colorScheme;
    final progress = totalLevels > 0 ? completedLevels / totalLevels : 0.0;

    return Material(
      color: isLocked
          ? scheme.surface.withValues(alpha: 0.5)
          : scheme.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isLocked
                  ? scheme.outline.withValues(alpha: 0.15)
                  : scheme.secondary.withValues(alpha: 0.3),
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
                          : scheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      world.icon,
                      color: isLocked
                          ? Colors.grey
                          : scheme.secondary,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  if (isLocked)
                    Icon(Icons.lock_outline,
                        color: scheme.onSurface.withValues(alpha: 0.2), size: 20),
                ],
              ),
              const Gap(16),
              Text(
                world.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isLocked
                      ? scheme.onSurface.withValues(alpha: 0.3)
                      : scheme.onSurface,
                ),
              ),
              const Gap(4),
              Text(
                world.description,
                style: TextStyle(
                  fontSize: 12,
                  color: isLocked
                      ? scheme.onSurface.withValues(alpha: 0.2)
                      : scheme.onSurface.withValues(alpha: 0.5),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Gap(16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: scheme.outline.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isLocked
                        ? Colors.grey
                        : scheme.secondary,
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
                  color: isLocked
                      ? scheme.onSurface.withValues(alpha: 0.2)
                      : scheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}
