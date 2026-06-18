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
    // ── World 1 ──
    'cpu_high_usage': [
      {'statement': 'Task Manager can be opened with Ctrl+Shift+Esc', 'isTrue': true},
      {'statement': 'High CPU usage is always caused by a virus', 'isTrue': false},
    ],
    'cpu_overheating': [
      {'statement': 'Dust buildup inside a PC can block airflow and cause overheating', 'isTrue': true},
      {'statement': 'Opening the BIOS always fixes overheating problems', 'isTrue': false},
      {'statement': 'Thermal paste helps transfer heat from the CPU to the cooler', 'isTrue': true},
    ],
    'computer_not_turning_on': [
      {'statement': 'A flipped PSU switch can prevent a PC from turning on', 'isTrue': true},
      {'statement': 'If the PC doesn\'t turn on, you must replace the motherboard', 'isTrue': false},
    ],
    'beep_codes': [
      {'statement': 'Beep codes are produced by the motherboard BIOS during POST', 'isTrue': true},
      {'statement': 'A single short beep always means there is a critical hardware failure', 'isTrue': false},
      {'statement': 'Different BIOS manufacturers use different beep code patterns', 'isTrue': true},
    ],
    'ram_not_detected': [
      {'statement': 'Reseating RAM sticks can fix detection issues', 'isTrue': true},
      {'statement': 'If RAM is not detected, it is always broken and must be replaced', 'isTrue': false},
      {'statement': 'RAM modules can only be installed in one specific slot', 'isTrue': false},
    ],

    // ── World 2 ──
    'pc_wont_boot': [
      {'statement': 'A corrupted bootloader can prevent the PC from booting', 'isTrue': true},
      {'statement': 'If the PC won\'t boot, you should always reinstall Windows immediately', 'isTrue': false},
      {'statement': 'Checking boot order in BIOS is a valid troubleshooting step', 'isTrue': true},
    ],
    'boot_loop': [
      {'statement': 'A failing hard drive can cause a boot loop', 'isTrue': true},
      {'statement': 'Boot loops are always caused by a virus', 'isTrue': false},
      {'statement': 'Safe Mode can help diagnose what is causing a boot loop', 'isTrue': true},
    ],
    'bsod': [
      {'statement': 'The stop code on a BSOD helps identify the problem', 'isTrue': true},
      {'statement': 'BSODs only happen on old computers', 'isTrue': false},
    ],
    'os_running_slow': [
      {'statement': 'Too many startup programs can slow down the operating system', 'isTrue': true},
      {'statement': 'Adding more RAM never helps with a slow OS', 'isTrue': false},
      {'statement': 'Disk fragmentation can reduce performance on mechanical hard drives', 'isTrue': true},
    ],
    'no_sound': [
      {'statement': 'Checking the audio output device settings is a good first step', 'isTrue': true},
      {'statement': 'If there is no sound, the speakers are always broken', 'isTrue': false},
      {'statement': 'Audio drivers can become corrupted and cause sound issues', 'isTrue': true},
    ],

    // ── World 3 ──
    'mouse_not_responding': [
      {'statement': 'A faulty USB port can cause the mouse to stop responding', 'isTrue': true},
      {'statement': 'If the mouse stops working, you must replace it immediately', 'isTrue': false},
      {'statement': 'Updating or reinstalling mouse drivers can resolve the issue', 'isTrue': true},
    ],
    'cursor_lagging': [
      {'statement': 'High system resource usage can cause cursor lag', 'isTrue': true},
      {'statement': 'Cursor lag always means the mouse sensor is dirty', 'isTrue': false},
      {'statement': 'A failing hard drive can indirectly cause cursor lag', 'isTrue': true},
    ],
    'keyboard_not_responding': [
      {'statement': 'Disconnecting and reconnecting the keyboard can fix recognition issues', 'isTrue': true},
      {'statement': 'A non-responsive keyboard always needs to be replaced', 'isTrue': false},
      {'statement': 'Sticky keys settings can sometimes interfere with normal typing', 'isTrue': true},
    ],
    'printer_offline': [
      {'statement': 'A loose USB or network cable can make a printer appear offline', 'isTrue': true},
      {'statement': 'An offline printer always has a broken printhead', 'isTrue': false},
      {'statement': 'Restarting the print spooler service can bring a printer back online', 'isTrue': true},
    ],
    'paper_jam': [
      {'statement': 'Using the correct paper size and type helps prevent paper jams', 'isTrue': true},
      {'statement': 'Pulling paper out forcefully is the safest way to clear a jam', 'isTrue': false},
      {'statement': 'Overloading the paper tray can increase the chance of a jam', 'isTrue': true},
    ],

    // ── World 4 ──
    'program_crashes': [
      {'statement': 'A missing software dependency can cause a program to crash on launch', 'isTrue': true},
      {'statement': 'Program crashes are always caused by hardware failure', 'isTrue': false},
      {'statement': 'Running the program as administrator can sometimes fix permission-related crashes', 'isTrue': true},
    ],
    'no_internet': [
      {'statement': 'Flushing the DNS cache can help restore internet connectivity', 'isTrue': true},
      {'statement': 'If one device has no internet, the entire network must be down', 'isTrue': false},
      {'statement': 'A loose Ethernet cable can cause a complete loss of internet', 'isTrue': true},
    ],
    'slow_internet': [
      {'statement': 'Other devices or programs using bandwidth can slow down your internet', 'isTrue': true},
      {'statement': 'A faster internet plan always eliminates all lag and buffering', 'isTrue': false},
      {'statement': 'Wi-Fi signal interference from other devices can reduce internet speed', 'isTrue': true},
    ],
    'dns_issues': [
      {'statement': 'Changing to a public DNS server like Google DNS can resolve DNS issues', 'isTrue': true},
      {'statement': 'DNS issues always mean your internet service provider is at fault', 'isTrue': false},
      {'statement': 'Incorrect DNS settings can prevent websites from loading', 'isTrue': true},
    ],
    'vpn_not_connecting': [
      {'statement': 'A firewall or antivirus program can block VPN connections', 'isTrue': true},
      {'statement': 'If a VPN won\'t connect, the VPN service is always down', 'isTrue': false},
      {'statement': 'Switching VPN server locations can sometimes resolve connection issues', 'isTrue': true},
    ],

    // ── World 5 ──
    'hard_drive_not_detected': [
      {'statement': 'A loose SATA or power cable can prevent the hard drive from being detected', 'isTrue': true},
      {'statement': 'If the BIOS doesn\'t detect the drive, the drive is always dead', 'isTrue': false},
      {'statement': 'Checking BIOS settings to ensure the SATA port is enabled is a valid step', 'isTrue': true},
    ],
    'disk_full': [
      {'statement': 'Temporary files and cache can take up significant disk space over time', 'isTrue': true},
      {'statement': 'A disk being full never affects system performance', 'isTrue': false},
      {'statement': 'Uninstalling unused programs frees up disk space', 'isTrue': true},
    ],
    'no_display_output': [
      {'statement': 'A monitor set to the wrong input source can show no display', 'isTrue': true},
      {'statement': 'No display output always means the GPU is dead', 'isTrue': false},
      {'statement': 'Re-seating the graphics card can sometimes fix display issues', 'isTrue': true},
    ],
    'flickering_screen': [
      {'statement': 'A loose display cable can cause the screen to flicker', 'isTrue': true},
      {'statement': 'Screen flickering is always caused by a virus', 'isTrue': false},
      {'statement': 'Outdated graphics drivers are a common cause of screen flickering', 'isTrue': true},
    ],
    'dead_pixels': [
      {'statement': 'Dead pixels are permanent defects on an LCD or OLED display', 'isTrue': true},
      {'statement': 'Dead pixels can always be fixed by running a pixel-fix video', 'isTrue': false},
      {'statement': 'Stuck pixels appear as a single color that does not change', 'isTrue': true},
    ],

    // ── World 6 ──
    'battery_draining': [
      {'statement': 'Background apps and services can drain battery life faster', 'isTrue': true},
      {'statement': 'Turning off the phone completely prevents all battery drain', 'isTrue': false},
      {'statement': 'Reducing screen brightness extends battery life', 'isTrue': true},
    ],
    'phone_overheating': [
      {'statement': 'Using resource-intensive apps like games or GPS can cause a phone to overheat', 'isTrue': true},
      {'statement': 'A phone overheating always means the battery needs to be replaced', 'isTrue': false},
      {'statement': 'Charging a phone while using heavy apps can increase its temperature', 'isTrue': true},
    ],
    'phone_apps_crashing': [
      {'statement': 'Clearing the app cache can fix crashes', 'isTrue': true},
      {'statement': 'App crashes always mean the phone needs a factory reset', 'isTrue': false},
      {'statement': 'Insufficient storage space can cause apps to crash unexpectedly', 'isTrue': true},
    ],
    'phone_not_charging': [
      {'statement': 'Debris or lint in the charging port can prevent a proper connection', 'isTrue': true},
      {'statement': 'If a phone won\'t charge, the battery is always defective', 'isTrue': false},
      {'statement': 'Trying a different cable and charger helps identify the faulty component', 'isTrue': true},
    ],
    'slow_phone': [
      {'statement': 'Too many background apps running can slow down a phone', 'isTrue': true},
      {'statement': 'A slow phone always has outdated hardware and cannot be improved', 'isTrue': false},
      {'statement': 'Clearing cached data can help improve phone performance', 'isTrue': true},
    ],

    // ── World 7 ──
    'game_crashing': [
      {'statement': 'Outdated graphics drivers are a common cause of game crashes', 'isTrue': true},
      {'statement': 'If a game crashes, the console or PC is always broken', 'isTrue': false},
      {'statement': 'Lowering in-game graphics settings can prevent crashes on weaker hardware', 'isTrue': true},
    ],
    'low_fps': [
      {'statement': 'Closing background applications can improve game frame rates', 'isTrue': true},
      {'statement': 'Low FPS always means the internet connection is slow', 'isTrue': false},
      {'statement': 'Overheating hardware can cause the system to throttle and reduce FPS', 'isTrue': true},
    ],
    'controller_not_connecting': [
      {'statement': 'Resetting the controller and re-pairing it can fix connection issues', 'isTrue': true},
      {'statement': 'A controller that won\'t connect is always broken beyond repair', 'isTrue': false},
      {'statement': 'Low battery levels can prevent a wireless controller from connecting', 'isTrue': true},
    ],
    'game_audio_stutter': [
      {'statement': 'Other programs using the audio device can cause in-game audio stutter', 'isTrue': true},
      {'statement': 'Audio stutter in games always means the speakers are broken', 'isTrue': false},
      {'statement': 'Updating audio drivers can resolve game audio stutter issues', 'isTrue': true},
    ],
    'gpu_driver_crash': [
      {'statement': 'A GPU driver crash can cause the screen to go black temporarily', 'isTrue': true},
      {'statement': 'GPU driver crashes always mean the graphics card is physically damaged', 'isTrue': false},
      {'statement': 'Rolling back to a previous stable driver version can fix driver crashes', 'isTrue': true},
    ],

    // ── World 8 ──
    'smart_device_offline': [
      {'statement': 'A weak Wi-Fi signal can cause a smart device to appear offline', 'isTrue': true},
      {'statement': 'If a smart device is offline, it must be replaced with a new one', 'isTrue': false},
      {'statement': 'Power cycling the device and router can often restore connectivity', 'isTrue': true},
    ],
    'voice_assistant_not_responding': [
      {'statement': 'A muted microphone or physical mute button can prevent the assistant from hearing you', 'isTrue': true},
      {'statement': 'Voice assistants stop responding only when the device is broken', 'isTrue': false},
      {'statement': 'Background noise can interfere with voice recognition', 'isTrue': true},
    ],
    'smart_light_not_connecting': [
      {'statement': 'The smart light must be within range of the Wi-Fi or hub to connect', 'isTrue': true},
      {'statement': 'Smart lights that won\'t connect are always defective', 'isTrue': false},
      {'statement': 'Resetting the light to factory settings can resolve pairing issues', 'isTrue': true},
    ],
    'home_hub_setup_failed': [
      {'statement': 'An unstable internet connection can cause hub setup to fail', 'isTrue': true},
      {'statement': 'A failed hub setup always means the hub is incompatible with your devices', 'isTrue': false},
      {'statement': 'Ensuring the hub firmware is up to date can fix setup problems', 'isTrue': true},
    ],
    'automation_not_triggering': [
      {'statement': 'Incorrect time or location settings can prevent automations from triggering', 'isTrue': true},
      {'statement': 'If an automation fails once, it is permanently broken', 'isTrue': false},
      {'statement': 'Checking the automation conditions and actions can reveal configuration errors', 'isTrue': true},
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
