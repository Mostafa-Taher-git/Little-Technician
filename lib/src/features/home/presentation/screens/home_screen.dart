import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
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
                                color: AppColors.surfaceVariant,
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
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                                ),
                                const Text('Ready to troubleshoot?', style: TextStyle(color: AppColors.onSurfaceMuted, fontSize: 13)),
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
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.bookmark_outline, size: 20, color: AppColors.onSurface),
                    ),
                  ),
                  const Gap(8),
                  IconButton(
                    onPressed: () => Nav.push(context, const SettingsScreen()),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.settings_outlined, size: 20, color: AppColors.onSurface),
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
                  gradient: AppColors.darkGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Problems Resolved', style: TextStyle(color: Colors.white60, fontSize: 13, letterSpacing: 0.5)),
                    const Gap(8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BlocBuilder<CounterCubit, int>(
                          builder: (_, count) {
                            return Text(
                              '$count',
                              style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white, height: 1),
                            );
                          },
                        ),
                        const Gap(8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('🎉 Great job!', style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
              const Gap(28),

              // Quick actions
              const Text('Quick Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.grid_view_rounded,
                      label: 'Categories',
                      color: AppColors.primary,
                      onTap: () => Nav.push(context, const CategoriesScreen()),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.search_rounded,
                      label: 'Search Problems',
                      color: AppColors.accent,
                      onTap: () => Nav.push(context, const SearchScreen()),
                    ),
                  ),
                ],
              ),
              const Gap(28),

              // Browse categories preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Browse Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface)),
                  TextButton(
                    onPressed: () => Nav.push(context, const CategoriesScreen()),
                    child: const Text('See All', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600)),
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
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.black,
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(c['icon'] as IconData, color: AppColors.primary, size: 20),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.onSurface)),
                  Text('${c['count']} solutions', style: const TextStyle(color: AppColors.onSurfaceMuted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceMuted, size: 20),
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

  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
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
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.onSurface)),
            ],
          ),
        ),
      ),
    );
  }
}
