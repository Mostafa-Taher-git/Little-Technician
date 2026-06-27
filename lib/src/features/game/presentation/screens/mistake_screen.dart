import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/prep_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/scenario_screen.dart';

class MistakeScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const MistakeScreen({super.key, required this.world, required this.level});

  @override
  State<MistakeScreen> createState() => _MistakeScreenState();
}

class _MistakeScreenState extends State<MistakeScreen> {
  int? _selectedIndex;
  bool _solved = false;
  bool _showExplanation = false;

  Map<String, dynamic> get _levelMistake {
    return PrepData.mistakes[PrepData.key(widget.level.id)] ?? {
      'steps': [
        {'text': 'Identify the symptoms of the problem', 'isWrong': false},
        {'text': 'Research common causes for these symptoms', 'isWrong': false},
        {'text': 'Destroy all your electronics in frustration', 'isWrong': true},
        {'text': 'Try the simplest fix first', 'isWrong': false},
        {'text': 'Escalate to more complex solutions if needed', 'isWrong': false},
      ],
      'explanation': 'Destroying electronics is never the right approach. Effective troubleshooting always starts with understanding the problem and trying simple solutions first.',
    };
  }

  void _selectStep(int index) {
    if (_solved) return;
    final steps = _levelMistake['steps'] as List<Map<String, dynamic>>;
    final isWrong = steps[index]['isWrong'] as bool;

    setState(() {
      _selectedIndex = index;
      if (isWrong) {
        _solved = true;
        context.read<GameCubit>().addPoints(10);
        context.read<GameCubit>().saveMistakeResult(widget.level.id, true);
        Future.delayed(800.ms, () {
          if (mounted) {
            setState(() => _showExplanation = true);
          }
        });
      }
    });
  }

  void _continue() {
    Nav.pushReplacement(
      context,
      ScenarioScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final steps = _levelMistake['steps'] as List<Map<String, dynamic>>;
    final explanation = _levelMistake['explanation'] as String;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Spot the Mistake'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.tertiary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.tertiary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: scheme.tertiary, size: 20),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      'One of these troubleshooting steps is WRONG. Tap it to identify the mistake.',
                      style: TextStyle(
                        color: scheme.tertiary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (_, i) {
                  final step = steps[i];
                  final text = step['text'] as String;
                  final isWrong = step['isWrong'] as bool;
                  final isSelected = _selectedIndex == i;

                  Color bgColor;
                  Color borderColor;
                  if (_solved && isWrong) {
                    bgColor = Colors.green.withValues(alpha: 0.1);
                    borderColor = Colors.green;
                  } else if (!_solved && isSelected) {
                    bgColor = Colors.red.withValues(alpha: 0.1);
                    borderColor = Colors.red;
                  } else if (_solved && isSelected && !isWrong) {
                    bgColor = Colors.red.withValues(alpha: 0.05);
                    borderColor = Colors.red.withValues(alpha: 0.5);
                  } else {
                    bgColor = scheme.surface;
                    borderColor = scheme.outline.withValues(alpha: 0.3);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _solved ? null : () => _selectStep(i),
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: 300.ms,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _solved && isWrong
                                      ? Colors.green
                                      : _solved && isSelected && !isWrong
                                          ? Colors.red
                                          : scheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _solved && isWrong
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : _solved && isSelected && !isWrong
                                        ? const Icon(Icons.close, color: Colors.white, size: 16)
                                        : Text(
                                            '${i + 1}',
                                            style: TextStyle(
                                              color: scheme.onSurface.withValues(alpha: 0.5),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                              ),
                              const Gap(14),
                              Expanded(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    color: _solved && isWrong
                                        ? Colors.green
                                        : _solved && isSelected && !isWrong
                                            ? Colors.red
                                            : scheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: (80 * i).ms).slideX(begin: 0.05);
                },
              ),
            ),
            if (!_solved && _selectedIndex != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red.shade300, size: 18),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'Not quite â€” that step is correct. Try again!',
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
            if (_showExplanation)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade300, size: 18),
                        const Gap(8),
                        Text(
                          'Correct! You spotted the mistake',
                          style: TextStyle(
                            color: Colors.green.shade300,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Text(
                      explanation,
                      style: TextStyle(
                        color: Colors.green.shade300,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _solved ? _continue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                  disabledBackgroundColor: scheme.outline.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continue to Scenarios',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}