import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_complete_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/level_select_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/reward_spin_screen.dart';
import 'package:littletech/src/features/game/presentation/screens/suptech_dialog.dart';
import 'package:littletech/src/features/game/presentation/widgets/alt_solution_banner.dart';
import 'package:littletech/src/features/game/presentation/widgets/step_tile.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/presentation/widgets/sup_tech_avatar_wrapper.dart';
import 'package:littletech/src/features/game/presentation/widgets/visual_aid.dart';

class ProblemScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;
  final bool isReview;

  const ProblemScreen({
    super.key,
    required this.world,
    required this.level,
    this.isReview = false,
  });

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {
  bool _showingAltForStep = false;
  bool _navigatedToReward = false;
  bool _feedbackGiven = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isReview) {
      context.read<GameCubit>().selectLevel(widget.level);
    }
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
          final solvedCount = widget.isReview ? steps.length : state.currentStepIndex;
          final allSolved = solvedCount >= steps.length;
          final progress = steps.isNotEmpty ? solvedCount / steps.length : 0.0;

          if (allSolved && !widget.isReview && !_navigatedToReward) {
            _navigatedToReward = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                if (state.lastDrawnReward != null) {
                  Nav.pushReplacement(
                    context,
                    RewardSpinScreen(reward: state.lastDrawnReward!),
                  );
                } else {
                  Nav.pushReplacement(
                    context,
                    LevelCompleteScreen(
                      world: widget.world,
                      level: widget.level,
                      newAchievements: state.newlyUnlockedAchievements,
                      reward: null,
                    ),
                  );
                }
              }
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
              if (_showingAltForStep)
                AltSolutionBanner(
                  world: widget.world,
                  level: widget.level,
                  onTapAlternative: () {
                    setState(() => _showingAltForStep = false);
                    context.read<GameCubit>().resetSteps();
                  },
                ),
              if (!allSolved && solvedCount > 0 && !_showingAltForStep)
                Center(
                  child: TextButton.icon(
                    onPressed: () => setState(() => _showingAltForStep = true),
                    icon: Icon(Icons.replay, size: 16, color: Colors.orange.shade300),
                    label: Text(
                      'Not quite? Try alternative steps',
                      style: TextStyle(color: Colors.orange.shade300, fontSize: 12),
                    ),
                  ),
                ),
              if (allSolved && state.lastDrawnReward == null && !_showingAltForStep)
                AltSolutionBanner(
                  world: widget.world,
                  level: widget.level,
                  onTapAlternative: () => context.read<GameCubit>().resetSteps(),
                ),
              if (allSolved && !_feedbackGiven && !widget.isReview)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.help_outline, color: scheme.secondary, size: 20),
                      const Gap(10),
                      Expanded(
                        child: Text(
                          'Did this fix it?',
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<GameCubit>().saveFeedback(widget.level.id, true);
                          setState(() => _feedbackGiven = true);
                        },
                        icon: const Icon(Icons.thumb_up_outlined, color: Colors.green, size: 22),
                        tooltip: 'Yes, it worked',
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<GameCubit>().saveFeedback(widget.level.id, false);
                          setState(() => _feedbackGiven = true);
                        },
                        icon: const Icon(Icons.thumb_down_outlined, color: Colors.red, size: 22),
                        tooltip: "No, it didn't work",
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
              if (_feedbackGiven)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      Gap(8),
                      Text(
                        'Thanks for your feedback!',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(),
              const Gap(12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: steps.length,
                  itemBuilder: (_, i) {
                    return StepTile(
                      stepNumber: i + 1,
                      text: steps[i],
                      isCompleted: i < solvedCount,
                      imageUrl: i == solvedCount ? widget.level.imageUrl : null,
                    );
                  },
                ),
              ),
              if (widget.isReview)
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
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => Nav.pushReplacement(
                        context,
                        LevelSelectScreen(world: widget.world),
                      ),
                      icon: const Icon(Icons.arrow_back, size: 20),
                      label: const Text('Back to Worlds'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.secondary,
                        foregroundColor: scheme.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                )
              else
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: SupTechAvatarWrapper(
                          size: 44,
                          onTap: state.canUseSupTech
                              ? () => _showSupTechDialog(context)
                              : null,
                          child: SupTechAvatar(
                            size: 44,
                            skinId: state.progress.activeSkinId,
                          ),
                        ),
                      ),
                      const Gap(12),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: state.currentStepIndex < steps.length
                              ? () => context.read<GameCubit>().solveStep()
                              : null,
                          icon: const Icon(Icons.check_circle_outline, size: 20),
                          label: Text(
                            solvedCount >= steps.length
                                ? 'Completed!'
                                : 'Complete Quest Step ${solvedCount + 1}',
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