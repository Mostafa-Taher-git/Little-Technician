import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

class VisualAid extends StatelessWidget {
  final LevelDef level;
  final int stepIndex;

  const VisualAid({super.key, required this.level, required this.stepIndex});

  static const _stepIcons = {
    'cpu_high_usage': [
      Icons.keyboard,
      Icons.sort,
      Icons.security,
      Icons.settings,
      Icons.system_update,
    ],
    'no_internet': [
      Icons.power_settings_new,
      Icons.devices,
      Icons.wifi_find,
      Icons.terminal,
      Icons.phone_callback,
    ],
    'bsod': [
      Icons.info,
      Icons.security,
      Icons.terminal,
      Icons.memory,
      Icons.build,
    ],
  };

  IconData get _icon {
    final icons = _stepIcons[level.id];
    if (icons != null && stepIndex < icons.length) return icons[stepIndex];
    return Icons.tips_and_updates;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_icon, color: scheme.secondary, size: 24),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${stepIndex + 1} Visual Guide',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Look for ${_iconName(_icon)} icon or option',
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _iconName(IconData icon) {
    if (icon == Icons.keyboard) return 'Ctrl+Shift+Esc';
    if (icon == Icons.terminal) return 'Command Prompt';
    if (icon == Icons.security) return 'Windows Defender';
    if (icon == Icons.settings) return 'Settings app';
    if (icon == Icons.memory) return 'RAM/System info';
    if (icon == Icons.wifi_find) return 'Network settings';
    return 'the relevant';
  }
}
