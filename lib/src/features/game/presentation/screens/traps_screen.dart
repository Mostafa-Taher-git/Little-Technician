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
      _finish();
    }
  }

  void _finish() {
    _passed = _correctCount >= _levelTraps.length ~/ 2 + 1;
    if (_passed) {
      context.read<GameCubit>().addPoints(15);
    }
    Nav.pushReplacement(
      context,
      ProblemScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final trap = _levelTraps[_currentIndex];
    final statement = trap['statement'] as String;
    final isTrue = trap['isTrue'] as bool;

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
            if (_isAnswered) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (_isAnswered && ((isTrue && _correctCount > 0) || (!isTrue && _correctCount > 0)))
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      (_isAnswered && ((isTrue && _correctCount > 0) || (!isTrue && _correctCount > 0)))
                          ? Icons.check_circle
                          : Icons.info_outline,
                      color: (_isAnswered && ((isTrue && _correctCount > 0) || (!isTrue && _correctCount > 0)))
                          ? Colors.green
                          : Colors.orange,
                      size: 20,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        isTrue
                            ? 'This statement is TRUE — correct troubleshooting knowledge!'
                            : 'This statement is FALSE — don\'t fall for common myths!',
                        style: TextStyle(
                          color: (_isAnswered && ((isTrue && _correctCount > 0) || (!isTrue && _correctCount > 0)))
                              ? Colors.green.shade300
                              : Colors.orange.shade300,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
              const Gap(20),
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
                    _currentIndex < _levelTraps.length - 1 ? 'Next Trap' : 'Start Quest',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
