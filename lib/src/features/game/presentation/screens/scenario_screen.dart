import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/prep_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/traps_screen.dart';

class ScenarioScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const ScenarioScreen({super.key, required this.world, required this.level});

  @override
  State<ScenarioScreen> createState() => _ScenarioScreenState();
}

class _ScenarioScreenState extends State<ScenarioScreen> {
  int _currentQuestion = 0;
  int _correctCount = 0;
  bool _isAnswered = false;
  bool _showResults = false;
  final List<int> _userAnswers = [];
  final List<bool> _questionResults = [];

  List<Map<String, dynamic>> get _levelScenarios {
    return [
      PrepData.scenarios[PrepData.key(widget.level.id)] ?? {
        'scenario': 'A troubleshooting situation has arisen. What is your first step?',
        'correctAction': 'Identify the symptoms and gather information',
        'wrongActions': ['Replace all components', 'Ignore the problem', 'Buy a new device'],
        'explanation': 'Gathering information is always the first step in effective troubleshooting.',
        'followUps': [
          {
            'scenario': 'You have identified the symptoms. What do you do next?',
            'correctAction': 'Research the symptoms to find common causes',
            'wrongActions': ['Replace random parts', 'Guess the problem', 'Give up'],
            'explanation': 'Researching symptoms helps narrow down the possible causes before taking action.',
          },
          {
            'scenario': 'You found a potential cause. What is the best next step?',
            'correctAction': 'Try the least invasive fix first',
            'wrongActions': ['Replace everything', 'Reinstall the OS', 'Buy new hardware'],
            'explanation': 'Starting with simple fixes saves time and money. Only escalate to more complex solutions if needed.',
          },
        ],
      },
    ];
  }

  void _answer(int index) {
    if (_isAnswered) return;
    const correctIndex = 0;
    final isCorrect = index == correctIndex;

    setState(() {
      _isAnswered = true;
      _userAnswers.add(index);
      _questionResults.add(isCorrect);
      if (isCorrect) _correctCount++;
    });
  }

  void _next() {
    final allQuestions = _levelScenarios;
    if (_currentQuestion < allQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _isAnswered = false;
      });
    } else {
      setState(() => _showResults = true);
    }
  }

  void _finish() {
    final passed = _correctCount >= 2;
    context.read<GameCubit>().saveScenariosResult(widget.level.id, _correctCount, 3, passed);
    if (passed) context.read<GameCubit>().addPoints(15);
    Nav.pushReplacement(
      context,
      TrapsScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_showResults) return _buildResults(scheme);

    final q = _levelScenarios[_currentQuestion];
    final scenario = q['scenario'] as String;
    final correctAction = q['correctAction'] as String;
    final wrongActions = List<String>.from(q['wrongActions'] as List);
    final explanation = q['explanation'] as String;

    final options = [correctAction, ...wrongActions]..shuffle();
    final isFollowUp = _currentQuestion > 0;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Scenario Simulation'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.tertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                    child: Text(
                      isFollowUp ? 'Follow-up $_currentQuestion/2' : 'Scenario 1/3',
                      style: TextStyle(
                        color: scheme.tertiary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ),
                const Spacer(),
                Text(
                  '$_correctCount correct',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Gap(20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
              ),
              child: Text(
                scenario,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
            const Gap(20),
            Text(
              'What is the BEST first step?',
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (_, i) {
                  final option = options[i];
                  final isSelected = _userAnswers.length > _currentQuestion &&
                      _userAnswers[_currentQuestion] == i;
                  final isCorrectOption = option == correctAction;
                  final showFeedback = _isAnswered;

                  Color bgColor;
                  Color borderColor;
                  if (showFeedback && isSelected) {
                    bgColor = isCorrectOption
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1);
                    borderColor = isCorrectOption ? Colors.green : Colors.red;
                  } else if (showFeedback && isCorrectOption) {
                    bgColor = Colors.green.withValues(alpha: 0.05);
                    borderColor = Colors.green.withValues(alpha: 0.5);
                  } else {
                    bgColor = scheme.surface;
                    borderColor = scheme.outline.withValues(alpha: 0.3);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isAnswered ? null : () => _answer(i),
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
                                  color: showFeedback && isCorrectOption
                                      ? Colors.green
                                      : showFeedback && isSelected
                                          ? Colors.red
                                          : scheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: showFeedback && isCorrectOption
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : showFeedback && isSelected
                                        ? const Icon(Icons.close, color: Colors.white, size: 16)
                                        : Text(
                                            String.fromCharCode(65 + i),
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
                                  option,
                                  style: TextStyle(
                                    color: showFeedback && isCorrectOption
                                        ? Colors.green
                                        : showFeedback && isSelected
                                            ? Colors.red
                                            : scheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: (100 * i).ms).slideX(begin: 0.05);
                },
              ),
            ),
            if (_isAnswered)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _questionResults[_currentQuestion]
                      ? Colors.green.withValues(alpha: 0.08)
                      : Colors.orange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _questionResults[_currentQuestion]
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  explanation,
                  style: TextStyle(
                    color: _questionResults[_currentQuestion]
                        ? Colors.green.shade300
                        : Colors.orange.shade300,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isAnswered ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                  disabledBackgroundColor: scheme.outline.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _currentQuestion < _levelScenarios.length - 1 ? 'Next Scenario' : 'Review Results',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(ColorScheme scheme) {
    final passed = _correctCount >= 2;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Scenario Complete'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: passed
                    ? [Colors.green.shade800, Colors.green.shade600]
                    : [Colors.orange.shade800, Colors.orange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  passed ? Icons.emoji_events : Icons.info_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const Gap(12),
                Text(
                  '$_correctCount / 3 Correct',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(4),
                Text(
                  passed ? 'Passed! +15 points' : 'Not quite â€” keep learning!',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
          const Gap(24),
          ..._levelScenarios.asMap().entries.map((entry) {
            final i = entry.key;
            final q = entry.value;
            final isCorrect = i < _questionResults.length ? _questionResults[i] : false;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isCorrect
                    ? Colors.green.withValues(alpha: 0.05)
                    : Colors.red.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCorrect
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      (q['scenario'] as String).length > 80
                          ? '${(q['scenario'] as String).substring(0, 80)}...'
                          : q['scenario'] as String,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const Gap(24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _finish,
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: const Text(
                'Continue',
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
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}