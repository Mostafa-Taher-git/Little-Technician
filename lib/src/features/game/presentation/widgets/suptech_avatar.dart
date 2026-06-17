import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:littletech/src/core/constants/colors.dart';

class SupTechAvatar extends StatelessWidget {
  final int availableUses;
  final bool isGlowing;
  final double size;
  final VoidCallback? onTap;

  const SupTechAvatar({
    super.key,
    this.availableUses = 0,
    this.isGlowing = false,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: isGlowing
            ? const LinearGradient(
                colors: [AppColors.accent, Colors.cyan, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppColors.darkGradient,
        borderRadius: BorderRadius.circular(size / 3),
        boxShadow: isGlowing
            ? [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            '🤖',
            style: TextStyle(fontSize: size * 0.45),
          ),
          if (isGlowing)
            ...List.generate(6, (i) {
              final angle = i * (pi * 2 / 6);
              return Positioned(
                left: size * 0.4 + sin(angle) * size * 0.3,
                top: size * 0.4 + cos(angle) * size * 0.3,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.8),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            }),
          if (availableUses > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$availableUses',
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onAccent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    final animated = isGlowing
        ? avatar
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 1500.ms, color: Colors.white.withValues(alpha: 0.2))
            .then()
            .animate()
            .scale(duration: 2000.ms, begin: const Offset(1, 1), end: const Offset(1.08, 1.08))
        : avatar;

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: animated);
    }
    return animated;
  }
}
