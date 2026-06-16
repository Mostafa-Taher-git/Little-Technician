import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/services/rule_engine.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'package:littletech/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:littletech/src/features/solutions/data/models/problem_solution_model.dart';
import 'package:littletech/src/features/solutions/data/models/saved_solution_model.dart';
import 'package:littletech/src/features/solutions/data/services/saved_solutions_service.dart';

class SolutionDetailScreen extends StatefulWidget {
  final String problemName;
  final String categoryName;

  const SolutionDetailScreen({super.key, required this.problemName, required this.categoryName});

  @override
  State<SolutionDetailScreen> createState() => _SolutionDetailScreenState();
}

class _SolutionDetailScreenState extends State<SolutionDetailScreen> {
  ProblemSolution? _solution;
  bool _isSaved = false;
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _solution = RuleEngine.solve(widget.problemName);
    _checkSaved();
  }

  Future<void> _checkSaved() async {
    final saved = await SavedSolutionsService.isSaved(widget.problemName);
    if (mounted) setState(() => _isSaved = saved);
  }

  Future<void> _toggleSave() async {
    if (_solution == null) return;
    if (_isSaved) {
      showSuccessToast(context, 'Already saved.');
      return;
    }
    await SavedSolutionsService.save(SavedSolution(
      problemTitle: widget.problemName,
      category: widget.categoryName,
      steps: _solution!.steps,
      savedAt: DateTime.now(),
    ));
    if (mounted) showSuccessToast(context, 'Solution saved!');
    _checkSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.problemName, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: _toggleSave,
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_outline,
              color: _isSaved ? AppColors.accent : AppColors.onSurfaceMuted,
            ),
          ),
        ],
      ),
      body: _solution == null
          ? const EmptyState(
              icon: Icons.search_off,
              title: 'No Solution Found',
              subtitle: 'We couldn\'t find a solution for this problem yet. Try searching with different keywords.',
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Problem title card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.darkGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(widget.categoryName, style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                      const Gap(10),
                      Text(
                        _solution!.problem,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const Gap(24),

                // Steps header
                const Text(
                  'Solution Steps',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.onSurface),
                ),
                const Gap(14),

                // Solution steps
                ..._solution!.steps.asMap().entries.map((e) {
                  return SolutionStepCard(
                    stepNumber: e.key + 1,
                    text: e.value,
                  ).animate(delay: Duration(milliseconds: 100 * e.key)).fadeIn().slideX(begin: 0.05);
                }),
                const Gap(28),

                // Did this help?
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Did this solve your problem?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isSolved
                                  ? null
                                  : () {
                                      setState(() => _isSolved = true);
                                      context.read<CounterCubit>().increment();
                                      showSuccessToast(context, 'Great! Problem solved.');
                                    },
                              icon: Icon(_isSolved ? Icons.check_circle : Icons.check_circle_outline, size: 18),
                              label: Text(_isSolved ? 'Solved!' : 'Yes, Fixed'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.success,
                                side: BorderSide(color: _isSolved ? AppColors.success : AppColors.border),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.cancel_outlined, size: 18),
                              label: const Text('Not Yet'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.onSurfaceMuted,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(24),
              ],
            ),
    );
  }
}
