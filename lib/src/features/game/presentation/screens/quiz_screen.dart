import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/prep_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/ordering_screen.dart';

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
  bool _showResults = false;
  final List<int> _userAnswers = [];

  List<Map<String, dynamic>> get _levelQuestions {
    return PrepData.quiz[widget.level.id] ?? [
      {
        'question': 'What is the first step in troubleshooting any tech problem?',
        'options': ['Identify the symptoms', 'Replace the device', 'Call for help', 'Ignore the problem'],
        'correct': 0,
        'explanation': 'Understanding what symptoms are present helps narrow down the possible causes systematically.',
      },
    ];
  }

  void _answer(int index) {
    if (_isAnswered || _gameOver) return;
    setState(() {
      _selectedAnswer = index;
      _isAnswered = true;
      _userAnswers.add(index);
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
      setState(() => _showResults = true);
    }
  }

  void _continueToOrdering() {
    final passed = _correctCount >= _levelQuestions.length ~/ 2 + 1;
    context.read<GameCubit>().saveQuizResult(widget.level.id, _correctCount, _levelQuestions.length, _lives);
    if (passed) context.read<GameCubit>().addPoints(20);
    Nav.pushReplacement(
      context,
      OrderingScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_showResults) return _buildResults(scheme);

    final q = _levelQuestions[_currentQuestion];
    final options = List<String>.from(q['options'] as List);

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
              final isSelected = _selectedAnswer == i;

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
                        color: isSelected
                            ? scheme.primary.withValues(alpha: 0.1)
                            : scheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? scheme.primary
                              : scheme.outline.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? scheme.primary
                                  : scheme.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              String.fromCharCode(65 + i),
                              style: TextStyle(
                                color: isSelected
                                    ? scheme.onPrimary
                                    : scheme.onSurface.withValues(alpha: 0.5),
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
                                color: isSelected
                                    ? scheme.primary
                                    : scheme.onSurface,
                                fontSize: 15,
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
            }),
            if (_isAnswered && _selectedAnswer != q['correct'])
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.orange.shade300, size: 18),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        (q['explanation'] as String?) ?? 'The correct answer is: ${options[q['correct'] as int]}',
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.8),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
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
                  _currentQuestion < _levelQuestions.length - 1 ? 'Next' : 'Review Results',
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
    final passed = _correctCount >= _levelQuestions.length ~/ 2 + 1;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Sage\'s Trial Complete'),
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
                    : [Colors.red.shade800, Colors.red.shade600],
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
                  '$_correctCount / ${_levelQuestions.length} Correct',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(4),
                Text(
                  passed ? 'Passed!' : 'Failed â€” continue anyway',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final filled = i < _lives;
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        filled ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 18,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
          const Gap(24),
          ..._levelQuestions.asMap().entries.map((entry) {
            final i = entry.key;
            final q = entry.value;
            final userAnswer = i < _userAnswers.length ? _userAnswers[i] : -1;
            final correctAns = q['correct'] as int;
            final isCorrect = userAnswer == correctAns;
            final options = List<String>.from(q['options'] as List);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 18,
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          q['question'] as String,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    'Your answer: ${userAnswer >= 0 ? options[userAnswer] : 'â€”'}',
                    style: TextStyle(
                      color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
                      fontSize: 12,
                    ),
                  ),
                  if (!isCorrect)
                    Text(
                      'Correct: ${options[correctAns]}',
                      style: TextStyle(
                        color: Colors.green.shade300,
                        fontSize: 12,
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
              onPressed: _continueToOrdering,
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: const Text(
                'Continue to Ordering',
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