import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_select_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/presentation/widgets/sup_tech_avatar_wrapper.dart';
import 'package:littletech/src/features/game/presentation/widgets/world_card.dart';

class WorldSelectScreen extends StatelessWidget {
  const WorldSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Dungeon Map'),
        backgroundColor: Colors.transparent,
        actions: [
          BlocBuilder<GameCubit, GameState>(
            builder: (_, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, color: scheme.secondary, size: 16),
                    const Gap(2),
                    Flexible(
                      child: Text(
                        '${state.totalPoints}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: scheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(6),
                    SupTechAvatarWrapper(
                      size: 30,
                      child: SupTechAvatar(
                        size: 30,
                        skinId: state.progress.activeSkinId,
                      ),
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
          final worlds = GameData.worlds;

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: worlds.length,
            itemBuilder: (_, index) {
              final world = worlds[index];
              final completed = world.levels
                  .where((l) => state.progress.completedLevelIds.contains(l.id))
                  .length;
              final worldIndex = GameData.worlds.indexWhere((w) => w.id == world.id);
              final prevWorld = worldIndex > 0 ? GameData.worlds[worldIndex - 1] : null;
              final isUnlocked = prevWorld == null ||
                  prevWorld.levels
                      .where((l) => state.progress.completedLevelIds.contains(l.id))
                      .length >=
                      (prevWorld.levels.length * 0.5).ceil();

              final cat = CategoryManager.byId(world.id);
              final bosses = cat?.bosses ?? [];
              final totalBosses = bosses.length;
              final defeatedCount = bosses
                  .where((b) => state.progress.defeatedBossIds.contains(b.id))
                  .length;
              final bossVisualType = bosses.isNotEmpty ? bosses.first.visualType : 1;

              return WorldCard(
                world: world,
                completedLevels: completed,
                totalLevels: world.levels.length,
                isLocked: !isUnlocked,
                bossesDefeated: defeatedCount,
                totalBosses: totalBosses,
                bossVisualType: bossVisualType,
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
