import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class DeviceType {
  final String id;
  final String name;
  final IconData icon;

  const DeviceType({required this.id, required this.name, required this.icon});
}

class DeviceSelector extends StatelessWidget {
  final void Function(DeviceType device)? onSelected;

  const DeviceSelector({super.key, this.onSelected});

  static const List<DeviceType> devices = [
    DeviceType(id: 'desktop', name: 'Desktop', icon: Icons.desktop_windows),
    DeviceType(id: 'laptop', name: 'Laptop', icon: Icons.laptop),
    DeviceType(id: 'phone', name: 'Phone', icon: Icons.phone_android),
    DeviceType(id: 'tablet', name: 'Tablet', icon: Icons.tablet),
    DeviceType(id: 'printer', name: 'Printer', icon: Icons.print),
    DeviceType(id: 'router', name: 'Router', icon: Icons.router),
    DeviceType(id: 'smart_tv', name: 'Smart TV', icon: Icons.tv),
    DeviceType(id: 'console', name: 'Console', icon: Icons.sports_esports),
  ];

  static void show(BuildContext context, {void Function(DeviceType)? onSelected}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DeviceSelector(onSelected: onSelected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(16),
          Text(
            'Select Device Type',
            style: TextStyle(
              color: scheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: devices.length,
            itemBuilder: (_, i) {
              final device = devices[i];
              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onSelected?.call(device);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(device.icon, color: scheme.secondary, size: 28),
                        const Gap(6),
                        Text(
                          device.name,
                          style: TextStyle(
                            color: scheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: (50 * i).ms).slideY(begin: 0.1);
            },
          ),
        ],
      ),
    );
  }
}
