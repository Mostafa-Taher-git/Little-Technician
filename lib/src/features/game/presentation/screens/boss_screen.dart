import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/constants/colors.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/reward_spin_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';

class BossScreen extends StatelessWidget {
  final WorldDef world;

  const BossScreen({super.key, required this.world});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('BOSS FIGHT', style: TextStyle(letterSpacing: 2)),
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (_, state) {
          final boss = world.boss;
          final hpLeft = state.currentBossHp;
          final isDefeated = hpLeft <= 0;
          final hpProgress = boss.hp > 0 ? (boss.hp - hpLeft) / boss.hp : 1.0;

          if (isDefeated && state.lastDrawnReward != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Nav.pushReplacement(
                context,
                RewardSpinScreen(reward: state.lastDrawnReward!),
              );
            });
          }

          return Stack(
            children: [
              // Particle background
              Positioned.fill(
                child: CustomPaint(
                  painter: _BossParticlePainter(),
                ),
              ),
              Column(
                children: [
                  const Spacer(flex: 2),
                  // Boss portrait area
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.red.shade800,
                          Colors.red.shade900,
                          Colors.black,
                        ],
                        stops: const [0.3, 0.6, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '👹',
                      style: TextStyle(fontSize: 72),
                    ),
                  ).animate().fadeIn().scale(begin: const Offset(0.5, 0.5)),
                  const Gap(24),
                  // Boss name
                  Text(
                    boss.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ).animate().fadeIn(delay: 200.ms),
                  const Gap(8),
                  // Lore
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      boss.lore,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const Gap(32),
                  // HP bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite, color: Colors.red, size: 16),
                            const Gap(8),
                            Text(
                              'HP: $hpLeft / ${boss.hp}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const Gap(8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: hpProgress,
                            backgroundColor: Colors.white.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDefeated ? AppColors.success : Colors.red,
                            ),
                            minHeight: 12,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                  const Spacer(flex: 2),
                  // Actions
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: isDefeated
                                ? null
                                : () => context.read<GameCubit>().attackBoss(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade800,
                              disabledForegroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: Icon(
                              isDefeated ? Icons.check : Icons.flash_on,
                              size: 22,
                            ),
                            label: Text(
                              isDefeated ? 'Defeated!' : 'Attack!',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        if (state.availableSupTechUses > 0) ...[
                          const Gap(12),
                          SupTechAvatar(
                            availableUses: state.availableSupTechUses,
                            isGlowing: true,
                            size: 48,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (isDefeated)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'VICTORY!',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Awaiting your reward...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BossParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    for (var i = 0; i < 30; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final radius = rng.nextDouble() * 3 + 1;
      final alpha = (rng.nextDouble() * 60 + 20).toInt();
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = Colors.red.withValues(alpha: alpha / 255),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
