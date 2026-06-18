import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/core/navigation/nav.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';
import 'package:littletech/src/features/game/presentation/screens/scenario_screen.dart';

class MistakeScreen extends StatefulWidget {
  final WorldDef world;
  final LevelDef level;

  const MistakeScreen({super.key, required this.world, required this.level});

  @override
  State<MistakeScreen> createState() => _MistakeScreenState();
}

class _MistakeScreenState extends State<MistakeScreen> {
  int? _selectedIndex;
  bool _solved = false;
  bool _showExplanation = false;

  static const _mistakes = {
    'cpu_high_usage': {
      'steps': [
        {'text': 'Open Task Manager to check which process is using CPU', 'isWrong': false},
        {'text': 'Sort processes by CPU usage to find the culprit', 'isWrong': false},
        {'text': 'Reinstall Windows to fix the CPU usage problem', 'isWrong': true},
        {'text': 'Run a malware scan if a suspicious process is found', 'isWrong': false},
        {'text': 'Disable unnecessary startup programs in Task Manager', 'isWrong': false},
      ],
      'explanation': 'Reinstalling Windows is overkill for high CPU usage. You should first identify and address the specific process causing the issue before resorting to drastic measures.',
    },
    'cpu_overheating': {
      'steps': [
        {'text': 'Check if the CPU fan is spinning and not blocked', 'isWrong': false},
        {'text': 'Clean dust from the fan and heatsink with compressed air', 'isWrong': false},
        {'text': 'Replace the entire computer if it overheats', 'isWrong': true},
        {'text': 'Reapply thermal paste between CPU and cooler', 'isWrong': false},
        {'text': 'Monitor temperatures with HWMonitor to track progress', 'isWrong': false},
      ],
      'explanation': 'Replacing the entire computer is unnecessary for overheating. Most overheating issues can be resolved by cleaning dust, reapplying thermal paste, or improving airflow.',
    },
    'computer_not_turning_on': {
      'steps': [
        {'text': 'Verify the power cable is connected to the PC and outlet', 'isWrong': false},
        {'text': 'Check that the PSU switch at the back is turned on', 'isWrong': false},
        {'text': 'Try a different power cable and wall outlet', 'isWrong': false},
        {'text': 'Replace the motherboard before testing other components', 'isWrong': true},
        {'text': 'Disconnect all peripherals and try powering on again', 'isWrong': false},
      ],
      'explanation': 'Replacing the motherboard before testing simpler fixes wastes time and money. Always check cables, outlets, and the PSU switch before assuming motherboard failure.',
    },
    'pc_wont_boot': {
      'steps': [
        {'text': 'Enter BIOS to check if the boot drive is detected', 'isWrong': false},
        {'text': 'Check all internal cable connections to the drive', 'isWrong': false},
        {'text': 'Boot from a USB recovery drive to repair Windows', 'isWrong': false},
        {'text': 'Buy a new computer instead of troubleshooting', 'isWrong': true},
        {'text': 'Try Safe Mode to see if Windows can load partially', 'isWrong': false},
      ],
      'explanation': 'Buying a new computer is unnecessary when the issue could be a loose cable, corrupted boot record, or failed drive. Always troubleshoot before replacing hardware.',
    },
    'bsod': {
      'steps': [
        {'text': 'Note the stop code displayed on the blue screen', 'isWrong': false},
        {'text': 'Boot into Safe Mode and uninstall recent drivers', 'isWrong': false},
        {'text': 'Ignore the stop code and restart repeatedly', 'isWrong': true},
        {'text': 'Run system file checker (sfc /scannow) to repair files', 'isWrong': false},
        {'text': 'Check RAM with Windows Memory Diagnostic', 'isWrong': false},
      ],
      'explanation': 'Ignoring the stop code and restarting repeatedly wastes time. The stop code tells you exactly what failed — without it, you are troubleshooting blind.',
    },
    'no_internet': {
      'steps': [
        {'text': 'Restart the router and modem by unplugging for 30 seconds', 'isWrong': false},
        {'text': 'Check if other devices on the network have internet', 'isWrong': false},
        {'text': 'Run the Windows Network Troubleshooter', 'isWrong': false},
        {'text': 'Delete all system files to fix the network', 'isWrong': true},
        {'text': 'Reset network settings via Command Prompt', 'isWrong': false},
      ],
      'explanation': 'Deleting system files will break your computer and make the problem worse. Network issues are almost always caused by configuration, hardware, or ISP problems.',
    },
    'battery_draining': {
      'steps': [
        {'text': 'Check battery usage stats to find power-hungry apps', 'isWrong': false},
        {'text': 'Reduce screen brightness and shorten screen timeout', 'isWrong': false},
        {'text': 'Disable background app refresh for non-essential apps', 'isWrong': false},
        {'text': 'Replace the phone battery every month', 'isWrong': true},
        {'text': 'Turn off Bluetooth, GPS, and Wi-Fi when not in use', 'isWrong': false},
      ],
      'explanation': 'Replacing the phone battery monthly is wasteful and unnecessary. Phone batteries typically last 2-3 years. Software optimization is the first step before considering hardware replacement.',
    },
    'game_crashing': {
      'steps': [
        {'text': 'Update GPU drivers to the latest stable version', 'isWrong': false},
        {'text': 'Verify game files through the game launcher', 'isWrong': false},
        {'text': 'Disable overlays like Discord or Steam', 'isWrong': false},
        {'text': 'Buy a new graphics card every time a game crashes', 'isWrong': true},
        {'text': 'Run the game as Administrator', 'isWrong': false},
      ],
      'explanation': 'Buying a new graphics card for every crash is expensive and unnecessary. Most crashes are caused by driver issues, corrupted files, or software conflicts that can be fixed.',
    },
    'printer_offline': {
      'steps': [
        {'text': 'Restart the Print Spooler service in services.msc', 'isWrong': false},
        {'text': 'Check if the printer is set as the default printer', 'isWrong': false},
        {'text': 'Reinstall the printer driver from manufacturer website', 'isWrong': false},
        {'text': 'Throw away the printer and buy a new one', 'isWrong': true},
        {'text': 'Restart both the printer and computer', 'isWrong': false},
      ],
      'explanation': 'Throwing away a printer for an offline status is wasteful. Most offline printer issues are caused by software problems that can be fixed with simple troubleshooting.',
    },
    'smart_device_offline': {
      'steps': [
        {'text': 'Power cycle the device by unplugging for 30 seconds', 'isWrong': false},
        {'text': 'Check if other smart devices on the network are working', 'isWrong': false},
        {'text': 'Re-add the device in the manufacturer\'s app', 'isWrong': false},
        {'text': 'Sell your house because the smart home is broken', 'isWrong': true},
        {'text': 'Check for firmware updates via the companion app', 'isWrong': false},
      ],
      'explanation': 'Selling your house over a single offline smart device is extreme and unnecessary. Most connectivity issues can be resolved by power cycling, re-pairing, or updating firmware.',
    },
  };

  Map<String, dynamic> get _levelMistake {
    return _mistakes[widget.level.id] ?? {
      'steps': [
        {'text': 'Identify the symptoms of the problem', 'isWrong': false},
        {'text': 'Research common causes for these symptoms', 'isWrong': false},
        {'text': 'Destroy all your electronics in frustration', 'isWrong': true},
        {'text': 'Try the simplest fix first', 'isWrong': false},
        {'text': 'Escalate to more complex solutions if needed', 'isWrong': false},
      ],
      'explanation': 'Destroying electronics is never the right approach. Effective troubleshooting always starts with understanding the problem and trying simple solutions first.',
    };
  }

  void _selectStep(int index) {
    if (_solved) return;
    final steps = _levelMistake['steps'] as List<Map<String, dynamic>>;
    final isWrong = steps[index]['isWrong'] as bool;

    setState(() {
      _selectedIndex = index;
      if (isWrong) {
        _solved = true;
        context.read<GameCubit>().addPoints(10);
        context.read<GameCubit>().saveMistakeResult(widget.level.id, true);
        Future.delayed(800.ms, () {
          if (mounted) {
            setState(() => _showExplanation = true);
          }
        });
      }
    });
  }

  void _continue() {
    Nav.pushReplacement(
      context,
      ScenarioScreen(world: widget.world, level: widget.level),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final steps = _levelMistake['steps'] as List<Map<String, dynamic>>;
    final explanation = _levelMistake['explanation'] as String;

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        title: const Text('Spot the Mistake'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: scheme.tertiary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.tertiary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: scheme.tertiary, size: 20),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      'One of these troubleshooting steps is WRONG. Tap it to identify the mistake.',
                      style: TextStyle(
                        color: scheme.tertiary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (_, i) {
                  final step = steps[i];
                  final text = step['text'] as String;
                  final isWrong = step['isWrong'] as bool;
                  final isSelected = _selectedIndex == i;

                  Color bgColor;
                  Color borderColor;
                  if (_solved && isWrong) {
                    bgColor = Colors.green.withValues(alpha: 0.1);
                    borderColor = Colors.green;
                  } else if (!_solved && isSelected) {
                    bgColor = Colors.red.withValues(alpha: 0.1);
                    borderColor = Colors.red;
                  } else if (_solved && isSelected && !isWrong) {
                    bgColor = Colors.red.withValues(alpha: 0.05);
                    borderColor = Colors.red.withValues(alpha: 0.5);
                  } else {
                    bgColor = scheme.surface;
                    borderColor = scheme.outline.withValues(alpha: 0.3);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _solved ? null : () => _selectStep(i),
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
                                  color: _solved && isWrong
                                      ? Colors.green
                                      : _solved && isSelected && !isWrong
                                          ? Colors.red
                                          : scheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _solved && isWrong
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : _solved && isSelected && !isWrong
                                        ? const Icon(Icons.close, color: Colors.white, size: 16)
                                        : Text(
                                            '${i + 1}',
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
                                  text,
                                  style: TextStyle(
                                    color: _solved && isWrong
                                        ? Colors.green
                                        : _solved && isSelected && !isWrong
                                            ? Colors.red
                                            : scheme.onSurface,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: (80 * i).ms).slideX(begin: 0.05);
                },
              ),
            ),
            if (!_solved && _selectedIndex != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red.shade300, size: 18),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        'Not quite — that step is correct. Try again!',
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
            if (_showExplanation)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade300, size: 18),
                        const Gap(8),
                        Text(
                          'Correct! You spotted the mistake',
                          style: TextStyle(
                            color: Colors.green.shade300,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Text(
                      explanation,
                      style: TextStyle(
                        color: Colors.green.shade300,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _solved ? _continue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                  disabledBackgroundColor: scheme.outline.withValues(alpha: 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Continue to Scenarios',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
