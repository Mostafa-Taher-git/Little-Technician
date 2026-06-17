import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';

class StepTile extends StatelessWidget {
  final int stepNumber;
  final String text;
  final bool isCompleted;
  final bool isSupTechUsed;

  const StepTile({
    super.key,
    required this.stepNumber,
    required this.text,
    this.isCompleted = false,
    this.isSupTechUsed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success.withValues(alpha: 0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.success
                  : AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
          ),
          const Gap(12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isCompleted
                      ? AppColors.onSurfaceMuted
                      : AppColors.onSurface,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isSupTechUsed)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'SupTech',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
