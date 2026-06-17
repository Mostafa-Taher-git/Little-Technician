import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';

class RewardChip extends StatelessWidget {
  final RewardDef reward;

  const RewardChip({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: reward.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: reward.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(reward.icon, size: 16, color: reward.color),
          const Gap(6),
          Text(
            reward.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: reward.color,
            ),
          ),
        ],
      ),
    );
  }
}
