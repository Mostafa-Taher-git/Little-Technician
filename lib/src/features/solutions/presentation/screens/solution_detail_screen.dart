import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/services/rule_engine.dart';
import 'package:littletech/src/core/widgets/app_widgets.dart';
import 'package:littletech/src/features/home/presentation/bloc/counter_cubit.dart';
import 'package:littletech/src/features/solutions/data/models/problem_solution_model.dart';
import 'package:littletech/src/features/solutions/data/models/saved_solution_model.dart';
import 'package:littletech/src/features/solutions/data/services/saved_solutions_service.dart';
import 'package:littletech/src/features/solutions/data/services/solved_problems_service.dart';

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
    _checkSolved();
  }

  Future<void> _checkSolved() async {
    final solved = await SolvedProblemsService.isSolved(widget.problemName);
    if (mounted) setState(() => _isSolved = solved);
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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: Text(widget.problemName, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: _toggleSave,
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_outline,
              color: _isSaved ? scheme.secondary : scheme.onSurface.withValues(alpha: 0.6),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        scheme.primary.withValues(alpha: 0.8),
                        scheme.primary.withValues(alpha: 0.4),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                const Text(
                  'Solution Steps',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Gap(14),
                ..._solution!.steps.asMap().entries.map((e) {
                  return SolutionStepCard(
                    stepNumber: e.key + 1,
                    text: e.value,
                  ).animate(delay: Duration(milliseconds: 100 * e.key)).fadeIn().slideX(begin: 0.05);
                }),
                const Gap(28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outline),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Did this solve your problem?',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: scheme.onSurface),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isSolved
                                  ? null
                                  : () async {
                                      setState(() => _isSolved = true);
                                      await SolvedProblemsService.markSolved(widget.problemName);
                                      if (!context.mounted) return;
                                      context.read<CounterCubit>().increment();
                                      showSuccessToast(context, 'Great! Problem solved.');
                                    },
                              icon: Icon(_isSolved ? Icons.check_circle : Icons.check_circle_outline, size: 18),
                              label: Text(_isSolved ? 'Solved!' : 'Yes, Fixed'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green.shade600,
                                side: BorderSide(color: _isSolved ? Colors.green.shade600 : scheme.outline),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isSolved
                                  ? () async {
                                      setState(() => _isSolved = false);
                                      await SolvedProblemsService.unmarkSolved(widget.problemName);
                                      if (!context.mounted) return;
                                      context.read<CounterCubit>().decrement();
                                      showSuccessToast(context, 'Problem marked as unsolved.');
                                    }
                                  : null,
                              icon: const Icon(Icons.cancel_outlined, size: 18),
                              label: const Text('Not Yet'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: scheme.onSurface.withValues(alpha: 0.6),
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
