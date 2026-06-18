import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/reward_spin_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/suptech_dialog.dart';
import 'package:littletech/src/features/game/presentation/widgets/alt_solution_banner.dart';
import 'package:littletech/src/features/game/presentation/widgets/step_tile.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/presentation/widgets/visual_aid.dart';

class ProblemScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const ProblemScreen({super.key, required this.world, required this.level});

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GameCubit>().selectLevel(widget.level);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(widget.level.title),
        backgroundColor: Colors.transparent,
        actions: [
          BlocBuilder<GameCubit, GameState>(
            builder: (_, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, color: scheme.secondary, size: 16),
                    const Gap(4),
                    Text(
                      '${state.totalPoints}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: scheme.onSurface,
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
          if (state.currentLevel == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final steps = widget.level.steps;
          final solvedCount = state.currentStepIndex;
          final allSolved = solvedCount >= steps.length;
          final progress = steps.isNotEmpty ? solvedCount / steps.length : 0.0;

          if (allSolved && state.lastDrawnReward != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Nav.pushReplacement(
                context,
                RewardSpinScreen(reward: state.lastDrawnReward!),
              );
            });
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: scheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Step $solvedCount of ${steps.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: scheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${widget.level.points}pts on completion',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: scheme.outline.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(scheme.secondary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              if (state.hintText != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.tertiary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: scheme.tertiary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline, color: scheme.tertiary, size: 18),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          state.hintText!,
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.tertiary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideX(begin: -0.1),
              if (!allSolved)
                VisualAid(level: widget.level, stepIndex: solvedCount.clamp(0, widget.level.steps.length - 1)),
              if (allSolved && state.lastDrawnReward == null)
                AltSolutionBanner(world: widget.world, level: widget.level),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: steps.length,
                  itemBuilder: (_, i) {
                    return StepTile(
                      stepNumber: i + 1,
                      text: steps[i],
                      isCompleted: i < solvedCount,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SupTechAvatar(
                      availableUses: state.availableSupTechUses,
                      isGlowing: state.canUseSupTech,
                      size: 44,
                      onTap: state.canUseSupTech
                          ? () => _showSupTechDialog(context)
                          : null,
                    ),
                    const Gap(16),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: state.currentStepIndex < steps.length
                              ? () => context.read<GameCubit>().solveStep()
                              : null,
                          icon: const Icon(Icons.check_circle_outline, size: 20),
                          label: Text(
                            solvedCount >= steps.length
                                ? 'Completed!'
                                : 'Complete Quest Step $solvedCount',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSupTechDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const SupTechDialog(),
    );
  }
}
