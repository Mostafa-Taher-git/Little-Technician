import 'package:flutter/material.dart';

class SupTechAvatarWrapper extends StatelessWidget {
  final bool isGlowing;
  final double size;
  final VoidCallback? onTap;
  final Widget child;

  const SupTechAvatarWrapper({
    super.key,
    required this.isGlowing,
    required this.size,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final wrapper = Container(
      padding: const EdgeInsets.all(6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isGlowing
            ? scheme.secondary.withValues(alpha: 0.1)
            : scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGlowing
              ? scheme.secondary.withValues(alpha: 0.3)
              : scheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: wrapper);
    }
    return wrapper;
  }
}
