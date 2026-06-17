import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_select_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';

class LevelCompleteScreen extends StatelessWidget {
  final WorldDef world;
  final LevelDef level;

  const LevelCompleteScreen({
    super.key,
    required this.world,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1A0A),
      body: SafeArea(
        child: BlocBuilder<GameCubit, GameState>(
          builder: (_, state) {
            return Column(
              children: [
                const Spacer(),
                const Icon(
                  Icons.celebration_outlined,
                  size: 80,
                  color: Color(0xFFF59E0B),
                ).animate().scale(
                  begin: const Offset(0, 0),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),
                const Gap(24),
                const Text(
                  'LEVEL COMPLETE!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const Gap(8),
                Text(
                  level.title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                ).animate().fadeIn(delay: 500.ms),
                const Gap(40),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    children: [
                      _PointRow(
                        label: 'Step points',
                        points: 10 * level.steps.length,
                        accentColor: scheme.secondary,
                      ),
                      _PointRow(
                        label: 'Level clear bonus',
                        points: level.points,
                        accentColor: scheme.secondary,
                      ),
                      const Divider(color: Colors.white12, height: 24),
                      _PointRow(
                        label: 'Total earned',
                        points: 10 * level.steps.length + level.points,
                        isTotal: true,
                        accentColor: scheme.secondary,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
                const Gap(32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SupTechAvatar(
                      availableUses: state.availableSupTechUses,
                      isGlowing: state.canUseSupTech,
                      size: 36,
                    ),
                    const Gap(10),
                    Text(
                      'SupTech uses remaining: ${state.availableSupTechUses}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Nav.pushReplacement(
                          context,
                          LevelSelectScreen(world: world),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward, size: 20),
                      label: const Text(
                        'Next Level',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PointRow extends StatelessWidget {
  final String label;
  final int points;
  final bool isTotal;
  final Color accentColor;

  const _PointRow({
    required this.label,
    required this.points,
    this.isTotal = false,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal
                  ? accentColor
                  : Colors.white.withValues(alpha: 0.7),
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          const Spacer(),
          Text(
            '+$points',
            style: TextStyle(
              color: isTotal ? accentColor : Colors.white,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              fontSize: isTotal ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
