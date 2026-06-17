import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StepTile extends StatelessWidget {
  final int stepNumber;
  final String text;
  final bool isCompleted;

  const StepTile({
    super.key,
    required this.stepNumber,
    required this.text,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCompleted
              ? scheme.secondary.withValues(alpha: 0.3)
              : scheme.outline.withValues(alpha: 0.3),
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
                  ? scheme.secondary
                  : scheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isCompleted
                ? Icon(Icons.check, color: scheme.onSecondary, size: 16)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      color: scheme.onPrimary,
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
                  color: scheme.onSurface.withValues(alpha: isCompleted ? 0.6 : 1.0),
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
