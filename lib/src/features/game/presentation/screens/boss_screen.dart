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

class BossScreen extends StatefulWidget {
  final WorldDef world;

  const BossScreen({super.key, required this.world});

  @override
  State<BossScreen> createState() => _BossScreenState();
}

class _BossScreenState extends State<BossScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bossController;
  late Animation<double> _breathAnimation;
  late Animation<double> _glowPulse;
  late Animation<double> _entranceAnimation;

  int _currentPhase = 0;
  String? _lastOutcome;

  static const _bossAbilities = {
    1: ['Crushing Charge', 'Bone Wall', 'Rotting Aura'],
    2: ['Soul Drain', 'Life Sap', 'Death Gaze'],
    3: ['Goblin Frenzy', 'Tangle Trap', 'Sneak Attack'],
    4: ['Dragon Breath', 'Wing Gust', 'Tail Slam'],
    5: ['Death Ray', 'Disintegrate', 'Anti-Magic Cone'],
  };

  static const _bossArmor = {1: 14, 2: 16, 3: 12, 4: 15, 5: 18};

  static const Map<int, List<Map<String, dynamic>>> _strategies = {
    1: [
      {'name': 'Aim for the joints', 'success': 70, 'damage': 2, 'flavor': 'You strike the bone joints! The colossus stumbles!', 'failFlavor': 'Your attack clangs harmlessly off the thick bone.'},
      {'name': 'Target the eye cores', 'success': 50, 'damage': 3, 'flavor': 'You shatter a glowing eye core! The colossus roars!', 'failFlavor': 'The eyes are too well-guarded — your attack misses.'},
      {'name': 'Defensive stance', 'success': 90, 'damage': 1, 'flavor': 'You find a small opening and strike.', 'failFlavor': 'The colossus anticipated your move.'},
    ],
    2: [
      {'name': 'Dispel the aura', 'success': 60, 'damage': 2, 'flavor': 'Your strike disrupts the lich\'s dark aura!', 'failFlavor': 'The lich\'s shield deflects your magic.'},
      {'name': 'Attack the phylactery', 'success': 40, 'damage': 4, 'flavor': 'You crack the phylactery! The lich screams!', 'failFlavor': 'The phylactery is heavily warded.'},
      {'name': 'Holy infusion', 'success': 80, 'damage': 1, 'flavor': 'Your blade glows with holy light and connects!', 'failFlavor': 'The lich\'s darkness extinguishes your light.'},
    ],
    3: [
      {'name': 'Sever the cables', 'success': 65, 'damage': 2, 'flavor': 'You cut through the tangled cables!', 'failFlavor': 'More cables spring up to replace them.'},
      {'name': 'Trap the goblin', 'success': 45, 'damage': 3, 'flavor': 'The goblin king is caught! You land a solid hit!', 'failFlavor': 'He dodges into a side tunnel.'},
      {'name': 'Rush attack', 'success': 85, 'damage': 1, 'flavor': 'Your aggressive push lands a blow!', 'failFlavor': 'He parries and counterattacks.'},
    ],
    4: [
      {'name': 'Aim for the wings', 'success': 55, 'damage': 2, 'flavor': 'You clip the dragon\'s wing!', 'failFlavor': 'The dragon\'s scales deflect your blade.'},
      {'name': 'Throw a net', 'success': 35, 'damage': 4, 'flavor': 'The net tangles the whelp! Massive opening!', 'failFlavor': 'The dragon breathes fire, burning the net.'},
      {'name': 'Guard and wait', 'success': 80, 'damage': 1, 'flavor': 'You find an opening as the dragon tires.', 'failFlavor': 'The dragon\'s tail catches you off guard.'},
    ],
    5: [
      {'name': 'Close the eye', 'success': 50, 'damage': 3, 'flavor': 'You seal one of the beholder\'s eyes!', 'failFlavor': 'The eye ray forces you back.'},
      {'name': 'Reflective shield', 'success': 30, 'damage': 5, 'flavor': 'The beholder\'s own ray reflects back! Critical hit!', 'failFlavor': 'The shield shatters under the magical assault.'},
      {'name': 'Hit the central eye', 'success': 70, 'damage': 1, 'flavor': 'You land a quick strike on the main eye!', 'failFlavor': 'The beholder blinks and your attack misses.'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _bossController = AnimationController(
      vsync: this,
      duration: 2000.ms,
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _bossController, curve: Curves.easeInOutSine),
    );

    _glowPulse = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _bossController, curve: Curves.easeInOutSine),
    );

    _entranceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bossController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutBack),
      ),
    );
  }

  @override
  void dispose() {
    _bossController.dispose();
    super.dispose();
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

  Widget _buildPhaseStrategy(int bossIndex) {
    final strategies = _strategies[bossIndex] ?? _strategies[1]!;
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
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => setState(() => _currentPhase = 1),
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
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('BOSS ENCOUNTER', style: TextStyle(letterSpacing: 2)),
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (_, state) {
          final boss = widget.world.boss;
          final hpLeft = state.currentBossHp;
          final isDefeated = hpLeft <= 0;
          final bossIndex = widget.world.id;
          final abilities = _bossAbilities[bossIndex] ?? [];
          final armorClass = _bossArmor[bossIndex] ?? 14;

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
              Positioned.fill(
                child: CustomPaint(
                  painter: _ArenaParticlePainter(
                    phase: _bossController.value,
                    bossIndex: bossIndex,
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
                          opacity: _entranceAnimation.value,
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
                            bossIndex: bossIndex,
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
                      armorClass: armorClass,
                      hpDisplay: '${boss.hp}',
                      abilities: abilities,
                      isDefeated: isDefeated,
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
                            _buildPhaseStrategy(bossIndex)
                          else
                            _buildPhaseResolve(),
                          if (state.availableSupTechUses > 0 && !isDefeated) ...[
                            const Gap(16),
                            SupTechAvatar(
                              availableUses: state.availableSupTechUses,
                              isGlowing: true,
                              showWizardHat: true,
                              size: 48,
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

  const _MonsterStatBlock({
    required this.armorClass,
    required this.hpDisplay,
    required this.abilities,
    required this.isDefeated,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              _StatChip(label: 'AC', value: '$armorClass'),
              const Gap(16),
              _StatChip(label: 'HP', value: hpDisplay),
              const Gap(16),
              _StatChip(
                label: 'Status',
                value: isDefeated ? 'DEFEATED' : 'ACTIVE',
                valueColor: isDefeated ? Colors.green : Colors.red.shade400,
              ),
            ],
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
  final int bossIndex;
  final bool isDefeated;
  final double glowIntensity;
  final double phase;

  _MonsterPainter({
    required this.bossIndex,
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

    switch (bossIndex) {
      case 1:
        _drawBoneColossus(canvas, cx, cy, s);
      case 2:
        _drawLichLord(canvas, cx, cy, s);
      case 3:
        _drawGoblinKing(canvas, cx, cy, s);
      case 4:
        _drawDragonWhelp(canvas, cx, cy, s);
      case 5:
        _drawBeholder(canvas, cx, cy, s);
      default:
        _drawBoneColossus(canvas, cx, cy, s);
    }

    if (glowIntensity > 0.5) {
      _drawAura(canvas, cx, cy, s);
    }
  }

  void _drawAura(Canvas canvas, double cx, double cy, double s) {
    final auraPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.08 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(Offset(cx, cy), 60 * s, auraPaint);
  }

  void _drawBoneColossus(Canvas canvas, double cx, double cy, double s) {
    _drawBoneColossusBody(canvas, cx, cy, s);
    _drawBoneColossusJaw(canvas, cx, cy, s);
    _drawBoneColossusLegs(canvas, cx, cy, s);
  }

  void _drawBoneColossusBody(Canvas canvas, double cx, double cy, double s) {
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

  void _drawBoneColossusJaw(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final jawPath = Path()
      ..moveTo(cx - 20 * s, cy + 5 * s)
      ..lineTo(cx + 20 * s, cy + 5 * s)
      ..lineTo(cx + 15 * s, cy + 25 * s)
      ..lineTo(cx - 15 * s, cy + 25 * s)
      ..close();
    paint
      ..color = const Color(0xFF16213E)
      ..style = PaintingStyle.fill;
    canvas.drawPath(jawPath, paint);

    for (var i = 0; i < 4; i++) {
      final tooth = Path()
        ..moveTo(cx - 12 * s + i * 7 * s, cy + 10 * s)
        ..lineTo(cx - 9 * s + i * 7 * s, cy + 5 * s)
        ..lineTo(cx - 6 * s + i * 7 * s, cy + 10 * s)
        ..close();
      paint
        ..color = const Color(0xFFE8E8E8)
        ..style = PaintingStyle.fill;
      canvas.drawPath(tooth, paint);
    }
  }

  void _drawBoneColossusLegs(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 * s;

    for (var i = 0; i < 4; i++) {
      final angle = pi * 0.25 + i * pi * 0.5 + sin(phase * 4 + i.toDouble()) * 0.1;
      final legPath = Path()
        ..moveTo(cx - 20 * s + i * 12 * s, cy + 30 * s)
        ..lineTo(cx - 22 * s + i * 12 * s + sin(angle) * 5 * s, cy + 50 * s);
      canvas.drawPath(legPath, paint);
    }
  }

  void _drawLichLord(Canvas canvas, double cx, double cy, double s) {
    _drawKernelGhosts(canvas, cx, cy, s);
    _drawKernelBody(canvas, cx, cy, s);
    _drawKernelEyes(canvas, cx, cy, s);
    _drawKernelGlow(canvas, cx, cy, s);
    _drawKernelTentacles(canvas, cx, cy, s);
  }

  void _drawKernelGhosts(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (var i = 5; i >= 0; i--) {
      final alpha = (0.05 + i * 0.04).clamp(0.0, 1.0);
      final color = Colors.deepPurple.withValues(alpha: alpha);
      paint.color = color;
      canvas.drawCircle(
        Offset(
          cx + sin(phase * 3 + i * 1.2) * 10 * s,
          cy + cos(phase * 2 + i * 0.8) * 8 * s,
        ),
        (35 - i * 4) * s,
        paint,
      );
    }
  }

  void _drawKernelBody(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = const Color(0xFF7B2D8B)
      ..style = PaintingStyle.fill;
    final bodyPath = Path()
      ..moveTo(cx - 25 * s, cy + 20 * s)
      ..quadraticBezierTo(cx - 35 * s, cy - 10 * s, cx - 15 * s, cy - 35 * s)
      ..quadraticBezierTo(cx, cy - 45 * s, cx + 15 * s, cy - 35 * s)
      ..quadraticBezierTo(cx + 35 * s, cy - 10 * s, cx + 25 * s, cy + 20 * s)
      ..quadraticBezierTo(cx, cy + 30 * s, cx - 25 * s, cy + 20 * s);
    canvas.drawPath(bodyPath, paint);
  }

  void _drawKernelEyes(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    final color1 = const Color(0xFF00FF88).withValues(alpha: 0.8);
    paint.color = color1;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 20 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 20 * s), 5 * s, paint);

    paint.color = Colors.black;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 20 * s), 2.5 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 20 * s), 2.5 * s, paint);
  }

  void _drawKernelGlow(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = const Color(0xFF00FF88).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 20 * s), 7 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 20 * s), 7 * s, paint);
  }

  void _drawKernelTentacles(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = const Color(0xFF7B2D8B).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * s;

    for (var i = 0; i < 3; i++) {
      final angle = phase * 3 + i * 2.1;
      final tentaclePath = Path()
        ..moveTo(cx - 20 * s + i * 20 * s, cy + 20 * s)
        ..quadraticBezierTo(
          cx - 25 * s + i * 20 * s + sin(angle) * 15 * s,
          cy + 40 * s,
          cx - 15 * s + i * 20 * s + sin(angle * 1.3) * 10 * s,
          cy + 55 * s,
        );
      canvas.drawPath(tentaclePath, paint);
    }
  }

  void _drawGoblinKing(Canvas canvas, double cx, double cy, double s) {
    _drawGoblinKingBody(canvas, cx, cy, s);
    _drawGoblinKingEyes(canvas, cx, cy, s);
    _drawGoblinKingEars(canvas, cx, cy, s);
    _drawGoblinKingGrin(canvas, cx, cy, s);
    _drawGoblinKingArms(canvas, cx, cy, s);
  }

  void _drawGoblinKingBody(Canvas canvas, double cx, double cy, double s) {
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
      ..color = const Color(0xFF40916C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawPath(bodyPath, paint);
  }

  void _drawGoblinKingEyes(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFFFFD166)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10 * s, cy - 15 * s), 6 * s, paint);
    canvas.drawCircle(Offset(cx + 10 * s, cy - 15 * s), 6 * s, paint);

    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(cx - 10 * s + sin(phase * 2) * 1.5 * s, cy - 15 * s),
      3 * s,
      paint,
    );
    canvas.drawCircle(
      Offset(cx + 10 * s + sin(phase * 2) * 1.5 * s, cy - 15 * s),
      3 * s,
      paint,
    );
  }

  void _drawGoblinKingEars(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    paint
      ..color = const Color(0xFF2D6A4F)
      ..style = PaintingStyle.fill;

    final earPath = Path()
      ..moveTo(cx - 25 * s, cy - 25 * s)
      ..lineTo(cx - 30 * s, cy - 45 * s)
      ..lineTo(cx - 18 * s, cy - 30 * s)
      ..close();
    canvas.drawPath(earPath, paint);

    final earPath2 = Path()
      ..moveTo(cx + 25 * s, cy - 25 * s)
      ..lineTo(cx + 30 * s, cy - 45 * s)
      ..lineTo(cx + 18 * s, cy - 30 * s)
      ..close();
    canvas.drawPath(earPath2, paint);
  }

  void _drawGoblinKingGrin(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;
    final grin = Path()
      ..moveTo(cx - 15 * s, cy + 5 * s)
      ..quadraticBezierTo(cx, cy + 15 * s, cx + 15 * s, cy + 5 * s);
    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawPath(grin, paint);
  }

  void _drawGoblinKingArms(Canvas canvas, double cx, double cy, double s) {
    final armAngle = sin(phase * 3) * 0.2;
    final paint = Paint()..isAntiAlias = true;
    for (var sign in [-1.0, 1.0]) {
      paint
        ..color = const Color(0xFF2D6A4F)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(cx + sign * 35 * s, cy + 10 * s + armAngle * sign * 10 * s),
        7 * s,
        paint,
      );
      paint
        ..color = const Color(0xFF40916C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s;
      canvas.drawCircle(
        Offset(cx + sign * 35 * s, cy + 10 * s + armAngle * sign * 10 * s),
        7 * s,
        paint,
      );
    }
  }

  void _drawDragonWhelp(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;

    paint
      ..color = const Color(0xFF1B1B3A)
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
      ..color = const Color(0xFF3A3A6A)
      ..style = PaintingStyle.fill;
    final hatPath = Path()
      ..moveTo(cx - 40 * s, cy - 30 * s)
      ..lineTo(cx + 40 * s, cy - 30 * s)
      ..lineTo(cx + 30 * s, cy - 50 * s)
      ..lineTo(cx - 30 * s, cy - 50 * s)
      ..close();
    canvas.drawPath(hatPath, paint);

    paint
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy - 42 * s), 3 * s, paint);

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

    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    final eyePatch = Path()
      ..moveTo(cx + 10 * s, cy - 25 * s)
      ..lineTo(cx + 10 * s, cy - 10 * s);
    canvas.drawPath(eyePatch, paint);

    paint
      ..color = const Color(0xFF00B4D8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    for (var i = 0; i < 3; i++) {
      final angle = phase * 2 + i * 2.1;
      canvas.drawLine(
        Offset(cx - 35 * s, cy + 20 * s),
        Offset(
          cx - 42 * s + cos(angle) * 10 * s,
          cy + 35 * s + sin(angle) * 8 * s,
        ),
        paint..strokeWidth = (3 - i * 0.5) * s,
      );
    }

    paint
      ..color = const Color(0xFF0A9396).withValues(alpha: 0.2 + 0.15 * sin(phase * 3))
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(
          cx - 20 * s + i * 10 * s + sin(phase * 4 + i.toDouble()) * 3 * s,
          cy + 30 * s + cos(phase * 3 + i.toDouble()) * 2 * s,
        ),
        (2 + sin(phase * 2 + i.toDouble()) * 0.5) * s,
        paint,
      );
    }
  }

  void _drawBeholder(Canvas canvas, double cx, double cy, double s) {
    _drawBeholderCircles(canvas, cx, cy, s);
    _drawBeholderEye(canvas, cx, cy, s);
    _drawBeholderCore(canvas, cx, cy, s);
    _drawBeholderTentacles(canvas, cx, cy, s);
    _drawBeholderAura(canvas, cx, cy, s);
  }

  void _drawBeholderCircles(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    for (var i = 8; i >= 0; i--) {
      final t = i / 8;
      final color = Color.lerp(
        const Color(0xFF0D0015),
        const Color(0xFF2D004B),
        t,
      )!.withValues(alpha: 0.15 + t * 0.1);
      paint.color = color;
      canvas.drawCircle(
        Offset(cx + sin(phase * 1.5 + i * 0.7) * 5 * s, cy + cos(phase * 1.2 + i * 0.5) * 5 * s),
        (50 - i * 5) * s,
        paint,
      );
    }
  }

  void _drawBeholderEye(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = const Color(0xFF9B30FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    final eyePath = Path()
      ..moveTo(cx - 20 * s, cy - 25 * s)
      ..quadraticBezierTo(cx, cy - 35 * s, cx + 20 * s, cy - 25 * s)
      ..quadraticBezierTo(cx + 5 * s, cy - 15 * s, cx, cy - 18 * s)
      ..quadraticBezierTo(cx - 5 * s, cy - 15 * s, cx - 20 * s, cy - 25 * s);
    canvas.drawPath(eyePath, paint);
  }

  void _drawBeholderCore(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    final color1 = const Color(0xFFFFFFFF).withValues(alpha: 0.9);
    paint.color = color1;
    canvas.drawCircle(Offset(cx, cy - 24 * s), 4 * s, paint);

    paint.color = const Color(0xFFFF00FF);
    canvas.drawCircle(Offset(cx, cy - 24 * s), 2 * s, paint);

    final color2 = const Color(0xFFFF00FF).withValues(alpha: 0.3);
    paint.color = color2;
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(cx, cy - 24 * s), 10 * s, paint);
  }

  void _drawBeholderTentacles(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = const Color(0xFF9B30FF).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 * s;
    final highlightPaint = Paint()
      ..color = const Color(0xFF00FF88).withValues(alpha: 0.15 * glowIntensity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;

    for (var i = 0; i < 3; i++) {
      final angle = phase * 2.5 + i * 2.1;
      final tentaclePath = Path()
        ..moveTo(cx - 25 * s + i * 25 * s, cy + 25 * s)
        ..cubicTo(
          cx - 30 * s + i * 25 * s + cos(angle) * 15 * s,
          cy + 40 * s,
          cx - 20 * s + i * 25 * s + sin(angle * 1.5) * 20 * s,
          cy + 50 * s,
          cx - 25 * s + i * 25 * s + cos(angle * 0.8) * 10 * s,
          cy + 60 * s,
        );
      canvas.drawPath(tentaclePath, paint);
      canvas.drawPath(tentaclePath, highlightPaint);
    }
  }

  void _drawBeholderAura(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..color = const Color(0xFF9B30FF).withValues(alpha: 0.15 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(cx, cy), 30 * s, paint);
  }

  void _drawDefeatedMonster(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), 30 * s, paint);

    paint
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawCircle(Offset(cx, cy), 30 * s, paint);

    paint
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s;
    canvas.drawLine(
      Offset(cx - 15 * s, cy - 15 * s),
      Offset(cx + 15 * s, cy + 15 * s),
      paint,
    );
    canvas.drawLine(
      Offset(cx + 15 * s, cy - 15 * s),
      Offset(cx - 15 * s, cy + 15 * s),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MonsterPainter old) =>
      old.bossIndex != bossIndex ||
      old.isDefeated != isDefeated ||
      old.phase != phase;
}

class _ArenaParticlePainter extends CustomPainter {
  final double phase;
  final int bossIndex;

  _ArenaParticlePainter({required this.phase, required this.bossIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42 + bossIndex);
    final baseColor = [
      Colors.red,
      Colors.deepPurple,
      Colors.green,
      Colors.cyan,
      const Color(0xFF9B30FF),
    ][(bossIndex - 1).clamp(0, 4)];

    for (var i = 0; i < 30; i++) {
      final driftX = sin(phase * 1.5 + i * 0.7) * 15;
      final driftY = cos(phase * 1.2 + i * 0.5) * 10;
      final x = (rng.nextDouble() * size.width + driftX) % size.width;
      final y = (rng.nextDouble() * size.height + phase * 40 + driftY) % size.height;
      final radius = rng.nextDouble() * 2.0 + 0.5;
      final alpha = ((rng.nextDouble() * 30 + 10) * (0.4 + 0.4 * sin(phase * 2 + i))).toInt();

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = baseColor.withValues(alpha: alpha / 255),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArenaParticlePainter old) =>
      old.phase != phase;
}
