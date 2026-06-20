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

        final text = Text(
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

        if (activeFrame == null) return text;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                activeFrame.color.withValues(alpha: 0.3),
                activeFrame.color.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: activeFrame.color.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: text,
        );
      },
    );
  }
}
