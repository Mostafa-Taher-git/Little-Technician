import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_select_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/presentation/widgets/world_card.dart';

class WorldSelectScreen extends StatelessWidget {
  const WorldSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Troubleshooting Worlds'),
        actions: [
          BlocBuilder<GameCubit, GameState>(
            builder: (_, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, color: AppColors.accent, size: 18),
                    const Gap(4),
                    Text(
                      '${state.totalPoints}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Gap(8),
                    SupTechAvatar(
                      availableUses: state.availableSupTechUses,
                      isGlowing: state.canUseSupTech,
                      size: 34,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (_, state) {
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: GameData.worlds.length,
            itemBuilder: (_, index) {
              final world = GameData.worlds[index];
              final completed = world.levels
                  .where((l) =>
                      state.progress.completedLevelIds.contains(l.id))
                  .length;
              final isUnlocked = index == 0 ||
                  GameData.worlds[index - 1].levels
                      .every((l) =>
                          state.progress.completedLevelIds.contains(l.id));
              return WorldCard(
                world: world,
                completedLevels: completed,
                totalLevels: world.levels.length,
                isLocked: !isUnlocked,
                onTap: () {
                  context.read<GameCubit>().selectWorld(world);
                  Nav.push(context, LevelSelectScreen(world: world));
                },
              );
            },
          );
        },
      ),
    );
  }
}
