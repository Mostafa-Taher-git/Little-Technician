import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_select_screen.dart';

class ReviewScreen extends StatelessWidget {
  final WorldDef world;
  final LevelDef level;

  const ReviewScreen({super.key, required this.world, required this.level});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Review'),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (_, state) {
          final raw = state.progress.getPrepResult(level.id);
          Map<String, dynamic> prepData;
          if (raw != null) {
            try {
              prepData = json.decode(raw) as Map<String, dynamic>;
            } catch (_) {
              prepData = <String, dynamic>{};
            }
          } else {
            prepData = <String, dynamic>{};
          }
          final quiz = prepData['quiz'] as Map<String, dynamic>?;
          final ordering = prepData['ordering'] as Map<String, dynamic>?;
          final traps = prepData['traps'] as Map<String, dynamic>?;
          final stepPoints = 10 * level.steps.length;
          final levelPoints = level.points;
          final total = stepPoints + levelPoints;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [scheme.primary, scheme.primary.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      world.name.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      level.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              if (quiz != null || ordering != null || traps != null) ...[
                Text(
                  'Preparation Results',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const Gap(12),
                if (quiz != null)
                  _PrepResultCard(
                    title: 'Sage\'s Trial',
                    icon: Icons.quiz_outlined,
                    color: scheme.secondary,
                    lines: [
                      '${quiz['correct']}/${quiz['total']} correct',
                      '${quiz['hearts']}/3 lives remaining',
                    ],
                    passed: (quiz['correct'] as int) >= (quiz['total'] as int) ~/ 2 + 1,
                    scheme: scheme,
                  ),
                if (ordering != null) ...[
                  const Gap(8),
                  _PrepResultCard(
                    title: 'Rite of Order',
                    icon: Icons.swap_vert,
                    color: scheme.tertiary,
                    lines: [
                      '${ordering['attempts']} attempt${ordering['attempts'] == 1 ? '' : 's'}',
                    ],
                    passed: ordering['passed'] as bool,
                    scheme: scheme,
                  ),
                ],
                if (traps != null) ...[
                  const Gap(8),
                  _PrepResultCard(
                    title: 'Detect Deception',
                    icon: Icons.psychology_outlined,
                    color: Colors.orange,
                    lines: [
                      '${traps['correct']}/${traps['total']} correct',
                    ],
                    passed: traps['passed'] as bool,
                    scheme: scheme,
                  ),
                ],
                const Gap(24),
              ],
              Text(
                'Solution Steps',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const Gap(12),
              ...level.steps.asMap().entries.map((entry) {
                final i = entry.key;
                final step = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Step ${i + 1}',
                              style: TextStyle(
                                color: Colors.green.shade300,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              step,
                              style: TextStyle(
                                color: scheme.onSurface,
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const Gap(24),
              Text(
                'Points Earned',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const Gap(12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    _PointRow(label: 'Step points', points: stepPoints, accentColor: scheme.secondary, scheme: scheme),
                    const Divider(height: 20),
                    _PointRow(label: 'Level bonus', points: levelPoints, accentColor: scheme.secondary, scheme: scheme),
                    const Divider(height: 20),
                    _PointRow(label: 'Total', points: total, isTotal: true, accentColor: scheme.secondary, scheme: scheme),
                  ],
                ),
              ),
              const Gap(32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Nav.pushReplacement(
                    context,
                    LevelSelectScreen(world: world),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  label: const Text(
                    'Back to Dungeon Map',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.secondary,
                    foregroundColor: scheme.onSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const Gap(16),
            ],
          );
        },
      ),
    );
  }
}

class _PrepResultCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> lines;
  final bool passed;
  final ColorScheme scheme;

  const _PrepResultCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.lines,
    required this.passed,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: passed ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                ...lines.map((l) => Text(
                  l,
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                )),
              ],
            ),
          ),
          Icon(
            passed ? Icons.check_circle : Icons.cancel,
            color: passed ? Colors.green : Colors.red,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class _PointRow extends StatelessWidget {
  final String label;
  final int points;
  final bool isTotal;
  final Color accentColor;
  final ColorScheme scheme;

  const _PointRow({
    required this.label,
    required this.points,
    this.isTotal = false,
    required this.accentColor,
    required this.scheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? accentColor : scheme.onSurface.withValues(alpha: 0.7),
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          const Spacer(),
          Text(
            '+$points',
            style: TextStyle(
              color: isTotal ? accentColor : scheme.onSurface,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              fontSize: isTotal ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
