import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_complete_screen.dart';

class RewardSpinScreen extends StatefulWidget {
  final RewardDef reward;

  const RewardSpinScreen({super.key, required this.reward});

  @override
  State<RewardSpinScreen> createState() => _RewardSpinScreenState();
}

class _RewardSpinScreenState extends State<RewardSpinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _spinAnimation;
  bool _isSpinning = true;
  bool _isCollected = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 2000.ms,
    );
    _spinAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _startSpin();
  }

  void _startSpin() {
    _controller.forward().then((_) {
      if (mounted) setState(() => _isSpinning = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reward = widget.reward;
    final rarityLabel = reward.rarity.name.toUpperCase();
    final rarityColor = reward.color;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(
              'REWARD UNLOCKED!',
              style: TextStyle(
                color: rarityColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const Gap(40),
            AnimatedBuilder(
              animation: _spinAnimation,
              builder: (_, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateY(_spinAnimation.value * 3.14 * 4),
                  child: child,
                );
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      rarityColor.withValues(alpha: 0.3),
                      rarityColor.withValues(alpha: 0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: rarityColor.withValues(alpha: 0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  reward.icon,
                  size: 80,
                  color: rarityColor,
                ),
              ),
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: rarityColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rarityColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                rarityLabel,
                style: TextStyle(
                  color: rarityColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 2,
                ),
              ),
            ).animate().fadeIn(delay: 600.ms),
            const Gap(16),
            Text(
              reward.displayName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),
            const Gap(40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSpinning || _isCollected
                      ? null
                      : () {
                          setState(() => _isCollected = true);
                          context.read<GameCubit>().collectReward();
                          _navigateToComplete(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rarityColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _isSpinning ? 'Spinning...' : 'Collect',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void _navigateToComplete(BuildContext context) {
    final world = context.read<GameCubit>().state.currentWorld;
    final level = context.read<GameCubit>().state.currentLevel;
    if (world != null && level != null) {
      Nav.pushReplacement(
        context,
        LevelCompleteScreen(
          world: world,
          level: level,
          reward: widget.reward,
        ),
      );
    } else {
      Nav.pop(context);
    }
  }
}
