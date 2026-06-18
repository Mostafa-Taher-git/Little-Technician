import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_select_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/presentation/widgets/device_selector.dart';
import 'package:littletech/src/features/game/presentation/widgets/world_card.dart';

class WorldSelectScreen extends StatefulWidget {
  const WorldSelectScreen({super.key});

  @override
  State<WorldSelectScreen> createState() => _WorldSelectScreenState();
}

class _WorldSelectScreenState extends State<WorldSelectScreen> {
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    _loadDeviceFilter();
  }

  Future<void> _loadDeviceFilter() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('device_filter');
    if (saved != null && mounted) {
      setState(() => _selectedDeviceId = saved);
    }
  }

  Future<void> _setDeviceFilter(String? deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    if (deviceId == null) {
      await prefs.remove('device_filter');
    } else {
      await prefs.setString('device_filter', deviceId);
    }
  }

  static const _deviceWorldFilter = <String, Set<String>>{
    'desktop': {'Core Components', 'Operating System', 'Software & Network', 'Storage & Display'},
    'laptop': {'Core Components', 'Operating System', 'Software & Network', 'Storage & Display'},
    'phone': {'Mobile Troubleshooting'},
    'tablet': {'Mobile Troubleshooting'},
    'printer': {'Peripherals'},
    'router': {'Software & Network'},
    'smart_tv': {'Gaming Rig', 'Storage & Display'},
    'console': {'Gaming Rig'},
  };

  List<WorldDef> get _filteredWorlds {
    if (_selectedDeviceId == null) return GameData.worlds;
    final allowed = _deviceWorldFilter[_selectedDeviceId];
    if (allowed == null) return GameData.worlds;
    return GameData.worlds.where((w) => allowed.contains(w.name)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final worlds = _filteredWorlds;
    final isFiltered = _selectedDeviceId != null;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Campaign Map'),
        backgroundColor: Colors.transparent,
        actions: [
          BlocBuilder<GameCubit, GameState>(
            builder: (_, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, color: scheme.secondary, size: 18),
                    const Gap(4),
                    Text(
                      '${state.totalPoints}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: scheme.onSurface,
                      ),
                    ),
                    const Gap(8),
                    SupTechAvatar(
                      availableUses: state.availableSupTechUses,
                      isGlowing: state.canUseSupTech,
                      size: 34,
                    ),
                    const Gap(4),
                    IconButton(
                      icon: Icon(
                        Icons.devices,
                        color: isFiltered ? scheme.secondary : scheme.onSurface.withValues(alpha: 0.6),
                        size: 20,
                      ),
                      onPressed: () => DeviceSelector.show(context, onSelected: (device) {
                        final newId = _selectedDeviceId == device.id ? null : device.id;
                        setState(() => _selectedDeviceId = newId);
                        _setDeviceFilter(newId);
                      }),
                      tooltip: 'Filter by device',
                    ),
                    if (isFiltered)
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedDeviceId = null);
                          _setDeviceFilter(null);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: scheme.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'clear',
                            style: TextStyle(
                              color: scheme.secondary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
          if (worlds.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.devices_other, size: 48, color: scheme.onSurface.withValues(alpha: 0.3)),
                  const Gap(12),
                  Text(
                    'No worlds match this device',
                    style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5), fontSize: 15),
                  ),
                  const Gap(4),
                  TextButton(
                    onPressed: () => setState(() => _selectedDeviceId = null),
                    child: const Text('Show all worlds'),
                  ),
                ],
              ),
            );
          }
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
              final worldIndex = GameData.worlds.indexOf(world);
              final isUnlocked = worldIndex == 0 ||
                  GameData.worlds[worldIndex - 1].levels
                      .every((l) => state.progress.completedLevelIds.contains(l.id));
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
