import 'package:flutter/material.dart';

enum SkinTier { default_, rookie, ninja, wizard, golden, hacker, engineer, grandmaster }

enum SupTechAccessory { none, antenna, headband, pointedHat, crown, visor, gear, cape }

class SkinDefinition {
  final String id;
  final String name;
  final SkinTier tier;
  final String description;
  final int levelsRequired;
  final IconData previewIcon;
  final bool isRewardSkin;
  final Color bodyColor;
  final Color accentColor;
  final SupTechAccessory accessory;

  const SkinDefinition({
    required this.id,
    required this.name,
    required this.tier,
    required this.description,
    required this.levelsRequired,
    required this.previewIcon,
    this.isRewardSkin = false,
    required this.bodyColor,
    required this.accentColor,
    this.accessory = SupTechAccessory.none,
  });

  Color get color {
    return switch (tier) {
      SkinTier.default_ => const Color(0xFF6B7280),
      SkinTier.rookie => const Color(0xFF2563EB),
      SkinTier.ninja => const Color(0xFF7C3AED),
      SkinTier.wizard => const Color(0xFF92400E),
      SkinTier.golden => const Color(0xFFDC2626),
      SkinTier.hacker => const Color(0xFF059669),
      SkinTier.engineer => const Color(0xFF4338CA),
      SkinTier.grandmaster => const Color(0xFFD97706),
    };
  }

  String get tierLabel {
    return switch (tier) {
      SkinTier.default_ => 'Default SupTech',
      SkinTier.rookie => 'Tech Rookie',
      SkinTier.ninja => 'Network Ninja',
      SkinTier.wizard => 'System Wizard',
      SkinTier.golden => 'Golden SupTech',
      SkinTier.hacker => 'Hacker',
      SkinTier.engineer => 'Engineer',
      SkinTier.grandmaster => 'Grandmaster',
    };
  }
}

class SkinTierManager {
  static const List<SkinDefinition> skins = [
    SkinDefinition(
      id: 'default',
      name: 'Default SupTech',
      tier: SkinTier.default_,
      description: 'A friendly gray companion ready for adventure',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
      bodyColor: Color(0xFF6B7280),
      accentColor: Color(0xFF9CA3AF),
    ),
    SkinDefinition(
      id: 'rookie',
      name: 'Tech Rookie',
      tier: SkinTier.rookie,
      description: 'A blue-capped novice with an antenna for detecting signals',
      levelsRequired: 5,
      previewIcon: Icons.auto_awesome_mosaic,
      bodyColor: Color(0xFF2563EB),
      accentColor: Color(0xFF60A5FA),
      accessory: SupTechAccessory.antenna,
    ),
    SkinDefinition(
      id: 'ninja',
      name: 'Network Ninja',
      tier: SkinTier.ninja,
      description: 'A purple headband-wrapped stealth specialist',
      levelsRequired: 15,
      previewIcon: Icons.auto_awesome_motion,
      bodyColor: Color(0xFF7C3AED),
      accentColor: Color(0xFFA78BFA),
      accessory: SupTechAccessory.headband,
    ),
    SkinDefinition(
      id: 'wizard',
      name: 'System Wizard',
      tier: SkinTier.wizard,
      description: 'A brown-robed mage with a pointed hat of knowledge',
      levelsRequired: 30,
      previewIcon: Icons.workspace_premium,
      bodyColor: Color(0xFF92400E),
      accentColor: Color(0xFFF59E0B),
      accessory: SupTechAccessory.pointedHat,
    ),
    SkinDefinition(
      id: 'golden',
      name: 'Golden SupTech',
      tier: SkinTier.golden,
      description: 'A red-suited hero crowned with golden authority',
      levelsRequired: 50,
      previewIcon: Icons.auto_awesome,
      bodyColor: Color(0xFFDC2626),
      accentColor: Color(0xFFFCD34D),
      accessory: SupTechAccessory.crown,
    ),
    SkinDefinition(
      id: 'hacker',
      name: 'Hacker',
      tier: SkinTier.hacker,
      description: 'A green-veiled phantom who sees through firewalls',
      levelsRequired: 0,
      previewIcon: Icons.terminal,
      isRewardSkin: true,
      bodyColor: Color(0xFF059669),
      accentColor: Color(0xFF34D399),
      accessory: SupTechAccessory.visor,
    ),
    SkinDefinition(
      id: 'engineer',
      name: 'Engineer',
      tier: SkinTier.engineer,
      description: 'An indigo-clad builder with a gear of creation',
      levelsRequired: 0,
      previewIcon: Icons.engineering,
      isRewardSkin: true,
      bodyColor: Color(0xFF4338CA),
      accentColor: Color(0xFF818CF8),
      accessory: SupTechAccessory.gear,
    ),
    SkinDefinition(
      id: 'grandmaster',
      name: 'Grandmaster',
      tier: SkinTier.grandmaster,
      description: 'An amber-caped legend radiating golden power',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
      isRewardSkin: true,
      bodyColor: Color(0xFFD97706),
      accentColor: Color(0xFFFDE68A),
      accessory: SupTechAccessory.cape,
    ),
  ];

  static SkinDefinition? skinForLevelsCleared(int cleared) {
    SkinDefinition? best;
    for (final s in skins) {
      if (!s.isRewardSkin && cleared >= s.levelsRequired) best = s;
    }
    return best;
  }

  static SkinDefinition? byId(String id) {
    for (final s in skins) {
      if (s.id == id) return s;
    }
    return null;
  }

  static SkinDefinition getActiveSkin(String? activeSkinId) {
    if (activeSkinId != null) {
      final skin = byId(activeSkinId);
      if (skin != null) return skin;
    }
    return skins.first;
  }
}
