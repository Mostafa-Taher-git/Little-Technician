import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';

class SupTechBadge extends StatelessWidget {
  final double size;
  final bool isGlowing;

  const SupTechBadge({
    super.key,
    this.size = 40,
    this.isGlowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (_, state) {
        return SupTechAvatar(
          isGlowing: isGlowing,
          size: size,
          skinId: state.progress.activeSkinId,
        );
      },
    );
  }
}
