import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/auth/data/models/user_model.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/solutions/presentation/screens/saved_solutions_screen.dart';
import 'package:littletech/src/features/solutions/presentation/screens/categories_screen.dart';
import 'package:littletech/src/features/solutions/presentation/screens/search_screen.dart';
import 'package:littletech/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:littletech/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/world_select_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/profile_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: FutureBuilder<UserModel?>(
                      future: AuthService.getCurrentUser(),
                      builder: (_, snap) {
                        final user = snap.data;
                        return Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: scheme.surface,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(user?.avatarIcon ?? '🔧', style: const TextStyle(fontSize: 24)),
                            ),
                            const Gap(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${user?.username ?? 'User'}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurface),
                                ),
                                Text('Ready to troubleshoot?', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 13)),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  BlocBuilder<GameCubit, GameState>(
                    builder: (_, state) {
                      return GestureDetector(
                        onTap: () => Nav.push(context, const ProfileScreen()),
                        child: SupTechAvatar(
                          availableUses: state.availableSupTechUses,
                          isGlowing: state.canUseSupTech,
                          size: 36,
                        ),
                      );
                    },
                  ),
                  const Gap(8),
                  IconButton(
                    onPressed: () => Nav.push(context, const SavedSolutionsScreen()),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.outline),
                      ),
                      child: Icon(Icons.bookmark_outline, size: 20, color: scheme.onSurface),
                    ),
                  ),
                  const Gap(8),
                  IconButton(
                    onPressed: () => Nav.push(context, const SettingsScreen()),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.outline),
                      ),
                      child: Icon(Icons.settings_outlined, size: 20, color: scheme.onSurface),
                    ),
                  ),
                ],
              ),
              const Gap(28),

              // Stats card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.surface.withValues(alpha: 0.5),
                      scheme.surface.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Problems Resolved', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.8), fontSize: 13, letterSpacing: 0.5)),
                    const Gap(8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BlocBuilder<CounterCubit, int>(
                          builder: (_, count) {
                            return Text(
                              '$count',
                              style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: scheme.onSurface, height: 1),
                            );
                          },
                        ),
                        const Gap(8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: scheme.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('🎉 Great job!', style: TextStyle(color: scheme.secondary, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
              const Gap(28),

              // Quick actions
              Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.onSurface)),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.grid_view_rounded,
                      label: 'Categories',
                      color: scheme.primary,
                      onTap: () => Nav.push(context, const CategoriesScreen()),
                      scheme: scheme,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.search_rounded,
                      label: 'Search Problems',
                      color: scheme.secondary,
                      onTap: () => Nav.push(context, const SearchScreen()),
                      scheme: scheme,
                    ),
                  ),
                ],
              ),
              const Gap(28),

              // Browse categories preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Browse Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                  TextButton(
                    onPressed: () => Nav.push(context, const CategoriesScreen()),
                    child: Text('See All', style: TextStyle(color: scheme.secondary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const Gap(12),
              // Show first 4 categories as preview
              ..._buildCategoryPreview(context),
              const Gap(12),

              // CTA
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Nav.push(context, const CategoriesScreen()),
                      icon: const Icon(Icons.search_rounded, size: 18),
                      label: const Text('Browse Solutions'),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: BlocBuilder<GameCubit, GameState>(
                      builder: (_, state) {
                        return ElevatedButton.icon(
                          onPressed: () {
                            context.read<GameCubit>().loadGame();
                            Nav.push(context, const WorldSelectScreen());
                          },
                          icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                          label: const Text('Play Troubleshooting'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: scheme.secondary,
                            foregroundColor: scheme.onSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCategoryPreview(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final previewCategories = [
      {'name': 'CPU', 'icon': Icons.memory, 'count': '6'},
      {'name': 'Internet', 'icon': Icons.wifi, 'count': '5'},
      {'name': 'Display', 'icon': Icons.monitor, 'count': '5'},
    ];

    return previewCategories.map((c) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outline),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(c['icon'] as IconData, color: scheme.primary, size: 20),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['name'] as String, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: scheme.onSurface)),
                  Text('${c['count']} solutions', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.onSurface.withValues(alpha: 0.6), size: 20),
          ],
        ),
      );
    }).toList();
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final ColorScheme scheme;

  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outline),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Gap(12),
              Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: scheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }
}