import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';

class FramedUsername extends StatelessWidget {
  final String username;
  final double fontSize;
  final Color fontColor;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  const FramedUsername({
    super.key,
    required this.username,
    this.fontSize = 16,
    this.fontColor = Colors.white,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.w700,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (_, state) {
        final progress = state.progress;
        final activeFrame = progress.activeFrameId != null
            ? RewardPool.byId(progress.activeFrameId!)
            : null;
        final activeIcon = progress.activeIconId != null
            ? RewardPool.byId(progress.activeIconId!)
            : null;
        final activeTitle = progress.activeTitleId != null
            ? RewardPool.byId(progress.activeTitleId!)
            : null;

        final usernameText = Text(
          username,
          textAlign: textAlign,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        );

        final hasBadge = activeIcon != null || activeTitle != null;
        final badgeColor = activeFrame?.color ?? Colors.white54;

        if (activeFrame == null && !hasBadge) return usernameText;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                badgeColor.withValues(alpha: 0.3),
                badgeColor.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: badgeColor.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Column(
            crossAxisAlignment: textAlign == TextAlign.center
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              usernameText,
              if (hasBadge) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (activeIcon != null)
                      Text(
                        activeIcon.value,
                        style: TextStyle(
                          fontSize: fontSize * 0.75,
                          color: badgeColor,
                        ),
                      ),
                    if (activeIcon != null && activeTitle != null)
                      const SizedBox(width: 4),
                    if (activeTitle != null)
                      Text(
                        activeTitle.value,
                        style: TextStyle(
                          fontSize: fontSize * 0.65,
                          color: badgeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
