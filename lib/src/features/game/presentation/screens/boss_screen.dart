import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/reward_spin_screen.dart';
import 'package:littletech/src/features/game/presentation/widgets/suptech_avatar.dart';
import 'package:littletech/src/features/game/presentation/widgets/sup_tech_avatar_wrapper.dart';

class BossScreen extends StatefulWidget {
  final BossEncounterDef boss;

  const BossScreen({super.key, required this.boss});

  @override
  State<BossScreen> createState() => _BossScreenState();
}

class _BossScreenState extends State<BossScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bossController;
  late AnimationController _entranceController;
  late Animation<double> _breathAnimation;
  late Animation<double> _glowPulse;
  late Animation<double> _entranceAnimation;

  int _currentPhase = 0;
  String? _lastOutcome;
  bool _navigatedToReward = false;
  bool _showDiagnosis = false;
  String? _diagnosisResult;
  int _resolveCount = 0;

  bool get _isEasy => widget.boss.difficulty == DifficultyLevel.easy;
  bool get _isHard => widget.boss.difficulty == DifficultyLevel.hard;

  @override
  void initState() {
    super.initState();
    _bossController = AnimationController(
      vsync: this,
      duration: 2000.ms,
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: 800.ms,
    )..forward();

    _breathAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _bossController, curve: Curves.easeInOutSine),
    );

    _glowPulse = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _bossController, curve: Curves.easeInOutSine),
    );

    _entranceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _bossController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _selectedDiagnosis(int selectedIndex) {
    final diagnosis = widget.boss.diagnosis;
    if (diagnosis.isEmpty) return;

    final correct = diagnosis['correct'] as int;
    final cubit = context.read<GameCubit>();

    if (selectedIndex == correct) {
      cubit.attackBoss(damage: 3);
      setState(() {
        _diagnosisResult = diagnosis['flavor'] as String;
      });
    } else {
      setState(() {
        _diagnosisResult = diagnosis['failFlavor'] as String;
      });
    }

    Future.delayed(1500.ms, () {
      if (mounted) {
        setState(() {
          _showDiagnosis = false;
          _diagnosisResult = null;
          _currentPhase = 1;
        });
      }
    });
  }

  void _executeStrategy(Map<String, dynamic> strategy) {
    final cubit = context.read<GameCubit>();
    final rng = Random();
    final roll = rng.nextInt(100) + 1;
    final success = strategy['success'] as int;
    final damage = strategy['damage'] as int;

    if (roll <= success) {
      cubit.attackBoss(damage: damage);
      setState(() {
        _lastOutcome = strategy['flavor'] as String;
        _currentPhase = 2;
      });
    } else {
      setState(() {
        _lastOutcome = strategy['failFlavor'] as String;
        _currentPhase = 2;
      });
    }
  }

  Color _bossColor(int visualType) {
    const colors = [
      Color(0xFFE94560), Color(0xFF6BB5FF), Color(0xFF7B2D8B), Color(0xFF4A90D9),
      Color(0xFF2D6A4F), Color(0xFFFF6B35), Color(0xFF8B0000), Color(0xFFFFD700),
      Color(0xFF9B30FF), Color(0xFF00E5FF), Color(0xFFFF6B35), Color(0xFF00E5FF),
      Color(0xFFFF00FF), Color(0xFF00FF88),
    ];
    return colors[(visualType - 1).clamp(0, 13)];
  }

  Widget _buildDefeatedButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade800,
          disabledForegroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.check, size: 22),
        label: const Text(
          'Defeated!',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildPhaseStart() {
    if (_isEasy) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () => setState(() => _currentPhase = 1),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.flash_on, size: 22),
          label: const Text(
            'Begin Battle!',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
      );
    }

    final diagnosis = widget.boss.diagnosis;
    if (_showDiagnosis) {
      if (_diagnosisResult != null) {
        final isCorrect = _diagnosisResult == diagnosis['flavor'];
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCorrect
                ? Colors.green.shade900.withValues(alpha: 0.3)
                : Colors.red.shade900.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCorrect
                  ? Colors.green.shade400.withValues(alpha: 0.4)
                  : Colors.red.shade400.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
                size: 36,
              ),
              const Gap(12),
              Text(
                _diagnosisResult!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      }

      final options = diagnosis['options'] as List<String>;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DIAGNOSIS PHASE',
            style: TextStyle(
              color: Colors.orange.shade300,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const Gap(10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Text(
              diagnosis['symptoms'] as String,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const Gap(12),
          Text(
            'What is the correct diagnosis?',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(8),
          ...options.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _selectedDiagnosis(entry.key),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () => setState(() {
          _showDiagnosis = true;
        }),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.flash_on, size: 22),
        label: const Text(
          'Begin Battle!',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildPhaseStrategy() {
    final strategies = widget.boss.strategies;
    return Column(
      children: [
        Text(
          'Choose your strategy:',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        ...strategies.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _executeStrategy(s),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['name'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            '${s['damage']} dmg · ${s['success']}% success',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${s['success']}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildPhaseResolve() {
    final isRound2 = _isHard && _resolveCount >= 1;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _lastOutcome?.contains('!') ?? false ? Icons.whatshot : Icons.block,
                color: _lastOutcome?.contains('!') ?? false
                    ? Colors.orange.shade400
                    : Colors.red.shade300,
                size: 18,
              ),
              const Gap(10),
              Expanded(
                child: Text(
                  _lastOutcome ?? '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(16),
        if (_isHard && !isRound2)
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => setState(() {
                _currentPhase = 1;
                _resolveCount++;
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Second Wind!',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => setState(() {
                _currentPhase = 1;
                _resolveCount = 0;
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Next Turn',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final boss = widget.boss;
    final bossColor = _bossColor(boss.visualType);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('BOSS ENCOUNTER', style: TextStyle(letterSpacing: 2)),
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (_, state) {
          final hpLeft = state.currentBossHp;
          final isDefeated = hpLeft <= 0;

          if (isDefeated && state.lastDrawnReward != null && !_navigatedToReward) {
            _navigatedToReward = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                Nav.pushReplacement(
                  context,
                  RewardSpinScreen(reward: state.lastDrawnReward!),
                );
              }
            });
          }

          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        bossColor.withValues(alpha: 0.15),
                        const Color(0xFF0D0D0D),
                        Colors.black,
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _ArenaParticlePainter(
                    phase: _bossController.value,
                    visualType: boss.visualType,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    AnimatedBuilder(
                      animation: _breathAnimation,
                      builder: (_, child) {
                        return Opacity(
                          opacity: _entranceAnimation.value.clamp(0.0, 1.0),
                          child: Transform.scale(
                            scale: _breathAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: _MonsterPainter(
                            visualType: boss.visualType,
                            isDefeated: isDefeated,
                            glowIntensity: _glowPulse.value,
                            phase: _bossController.value,
                          ),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Text(
                      boss.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const Gap(8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        boss.lore,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms),
                    const Gap(24),
                    _HitDiceBar(
                      hpLeft: hpLeft,
                      bossHp: boss.hp,
                      isDefeated: isDefeated,
                    ).animate().fadeIn(delay: 500.ms),
                    const Gap(24),
                    _MonsterStatBlock(
                      armorClass: boss.armor,
                      hpDisplay: '${boss.hp}',
                      abilities: boss.abilities,
                      isDefeated: isDefeated,
                      challengeRating: boss.challengeRating,
                      difficulty: boss.difficulty,
                    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1),
                    const Gap(24),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      child: Column(
                        children: [
                          if (isDefeated)
                            _buildDefeatedButton()
                          else if (_currentPhase == 0)
                            _buildPhaseStart()
                          else if (_currentPhase == 1)
                            _buildPhaseStrategy()
                          else
                            _buildPhaseResolve(),
                          if (state.availableSupTechUses > 0 && !isDefeated) ...[
                            const Gap(16),
                            Center(
                              child: SupTechAvatarWrapper(
                                size: 48,
                                child: SupTechAvatar(
                                  size: 48,
                                  skinId: state.progress.activeSkinId,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isDefeated)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'VICTORY!',
                            style: TextStyle(
                              color: Color(0xFFF59E0B),
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 6,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Awaiting your reward...',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
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

class _HitDiceBar extends StatelessWidget {
  final int hpLeft;
  final int bossHp;
  final bool isDefeated;

  const _HitDiceBar({
    required this.hpLeft,
    required this.bossHp,
    required this.isDefeated,
  });

  @override
  Widget build(BuildContext context) {
    const segments = 8;
    final segmentHp = bossHp / segments;
    final filledSegments = ((bossHp - hpLeft) / segmentHp).ceil().clamp(0, segments);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HIT POINTS',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const Gap(8),
          Row(
            children: [
              Icon(
                isDefeated ? Icons.check_circle : Icons.favorite,
                color: isDefeated ? Colors.green : Colors.red.shade400,
                size: 16,
              ),
              const Gap(8),
              Text(
                '$hpLeft / $bossHp',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: List.generate(segments, (i) {
              final isFilled = i < filledSegments;
              return Expanded(
                child: Container(
                  height: 12,
                  margin: EdgeInsets.only(right: i < segments - 1 ? 3 : 0),
                  decoration: BoxDecoration(
                    color: isFilled
                        ? (isDefeated ? Colors.green : Colors.red.shade400)
                        : Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isFilled
                          ? (isDefeated ? Colors.green.shade300 : Colors.red.shade300)
                          : Colors.white.withValues(alpha: 0.12),
                      width: 0.5,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MonsterStatBlock extends StatelessWidget {
  final int armorClass;
  final String hpDisplay;
  final List<String> abilities;
  final bool isDefeated;
  final int challengeRating;
  final DifficultyLevel difficulty;

  const _MonsterStatBlock({
    required this.armorClass,
    required this.hpDisplay,
    required this.abilities,
    required this.isDefeated,
    this.challengeRating = 3,
    this.difficulty = DifficultyLevel.medium,
  });

  @override
  Widget build(BuildContext context) {
    final diffLabel = switch (difficulty) {
      DifficultyLevel.easy => 'EASY',
      DifficultyLevel.medium => 'MEDIUM',
      DifficultyLevel.hard => 'HARD',
    };
    final diffColor = switch (difficulty) {
      DifficultyLevel.easy => Colors.green,
      DifficultyLevel.medium => Colors.orange,
      DifficultyLevel.hard => Colors.red,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STAT BLOCK',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const Gap(12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StatChip(label: 'AC', value: '$armorClass'),
                const Gap(12),
                _StatChip(label: 'HP', value: hpDisplay),
                const Gap(12),
                _StatChip(label: 'CR', value: '$challengeRating'),
                const Gap(12),
                _StatChip(label: 'Tier', value: diffLabel, valueColor: diffColor),
                const Gap(12),
                _StatChip(
                  label: 'Status',
                  value: isDefeated ? 'DEFEATED' : 'ACTIVE',
                  valueColor: isDefeated ? Colors.green : Colors.red.shade400,
                ),
              ],
            ),
          ),
          const Gap(12),
          const Divider(color: Colors.white12, height: 1),
          const Gap(12),
          Text(
            'ABILITIES',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const Gap(8),
          ...abilities.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.circle, size: 4, color: Colors.white.withValues(alpha: 0.3)),
                    const Gap(8),
                    Text(
                      a,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _StatChip({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(2),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MonsterPainter extends CustomPainter {
  final int visualType;
  final bool isDefeated;
  final double glowIntensity;
  final double phase;

  _MonsterPainter({
    required this.visualType,
    required this.isDefeated,
    required this.glowIntensity,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width / 100;

    if (isDefeated) {
      _drawDefeatedMonster(canvas, cx, cy, s);
      return;
    }

    switch (visualType) {
      case 1: _drawBoneColossus(canvas, cx, cy, s);
      case 2: _drawMemoryWraith(canvas, cx, cy, s);
      case 3: _drawLichLord(canvas, cx, cy, s);
      case 4: _drawStaticSpecter(canvas, cx, cy, s);
      case 5: _drawGoblinKing(canvas, cx, cy, s);
      case 6: _drawTheGlitch(canvas, cx, cy, s);
      case 7: _drawDataDragon(canvas, cx, cy, s);
      case 8: _drawVoidDisk(canvas, cx, cy, s);
      case 9: _drawBeholder(canvas, cx, cy, s);
      case 10: _drawBatteryWraith(canvas, cx, cy, s);
      case 11: _drawLagDragon(canvas, cx, cy, s);
      case 12: _drawStaticPhantom(canvas, cx, cy, s);
      case 13: _drawMalwareBeast(canvas, cx, cy, s);
      case 14: _drawNetworkHydra(canvas, cx, cy, s);
      default: _drawBoneColossus(canvas, cx, cy, s);
    }

    if (glowIntensity > 0.5) {
      _drawAura(canvas, cx, cy, s);
    }
  }

  void _drawAura(Canvas canvas, double cx, double cy, double s) {
    final auraPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.18 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(Offset(cx, cy), 85 * s, auraPaint);
  }

  void _drawBoneColossus(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final bodyPath = Path()
      ..moveTo(cx - 30 * s, cy + 30 * s)
      ..lineTo(cx - 35 * s, cy - 10 * s)
      ..quadraticBezierTo(cx - 30 * s, cy - 35 * s, cx, cy - 40 * s)
      ..quadraticBezierTo(cx + 30 * s, cy - 35 * s, cx + 35 * s, cy - 10 * s)
      ..lineTo(cx + 30 * s, cy + 30 * s)
      ..close();
    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFFE94560)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawPath(bodyPath, paint);

    for (var i = 0; i < 3; i++) {
      final eyeX = cx - 10 * s + i * 10 * s;
      paint
        ..color = const Color(0xFFFF0000)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(eyeX, cy - 15 * s), 4 * s, paint);
      paint
        ..color = Colors.black
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(eyeX, cy - 15 * s), 2 * s, paint);
    }
  }

  void _drawMemoryWraith(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF0D3B66).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 25 * s, cy + 30 * s)
      ..quadraticBezierTo(cx - 35 * s, cy - 5 * s, cx - 15 * s, cy - 30 * s)
      ..quadraticBezierTo(cx, cy - 42 * s, cx + 15 * s, cy - 30 * s)
      ..quadraticBezierTo(cx + 35 * s, cy - 5 * s, cx + 25 * s, cy + 30 * s)
      ..lineTo(cx + 15 * s, cy + 20 * s + sin(phase * 4) * 4 * s)
      ..lineTo(cx, cy + 28 * s)
      ..lineTo(cx - 15 * s, cy + 20 * s + sin(phase * 4 + 1) * 4 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFF6BB5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFF6BB5FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 18 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 18 * s), 4 * s, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 18 * s), 2 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 18 * s), 2 * s, paint);
  }

  void _drawLichLord(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF7B2D8B)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 25 * s, cy + 20 * s)
      ..quadraticBezierTo(cx - 35 * s, cy - 10 * s, cx - 15 * s, cy - 35 * s)
      ..quadraticBezierTo(cx, cy - 45 * s, cx + 15 * s, cy - 35 * s)
      ..quadraticBezierTo(cx + 35 * s, cy - 10 * s, cx + 25 * s, cy + 20 * s)
      ..quadraticBezierTo(cx, cy + 30 * s, cx - 25 * s, cy + 20 * s);
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 20 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 20 * s), 5 * s, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 20 * s), 2.5 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 20 * s), 2.5 * s, paint);
  }

  void _drawStaticSpecter(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    final hubRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 22 * s, cy - 25 * s, 44 * s, 50 * s),
      Radius.circular(8 * s),
    );
    canvas.drawRRect(hubRect, paint);
    paint
      ..color = const Color(0xFF4A90D9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawRRect(hubRect, paint);
    paint
      ..color = const Color(0xFF4A90D9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 6 * s, cy - 5 * s), 3 * s, paint);
    canvas.drawCircle(Offset(cx + 6 * s, cy - 5 * s), 3 * s, paint);
    paint
      ..color = const Color(0xFF4A90D9).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy - 25 * s), radius: (10 + i * 8) * s),
        -pi * 0.8, pi * 0.6, false, paint,
      );
    }
  }

  void _drawGoblinKing(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF2D6A4F)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 28 * s, cy + 25 * s)
      ..lineTo(cx - 32 * s, cy - 5 * s)
      ..quadraticBezierTo(cx - 25 * s, cy - 35 * s, cx, cy - 38 * s)
      ..quadraticBezierTo(cx + 25 * s, cy - 35 * s, cx + 32 * s, cy - 5 * s)
      ..lineTo(cx + 28 * s, cy + 25 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFFFFD166)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10 * s, cy - 15 * s), 6 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 15 * s), 6 * s, paint);
    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10 * s, cy - 15 * s), 3 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 15 * s), 3 * s, paint);
  }

  void _drawTheGlitch(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF0D2137)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 30 * s, cy + 25 * s)
      ..quadraticBezierTo(cx - 38 * s, cy - 10 * s, cx - 10 * s, cy - 35 * s)
      ..quadraticBezierTo(cx + 5 * s, cy - 45 * s, cx + 20 * s, cy - 30 * s)
      ..quadraticBezierTo(cx + 38 * s, cy - 10 * s, cx + 30 * s, cy + 25 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFFFF6B35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawPath(bodyPath, paint);
    for (var i = 0; i < 4; i++) {
      final glitchY = cy - 20 * s + i * 12 * s;
      final offset = sin(phase * 5 + i * 1.5) * 4 * s;
      paint
        ..color = const Color(0xFFFF6B35).withValues(alpha: 0.4 + 0.3 * sin(phase * 3 + i.toDouble()))
        ..strokeWidth = 1 * s;
      canvas.drawLine(Offset(cx - 20 * s + offset, glitchY), Offset(cx + 20 * s + offset, glitchY), paint);
    }
    paint
      ..color = const Color(0xFFFF4444)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 22 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 22 * s), 4 * s, paint);
  }

  void _drawDataDragon(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF8B0000)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 32 * s, cy + 25 * s)
      ..lineTo(cx - 35 * s, cy - 5 * s)
      ..quadraticBezierTo(cx - 28 * s, cy - 38 * s, cx, cy - 42 * s)
      ..quadraticBezierTo(cx + 28 * s, cy - 38 * s, cx + 35 * s, cy - 5 * s)
      ..lineTo(cx + 32 * s, cy + 25 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFFFF4444)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10 * s, cy - 18 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 18 * s), 5 * s, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10 * s, cy - 18 * s), 2.5 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 18 * s), 2.5 * s, paint);
  }

  void _drawVoidDisk(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF2D2D2D)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 35 * s, paint);
    paint
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawCircle(Offset(cx, cy), 35 * s, paint);
    paint
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 15 * s, paint);
    paint
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10 * s, cy - 10 * s), 3 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 10 * s), 3 * s, paint);
  }

  void _drawBeholder(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    for (var i = 8; i >= 0; i--) {
      final t = i / 8;
      paint.color = Color.lerp(const Color(0xFF0D0015), const Color(0xFF2D004B), t)!.withValues(alpha: 0.15 + t * 0.1);
      canvas.drawCircle(
        Offset(cx + sin(phase * 1.5 + i * 0.7) * 5 * s, cy + cos(phase * 1.2 + i * 0.5) * 5 * s),
        (50 - i * 5) * s, paint,
      );
    }
    paint
      ..color = const Color(0xFF9B30FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    final eyePath = Path()
      ..moveTo(cx - 20 * s, cy - 25 * s)
      ..quadraticBezierTo(cx, cy - 35 * s, cx + 20 * s, cy - 25 * s)
      ..quadraticBezierTo(cx + 5 * s, cy - 15 * s, cx, cy - 18 * s)
      ..quadraticBezierTo(cx - 5 * s, cy - 15 * s, cx - 20 * s, cy - 25 * s);
    canvas.drawPath(eyePath, paint);
    paint
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy - 24 * s), 4 * s, paint);
    paint.color = const Color(0xFFFF00FF);
    canvas.drawCircle(Offset(cx, cy - 24 * s), 2 * s, paint);
  }

  void _drawBatteryWraith(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF1B3A4B)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 25 * s, cy + 30 * s)
      ..quadraticBezierTo(cx - 35 * s, cy - 5 * s, cx - 15 * s, cy - 30 * s)
      ..quadraticBezierTo(cx, cy - 42 * s, cx + 15 * s, cy - 30 * s)
      ..quadraticBezierTo(cx + 35 * s, cy - 5 * s, cx + 25 * s, cy + 30 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(cx - 8 * s, cy - 12 * s, 16 * s, 22 * s), paint);
    paint
      ..color = const Color(0xFFFF4444)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 22 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 22 * s), 4 * s, paint);
  }

  void _drawLagDragon(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF0D2137)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 30 * s, cy + 25 * s)
      ..quadraticBezierTo(cx - 38 * s, cy - 10 * s, cx - 10 * s, cy - 35 * s)
      ..quadraticBezierTo(cx + 5 * s, cy - 45 * s, cx + 20 * s, cy - 30 * s)
      ..quadraticBezierTo(cx + 38 * s, cy - 10 * s, cx + 30 * s, cy + 25 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFFFF6B35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFFFF4444)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 22 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 22 * s), 4 * s, paint);
  }

  void _drawStaticPhantom(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF2E4057).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 25 * s, cy + 30 * s)
      ..quadraticBezierTo(cx - 35 * s, cy - 5 * s, cx - 15 * s, cy - 30 * s)
      ..quadraticBezierTo(cx, cy - 42 * s, cx + 15 * s, cy - 30 * s)
      ..quadraticBezierTo(cx + 35 * s, cy - 5 * s, cx + 25 * s, cy + 30 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 18 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 18 * s), 4 * s, paint);
    paint
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy - 30 * s), radius: (10 + i * 8) * s),
        -pi * 0.8, pi * 0.6, false, paint,
      );
    }
  }

  void _drawMalwareBeast(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF4A0E4E)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 30 * s, cy + 30 * s)
      ..quadraticBezierTo(cx - 40 * s, cy - 10 * s, cx - 15 * s, cy - 35 * s)
      ..quadraticBezierTo(cx, cy - 45 * s, cx + 15 * s, cy - 35 * s)
      ..quadraticBezierTo(cx + 40 * s, cy - 10 * s, cx + 30 * s, cy + 30 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    paint
      ..color = const Color(0xFFFF00FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10 * s, cy - 18 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 18 * s), 5 * s, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10 * s, cy - 18 * s), 2.5 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 18 * s), 2.5 * s, paint);
    paint
      ..color = const Color(0xFFFF00FF).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    for (var i = 0; i < 3; i++) {
      final angle = phase * 3 + i * 2.1;
      final tentaclePath = Path()
        ..moveTo(cx - 20 * s + i * 20 * s, cy + 25 * s)
        ..quadraticBezierTo(
          cx - 25 * s + i * 20 * s + sin(angle) * 12 * s, cy + 40 * s,
          cx - 15 * s + i * 20 * s + sin(angle * 1.3) * 8 * s, cy + 50 * s,
        );
      canvas.drawPath(tentaclePath, paint);
    }
  }

  void _drawNetworkHydra(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF1B4332)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 30 * s, cy + 25 * s)
      ..quadraticBezierTo(cx - 38 * s, cy - 10 * s, cx - 15 * s, cy - 30 * s)
      ..quadraticBezierTo(cx, cy - 42 * s, cx + 15 * s, cy - 30 * s)
      ..quadraticBezierTo(cx + 38 * s, cy - 10 * s, cx + 30 * s, cy + 25 * s)
      ..close();
    canvas.drawPath(bodyPath, paint);
    for (var i = -1; i <= 1; i++) {
      final headX = cx + i * 20 * s;
      final headY = cy - 35 * s + sin(phase * 2 + i) * 3 * s;
      paint
        ..color = const Color(0xFF2D6A4F)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(headX, headY), 10 * s, paint);
      paint
        ..color = const Color(0xFF00FF88)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(headX - 3 * s, headY - 2 * s), 2 * s, paint);
      canvas.drawCircle(Offset(headX + 3 * s, headY - 2 * s), 2 * s, paint);
    }
    paint
      ..color = const Color(0xFF2D6A4F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s;
    for (var i = -1; i <= 1; i++) {
      final headX = cx + i * 20 * s;
      final headY = cy - 35 * s + sin(phase * 2 + i) * 3 * s;
      canvas.drawLine(Offset(headX, headY + 10 * s), Offset(cx + i * 5 * s, cy - 10 * s), paint);
    }
  }

  void _drawDefeatedMonster(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 30 * s, paint);
    paint
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s;
    canvas.drawLine(Offset(cx - 15 * s, cy - 15 * s), Offset(cx + 15 * s, cy + 15 * s), paint);
    canvas.drawLine(Offset(cx + 15 * s, cy - 15 * s), Offset(cx - 15 * s, cy + 15 * s), paint);
  }

  @override
  bool shouldRepaint(covariant _MonsterPainter old) =>
      old.visualType != visualType ||
      old.isDefeated != isDefeated ||
      old.phase != phase;
}

class _ArenaParticlePainter extends CustomPainter {
  final double phase;
  final int visualType;

  _ArenaParticlePainter({required this.phase, required this.visualType});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42 + visualType);
    const colors = [
      Color(0xFFE94560), Color(0xFF6BB5FF), Color(0xFF7B2D8B), Color(0xFF4A90D9),
      Color(0xFF2D6A4F), Color(0xFFFF6B35), Color(0xFF8B0000), Color(0xFFFFD700),
      Color(0xFF9B30FF), Color(0xFF00E5FF), Color(0xFFFF6B35), Color(0xFF00E5FF),
      Color(0xFFFF00FF), Color(0xFF00FF88),
    ];
    final baseColor = colors[(visualType - 1).clamp(0, 13)];

    for (var i = 0; i < 30; i++) {
      final driftX = sin(phase * 1.5 + i * 0.7) * 20;
      final driftY = cos(phase * 1.2 + i * 0.5) * 15;
      final x = (rng.nextDouble() * size.width + driftX) % size.width;
      final y = (rng.nextDouble() * size.height + phase * 40 + driftY) % size.height;
      final radius = rng.nextDouble() * 3.0 + 1.0;
      final alpha = ((rng.nextDouble() * 80 + 40) * (0.4 + 0.4 * sin(phase * 2 + i))).toInt();

      final paint = Paint()
        ..color = baseColor.withValues(alpha: alpha / 255)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArenaParticlePainter old) => old.phase != phase;
}
