import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/achievements.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/level_select_screen.dart';

class LevelCompleteScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;
  final List<Achievement> newAchievements;
  final RewardDef? reward;

  const LevelCompleteScreen({
    super.key,
    required this.world,
    required this.level,
    this.newAchievements = const [],
    this.reward,
  });

  @override
  State<LevelCompleteScreen> createState() => _LevelCompleteScreenState();
}

class _LevelCompleteScreenState extends State<LevelCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _rng = Random();
  int _displayPoints = 0;
  int _totalPoints = 0;
  Map<String, dynamic>? _prepData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _particles = List.generate(30, (_) => _Particle(
      x: _rng.nextDouble(),
      y: 1.0 + _rng.nextDouble() * 0.3,
      speed: 0.003 + _rng.nextDouble() * 0.005,
      size: 2 + _rng.nextDouble() * 4,
      opacity: 0.3 + _rng.nextDouble() * 0.5,
      color: _rng.nextDouble() > 0.5
          ? const Color(0xFFFFD700)
          : const Color(0xFFFFA000),
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller.isAnimating) return;
    final raw = context.read<GameCubit>().state.progress.getPrepResult(widget.level.id);
    _prepData = raw != null ? json.decode(raw) as Map<String, dynamic> : null;
    final quizPts = _prepData?['quiz'] != null ? 20 : 0;
    final orderPts = _prepData?['ordering']?['passed'] == true ? 15 : 0;
    final trapPts = _prepData?['traps']?['passed'] == true ? 15 : 0;
    final progress = context.read<GameCubit>().state.progress;
    final noSupTechBonus = progress.supTechUsesThisLevel >= 1 ? 25 : 0;
    const firstAttemptBonus = 25;
    _totalPoints = quizPts + orderPts + trapPts + noSupTechBonus + firstAttemptBonus + 10 * widget.level.steps.length + widget.level.points;

    _controller.addListener(() {
      final t = _controller.value;
      for (final p in _particles) {
        p.y -= p.speed;
        if (p.y < -0.1) {
          p.y = 1.0;
          p.x = _rng.nextDouble();
        }
      }
      if (t >= 0.4 && t <= 0.7) {
        final pts = ((t - 0.4) / 0.3 * _totalPoints).round();
        if (pts != _displayPoints) setState(() => _displayPoints = pts);
      }
      if (t >= 0.7) setState(() => _displayPoints = _totalPoints);
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _controller.value;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                size: Size.infinite,
                painter: _ParticlePainter(
                  particles: _particles,
                  opacity: (t - 0.1).clamp(0.0, 1.0),
                ),
              );
            },
          ),
          Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF1A1A2E).withValues(alpha: 0.6),
                    Colors.black,
                  ],
                  radius: 1.2,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Opacity(
                  opacity: (t - 0.2).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.5 + 0.5 * ((t - 0.2) / 0.2).clamp(0.0, 1.0),
                    child: Text(
                      'LEVEL COMPLETE',
                      style: TextStyle(
                        color: const Color(0xFFF59E0B),
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(8),
                Opacity(
                  opacity: (t - 0.3).clamp(0.0, 1.0),
                  child: Text(
                    widget.level.title,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(40),
                Opacity(
                  opacity: (t - 0.4).clamp(0.0, 1.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 48),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '+$_displayPoints',
                          style: TextStyle(
                            color: const Color(0xFFF59E0B),
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'POINTS EARNED',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ..._buildPrepChips(t),
                if (widget.reward != null)
                  Opacity(
                    opacity: (t - 0.5).clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        children: [
                          Icon(
                            widget.reward!.icon,
                            color: Colors.amber,
                            size: 48,
                          ).animate().scale(
                            begin: const Offset(0, 0),
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          ),
                          const Gap(8),
                          Text(
                            widget.reward!.displayName,
                            style: TextStyle(
                              color: Colors.amber.shade300,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (widget.newAchievements.isNotEmpty)
                  Opacity(
                    opacity: (t - 0.6).clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        children: widget.newAchievements.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                              const Gap(8),
                              Text(
                                a.name,
                                style: TextStyle(
                                  color: Colors.amber.shade200,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Opacity(
                    opacity: (t - 0.75).clamp(0.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: t >= 0.75 ? () {
                            Nav.pushReplacement(
                              context,
                              LevelSelectScreen(world: widget.world),
                            );
                          } : null,
                          icon: const Icon(Icons.arrow_forward, size: 20),
                          label: const Text(
                            'Continue',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPrepChips(double t) {
    if (_prepData == null) return [];
    final chips = <Widget>[];
    final quiz = _prepData!['quiz'] as Map?;
    final ordering = _prepData!['ordering'] as Map?;
    final traps = _prepData!['traps'] as Map?;
    if (quiz != null) chips.add(_prepChip('Quiz ${quiz['correct']}/${quiz['total']}', const Color(0xFF3B82F6)));
    if (ordering != null) chips.add(_prepChip('Order ${ordering['passed'] == true ? '✓' : '${ordering['attempts']}x'}', ordering['passed'] == true ? const Color(0xFF22C55E) : const Color(0xFFEF4444)));
    if (traps != null) chips.add(_prepChip('Traps ${traps['correct']}/${traps['total']} ${traps['passed'] == true ? '✓' : '✗'}', traps['passed'] == true ? const Color(0xFF22C55E) : const Color(0xFFEF4444)));

    // Bonus chips
    final progress = context.read<GameCubit>().state.progress;
    if (progress.supTechUsesThisLevel >= 1) {
      chips.add(_prepChip('+25 No SupTech', const Color(0xFF22C55E)));
    }
    chips.add(_prepChip('+25 First Attempt', const Color(0xFF22C55E)));

    if (chips.isEmpty) return [];

    return [
      Opacity(
        opacity: (t - 0.45).clamp(0.0, 1.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: chips,
          ),
        ),
      ),
    ];
  }

  Widget _prepChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Particle {
  double x, y, speed, size, opacity;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double opacity;

  _ParticlePainter({required this.particles, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity * opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.opacity != opacity || old.particles != particles;
}
