import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
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

  Future<String> get _deviceFilterKey async {
    final uid = await AuthService.getCurrentUserId();
    return uid != null ? 'device_filter_$uid' : 'device_filter';
  }

  Future<void> _loadDeviceFilter() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _deviceFilterKey;
    final saved = prefs.getString(key);
    if (saved != null && mounted) {
      setState(() => _selectedDeviceId = saved);
    }
  }

  Future<void> _setDeviceFilter(String? deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _deviceFilterKey;
    if (deviceId == null) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, deviceId);
    }
  }

  List<WorldDef> get _filteredWorlds {
    if (_selectedDeviceId == null) return GameData.worlds;
    return GameData.worlds.where((w) {
      final cat = CategoryManager.byId(w.id);
      return cat != null && cat.deviceTypes.contains(_selectedDeviceId);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final worlds = _filteredWorlds;
    final isFiltered = _selectedDeviceId != null;

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
                    SupTechAvatar(
                      availableUses: state.availableSupTechUses,
                      isGlowing: state.canUseSupTech,
                      size: 30,
                    ),
                    const Gap(2),
                    IconButton(
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      icon: Icon(
                        Icons.devices,
                        color: isFiltered ? scheme.secondary : scheme.onSurface.withValues(alpha: 0.6),
                        size: 18,
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
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
              final worldIndex = GameData.worlds.indexWhere((w) => w.id == world.id);
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
