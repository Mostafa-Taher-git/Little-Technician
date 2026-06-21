import 'package:flutter/material.dart';

enum SkinTier { default_, rookie, ninja, wizard, golden, hacker, engineer, grandmaster }

class SkinDefinition {
  final String id;
  final String name;
  final SkinTier tier;
  final String description;
  final int levelsRequired;
  final IconData previewIcon;
  final bool isRewardSkin;
  final Color robeColor;
  final Color trimColor;
  final Color eyeColor;
  final bool hasAntenna;
  final bool hasScarf;
  final bool hasWizardHat;
  final bool hasCrown;
  final bool hasVisor;
  final bool hasGearEmblem;
  final bool hasCape;

  const SkinDefinition({
    required this.id,
    required this.name,
    required this.tier,
    required this.description,
    required this.levelsRequired,
    required this.previewIcon,
    this.isRewardSkin = false,
    required this.robeColor,
    required this.trimColor,
    required this.eyeColor,
    this.hasAntenna = false,
    this.hasScarf = false,
    this.hasWizardHat = false,
    this.hasCrown = false,
    this.hasVisor = false,
    this.hasGearEmblem = false,
    this.hasCape = false,
  });

  Color get color {
    return switch (tier) {
      SkinTier.default_ => Colors.grey,
      SkinTier.rookie => Colors.blue,
      SkinTier.ninja => Colors.purple,
      SkinTier.wizard => Colors.amber,
      SkinTier.golden => Colors.red,
      SkinTier.hacker => const Color(0xFF00E676),
      SkinTier.engineer => const Color(0xFF7C4DFF),
      SkinTier.grandmaster => const Color(0xFFFFD700),
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
    // Progression skins (unlocked by levels cleared)
    SkinDefinition(
      id: 'default',
      name: 'Default SupTech',
      tier: SkinTier.default_,
      description: 'Your trusty gray companion — the journey begins',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
      robeColor: Color(0xFF4A4A4A),
      trimColor: Color(0xFF888888),
      eyeColor: Color(0xFF1A202C),
    ),
    SkinDefinition(
      id: 'rookie',
      name: 'Tech Rookie',
      tier: SkinTier.rookie,
      description: 'A blue-glowing novice with basic troubleshooting skills',
      levelsRequired: 5,
      previewIcon: Icons.auto_awesome_mosaic,
      robeColor: Color(0xFF1565C0),
      trimColor: Color(0xFF42A5F5),
      eyeColor: Color(0xFF42A5F5),
      hasAntenna: true,
    ),
    SkinDefinition(
      id: 'ninja',
      name: 'Network Ninja',
      tier: SkinTier.ninja,
      description: 'A purple-cloaked specialist in connectivity and systems',
      levelsRequired: 15,
      previewIcon: Icons.auto_awesome_motion,
      robeColor: Color(0xFF6A1B9A),
      trimColor: Color(0xFFAB47BC),
      eyeColor: Color(0xFFCE93D8),
      hasScarf: true,
    ),
    SkinDefinition(
      id: 'wizard',
      name: 'System Wizard',
      tier: SkinTier.wizard,
      description: 'A golden-trimmed master of all things technical',
      levelsRequired: 30,
      previewIcon: Icons.workspace_premium,
      robeColor: Color(0xFF5D4037),
      trimColor: Color(0xFFFFB300),
      eyeColor: Color(0xFFFFB300),
      hasWizardHat: true,
    ),
    SkinDefinition(
      id: 'golden',
      name: 'Golden SupTech',
      tier: SkinTier.golden,
      description: 'The legendary golden form — radiant and all-knowing',
      levelsRequired: 50,
      previewIcon: Icons.auto_awesome,
      robeColor: Color(0xFFBF360C),
      trimColor: Color(0xFFFFD700),
      eyeColor: Color(0xFFFFD700),
      hasCrown: true,
    ),
    // Reward skins (unlocked from dungeon rewards)
    SkinDefinition(
      id: 'hacker',
      name: 'Hacker',
      tier: SkinTier.hacker,
      description: 'A green-glowing rogue who bends systems to their will',
      levelsRequired: 0,
      previewIcon: Icons.terminal,
      isRewardSkin: true,
      robeColor: Color(0xFF1B5E20),
      trimColor: Color(0xFF00E676),
      eyeColor: Color(0xFF00E676),
      hasVisor: true,
    ),
    SkinDefinition(
      id: 'engineer',
      name: 'Engineer',
      tier: SkinTier.engineer,
      description: 'A violet-clad master builder with arcane circuit knowledge',
      levelsRequired: 0,
      previewIcon: Icons.engineering,
      isRewardSkin: true,
      robeColor: Color(0xFF311B92),
      trimColor: Color(0xFF7C4DFF),
      eyeColor: Color(0xFFB388FF),
      hasGearEmblem: true,
    ),
    SkinDefinition(
      id: 'grandmaster',
      name: 'Grandmaster',
      tier: SkinTier.grandmaster,
      description: 'The ultimate golden form — radiant and all-powerful',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
      isRewardSkin: true,
      robeColor: Color(0xFFF57F17),
      trimColor: Color(0xFFFFD700),
      eyeColor: Color(0xFFFFEB3B),
      hasCape: true,
    ),
  ];

  /// Returns the best progression skin for levels cleared.
  static SkinDefinition? skinForLevelsCleared(int cleared) {
    SkinDefinition? best;
    for (final s in skins) {
      if (!s.isRewardSkin && cleared >= s.levelsRequired) best = s;
    }
    return best;
  }

  /// Find skin definition by ID.
  static SkinDefinition? byId(String id) {
    for (final s in skins) {
      if (s.id == id) return s;
    }
    return null;
  }

  /// Get the active skin, falling back to default.
  static SkinDefinition getActiveSkin(String? activeSkinId) {
    if (activeSkinId != null) {
      final skin = byId(activeSkinId);
      if (skin != null) return skin;
    }
    return skins.first; // default
  }
}
