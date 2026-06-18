import 'package:flutter/material.dart';

enum SkinTier { default_, rookie, ninja, wizard, golden }

class SkinDefinition {
  final String id;
  final String name;
  final SkinTier tier;
  final String description;
  final int levelsRequired;
  final IconData previewIcon;

  const SkinDefinition({
    required this.id,
    required this.name,
    required this.tier,
    required this.description,
    required this.levelsRequired,
    required this.previewIcon,
  });

  Color get color {
    return switch (tier) {
      SkinTier.default_ => Colors.grey,
      SkinTier.rookie => Colors.blue,
      SkinTier.ninja => Colors.purple,
      SkinTier.wizard => Colors.amber,
      SkinTier.golden => Colors.red,
    };
  }

  String get tierLabel {
    return switch (tier) {
      SkinTier.default_ => 'Default SupTech',
      SkinTier.rookie => 'Tech Rookie',
      SkinTier.ninja => 'Network Ninja',
      SkinTier.wizard => 'System Wizard',
      SkinTier.golden => 'Golden SupTech',
    };
  }
}

class SkinTierManager {
  static const List<SkinDefinition> skins = [
    SkinDefinition(
      id: 'default',
      name: 'Default SupTech',
      tier: SkinTier.default_,
      description: 'Your trusty gray companion — the journey begins',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
    ),
    SkinDefinition(
      id: 'rookie',
      name: 'Tech Rookie',
      tier: SkinTier.rookie,
      description: 'A blue-glowing novice with basic troubleshooting skills',
      levelsRequired: 5,
      previewIcon: Icons.auto_awesome_mosaic,
    ),
    SkinDefinition(
      id: 'ninja',
      name: 'Network Ninja',
      tier: SkinTier.ninja,
      description: 'A purple-cloaked specialist in connectivity and systems',
      levelsRequired: 15,
      previewIcon: Icons.auto_awesome_motion,
    ),
    SkinDefinition(
      id: 'wizard',
      name: 'System Wizard',
      tier: SkinTier.wizard,
      description: 'A golden-trimmed master of all things technical',
      levelsRequired: 30,
      previewIcon: Icons.workspace_premium,
    ),
    SkinDefinition(
      id: 'golden',
      name: 'Golden SupTech',
      tier: SkinTier.golden,
      description: 'The legendary golden form — radiant and all-knowing',
      levelsRequired: 50,
      previewIcon: Icons.auto_awesome,
    ),
  ];

  static SkinDefinition? skinForLevelsCleared(int cleared) {
    SkinDefinition? best;
    for (final s in skins) {
      if (cleared >= s.levelsRequired) best = s;
    }
    return best;
  }
}
