import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/problem_screen.dart';

class TrapsScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const TrapsScreen({super.key, required this.world, required this.level});

  @override
  State<TrapsScreen> createState() => _TrapsScreenState();
}

class _TrapsScreenState extends State<TrapsScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _isAnswered = false;
  bool _passed = false;
  bool _showResults = false;
  final List<bool> _userAnswers = [];
  final List<bool> _trapResults = [];

  static const _traps = {
    'cpu_high_usage': [
      {'statement': 'Task Manager can be opened with Ctrl+Shift+Esc', 'isTrue': true},
      {'statement': 'High CPU usage is always caused by a virus', 'isTrue': false},
    ],
    'computer_not_turning_on': [
      {'statement': 'A flipped PSU switch can prevent a PC from turning on', 'isTrue': true},
      {'statement': 'If the PC doesn\'t turn on, you must replace the motherboard', 'isTrue': false},
    ],
    'bsod': [
      {'statement': 'The stop code on a BSOD helps identify the problem', 'isTrue': true},
      {'statement': 'BSODs only happen on old computers', 'isTrue': false},
    ],
  };

  List<Map<String, dynamic>> get _levelTraps {
    return _traps[widget.level.id] ?? [
      {'statement': 'Identifying symptoms is the first troubleshooting step', 'isTrue': true},
      {'statement': 'You should replace a device before trying to fix it', 'isTrue': false},
      {'statement': 'Restarting can fix many tech problems', 'isTrue': true},
    ];
  }

  void _answer(bool userSaysTrue) {
    if (_isAnswered) return;
    final correct = _levelTraps[_currentIndex]['isTrue'] as bool;
    final spotOn = userSaysTrue == correct;
    setState(() {
      _isAnswered = true;
      _userAnswers.add(userSaysTrue);
      _trapResults.add(spotOn);
      if (spotOn) _correctCount++;
    });
  }

  void _next() {
    if (_currentIndex < _levelTraps.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
      });
    } else {
      setState(() => _showResults = true);
    }
  }

  void _continueToQuest() {
    _passed = _correctCount >= _levelTraps.length ~/ 2 + 1;
    context.read<GameCubit>().saveTrapsResult(widget.level.id, _correctCount, _levelTraps.length, _passed);
    if (_passed) context.read<GameCubit>().addPoints(15);
    Nav.pushReplacement(
      context,
      ProblemScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_showResults) return _buildResults(scheme);

    final trap = _levelTraps[_currentIndex];
    final statement = trap['statement'] as String;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Detect Deception'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
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
                    'Trap ${_currentIndex + 1}/${_levelTraps.length}',
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
            const Gap(32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Icon(Icons.psychology_outlined, color: scheme.tertiary, size: 36),
                  const Gap(16),
                  Text(
                    statement,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(32),
            if (!_isAnswered)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: ElevatedButton.icon(
                        onPressed: () => _answer(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.check, size: 24),
                        label: const Text('TRUE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                  ),
                  const Gap(16),
                  Expanded(
                    child: SizedBox(
                      height: 64,
                      child: ElevatedButton.icon(
                        onPressed: () => _answer(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.close, size: 24),
                        label: const Text('FALSE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                  ),
                ],
              ),
            if (_isAnswered)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.secondary,
                    foregroundColor: scheme.onSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _currentIndex < _levelTraps.length - 1 ? 'Next Trap' : 'Review Results',
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
    _passed = _correctCount >= _levelTraps.length ~/ 2 + 1;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Detect Deception Complete'),
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
                colors: _passed
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
                  _passed ? Icons.emoji_events : Icons.info_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const Gap(12),
                Text(
                  '$_correctCount / ${_levelTraps.length} Correct',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(4),
                Text(
                  _passed ? 'Passed!' : 'Failed — continue anyway',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
          const Gap(24),
          ..._levelTraps.asMap().entries.map((entry) {
            final i = entry.key;
            final trap = entry.value;
            final isCorrect = i < _trapResults.length ? _trapResults[i] : false;
            final userAnswer = i < _userAnswers.length ? _userAnswers[i] : false;

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
                          trap['statement'] as String,
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(6),
                  Text(
                    'You said: ${userAnswer ? "TRUE" : "FALSE"}',
                    style: TextStyle(
                      color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
                      fontSize: 12,
                    ),
                  ),
                  if (!isCorrect)
                    Text(
                      'Correct: ${trap['isTrue'] ? "TRUE" : "FALSE"}',
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
              onPressed: _continueToQuest,
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: const Text(
                'Start Quest',
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
