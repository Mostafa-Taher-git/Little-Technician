import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/traps_screen.dart';

class OrderingScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const OrderingScreen({super.key, required this.world, required this.level});

  @override
  State<OrderingScreen> createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  late List<String> _shuffled;
  bool _isVerified = false;
  bool _isCorrect = false;
  int _lives = 3;
  int _attempts = 0;
  int _wrongCount = 0;
  bool _showVerified = false;

  @override
  void initState() {
    super.initState();
    _shuffled = List<String>.from(widget.level.steps)..shuffle();
  }

  void _moveItem(int oldIndex, int newIndex) {
    setState(() {
      final item = _shuffled.removeAt(oldIndex);
      _shuffled.insert(newIndex, item);
      _isVerified = false;
      _showVerified = false;
    });
  }

  void _verify() {
    final correct = widget.level.steps;
    final match = _shuffled.length == correct.length &&
        _shuffled.asMap().entries.every((e) => e.value == correct[e.key]);
    _attempts++;

    if (match) {
      setState(() {
        _isVerified = true;
        _isCorrect = true;
        _showVerified = true;
      });
      context.read<GameCubit>().saveOrderingResult(widget.level.id, _attempts, true);
      context.read<GameCubit>().addPoints(15);
      Future.delayed(800.ms, () {
        if (mounted) {
          Nav.pushReplacement(
            context,
            TrapsScreen(world: widget.world, level: widget.level),
          );
        }
      });
    } else {
      setState(() {
        _lives--;
        _wrongCount = _shuffled.asMap().entries.where((e) => e.value != correct[e.key]).length;
        _showVerified = true;
      });
      if (_lives <= 0) {
        context.read<GameCubit>().saveOrderingResult(widget.level.id, _attempts, false);
        Future.delayed(1.ms, () {
          if (mounted) {
            Nav.pushReplacement(
              context,
              TrapsScreen(world: widget.world, level: widget.level),
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Rite of Order'),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final filled = i < _lives;
                return Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    filled ? Icons.favorite : Icons.favorite_border,
                    color: filled ? Colors.red.shade400 : scheme.onSurface.withValues(alpha: 0.2),
                    size: 18,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text(
              'Drag the steps into the correct order to fix "${widget.level.title}"',
              style: TextStyle(
                color: scheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
          const Gap(16),
          if (_showVerified && !_isCorrect && _lives > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '$_wrongCount steps in wrong position — try again!',
                style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.5), fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _shuffled.length,
              onReorderItem: _moveItem,
              proxyDecorator: (child, _, __) => Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(14),
                shadowColor: scheme.secondary.withValues(alpha: 0.3),
                child: child,
              ),
              itemBuilder: (_, i) {
                return Container(
                  key: ValueKey(_shuffled[i]),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: scheme.outline.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.drag_handle, size: 16, color: scheme.onSurface.withValues(alpha: 0.4)),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          '${i + 1}. ${_shuffled[i]}',
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: (_isVerified && _isCorrect) || _lives <= 0 ? null : _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVerified && _isCorrect
                      ? Colors.green.shade700
                      : scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                  disabledBackgroundColor: scheme.outline.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: Icon(
                  _isVerified && _isCorrect ? Icons.check : Icons.verified,
                  size: 20,
                ),
                label: Text(
                  _isVerified && _isCorrect ? 'Correct!' : 'Verify Order',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
