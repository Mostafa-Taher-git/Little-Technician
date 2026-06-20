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
  bool _navigatedToReward = false;
  bool _showDiagnosis = false;
  String? _diagnosisResult;

  static const _bossAbilities = {
    1: ['Crushing Charge', 'Bone Wall', 'Rotting Aura'],
    2: ['Soul Drain', 'Life Sap', 'Death Gaze'],
    3: ['Goblin Frenzy', 'Tangle Trap', 'Sneak Attack'],
    4: ['Dragon Breath', 'Wing Gust', 'Tail Slam'],
    5: ['Death Ray', 'Disintegrate', 'Anti-Magic Cone'],
    6: ['Battery Leech', 'Power Surge', 'Phantom Drain'],
    7: ['Frame Freeze', 'Lag Spike', 'Pixel Storm'],
    8: ['Signal Jam', 'Ghost Command', 'Static Shock'],
  };

  static const Map<int, Map<String, dynamic>> _bossDiagnoses = {
    1: {
      'symptoms': 'A towering construct of broken parts. It crushes everything with raw force and absorbs damage from broken hardware.',
      'options': ['It feeds on corrupted drivers', 'It is assembled from failed hardware components', 'It is a software virus'],
      'correct': 1,
      'flavor': 'You identify it as a hardware abomination! Your attacks deal bonus damage!',
      'failFlavor': 'Wrong diagnosis. The colossus gains extra armor.',
    },
    2: {
      'symptoms': 'An undead sorcerer that resurrects from crashes and drains system resources through dark processes.',
      'options': ['It is a network worm', 'It feeds on corrupted system files and process memory', 'It is a physical hardware issue'],
      'correct': 1,
      'flavor': 'Correct! You target the corrupted kernel files! Bonus damage!',
      'failFlavor': 'Wrong diagnosis. The lich heals itself.',
    },
    3: {
      'symptoms': 'A cunning creature that sabotages connected devices and traps you in tangled connections.',
      'options': ['It attacks through Wi-Fi signals', 'It is a virus spreading through USB drives', 'It traps and corrupts peripheral connections'],
      'correct': 2,
      'flavor': 'Brilliant! You identify the peripheral trap! Bonus damage!',
      'failFlavor': 'Wrong! The goblin strengthens his cable traps.',
    },
    4: {
      'symptoms': 'A dragon that hoards data packets and breathes fire through network connections, growing stronger with stolen bandwidth.',
      'options': ['It is a hardware overheating issue', 'It corrupts data through the network pipeline', 'It is a display driver problem'],
      'correct': 1,
      'flavor': 'Spot on! You target the data pipeline! Bonus damage!',
      'failFlavor': 'Wrong! The dragon floods the network.',
    },
    5: {
      'symptoms': 'A many-eyed creature that casts visual curses, corrupts display output, and sees through every camera and sensor.',
      'options': ['It is a simple monitor malfunction', 'It uses multiple surveillance vectors to cast display and security curses', 'It is a CPU bottleneck'],
      'correct': 1,
      'flavor': 'Perfect diagnosis! You counter its gaze abilities! Bonus damage!',
      'failFlavor': 'Wrong! The beholder unleashes all eye rays.',
    },
    6: {
      'symptoms': 'A spectral leech that drains battery life from every device it touches, leaving screens dim and processors starving for power.',
      'options': ['It is a hardware voltage issue', 'It feeds on background processes and battery-draining apps', 'It is a faulty charging cable'],
      'correct': 1,
      'flavor': 'Correct! You identify the power drain source! Bonus damage!',
      'failFlavor': 'Wrong diagnosis. The wraith drains more energy.',
    },
    7: {
      'symptoms': 'A corrupted game entity that spawns frame drops and lag spikes, slowing everything it touches to a crawl.',
      'options': ['It is a simple network ping issue', 'It corrupts the GPU pipeline and injects stutter into every render frame', 'It is a display resolution problem'],
      'correct': 1,
      'flavor': 'Spot on! You target the render pipeline! Bonus damage!',
      'failFlavor': 'Wrong! The lag dragon freezes your screen.',
    },
    8: {
      'symptoms': 'A possessed smart home hub that rewrites its own firmware, turns lights on at random, and ignores every voice command.',
      'options': ['It is a weak Wi-Fi signal', 'It has corrupted firmware that hijacks automation routines and voice processing', 'It is a dead smart bulb battery'],
      'correct': 1,
      'flavor': 'Brilliant! You target the corrupted firmware! Bonus damage!',
      'failFlavor': 'Wrong! The specter jams your smart devices.',
    },
  };

  static const _bossArmor = {1: 14, 2: 16, 3: 12, 4: 15, 5: 18, 6: 13, 7: 17, 8: 14};
  static const _bossChallengeRating = {1: 3, 2: 5, 3: 4, 4: 6, 5: 8, 6: 4, 7: 7, 8: 5};

  static const Map<int, List<Map<String, dynamic>>> _strategies = {
    1: [
      {'name': 'Aim for the joints', 'success': 70, 'damage': 2, 'flavor': 'You strike the bone joints! The colossus stumbles!', 'failFlavor': 'Your attack clangs harmlessly off the thick bone.'},
      {'name': 'Target the eye cores', 'success': 50, 'damage': 3, 'flavor': 'You shatter a glowing eye core! The colossus roars!', 'failFlavor': 'The eyes are too well-guarded — your attack misses.'},
      {'name': 'Defensive stance', 'success': 90, 'damage': 1, 'flavor': 'You find a small opening and strike.', 'failFlavor': 'The colossus anticipated your move.'},
      {'name': 'Target the core', 'success': 35, 'damage': 5, 'flavor': 'You pierce the colossus core! It cracks apart!', 'failFlavor': 'The core is shielded by thick bone plating.'},
      {'name': 'Rattle the ribcage', 'success': 60, 'damage': 2, 'flavor': 'The ribs vibrate and a bone chip breaks off!', 'failFlavor': 'The ribcage holds firm against your strike.'},
    ],
    2: [
      {'name': 'Dispel the aura', 'success': 60, 'damage': 2, 'flavor': 'Your strike disrupts the lich\'s dark aura!', 'failFlavor': 'The lich\'s shield deflects your magic.'},
      {'name': 'Attack the phylactery', 'success': 40, 'damage': 4, 'flavor': 'You crack the phylactery! The lich screams!', 'failFlavor': 'The phylactery is heavily warded.'},
      {'name': 'Holy infusion', 'success': 80, 'damage': 1, 'flavor': 'Your blade glows with holy light and connects!', 'failFlavor': 'The lich\'s darkness extinguishes your light.'},
      {'name': 'Purify the kernel', 'success': 45, 'damage': 3, 'flavor': 'Holy energy sears the corrupted kernel!', 'failFlavor': 'The lich shields the kernel with dark magic.'},
      {'name': 'Seal the resurrection', 'success': 55, 'damage': 2, 'flavor': 'You block the resurrection path! The lich weakens!', 'failFlavor': 'The phylactery redirects the energy flow.'},
    ],
    3: [
      {'name': 'Sever the cables', 'success': 65, 'damage': 2, 'flavor': 'You cut through the tangled cables!', 'failFlavor': 'More cables spring up to replace them.'},
      {'name': 'Trap the goblin', 'success': 45, 'damage': 3, 'flavor': 'The goblin king is caught! You land a solid hit!', 'failFlavor': 'He dodges into a side tunnel.'},
      {'name': 'Rush attack', 'success': 85, 'damage': 1, 'flavor': 'Your aggressive push lands a blow!', 'failFlavor': 'He parries and counterattacks.'},
      {'name': 'Burn the cables', 'success': 50, 'damage': 3, 'flavor': 'Flames consume the tangled cable trap!', 'failFlavor': 'The goblin repairs the cables with a snap.'},
      {'name': 'Stealth approach', 'success': 40, 'damage': 4, 'flavor': 'You sneak behind the king and strike!', 'failFlavor': 'Trip wires alert the goblin to your presence.'},
    ],
    4: [
      {'name': 'Aim for the wings', 'success': 55, 'damage': 2, 'flavor': 'You clip the dragon\'s wing!', 'failFlavor': 'The dragon\'s scales deflect your blade.'},
      {'name': 'Throw a net', 'success': 35, 'damage': 4, 'flavor': 'The net tangles the whelp! Massive opening!', 'failFlavor': 'The dragon breathes fire, burning the net.'},
      {'name': 'Guard and wait', 'success': 80, 'damage': 1, 'flavor': 'You find an opening as the dragon tires.', 'failFlavor': 'The dragon\'s tail catches you off guard.'},
      {'name': 'Cut the data stream', 'success': 50, 'damage': 3, 'flavor': 'You sever the dragon\'s packet hoard!', 'failFlavor': 'The dragon redirects through another channel.'},
      {'name': 'Fire resistance', 'success': 65, 'damage': 2, 'flavor': 'Your shield absorbs the fire breath! Counter-attack!', 'failFlavor': 'The fire is too intense even with resistance.'},
    ],
    5: [
      {'name': 'Close the eye', 'success': 50, 'damage': 3, 'flavor': 'You seal one of the beholder\'s eyes!', 'failFlavor': 'The eye ray forces you back.'},
      {'name': 'Reflective shield', 'success': 30, 'damage': 5, 'flavor': 'The beholder\'s own ray reflects back! Critical hit!', 'failFlavor': 'The shield shatters under the magical assault.'},
      {'name': 'Hit the central eye', 'success': 70, 'damage': 1, 'flavor': 'You land a quick strike on the main eye!', 'failFlavor': 'The beholder blinks and your attack misses.'},
      {'name': 'Dispel all eyes', 'success': 40, 'damage': 4, 'flavor': 'You seal three eyes at once! The beholder flails!', 'failFlavor': 'The beholder counters with a concentrated gaze.'},
      {'name': 'Anti-magic field', 'success': 55, 'damage': 2, 'flavor': 'Magic nullifies around you! The beholder is vulnerable!', 'failFlavor': 'The beholder\'s raw power breaks through your field.'},
    ],
    6: [
      {'name': 'Kill background apps', 'success': 70, 'damage': 2, 'flavor': 'You shut down power-draining processes! The wraith weakens!', 'failFlavor': 'The apps restart instantly — the wraith absorbs them.'},
      {'name': 'Enable battery saver', 'success': 80, 'damage': 1, 'flavor': 'Battery saver mode disrupts the wraith\'s drain!', 'failFlavor': 'The wraith overrides your battery settings.'},
      {'name': 'Reduce screen brightness', 'success': 60, 'damage': 2, 'flavor': 'Lower brightness starves the wraith of energy!', 'failFlavor': 'The wraith feeds on the dimmed display.'},
      {'name': 'Force-stop all services', 'success': 40, 'damage': 4, 'flavor': 'You sever every background connection! The wraith screams!', 'failFlavor': 'Critical services restart before you can strike.'},
      {'name': 'Factory reset the drain', 'success': 50, 'damage': 3, 'flavor': 'A clean slate weakens the wraith\'s grip!', 'failFlavor': 'The wraith survives the reset with data intact.'},
    ],
    7: [
      {'name': 'Lower graphics settings', 'success': 65, 'damage': 2, 'flavor': 'Reduced rendering load cracks the dragon\'s scales!', 'failFlavor': 'The dragon adapts and injects more lag.'},
      {'name': 'Close background apps', 'success': 75, 'damage': 1, 'flavor': 'Freeing resources disrupts the lag field!', 'failFlavor': 'The dragon spawns more background processes.'},
      {'name': 'Update GPU drivers', 'success': 45, 'damage': 4, 'flavor': 'Fresh drivers pierce through the lag armor! Massive hit!', 'failFlavor': 'The driver update stalls — the dragon exploits the gap.'},
      {'name': 'Overclock the GPU', 'success': 35, 'damage': 5, 'flavor': 'Raw power overwhelms the lag dragon! Critical damage!', 'failFlavor': 'The overclock destabilizes — the dragon feeds on the heat.'},
      {'name': 'Reduce resolution', 'success': 60, 'damage': 2, 'flavor': 'Lower pixel count lightens the render load!', 'failFlavor': 'The dragon corrupts the display output further.'},
    ],
    8: [
      {'name': 'Factory reset the hub', 'success': 60, 'damage': 2, 'flavor': 'Wiping the firmware disrupts the specter\'s control!', 'failFlavor': 'The specter rewrites the firmware before the reset completes.'},
      {'name': 'Disconnect all devices', 'success': 70, 'damage': 1, 'flavor': 'Isolating the hub starves the specter of targets!', 'failFlavor': 'The specter reconnects through a backdoor.'},
      {'name': 'Update hub firmware', 'success': 45, 'damage': 4, 'flavor': 'Patched firmware locks out the specter\'s exploits!', 'failFlavor': 'The update fails — the specter blocks the download.'},
      {'name': 'Change Wi-Fi password', 'success': 50, 'damage': 3, 'flavor': 'New credentials sever the specter\'s network grip!', 'failFlavor': 'The specter brute-forces the new password instantly.'},
      {'name': 'Use wired Ethernet', 'success': 80, 'damage': 1, 'flavor': 'A hardwired connection bypasses the specter\'s jamming!', 'failFlavor': 'The specter corrupts the Ethernet port instead.'},
    ],
  };

  static int _bossIndex(String worldId) {
    const indexMap = {
      'core_components': 1,
      'ram': 2,
      'operating_system': 2,
      'audio': 4,
      'peripherals': 3,
      'software': 4,
      'internet': 4,
      'storage': 5,
      'display': 5,
      'mobile': 6,
      'gaming': 7,
      'smart_home': 8,
      'security': 5,
    };
    return indexMap[worldId] ?? 1;
  }

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

  void _selectedDiagnosis(int selectedIndex) {
    final bossIndex = _bossIndex(widget.world.id);
    final diagnosis = _bossDiagnoses[bossIndex];
    if (diagnosis == null) return;

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
    final bossIndex = _bossIndex(widget.world.id);
    final diagnosis = _bossDiagnoses[bossIndex];

    if (_showDiagnosis && diagnosis != null) {
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
          final bossIndex = _bossIndex(widget.world.id);
          final abilities = _bossAbilities[bossIndex] ?? [];
          final armorClass = _bossArmor[bossIndex] ?? 14;

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
                      challengeRating: _bossChallengeRating[bossIndex] ?? 3,
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
                            const Center(
                              child: SupTechAvatarWrapper(
                                isGlowing: true,
                                size: 48,
                                child: SupTechAvatar(
                                  isGlowing: true,
                                  showWizardHat: true,
                                  size: 48,
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

  const _MonsterStatBlock({
    required this.armorClass,
    required this.hpDisplay,
    required this.abilities,
    required this.isDefeated,
    this.challengeRating = 3,
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
      case 6:
        _drawBatteryWraith(canvas, cx, cy, s);
      case 7:
        _drawLagDragon(canvas, cx, cy, s);
      case 8:
        _drawStaticSpecter(canvas, cx, cy, s);
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

  void _drawBatteryWraith(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;

    // Ghostly body
    paint
      ..color = const Color(0xFF1B3A4B)
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
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawPath(bodyPath, paint);

    // Battery icon on chest
    paint
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(cx - 8 * s, cy - 12 * s, 16 * s, 22 * s), paint);
    paint
      ..color = const Color(0xFF00E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawRect(Rect.fromLTWH(cx - 8 * s, cy - 12 * s, 16 * s, 22 * s), paint);
    canvas.drawRect(Rect.fromLTWH(cx - 4 * s, cy - 15 * s, 8 * s, 3 * s), paint);

    // Eyes
    paint
      ..color = const Color(0xFFFF4444)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 22 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 22 * s), 4 * s, paint);
    paint
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 22 * s), 2 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 22 * s), 2 * s, paint);

    // Energy drain tendrils
    paint
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s;
    for (var i = 0; i < 3; i++) {
      final angle = phase * 2 + i * 2.1;
      final tendrilPath = Path()
        ..moveTo(cx - 20 * s + i * 20 * s, cy + 25 * s)
        ..quadraticBezierTo(
          cx - 25 * s + i * 20 * s + sin(angle) * 12 * s,
          cy + 40 * s,
          cx - 15 * s + i * 20 * s + sin(angle * 1.3) * 8 * s,
          cy + 50 * s,
        );
      canvas.drawPath(tendrilPath, paint);
    }

    // Glow
    if (glowIntensity > 0.3) {
      paint
        ..color = const Color(0xFF00E5FF).withValues(alpha: 0.12 * glowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
      canvas.drawCircle(Offset(cx, cy), 35 * s, paint);
    }
  }

  void _drawLagDragon(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;

    // Serpentine body
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

    // Glitch lines
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

    // Horns
    paint
      ..color = const Color(0xFF0D2137)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 12 * s, cy - 38 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 12 * s, cy - 38 * s), 5 * s, paint);
    paint
      ..color = const Color(0xFFFF6B35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawCircle(Offset(cx - 12 * s, cy - 38 * s), 5 * s, paint);
    canvas.drawCircle(Offset(cx + 12 * s, cy - 38 * s), 5 * s, paint);

    // Eyes — flickering
    final eyeAlpha = 0.5 + 0.5 * sin(phase * 8);
    paint
      ..color = const Color(0xFFFF4444).withValues(alpha: eyeAlpha)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 8 * s, cy - 22 * s), 4 * s, paint);
    canvas.drawCircle(Offset(cx + 8 * s, cy - 22 * s), 4 * s, paint);

    // Tail
    paint
      ..color = const Color(0xFF0D2137)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * s
      ..strokeCap = StrokeCap.round;
    final tailPath = Path()
      ..moveTo(cx + 25 * s, cy + 20 * s)
      ..quadraticBezierTo(cx + 35 * s + sin(phase * 3) * 8 * s, cy + 35 * s, cx + 28 * s + cos(phase * 2) * 6 * s, cy + 48 * s);
    canvas.drawPath(tailPath, paint);
    paint
      ..color = const Color(0xFFFF6B35)
      ..strokeWidth = 1.5 * s;
    canvas.drawPath(tailPath, paint);
  }

  void _drawStaticSpecter(Canvas canvas, double cx, double cy, double s) {
    final paint = Paint()..isAntiAlias = true;

    // Hub body — rounded rectangle
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

    // Screen with static
    paint
      ..color = const Color(0xFF4A90D9).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - 16 * s, cy - 18 * s, 32 * s, 28 * s),
      Radius.circular(4 * s),
    );
    canvas.drawRRect(screenRect, paint);

    // Static noise
    final rng = Random(42 + (phase * 10).floor());
    for (var i = 0; i < 20; i++) {
      final nx = cx - 14 * s + rng.nextDouble() * 28 * s;
      final ny = cy - 16 * s + rng.nextDouble() * 24 * s;
      paint
        ..color = const Color(0xFF4A90D9).withValues(alpha: rng.nextDouble() * 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(nx, ny, 2 * s, 1 * s), paint);
    }

    // Antennae
    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - 10 * s, cy - 25 * s), Offset(cx - 18 * s + sin(phase * 3) * 3 * s, cy - 42 * s), paint);
    canvas.drawLine(Offset(cx + 10 * s, cy - 25 * s), Offset(cx + 18 * s + sin(phase * 3 + 1) * 3 * s, cy - 42 * s), paint);
    paint
      ..color = const Color(0xFF4A90D9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 18 * s + sin(phase * 3) * 3 * s, cy - 42 * s), 3 * s, paint);
    canvas.drawCircle(Offset(cx + 18 * s + sin(phase * 3 + 1) * 3 * s, cy - 42 * s), 3 * s, paint);

    // LED eyes
    final ledColor = Color.lerp(const Color(0xFFFF0000), const Color(0xFF4A90D9), (sin(phase * 4) + 1) / 2)!;
    paint
      ..color = ledColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 6 * s, cy - 5 * s), 3 * s, paint);
    canvas.drawCircle(Offset(cx + 6 * s, cy - 5 * s), 3 * s, paint);

    // Signal waves
    paint
      ..color = const Color(0xFF4A90D9).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    for (var i = 1; i <= 3; i++) {
      final waveAlpha = (0.3 - i * 0.08) * (0.5 + 0.5 * sin(phase * 2 + i));
      paint.color = const Color(0xFF4A90D9).withValues(alpha: waveAlpha);
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy - 25 * s), radius: (10 + i * 8) * s),
        -pi * 0.8,
        pi * 0.6,
        false,
        paint,
      );
    }

    // Cables/tentacles
    paint
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * s;
    for (var i = 0; i < 3; i++) {
      final angle = phase * 2 + i * 2.1;
      final tentaclePath = Path()
        ..moveTo(cx - 15 * s + i * 15 * s, cy + 25 * s)
        ..quadraticBezierTo(
          cx - 20 * s + i * 15 * s + cos(angle) * 10 * s,
          cy + 38 * s,
          cx - 12 * s + i * 15 * s + sin(angle * 1.3) * 8 * s,
          cy + 48 * s,
        );
      canvas.drawPath(tentaclePath, paint);
    }

    // Glow
    if (glowIntensity > 0.3) {
      paint
        ..color = const Color(0xFF4A90D9).withValues(alpha: 0.1 * glowIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawCircle(Offset(cx, cy), 32 * s, paint);
    }
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
      const Color(0xFF00E5FF),
      const Color(0xFFFF6B35),
      const Color(0xFF4A90D9),
    ][(bossIndex - 1).clamp(0, 7)];

    for (var i = 0; i < 15; i++) {
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
