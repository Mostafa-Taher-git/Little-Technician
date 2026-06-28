import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/prep_data.dart';

class AltSolutionBanner extends StatelessWidget {
  final WorldDef world;
  final LevelDef level;
  final VoidCallback? onTapAlternative;

  const AltSolutionBanner({
    super.key,
    required this.world,
    required this.level,
    this.onTapAlternative,
  });

  static const _alternatives = {
    'cpu_high_usage': [
      'Try disabling startup programs via System Configuration (msconfig)',
      'Check for cryptocurrency mining malware in your browser extensions',
      'Update or roll back the latest Windows update in Settings',
    ],
    'no_internet': [
      'Release and renew your IP: ipconfig /release then ipconfig /renew',
      'Temporarily disable firewall/antivirus to rule out blocking',
      'Boot into Safe Mode with Networking to test connectivity',
    ],
    'bsod': [
      'Use Driver Verifier (verifier.exe) to identify problematic drivers',
      'Check for overheating — high temps cause random BSODs',
      'Run chkdsk /f to check for disk-related BSOD causes',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final alts = _alternatives[PrepData.key(level.id)] ?? [
      'Try searching the exact error message on Google or forums',
      'Check the manufacturer website for known issues with this device',
      'Consider asking a fellow IT professional for a second opinion',
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.construction, color: Colors.orange, size: 18),
              const Gap(8),
              Text(
                'Seek alternative wisdom? Try these ancient techniques:',
                style: TextStyle(
                  color: Colors.orange.shade300,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Gap(8),
          ...alts.map((alt) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_right, size: 16, color: Colors.orange.shade200),
                Expanded(
                  child: Text(
                    alt,
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          )),
          if (onTapAlternative != null) ...[
            const Gap(12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: onTapAlternative,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: BorderSide(color: Colors.orange.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.replay, size: 18),
                label: const Text(
                  'This didn\'t work — retry with alternatives',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
