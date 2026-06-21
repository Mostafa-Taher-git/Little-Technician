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
    with TickerProviderStateMixin {
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

  static const _accentColors = {
    1: Color(0xFFCC3344),
    2: Color(0xFF00CCDD),
    3: Color(0xFF00FF88),
    4: Color(0xFFFF8800),
    5: Color(0xFFFFCC00),
    6: Color(0xFFFF4444),
    7: Color(0xFF00CCDD),
    8: Color(0xFFFFD700),
    9: Color(0xFFFF00FF),
    10: Color(0xFF00E5FF),
    11: Color(0xFFFF6600),
    12: Color(0xFF00E5FF),
    13: Color(0xFFFF00FF),
    14: Color(0xFF00FF88),
  };

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
      case 3: _drawKernelWraith(canvas, cx, cy, s);
      case 4: _drawFeedbackPhantom(canvas, cx, cy, s);
      case 5: _drawInputOverlord(canvas, cx, cy, s);
      case 6: _drawDependencyDemon(canvas, cx, cy, s);
      case 7: _drawLatencyLeviathan(canvas, cx, cy, s);
      case 8: _drawBitRotBehemoth(canvas, cx, cy, s);
      case 9: _drawPixelPunisher(canvas, cx, cy, s);
      case 10: _drawBatteryBanshee(canvas, cx, cy, s);
      case 11: _drawLagDragon(canvas, cx, cy, s);
      case 12: _drawStaticPhantom(canvas, cx, cy, s);
      case 13: _drawExploitEmperor(canvas, cx, cy, s);
      case 14: _drawPacketStorm(canvas, cx, cy, s);
      default: _drawBoneColossus(canvas, cx, cy, s);
    }

    if (glowIntensity > 0.5) {
      _drawAura(canvas, cx, cy, s);
    }
  }

  void _drawAura(Canvas canvas, double cx, double cy, double s) {
    final color = _accentColors[visualType] ?? Colors.red;
    final auraPaint = Paint()
      ..color = color.withValues(alpha: 0.18 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(Offset(cx, cy), 85 * s, auraPaint);
  }

  void _drawBoneColossus(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Body — broad rectangular torso
    final body = Path()
      ..moveTo(cx - 22 * s, cy + 30 * s)
      ..lineTo(cx - 22 * s, cy - 10 * s)
      ..quadraticBezierTo(cx - 20 * s, cy - 25 * s, cx, cy - 28 * s)
      ..quadraticBezierTo(cx + 20 * s, cy - 25 * s, cx + 22 * s, cy - 10 * s)
      ..lineTo(cx + 22 * s, cy + 30 * s)
      ..close();
    paint.color = const Color(0xFF5C1010);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // Left arm
    final leftArm = Path()
      ..moveTo(cx - 22 * s, cy - 5 * s)
      ..lineTo(cx - 38 * s, cy + 5 * s)
      ..lineTo(cx - 35 * s, cy + 25 * s)
      ..lineTo(cx - 22 * s, cy + 15 * s)
      ..close();
    paint.color = const Color(0xFF4A0C0C);
    canvas.drawPath(leftArm, paint);
    canvas.drawPath(leftArm, outline);
    // Right arm
    final rightArm = Path()
      ..moveTo(cx + 22 * s, cy - 5 * s)
      ..lineTo(cx + 38 * s, cy + 5 * s)
      ..lineTo(cx + 35 * s, cy + 25 * s)
      ..lineTo(cx + 22 * s, cy + 15 * s)
      ..close();
    canvas.drawPath(rightArm, paint);
    canvas.drawPath(rightArm, outline);
    // Head — small dome
    paint.color = const Color(0xFF5C1010);
    canvas.drawCircle(Offset(cx, cy - 35 * s), 12 * s, paint);
    canvas.drawCircle(Offset(cx, cy - 35 * s), 12 * s, outline);
    // Two curved horns
    final hornPaint = Paint()
      ..isAntiAlias = true
      ..color = const Color(0xFFD4C4A8)
      ..style = PaintingStyle.fill;
    final leftHorn = Path()
      ..moveTo(cx - 10 * s, cy - 42 * s)
      ..quadraticBezierTo(cx - 25 * s, cy - 55 * s, cx - 18 * s, cy - 60 * s)
      ..quadraticBezierTo(cx - 12 * s, cy - 55 * s, cx - 6 * s, cy - 42 * s)
      ..close();
    canvas.drawPath(leftHorn, hornPaint);
    canvas.drawPath(leftHorn, outline);
    final rightHorn = Path()
      ..moveTo(cx + 10 * s, cy - 42 * s)
      ..quadraticBezierTo(cx + 25 * s, cy - 55 * s, cx + 18 * s, cy - 60 * s)
      ..quadraticBezierTo(cx + 12 * s, cy - 55 * s, cx + 6 * s, cy - 42 * s)
      ..close();
    canvas.drawPath(rightHorn, hornPaint);
    canvas.drawPath(rightHorn, outline);
    // Three vertical red eyes
    for (var i = 0; i < 3; i++) {
      final eyeY = cy - 40 * s + i * 7 * s;
      paint.color = const Color(0xFFFF0000);
      canvas.drawCircle(Offset(cx, eyeY), 3 * s, paint);
      paint.color = const Color(0xFF1A1A1A);
      canvas.drawCircle(Offset(cx, eyeY), 1.5 * s, paint);
    }
  }

  void _drawMemoryWraith(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Body — serpentine shark
    final body = Path()
      ..moveTo(cx - 20 * s, cy + 30 * s)
      ..quadraticBezierTo(cx - 35 * s, cy + 10 * s, cx - 30 * s, cy - 10 * s)
      ..quadraticBezierTo(cx - 25 * s, cy - 30 * s, cx, cy - 35 * s)
      ..quadraticBezierTo(cx + 25 * s, cy - 30 * s, cx + 30 * s, cy - 10 * s)
      ..quadraticBezierTo(cx + 35 * s, cy + 10 * s, cx + 20 * s, cy + 30 * s)
      ..close();
    paint.color = const Color(0xFF0A2E5C);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // Dorsal fin
    final fin = Path()
      ..moveTo(cx - 3 * s, cy - 30 * s)
      ..lineTo(cx, cy - 48 * s)
      ..lineTo(cx + 8 * s, cy - 28 * s)
      ..close();
    paint.color = const Color(0xFF082244);
    canvas.drawPath(fin, paint);
    canvas.drawPath(fin, outline);
    // Massive open jaws
    final jawUpper = Path()
      ..moveTo(cx - 22 * s, cy + 5 * s)
      ..quadraticBezierTo(cx - 15 * s, cy - 5 * s, cx, cy - 8 * s)
      ..quadraticBezierTo(cx + 15 * s, cy - 5 * s, cx + 22 * s, cy + 5 * s)
      ..lineTo(cx + 18 * s, cy + 2 * s)
      ..lineTo(cx - 18 * s, cy + 2 * s)
      ..close();
    paint.color = const Color(0xFF061830);
    canvas.drawPath(jawUpper, paint);
    canvas.drawPath(jawUpper, outline);
    // Teeth
    final teethPaint = Paint()..color = const Color(0xFFF0F0F0);
    for (var i = -2; i <= 2; i++) {
      final tx = cx + i * 7 * s;
      final tooth = Path()
        ..moveTo(tx - 2 * s, cy + 2 * s)
        ..lineTo(tx, cy + 8 * s)
        ..lineTo(tx + 2 * s, cy + 2 * s)
        ..close();
      canvas.drawPath(tooth, teethPaint);
    }
    // Cyan fin tips
    paint.color = const Color(0xFF00CCEE);
    canvas.drawCircle(Offset(cx - 28 * s, cy - 5 * s), 3 * s, paint);
    canvas.drawCircle(Offset(cx + 28 * s, cy - 5 * s), 3 * s, paint);
    // Eyes
    paint.color = const Color(0xFFFFFFFF);
    canvas.drawCircle(Offset(cx - 10 * s, cy - 18 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 18 * s), 5 * s, paint);
    paint.color = const Color(0xFF0A2E5C);
    canvas.drawCircle(Offset(cx - 10 * s, cy - 18 * s), 2.5 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 18 * s), 2.5 * s, paint);
    // Jaws animate open/close
    final jawOffset = sin(phase * 2) * 3 * s;
    paint.color = const Color(0xFF061830);
    canvas.drawRect(Rect.fromLTWH(cx - 18 * s, cy + 2 * s, 36 * s, 4 * s + jawOffset), paint);
  }

  void _drawKernelWraith(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Robed body — tall narrow shape
    final robe = Path()
      ..moveTo(cx - 15 * s, cy + 35 * s)
      ..lineTo(cx - 25 * s, cy + 30 * s)
      ..quadraticBezierTo(cx - 28 * s, cy, cx - 18 * s, cy - 25 * s)
      ..quadraticBezierTo(cx - 10 * s, cy - 40 * s, cx, cy - 42 * s)
      ..quadraticBezierTo(cx + 10 * s, cy - 40 * s, cx + 18 * s, cy - 25 * s)
      ..quadraticBezierTo(cx + 28 * s, cy, cx + 25 * s, cy + 30 * s)
      ..lineTo(cx + 15 * s, cy + 35 * s)
      ..close();
    paint.color = const Color(0xFF3A0E5C);
    canvas.drawPath(robe, paint);
    canvas.drawPath(robe, outline);
    // Hood
    final hood = Path()
      ..moveTo(cx - 18 * s, cy - 20 * s)
      ..quadraticBezierTo(cx - 20 * s, cy - 38 * s, cx, cy - 45 * s)
      ..quadraticBezierTo(cx + 20 * s, cy - 38 * s, cx + 18 * s, cy - 20 * s)
      ..close();
    paint.color = const Color(0xFF2A0A44);
    canvas.drawPath(hood, paint);
    canvas.drawPath(hood, outline);
    // Two green glowing eyes
    paint.color = const Color(0xFF00FF88);
    canvas.drawCircle(Offset(cx - 7 * s, cy - 30 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 7 * s, cy - 30 * s), 4 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx - 7 * s, cy - 30 * s), 2 * s, paint);
    canvas.drawCircle(Offset(cx + 7 * s, cy - 30 * s), 2 * s, paint);
    // Orbiting rune circle
    final runePaint = Paint()
      ..color = const Color(0xFF00FF88).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    final runeAngle = phase * 1.5;
    final runeRadius = 35 * s;
    final runeX = cx + cos(runeAngle) * runeRadius;
    final runeY = cy - 10 * s + sin(runeAngle) * 10 * s;
    canvas.drawCircle(Offset(runeX, runeY), 5 * s, runePaint);
    paint.color = const Color(0xFF00FF88).withValues(alpha: 0.3);
    canvas.drawCircle(Offset(runeX, runeY), 8 * s, paint);
  }

  void _drawFeedbackPhantom(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Round body
    paint.color = const Color(0xFF2A3040);
    canvas.drawCircle(Offset(cx, cy), 30 * s, paint);
    canvas.drawCircle(Offset(cx, cy), 30 * s, outline);
    // Speaker-cone mouth — concentric circles
    paint.color = const Color(0xFF1A1E28);
    canvas.drawCircle(Offset(cx, cy + 5 * s), 18 * s, paint);
    paint.color = const Color(0xFFFF8800);
    canvas.drawCircle(Offset(cx, cy + 5 * s), 14 * s, paint);
    paint.color = const Color(0xFF1A1E28);
    canvas.drawCircle(Offset(cx, cy + 5 * s), 10 * s, paint);
    paint.color = const Color(0xFFFF8800).withValues(alpha: 0.5);
    canvas.drawCircle(Offset(cx, cy + 5 * s), 6 * s, paint);
    canvas.drawCircle(Offset(cx, cy + 5 * s), 18 * s, outline);
    // Two stubby arms
    paint.color = const Color(0xFF2A3040);
    final leftArm = Path()
      ..moveTo(cx - 28 * s, cy + 5 * s)
      ..lineTo(cx - 40 * s, cy + 15 * s)
      ..lineTo(cx - 35 * s, cy + 25 * s)
      ..lineTo(cx - 25 * s, cy + 15 * s)
      ..close();
    canvas.drawPath(leftArm, paint);
    canvas.drawPath(leftArm, outline);
    final rightArm = Path()
      ..moveTo(cx + 28 * s, cy + 5 * s)
      ..lineTo(cx + 40 * s, cy + 15 * s)
      ..lineTo(cx + 35 * s, cy + 25 * s)
      ..lineTo(cx + 25 * s, cy + 15 * s)
      ..close();
    canvas.drawPath(rightArm, paint);
    canvas.drawPath(rightArm, outline);
    // Eyes
    paint.color = const Color(0xFFFFCC00);
    canvas.drawCircle(Offset(cx - 10 * s, cy - 12 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 12 * s), 5 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx - 10 * s, cy - 12 * s), 2.5 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 12 * s), 2.5 * s, paint);
    // Sound rings pulse outward
    final ringPaint = Paint()
      ..color = const Color(0xFFFFCC00).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    for (var i = 1; i <= 3; i++) {
      final ringPhase = (phase * 2 + i * 0.8) % 3.0;
      final alpha = (0.3 - ringPhase * 0.1).clamp(0.0, 1.0);
      ringPaint.color = const Color(0xFFFFCC00).withValues(alpha: alpha);
      canvas.drawCircle(Offset(cx, cy + 5 * s), (20 + ringPhase * 15) * s, ringPaint);
    }
  }

  void _drawInputOverlord(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Wide flat crab body
    final body = Path()
      ..moveTo(cx - 30 * s, cy + 10 * s)
      ..quadraticBezierTo(cx - 35 * s, cy - 15 * s, cx, cy - 20 * s)
      ..quadraticBezierTo(cx + 35 * s, cy - 15 * s, cx + 30 * s, cy + 10 * s)
      ..quadraticBezierTo(cx, cy + 20 * s, cx - 30 * s, cy + 10 * s);
    paint.color = const Color(0xFF0E3A3A);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // 4 keyboard-key claws (2 per side)
    final clawPaint = Paint()..color = const Color(0xFFFFCC00);
    for (var i = 0; i < 2; i++) {
      final clawY = cy - 8 * s + i * 16 * s;
      // Left claw
      final leftClaw = RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - 48 * s, clawY - 5 * s, 16 * s, 10 * s),
        Radius.circular(2 * s),
      );
      canvas.drawRRect(leftClaw, clawPaint);
      canvas.drawRRect(leftClaw, outline);
      // Right claw
      final rightClaw = RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + 32 * s, clawY - 5 * s, 16 * s, 10 * s),
        Radius.circular(2 * s),
      );
      canvas.drawRRect(rightClaw, clawPaint);
      canvas.drawRRect(rightClaw, outline);
      // Claw click animation
      final clickOffset = sin(phase * 3 + i * 1.5) * 2 * s;
      canvas.drawRect(Rect.fromLTWH(cx - 48 * s + clickOffset, clawY - 5 * s, 16 * s, 10 * s), clawPaint);
      canvas.drawRect(Rect.fromLTWH(cx + 32 * s - clickOffset, clawY - 5 * s, 16 * s, 10 * s), clawPaint);
    }
    // Single large cyclops eye
    paint.color = const Color(0xFFFF0000);
    canvas.drawCircle(Offset(cx, cy - 5 * s), 10 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx, cy - 5 * s), 5 * s, paint);
    paint.color = const Color(0xFFFFFFFF);
    canvas.drawCircle(Offset(cx - 2 * s, cy - 7 * s), 2 * s, paint);
    // 2 stubby legs
    paint.color = const Color(0xFF0A2E2E);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 12 * s, cy + 15 * s, 8 * s, 15 * s), Radius.circular(3 * s)),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx + 4 * s, cy + 15 * s, 8 * s, 15 * s), Radius.circular(3 * s)),
      paint,
    );
  }

  void _drawDependencyDemon(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Tiny body
    final body = Path()
      ..moveTo(cx - 12 * s, cy + 15 * s)
      ..quadraticBezierTo(cx - 18 * s, cy - 5 * s, cx, cy - 10 * s)
      ..quadraticBezierTo(cx + 18 * s, cy - 5 * s, cx + 12 * s, cy + 15 * s)
      ..close();
    paint.color = const Color(0xFF5C1515);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // Oversized head
    paint.color = const Color(0xFF6B1A1A);
    canvas.drawCircle(Offset(cx, cy - 22 * s), 18 * s, paint);
    canvas.drawCircle(Offset(cx, cy - 22 * s), 18 * s, outline);
    // 2 small horns
    final hornPaint = Paint()..color = const Color(0xFF3A0A0A);
    final leftHorn = Path()
      ..moveTo(cx - 12 * s, cy - 35 * s)
      ..lineTo(cx - 16 * s, cy - 48 * s)
      ..lineTo(cx - 6 * s, cy - 35 * s)
      ..close();
    canvas.drawPath(leftHorn, hornPaint);
    canvas.drawPath(leftHorn, outline);
    final rightHorn = Path()
      ..moveTo(cx + 12 * s, cy - 35 * s)
      ..lineTo(cx + 16 * s, cy - 48 * s)
      ..lineTo(cx + 6 * s, cy - 35 * s)
      ..close();
    canvas.drawPath(rightHorn, hornPaint);
    canvas.drawPath(rightHorn, outline);
    // Yellow eyes
    paint.color = const Color(0xFFFFCC00);
    canvas.drawCircle(Offset(cx - 7 * s, cy - 25 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 7 * s, cy - 25 * s), 5 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx - 7 * s, cy - 25 * s), 2.5 * s, paint);
    canvas.drawCircle(Offset(cx + 7 * s, cy - 25 * s), 2.5 * s, paint);
    // Chain links dangling from body
    final chainPaint = Paint()
      ..color = const Color(0xFF888888)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    for (var i = 0; i < 3; i++) {
      final chainX = cx - 10 * s + i * 10 * s;
      final swing = sin(phase * 2 + i * 1.2) * 5 * s;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(chainX + swing, cy + 25 * s), width: 4 * s, height: 6 * s),
        chainPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(chainX + swing, cy + 32 * s), width: 4 * s, height: 6 * s),
        chainPaint,
      );
    }
  }

  void _drawLatencyLeviathan(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Massive whale/squid body
    final body = Path()
      ..moveTo(cx - 35 * s, cy + 10 * s)
      ..quadraticBezierTo(cx - 40 * s, cy - 20 * s, cx - 20 * s, cy - 30 * s)
      ..quadraticBezierTo(cx, cy - 40 * s, cx + 20 * s, cy - 30 * s)
      ..quadraticBezierTo(cx + 40 * s, cy - 20 * s, cx + 35 * s, cy + 10 * s)
      ..quadraticBezierTo(cx, cy + 25 * s, cx - 35 * s, cy + 10 * s);
    paint.color = const Color(0xFF0D0D3B);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // 4 tentacles underneath
    final tentPaint = Paint()
      ..color = const Color(0xFF1A1A5C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * s
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      final tx = cx - 18 * s + i * 12 * s;
      final tentSwing = sin(phase * 1.5 + i * 0.9) * 8 * s;
      final tentPath = Path()
        ..moveTo(tx, cy + 15 * s)
        ..quadraticBezierTo(tx + tentSwing, cy + 35 * s, tx + tentSwing * 0.5, cy + 50 * s);
      canvas.drawPath(tentPath, tentPaint);
    }
    // Cyan data stream trailing behind
    final streamPaint = Paint()
      ..color = const Color(0xFF00CCEE).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    for (var i = 0; i < 5; i++) {
      final sx = cx + 30 * s + i * 8 * s;
      final sy = cy - 15 * s + sin(phase * 2 + i * 0.5) * 5 * s;
      canvas.drawCircle(Offset(sx, sy), 2 * s, streamPaint);
    }
    // Eye
    paint.color = const Color(0xFF00CCEE);
    canvas.drawCircle(Offset(cx - 15 * s, cy - 15 * s), 6 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx - 15 * s, cy - 15 * s), 3 * s, paint);
  }

  void _drawBitRotBehemoth(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Dome shell
    final shell = Path()
      ..moveTo(cx - 30 * s, cy + 10 * s)
      ..quadraticBezierTo(cx - 35 * s, cy - 25 * s, cx, cy - 30 * s)
      ..quadraticBezierTo(cx + 35 * s, cy - 25 * s, cx + 30 * s, cy + 10 * s)
      ..close();
    paint.color = const Color(0xFF2D2D2D);
    canvas.drawPath(shell, paint);
    canvas.drawPath(shell, outline);
    // Body underneath
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawRect(Rect.fromLTWH(cx - 25 * s, cy + 8 * s, 50 * s, 15 * s), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 25 * s, cy + 8 * s, 50 * s, 15 * s), outline);
    // Gold corruption cracks — pulse
    final crackPaint = Paint()
      ..color = const Color(0xFFFFD700).withValues(alpha: 0.5 + 0.3 * sin(phase * 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    final crack1 = Path()
      ..moveTo(cx - 5 * s, cy - 25 * s)
      ..lineTo(cx - 10 * s, cy - 15 * s)
      ..lineTo(cx - 3 * s, cy - 5 * s);
    canvas.drawPath(crack1, crackPaint);
    final crack2 = Path()
      ..moveTo(cx + 8 * s, cy - 22 * s)
      ..lineTo(cx + 12 * s, cy - 12 * s)
      ..lineTo(cx + 5 * s, cy - 2 * s);
    canvas.drawPath(crack2, crackPaint);
    final crack3 = Path()
      ..moveTo(cx - 15 * s, cy - 18 * s)
      ..lineTo(cx - 20 * s, cy - 8 * s);
    canvas.drawPath(crack3, crackPaint);
    // 4 stubby legs
    paint.color = const Color(0xFF1A1A1A);
    for (var i = 0; i < 2; i++) {
      final lx = cx - 18 * s + i * 30 * s;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(lx, cy + 22 * s, 8 * s, 10 * s), Radius.circular(2 * s)),
        paint,
      );
    }
    // Head poking out
    paint.color = const Color(0xFF2D2D2D);
    canvas.drawCircle(Offset(cx, cy - 5 * s), 10 * s, paint);
    canvas.drawCircle(Offset(cx, cy - 5 * s), 10 * s, outline);
    // Eyes
    paint.color = const Color(0xFFFF0000);
    canvas.drawCircle(Offset(cx - 4 * s, cy - 7 * s), 3 * s, paint);
    canvas.drawCircle(Offset(cx + 4 * s, cy - 7 * s), 3 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx - 4 * s, cy - 7 * s), 1.5 * s, paint);
    canvas.drawCircle(Offset(cx + 4 * s, cy - 7 * s), 1.5 * s, paint);
  }

  void _drawPixelPunisher(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Angular triangular body
    final body = Path()
      ..moveTo(cx, cy - 35 * s)
      ..lineTo(cx - 30 * s, cy + 25 * s)
      ..lineTo(cx + 30 * s, cy + 25 * s)
      ..close();
    paint.color = const Color(0xFF2A0E4A);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // Single large eye with magenta iris
    paint.color = const Color(0xFFFF00FF);
    canvas.drawCircle(Offset(cx, cy - 5 * s), 12 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx, cy - 5 * s), 7 * s, paint);
    // Pixel grid pupil — cyan lines scanning
    final gridPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * s;
    final scanOffset = (phase * 10) % 14;
    for (var i = -3; i <= 3; i++) {
      final gy = cy - 5 * s + i * 2 * s;
      final gx = cx - 6 * s + scanOffset;
      canvas.drawLine(Offset(gx, gy), Offset(gx + 12 * s, gy), gridPaint);
    }
    for (var i = -3; i <= 3; i++) {
      final gx = cx - 6 * s + i * 2 * s;
      final gy = cy - 5 * s + scanOffset;
      canvas.drawLine(Offset(gx, gy - 6 * s), Offset(gx, gy + 6 * s), gridPaint);
    }
    // Sharp edges — small triangles at corners
    paint.color = const Color(0xFF1E0838);
    final edge1 = Path()
      ..moveTo(cx - 30 * s, cy + 25 * s)
      ..lineTo(cx - 40 * s, cy + 30 * s)
      ..lineTo(cx - 28 * s, cy + 30 * s)
      ..close();
    canvas.drawPath(edge1, paint);
    canvas.drawPath(edge1, outline);
    final edge2 = Path()
      ..moveTo(cx + 30 * s, cy + 25 * s)
      ..lineTo(cx + 40 * s, cy + 30 * s)
      ..lineTo(cx + 28 * s, cy + 30 * s)
      ..close();
    canvas.drawPath(edge2, paint);
    canvas.drawPath(edge2, outline);
  }

  void _drawBatteryBanshee(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Thin hunched body
    final body = Path()
      ..moveTo(cx - 15 * s, cy + 30 * s)
      ..quadraticBezierTo(cx - 20 * s, cy - 5 * s, cx - 10 * s, cy - 25 * s)
      ..quadraticBezierTo(cx, cy - 35 * s, cx + 10 * s, cy - 25 * s)
      ..quadraticBezierTo(cx + 20 * s, cy - 5 * s, cx + 15 * s, cy + 30 * s)
      ..close();
    paint.color = const Color(0xFF0E2A3A);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // Battery icon on chest
    final battFill = (sin(phase * 1.5) + 1) / 2;
    paint.color = const Color(0xFF0E1E28);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 8 * s, cy - 15 * s, 16 * s, 22 * s), Radius.circular(2 * s)),
      paint,
    );
    paint.color = const Color(0xFF00E5FF);
    canvas.drawRect(Rect.fromLTWH(cx - 5 * s, cy - 10 * s, 10 * s, 16 * s * battFill), paint);
    paint.color = const Color(0xFF00E5FF);
    canvas.drawRect(Rect.fromLTWH(cx - 3 * s, cy - 18 * s, 6 * s, 3 * s), paint);
    // Long thin limbs — arms reaching forward
    paint.color = const Color(0xFF0A2030);
    final leftArm = Path()
      ..moveTo(cx - 14 * s, cy - 10 * s)
      ..lineTo(cx - 35 * s, cy - 5 * s)
      ..lineTo(cx - 38 * s, cy + 5 * s)
      ..lineTo(cx - 14 * s, cy)
      ..close();
    canvas.drawPath(leftArm, paint);
    canvas.drawPath(leftArm, outline);
    final rightArm = Path()
      ..moveTo(cx + 14 * s, cy - 10 * s)
      ..lineTo(cx + 35 * s, cy - 5 * s)
      ..lineTo(cx + 38 * s, cy + 5 * s)
      ..lineTo(cx + 14 * s, cy)
      ..close();
    canvas.drawPath(rightArm, paint);
    canvas.drawPath(rightArm, outline);
    // Eyes
    paint.color = const Color(0xFFFF0000);
    canvas.drawCircle(Offset(cx - 5 * s, cy - 22 * s), 3 * s, paint);
    canvas.drawCircle(Offset(cx + 5 * s, cy - 22 * s), 3 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx - 5 * s, cy - 22 * s), 1.5 * s, paint);
    canvas.drawCircle(Offset(cx + 5 * s, cy - 22 * s), 1.5 * s, paint);
  }

  void _drawLagDragon(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Classic dragon body
    final body = Path()
      ..moveTo(cx - 25 * s, cy + 20 * s)
      ..quadraticBezierTo(cx - 30 * s, cy - 10 * s, cx - 15 * s, cy - 25 * s)
      ..quadraticBezierTo(cx, cy - 35 * s, cx + 15 * s, cy - 25 * s)
      ..quadraticBezierTo(cx + 30 * s, cy - 10 * s, cx + 25 * s, cy + 20 * s)
      ..close();
    paint.color = const Color(0xFF0A1530);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // Wings — orange membrane
    final wingPaint = Paint()..color = const Color(0xFFFF6600);
    final leftWing = Path()
      ..moveTo(cx - 20 * s, cy - 15 * s)
      ..lineTo(cx - 45 * s, cy - 35 * s + sin(phase * 1.2) * 5 * s)
      ..lineTo(cx - 38 * s, cy - 15 * s + sin(phase * 1.2) * 3 * s)
      ..lineTo(cx - 30 * s, cy - 25 * s + sin(phase * 1.2) * 4 * s)
      ..lineTo(cx - 20 * s, cy - 10 * s)
      ..close();
    canvas.drawPath(leftWing, wingPaint);
    canvas.drawPath(leftWing, outline);
    final rightWing = Path()
      ..moveTo(cx + 20 * s, cy - 15 * s)
      ..lineTo(cx + 45 * s, cy - 35 * s + sin(phase * 1.2 + pi) * 5 * s)
      ..lineTo(cx + 38 * s, cy - 15 * s + sin(phase * 1.2 + pi) * 3 * s)
      ..lineTo(cx + 30 * s, cy - 25 * s + sin(phase * 1.2 + pi) * 4 * s)
      ..lineTo(cx + 20 * s, cy - 10 * s)
      ..close();
    canvas.drawPath(rightWing, wingPaint);
    canvas.drawPath(rightWing, outline);
    // 2 horns
    paint.color = const Color(0xFF0A1530);
    final leftHorn = Path()
      ..moveTo(cx - 8 * s, cy - 28 * s)
      ..lineTo(cx - 14 * s, cy - 42 * s)
      ..lineTo(cx - 3 * s, cy - 28 * s)
      ..close();
    canvas.drawPath(leftHorn, paint);
    canvas.drawPath(leftHorn, outline);
    final rightHorn = Path()
      ..moveTo(cx + 8 * s, cy - 28 * s)
      ..lineTo(cx + 14 * s, cy - 42 * s)
      ..lineTo(cx + 3 * s, cy - 28 * s)
      ..close();
    canvas.drawPath(rightHorn, paint);
    canvas.drawPath(rightHorn, outline);
    // Eyes
    paint.color = const Color(0xFFFF0000);
    canvas.drawCircle(Offset(cx - 8 * s, cy - 18 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 18 * s), 4 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx - 8 * s, cy - 18 * s), 2 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 18 * s), 2 * s, paint);
    // Tail
    final tailPaint = Paint()
      ..color = const Color(0xFF0A1530)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * s
      ..strokeCap = StrokeCap.round;
    final tailPath = Path()
      ..moveTo(cx, cy + 20 * s)
      ..quadraticBezierTo(cx + 15 * s, cy + 30 * s, cx + 25 * s + sin(phase * 1.5) * 5 * s, cy + 35 * s);
    canvas.drawPath(tailPath, tailPaint);
  }

  void _drawStaticPhantom(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Central orb
    paint.color = const Color(0xFF1A1A2E);
    canvas.drawCircle(Offset(cx, cy), 20 * s, paint);
    canvas.drawCircle(Offset(cx, cy), 20 * s, outline);
    // Eyes
    paint.color = const Color(0xFF00E5FF);
    canvas.drawCircle(Offset(cx - 7 * s, cy - 3 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 7 * s, cy - 3 * s), 5 * s, paint);
    paint.color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(cx - 7 * s, cy - 3 * s), 2.5 * s, paint);
    canvas.drawCircle(Offset(cx + 7 * s, cy - 3 * s), 2.5 * s, paint);
    // 3 orbiting satellites
    for (var i = 0; i < 3; i++) {
      final angle = phase * 1.8 + i * (2 * pi / 3);
      final satX = cx + cos(angle) * 32 * s;
      final satY = cy + sin(angle) * 32 * s;
      paint.color = const Color(0xFF00E5FF);
      canvas.drawCircle(Offset(satX, satY), 5 * s, paint);
      canvas.drawCircle(Offset(satX, satY), 5 * s, outline);
      // Connection line
      final linePaint = Paint()
        ..color = const Color(0xFF00E5FF).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 * s;
      canvas.drawLine(Offset(cx, cy), Offset(satX, satY), linePaint);
    }
    // WiFi arcs above
    final arcPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.2 + 0.1 * sin(phase * 2))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy - 20 * s), radius: (10 + i * 8) * s),
        -pi * 0.8, pi * 0.6, false, arcPaint,
      );
    }
  }

  void _drawExploitEmperor(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Armored torso — rectangular
    final torso = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 18 * s, cy - 15 * s, 36 * s, 40 * s),
      Radius.circular(4 * s),
    );
    paint.color = const Color(0xFF2A2A3A);
    canvas.drawRRect(torso, paint);
    canvas.drawRRect(torso, outline);
    // Helmet — dome with visor slit
    paint.color = const Color(0xFF2A2A3A);
    canvas.drawCircle(Offset(cx, cy - 28 * s), 15 * s, paint);
    canvas.drawCircle(Offset(cx, cy - 28 * s), 15 * s, outline);
    // Visor slit
    final visorPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(cx - 12 * s, cy - 30 * s, 24 * s, 5 * s), visorPaint);
    // Magenta eyes through visor
    paint.color = const Color(0xFFFF00FF);
    canvas.drawCircle(Offset(cx - 5 * s, cy - 28 * s), 2 * s, paint);
    canvas.drawCircle(Offset(cx + 5 * s, cy - 28 * s), 2 * s, paint);
    // Crown
    final crownPaint = Paint()..color = const Color(0xFFFFD700);
    final crown = Path()
      ..moveTo(cx - 12 * s, cy - 40 * s)
      ..lineTo(cx - 10 * s, cy - 50 * s)
      ..lineTo(cx - 5 * s, cy - 43 * s)
      ..lineTo(cx, cy - 52 * s)
      ..lineTo(cx + 5 * s, cy - 43 * s)
      ..lineTo(cx + 10 * s, cy - 50 * s)
      ..lineTo(cx + 12 * s, cy - 40 * s)
      ..close();
    canvas.drawPath(crown, crownPaint);
    canvas.drawPath(crown, outline);
    // Magenta gem in crown
    paint.color = const Color(0xFFFF00FF);
    canvas.drawCircle(Offset(cx, cy - 46 * s), 3 * s, paint);
    // Shield on left
    final shieldPaint = Paint()..color = const Color(0xFF3A3A4A);
    final shield = Path()
      ..moveTo(cx - 30 * s, cy - 10 * s)
      ..lineTo(cx - 30 * s, cy + 15 * s)
      ..quadraticBezierTo(cx - 30 * s, cy + 22 * s, cx - 22 * s, cy + 22 * s)
      ..quadraticBezierTo(cx - 30 * s, cy + 22 * s, cx - 30 * s, cy + 15 * s)
      ..close();
    canvas.drawPath(shield, shieldPaint);
    canvas.drawPath(shield, outline);
    // Sword on right — key-shaped
    final swordPaint = Paint()
      ..color = const Color(0xFFAAAAAA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + 22 * s, cy - 5 * s), Offset(cx + 22 * s, cy + 25 * s), swordPaint);
    canvas.drawLine(Offset(cx + 18 * s, cy + 5 * s), Offset(cx + 26 * s, cy + 5 * s), swordPaint);
    // Key teeth at bottom
    canvas.drawLine(Offset(cx + 20 * s, cy + 22 * s), Offset(cx + 22 * s, cy + 25 * s), swordPaint);
    canvas.drawLine(Offset(cx + 24 * s, cy + 22 * s), Offset(cx + 22 * s, cy + 25 * s), swordPaint);
    // Gem glow pulse on sword
    final gemGlow = Paint()
      ..color = const Color(0xFFFF00FF).withValues(alpha: 0.3 + 0.2 * sin(phase * 2));
    canvas.drawCircle(Offset(cx + 22 * s, cy + 5 * s), 4 * s, gemGlow);
  }

  void _drawPacketStorm(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final outline = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 3 * s;
    // Thick body
    final body = Path()
      ..moveTo(cx - 25 * s, cy + 25 * s)
      ..quadraticBezierTo(cx - 30 * s, cy - 5 * s, cx - 15 * s, cy - 20 * s)
      ..quadraticBezierTo(cx, cy - 28 * s, cx + 15 * s, cy - 20 * s)
      ..quadraticBezierTo(cx + 30 * s, cy - 5 * s, cx + 25 * s, cy + 25 * s)
      ..close();
    paint.color = const Color(0xFF0D2B1A);
    canvas.drawPath(body, paint);
    canvas.drawPath(body, outline);
    // 3 necks
    paint.color = const Color(0xFF0D2B1A);
    final neckPaint = Paint()
      ..color = const Color(0xFF0D2B1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 * s
      ..strokeCap = StrokeCap.round;
    for (var i = -1; i <= 1; i++) {
      final neckX = cx + i * 12 * s;
      canvas.drawLine(Offset(neckX, cy - 18 * s), Offset(neckX + i * 5 * s, cy - 35 * s), neckPaint);
    }
    // 3 distinct heads — different colors
    final headColors = [const Color(0xFFFF4444), const Color(0xFF4488FF), const Color(0xFF44FF44)];
    final eyeColors = [const Color(0xFFFFAAAA), const Color(0xFFAAAADD), const Color(0xAAFFAAAA)];
    for (var i = -1; i <= 1; i++) {
      final headX = cx + i * 18 * s;
      final headY = cy - 40 * s + sin(phase * 2 + i) * 3 * s;
      paint.color = headColors[i + 1];
      canvas.drawCircle(Offset(headX, headY), 12 * s, paint);
      canvas.drawCircle(Offset(headX, headY), 12 * s, outline);
      // Eyes
      paint.color = const Color(0xFF1A1A1A);
      canvas.drawCircle(Offset(headX - 4 * s, headY - 2 * s), 3 * s, paint);
      canvas.drawCircle(Offset(headX + 4 * s, headY - 2 * s), 3 * s, paint);
      paint.color = eyeColors[i + 1];
      canvas.drawCircle(Offset(headX - 4 * s, headY - 2 * s), 1.5 * s, paint);
      canvas.drawCircle(Offset(headX + 4 * s, headY - 2 * s), 1.5 * s, paint);
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
