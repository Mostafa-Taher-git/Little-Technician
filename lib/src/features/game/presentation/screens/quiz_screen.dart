import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/problem_screen.dart';

class QuizScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const QuizScreen({super.key, required this.world, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int? _selectedAnswer;
  int _correctCount = 0;
  bool _isAnswered = false;
  int _lives = 3;
  bool _gameOver = false;

  static const _questions = {
    'cpu_high_usage': [
      {
        'question': 'Which tool do you use to check CPU usage in Windows?',
        'options': ['Task Manager', 'File Explorer', 'Control Panel', 'Notepad'],
        'correct': 0,
      },
      {
        'question': 'What keyboard shortcut opens Task Manager?',
        'options': ['Ctrl+Alt+Del and select Task Manager', 'Ctrl+C', 'Alt+F4', 'Windows+R'],
        'correct': 0,
      },
    ],
    'cpu_overheating': [
      {
        'question': 'What is the most common cause of CPU overheating?',
        'options': ['Dust buildup', 'Too much RAM', 'Old monitor', 'Slow internet'],
        'correct': 0,
      },
    ],
    'computer_not_turning_on': [
      {
        'question': 'What should you check FIRST when a PC won\'t turn on?',
        'options': ['Power cable connection', 'Replace the CPU', 'Reinstall Windows', 'Buy a new PC'],
        'correct': 0,
      },
    ],
  };

  List<Map<String, dynamic>> get _levelQuestions {
    return _questions[widget.level.id] ?? [
      {
        'question': 'What is the first step in troubleshooting any tech problem?',
        'options': ['Identify the symptoms', 'Replace the device', 'Call for help', 'Ignore the problem'],
        'correct': 0,
      },
    ];
  }

  void _answer(int index) {
    if (_isAnswered || _gameOver) return;
    setState(() {
      _selectedAnswer = index;
      _isAnswered = true;
      if (index == _levelQuestions[_currentQuestion]['correct']) {
        _correctCount++;
      } else {
        _lives--;
        if (_lives <= 0) _gameOver = true;
      }
    });
  }

  void _next() {
    if (_currentQuestion < _levelQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      _finish();
    }
  }

  void _finish() {
    final passed = !_gameOver && _correctCount >= _levelQuestions.length ~/ 2 + 1;
    if (passed) {
      context.read<GameCubit>().addPoints(20);
    }
    Nav.pushReplacement(
      context,
      ProblemScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final q = _levelQuestions[_currentQuestion];
    final options = List<String>.from(q['options'] as List);
    final correctIndex = q['correct'] as int;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Sage\'s Trial'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Question ${_currentQuestion + 1}/${_levelQuestions.length}',
                  style: TextStyle(
                    color: scheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_correctCount correct',
                    style: TextStyle(
                      color: scheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(24),
            Row(
              children: List.generate(3, (i) {
                final filled = i < _lives;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    filled ? Icons.favorite : Icons.favorite_border,
                    color: filled ? Colors.red.shade400 : scheme.onSurface.withValues(alpha: 0.2),
                    size: 20,
                  ),
                );
              }),
            ),
            const Gap(24),
            Text(
              q['question'] as String,
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const Gap(24),
            ...options.asMap().entries.map((entry) {
              final i = entry.key;
              final option = entry.value;
              Color bgColor = scheme.surface;
              Color borderColor = scheme.outline.withValues(alpha: 0.3);
              Color textColor = scheme.onSurface;

              if (_isAnswered) {
                if (i == correctIndex) {
                  bgColor = Colors.green.withValues(alpha: 0.1);
                  borderColor = Colors.green;
                  textColor = Colors.green;
                } else if (i == _selectedAnswer) {
                  bgColor = Colors.red.withValues(alpha: 0.1);
                  borderColor = Colors.red;
                  textColor = Colors.red;
                }
              } else if (_selectedAnswer == i) {
                bgColor = scheme.secondary.withValues(alpha: 0.1);
                borderColor = scheme.secondary;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _answer(i),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
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
                              color: _isAnswered && i == correctIndex
                                  ? Colors.green
                                  : _isAnswered && i == _selectedAnswer
                                      ? Colors.red
                                      : scheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              String.fromCharCode(65 + i),
                              style: TextStyle(
                                color: scheme.onPrimary,
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
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (_isAnswered && i == correctIndex)
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                          if (_isAnswered && i == _selectedAnswer && i != correctIndex)
                            const Icon(Icons.cancel, color: Colors.red, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: (100 * i).ms).slideX(begin: 0.05);
            }),
            if (_gameOver)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
                    const Gap(8),
                    Text(
                      'You ran out of lives!',
                      style: TextStyle(
                        color: Colors.red.shade300,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'Don\'t worry — you can still attempt the quest.',
                      style: TextStyle(color: Colors.red.shade200, fontSize: 12),
                    ),
                  ],
                ),
              ).animate().shake(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: (_isAnswered || _gameOver) ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                  disabledBackgroundColor: scheme.outline.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _currentQuestion < _levelQuestions.length - 1 ? 'Next' : 'Start Quest',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
