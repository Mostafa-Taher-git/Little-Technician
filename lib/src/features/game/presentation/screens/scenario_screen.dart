import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/traps_screen.dart';

class ScenarioScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const ScenarioScreen({super.key, required this.world, required this.level});

  @override
  State<ScenarioScreen> createState() => _ScenarioScreenState();
}

class _ScenarioScreenState extends State<ScenarioScreen> {
  int _currentQuestion = 0;
  int _correctCount = 0;
  bool _isAnswered = false;
  bool _showResults = false;
  final List<int> _userAnswers = [];
  final List<bool> _questionResults = [];

  static const _scenarios = {
    'cpu_high_usage': {
      'scenario': 'Your PC is running extremely slow. Task Manager shows CPU usage at 100% even with no demanding applications open. The fan is running loudly.',
      'correctAction': 'Open Task Manager to identify which process is consuming the most CPU',
      'wrongActions': [
        'Restart the computer immediately',
        'Install more RAM',
        'Buy a new computer',
      ],
      'explanation': 'Opening Task Manager first helps you identify exactly what is causing the high CPU usage. Without this information, you cannot know if restarting will help or if the problem will return.',
      'followUps': [
        {
          'scenario': 'Task Manager shows a process called "svchost.exe" using 80% CPU. What do you do next?',
          'correctAction': 'Research the process online to determine if it is legitimate or malware',
          'wrongActions': ['End the process immediately', 'Ignore it', 'Uninstall Windows'],
          'explanation': 'svchost.exe is a legitimate Windows process, but malware can disguise itself with the same name. Researching it first helps you determine if it is safe or a threat.',
        },
        {
          'scenario': 'After researching, you find the process is legitimate but still using too much CPU. What is the best next step?',
          'correctAction': 'Check for Windows updates that may fix the issue',
          'wrongActions': ['Replace the CPU', 'Reinstall Windows', 'Delete system32'],
          'explanation': 'Windows updates often include bug fixes for system processes. This is less destructive than reinstalling the OS and may resolve the issue permanently.',
        },
      ],
    },
    'cpu_overheating': {
      'scenario': 'Your computer keeps shutting down unexpectedly during gaming sessions. You notice the area near the CPU feels very hot to the touch.',
      'correctAction': 'Check if the CPU fan is spinning and free of dust buildup',
      'wrongActions': [
        'Lower the graphics settings',
        'Buy a bigger monitor',
        'Install more RAM',
      ],
      'explanation': 'Overheating is typically caused by blocked or dusty fans, or a failed fan. Checking the fan is the first step in diagnosing why the CPU is overheating.',
      'followUps': [
        {
          'scenario': 'The fan is spinning but has a thick layer of dust on it. What should you do?',
          'correctAction': 'Clean the dust from the fan and heatsink using compressed air',
          'wrongActions': ['Replace the entire computer', 'Turn up the AC', 'Use the computer less often'],
          'explanation': 'Dust buildup reduces the fan\'s ability to cool the CPU. Cleaning it with compressed air is a simple and effective fix.',
        },
        {
          'scenario': 'After cleaning, the CPU is still running hot. What is the next logical step?',
          'correctAction': 'Check and reapply the thermal paste between CPU and cooler',
          'wrongActions': ['Buy a new computer', 'Remove the CPU entirely', 'Overclock the CPU more'],
          'explanation': 'Thermal paste transfers heat from the CPU to the cooler. Over time it can dry out and become less effective. Reapplying it restores proper heat transfer.',
        },
      ],
    },
    'computer_not_turning_on': {
      'scenario': 'You press the power button on your desktop computer but nothing happens. No lights, no fan noise, complete silence.',
      'correctAction': 'Check that the power cable is firmly connected to both the PC and the wall outlet',
      'wrongActions': [
        'Replace the motherboard',
        'Reinstall Windows',
        'Buy a new computer',
      ],
      'explanation': 'Before assuming hardware failure, always check the simplest things first. A loose or disconnected power cable is a common cause and easy to fix.',
      'followUps': [
        {
          'scenario': 'The power cable is connected properly but the PC still won\'t turn on. What should you check next?',
          'correctAction': 'Check if the power supply switch at the back is turned on',
          'wrongActions': ['Buy a new power supply', 'Take it to a repair shop', 'Smack the computer'],
          'explanation': 'The PSU switch at the back is a common thing people overlook. It can accidentally get flipped during cleaning or moving the computer.',
        },
        {
          'scenario': 'The PSU switch is on and the outlet works. What is the next step?',
          'correctAction': 'Test with a different power cable to rule out cable failure',
          'wrongActions': ['Replace the motherboard', 'Buy a new computer', 'Try a different monitor'],
          'explanation': 'Power cables can fail internally without visible damage. Testing with a known-good cable eliminates it as a possible cause before moving to more expensive solutions.',
        },
      ],
    },
    'pc_wont_boot': {
      'scenario': 'Your computer turns on and you see the manufacturer logo, but then it freezes and never reaches the Windows desktop.',
      'correctAction': 'Enter BIOS/UEFI to check if the boot drive is detected',
      'wrongActions': [
        'Reinstall Windows immediately',
        'Buy a new hard drive',
        'Wait longer for it to load',
      ],
      'explanation': 'If the system posts but cannot find the boot drive, it may have failed or become disconnected. Checking BIOS confirms whether the drive is recognized before trying other fixes.',
      'followUps': [
        {
          'scenario': 'BIOS shows no boot drive detected. What is the most likely cause?',
          'correctAction': 'Check the SATA or NVMe connection to the drive',
          'wrongActions': ['Reinstall Windows', 'Buy a new monitor', 'Update the BIOS'],
          'explanation': 'A loose or disconnected drive cable can cause the drive to disappear from BIOS. Reseating the cable often resolves the issue without replacing hardware.',
        },
        {
          'scenario': 'The drive is detected in BIOS but Windows still won\'t load. What should you try?',
          'correctAction': 'Boot from a Windows USB recovery drive to repair the installation',
          'wrongActions': ['Buy a new computer', 'Remove the hard drive', 'Install Linux'],
          'explanation': 'A Windows recovery drive can repair boot records and system files without erasing your data. This is less destructive than reinstalling the OS.',
        },
      ],
    },
    'bsod': {
      'scenario': 'Your computer suddenly shows a blue screen with a sad face emoticon and error text. It restarts on its own but the same blue screen keeps appearing.',
      'correctAction': 'Note the stop code displayed on the blue screen before it disappears',
      'wrongActions': [
        'Restart the computer repeatedly',
        'Replace the hard drive',
        'Reinstall Windows without notes',
      ],
      'explanation': 'The stop code on a BSOD tells you exactly what caused the crash. Without noting it, you are troubleshooting blind. Writing it down allows you to research the specific problem.',
      'followUps': [
        {
          'scenario': 'The stop code shows "MEMORY_MANAGEMENT". What is the most likely problem?',
          'correctAction': 'Run Windows Memory Diagnostic to test the RAM',
          'wrongActions': ['Reinstall Windows', 'Buy a new graphics card', 'Update the BIOS'],
          'explanation': 'MEMORY_MANAGEMENT directly points to RAM issues. Testing the memory with a diagnostic tool confirms whether the RAM is faulty before replacing hardware.',
        },
        {
          'scenario': 'Memory Diagnostic found no errors but the BSOD keeps happening. What should you try next?',
          'correctAction': 'Boot into Safe Mode and uninstall recently installed drivers or updates',
          'wrongActions': ['Buy new RAM anyway', 'Reformat the hard drive', 'Ignore the problem'],
          'explanation': 'If the RAM is fine, recent driver updates or software changes are a common cause of BSODs. Safe Mode loads minimal drivers, helping you isolate the culprit.',
        },
      ],
    },
    'no_internet': {
      'scenario': 'Your laptop shows it is connected to Wi-Fi but web pages won\'t load. Other devices on the same network work fine.',
      'correctAction': 'Restart your computer\'s network adapter by disabling and re-enabling it',
      'wrongActions': [
        'Replace the router',
        'Call your internet provider immediately',
        'Buy a new laptop',
      ],
      'explanation': 'Since other devices work, the problem is specific to your computer. Resetting the network adapter often clears temporary network glitches without affecting other devices.',
      'followUps': [
        {
          'scenario': 'After resetting the adapter, the problem persists. What should you try next?',
          'correctAction': 'Flush the DNS cache and try a different DNS server like Google DNS (8.8.8.8)',
          'wrongActions': ['Replace the laptop', 'Factory reset Windows', 'Blame the ISP'],
          'explanation': 'DNS issues can cause the appearance of no internet even when the connection is fine. Flushing the cache and using a public DNS can resolve domain resolution problems.',
        },
        {
          'scenario': 'Changing DNS didn\'t help. What is the next logical step?',
          'correctAction': 'Run the Windows Network Troubleshooter to automatically detect and fix issues',
          'wrongActions': ['Buy a new computer', 'Reinstall Windows', 'Wait for it to fix itself'],
          'explanation': 'Windows Network Troubleshooter can automatically detect and fix many common network configuration issues, saving you from manual troubleshooting.',
        },
      ],
    },
    'battery_draining': {
      'scenario': 'Your smartphone battery drops from 100% to 20% in just 4 hours, even though you barely use it. It used to last all day.',
      'correctAction': 'Check battery usage stats in Settings to identify power-hungry apps',
      'wrongActions': [
        'Buy a new phone',
        'Carry a charger everywhere',
        'Disable all features permanently',
      ],
      'explanation': 'Battery usage stats show exactly which apps are consuming the most power. Without this data, you cannot know if the problem is a specific app or the battery itself.',
      'followUps': [
        {
          'scenario': 'Battery stats show a social media app using 40% of your battery. What is the best action?',
          'correctAction': 'Disable background app refresh for that specific app',
          'wrongActions': ['Delete the app permanently', 'Buy a new battery', 'Factory reset your phone'],
          'explanation': 'Many apps drain battery by refreshing content in the background. Disabling background refresh for power-hungry apps significantly reduces battery drain without losing functionality.',
        },
        {
          'scenario': 'After disabling background refresh, battery life improved but is still not great. What else can you do?',
          'correctAction': 'Reduce screen brightness and shorten the screen timeout duration',
          'wrongActions': ['Replace the phone battery', 'Buy a new phone', 'Turn off all notifications'],
          'explanation': 'The screen is one of the biggest battery consumers. Reducing brightness and timeout time can significantly extend battery life without major sacrifices.',
        },
      ],
    },
    'game_crashing': {
      'scenario': 'Your favorite game keeps crashing to the desktop every few minutes during gameplay. You have a decent gaming PC that should handle it.',
      'correctAction': 'Update your GPU drivers to the latest version from the manufacturer',
      'wrongActions': [
        'Reinstall the game',
        'Buy a new graphics card',
        'Lower all settings to minimum',
      ],
      'explanation': 'Outdated GPU drivers are a leading cause of game crashes. Manufacturers regularly release driver updates that fix compatibility issues with specific games.',
      'followUps': [
        {
          'scenario': 'Drivers are up to date but the game still crashes. What should you try next?',
          'correctAction': 'Verify the game files through the game launcher to check for corruption',
          'wrongActions': ['Buy a new computer', 'Reinstall Windows', 'Return the game'],
          'explanation': 'Game files can become corrupted during download or installation. Verifying files checks and repairs them without requiring a full reinstall.',
        },
        {
          'scenario': 'Verification found and fixed corrupted files, but the game still crashes. What is the next step?',
          'correctAction': 'Disable overlays like Discord, Steam, or GeForce Experience while playing',
          'wrongActions': ['Buy new RAM', 'Overclock the GPU', 'Install a different operating system'],
          'explanation': 'Game overlays can conflict with game processes and cause crashes. Disabling them eliminates this potential source of instability.',
        },
      ],
    },
    'printer_offline': {
      'scenario': 'Your printer shows as "Offline" in Windows even though it is powered on and connected via USB. You cannot print anything.',
      'correctAction': 'Restart the Print Spooler service in Windows Services (services.msc)',
      'wrongActions': [
        'Buy a new printer',
        'Reinstall Windows',
        'Use a different computer to print',
      ],
      'explanation': 'The Print Spooler service manages all print jobs. If it crashes or gets stuck, the printer appears offline. Restarting it often resolves the issue immediately.',
      'followUps': [
        {
          'scenario': 'Restarting the spooler didn\'t help. What should you check next?',
          'correctAction': 'Check if the printer is set as the default printer and try "Use Printer Online"',
          'wrongActions': ['Replace the USB cable', 'Buy a new printer', 'Reinstall the operating system'],
          'explanation': 'Windows can sometimes switch the default printer or mark a printer as offline even when it is connected. Setting it as default and bringing it online can resolve this.',
        },
        {
          'scenario': 'The printer is set as default but still shows offline. What is the next step?',
          'correctAction': 'Reinstall the printer driver from the manufacturer\'s website',
          'wrongActions': ['Throw away the printer', 'Buy a new computer', 'Print from a different device'],
          'explanation': 'Corrupted or outdated printer drivers can cause communication issues. Installing fresh drivers from the manufacturer ensures compatibility.',
        },
      ],
    },
    'smart_device_offline': {
      'scenario': 'Your smart light bulb shows as "Offline" in the companion app. The light switch is on and the bulb was working yesterday.',
      'correctAction': 'Restart the smart bulb by turning the light switch off for 10 seconds, then back on',
      'wrongActions': [
        'Buy a new smart bulb',
        'Delete and reinstall the app',
        'Factory reset your router',
      ],
      'explanation': 'Power cycling is the most common fix for smart devices. It forces the device to reconnect to the network and can resolve temporary connectivity issues.',
      'followUps': [
        {
          'scenario': 'After power cycling, the bulb is still offline. What should you check next?',
          'correctAction': 'Check if other smart devices on the same network are also offline',
          'wrongActions': ['Buy a new router', 'Call the police', 'Reset your phone'],
          'explanation': 'If multiple smart devices are offline, the problem is likely with your network rather than individual devices. This helps narrow down the root cause.',
        },
        {
          'scenario': 'Other smart devices are working fine. What is the next step for this bulb?',
          'correctAction': 'Re-add the bulb in the manufacturer\'s app following the pairing instructions',
          'wrongActions': ['Replace the bulb', 'Buy a new hub', 'Give up on smart home'],
          'explanation': 'Sometimes devices lose their pairing configuration. Re-adding them in the app re-establishes the connection without replacing hardware.',
        },
      ],
    },
  };

  List<Map<String, dynamic>> get _levelScenarios {
    return [
      _scenarios[widget.level.id] ?? {
        'scenario': 'A troubleshooting situation has arisen. What is your first step?',
        'correctAction': 'Identify the symptoms and gather information',
        'wrongActions': ['Replace all components', 'Ignore the problem', 'Buy a new device'],
        'explanation': 'Gathering information is always the first step in effective troubleshooting.',
        'followUps': [
          {
            'scenario': 'You have identified the symptoms. What do you do next?',
            'correctAction': 'Research the symptoms to find common causes',
            'wrongActions': ['Replace random parts', 'Guess the problem', 'Give up'],
            'explanation': 'Researching symptoms helps narrow down the possible causes before taking action.',
          },
          {
            'scenario': 'You found a potential cause. What is the best next step?',
            'correctAction': 'Try the least invasive fix first',
            'wrongActions': ['Replace everything', 'Reinstall the OS', 'Buy new hardware'],
            'explanation': 'Starting with simple fixes saves time and money. Only escalate to more complex solutions if needed.',
          },
        ],
      },
    ];
  }

  void _answer(int index) {
    if (_isAnswered) return;
    const correctIndex = 0;
    final isCorrect = index == correctIndex;

    setState(() {
      _isAnswered = true;
      _userAnswers.add(index);
      _questionResults.add(isCorrect);
      if (isCorrect) _correctCount++;
    });
  }

  void _next() {
    final allQuestions = _levelScenarios;
    if (_currentQuestion < allQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _isAnswered = false;
      });
    } else {
      setState(() => _showResults = true);
    }
  }

  void _finish() {
    final passed = _correctCount >= 2;
    context.read<GameCubit>().saveScenariosResult(widget.level.id, _correctCount, 3, passed);
    if (passed) context.read<GameCubit>().addPoints(15);
    Nav.pushReplacement(
      context,
      TrapsScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_showResults) return _buildResults(scheme);

    final q = _levelScenarios[_currentQuestion];
    final scenario = q['scenario'] as String;
    final correctAction = q['correctAction'] as String;
    final wrongActions = List<String>.from(q['wrongActions'] as List);
    final explanation = q['explanation'] as String;

    final options = [correctAction, ...wrongActions]..shuffle();
    final isFollowUp = _currentQuestion > 0;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Scenario Simulation'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      isFollowUp ? 'Follow-up $_currentQuestion/2' : 'Scenario 1/3',
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
            const Gap(20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outline.withValues(alpha: 0.2)),
              ),
              child: Text(
                scenario,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
            const Gap(20),
            Text(
              'What is the BEST first step?',
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (_, i) {
                  final option = options[i];
                  final isSelected = _userAnswers.length > _currentQuestion &&
                      _userAnswers[_currentQuestion] == i;
                  final isCorrectOption = option == correctAction;
                  final showFeedback = _isAnswered;

                  Color bgColor;
                  Color borderColor;
                  if (showFeedback && isSelected) {
                    bgColor = isCorrectOption
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1);
                    borderColor = isCorrectOption ? Colors.green : Colors.red;
                  } else if (showFeedback && isCorrectOption) {
                    bgColor = Colors.green.withValues(alpha: 0.05);
                    borderColor = Colors.green.withValues(alpha: 0.5);
                  } else {
                    bgColor = scheme.surface;
                    borderColor = scheme.outline.withValues(alpha: 0.3);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _isAnswered ? null : () => _answer(i),
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: 300.ms,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: showFeedback && isCorrectOption
                                      ? Colors.green
                                      : showFeedback && isSelected
                                          ? Colors.red
                                          : scheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: showFeedback && isCorrectOption
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : showFeedback && isSelected
                                        ? const Icon(Icons.close, color: Colors.white, size: 16)
                                        : Text(
                                            String.fromCharCode(65 + i),
                                            style: TextStyle(
                                              color: scheme.onSurface.withValues(alpha: 0.5),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                              ),
                              const Gap(14),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: showFeedback && isCorrectOption
                                        ? Colors.green
                                        : showFeedback && isSelected
                                            ? Colors.red
                                            : scheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: (100 * i).ms).slideX(begin: 0.05);
                },
              ),
            ),
            if (_isAnswered)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _questionResults[_currentQuestion]
                      ? Colors.green.withValues(alpha: 0.08)
                      : Colors.orange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _questionResults[_currentQuestion]
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  explanation,
                  style: TextStyle(
                    color: _questionResults[_currentQuestion]
                        ? Colors.green.shade300
                        : Colors.orange.shade300,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isAnswered ? _next : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                  disabledBackgroundColor: scheme.outline.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _currentQuestion < _levelScenarios.length - 1 ? 'Next Scenario' : 'Review Results',
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
    final passed = _correctCount >= 2;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Scenario Complete'),
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
                colors: passed
                    ? [Colors.green.shade800, Colors.green.shade600]
                    : [Colors.orange.shade800, Colors.orange.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  passed ? Icons.emoji_events : Icons.info_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const Gap(12),
                Text(
                  '$_correctCount / 3 Correct',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(4),
                Text(
                  passed ? 'Passed! +15 points' : 'Not quite — keep learning!',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
          const Gap(24),
          ..._levelScenarios.asMap().entries.map((entry) {
            final i = entry.key;
            final q = entry.value;
            final isCorrect = i < _questionResults.length ? _questionResults[i] : false;

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
              child: Row(
                children: [
                  Icon(
                    isCorrect ? Icons.check_circle : Icons.cancel,
                    color: isCorrect ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      (q['scenario'] as String).length > 80
                          ? '${(q['scenario'] as String).substring(0, 80)}...'
                          : q['scenario'] as String,
                      style: TextStyle(
                        color: scheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
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
              onPressed: _finish,
              icon: const Icon(Icons.arrow_forward, size: 20),
              label: const Text(
                'Continue',
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
