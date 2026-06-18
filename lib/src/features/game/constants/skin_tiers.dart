import 'package:flutter/material.dart';

enum SkinTier { apprentice, adept, expert, master, grandmaster }

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
      SkinTier.apprentice => Colors.grey,
      SkinTier.adept => Colors.blue,
      SkinTier.expert => Colors.purple,
      SkinTier.master => Colors.amber,
      SkinTier.grandmaster => Colors.red,
    };
  }

  String get tierLabel {
    return switch (tier) {
      SkinTier.apprentice => 'Apprentice',
      SkinTier.adept => 'Adept',
      SkinTier.expert => 'Expert',
      SkinTier.master => 'Master',
      SkinTier.grandmaster => 'Grandmaster',
    };
  }
}

class SkinTierManager {
  static const List<SkinDefinition> skins = [
    SkinDefinition(
      id: 'apprentice',
      name: 'Apprentice Familiar',
      tier: SkinTier.apprentice,
      description: 'A eager young spirit just beginning its journey',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
    ),
    SkinDefinition(
      id: 'adept',
      name: 'Adept Familiar',
      tier: SkinTier.adept,
      description: 'A seasoned companion with glowing aura',
      levelsRequired: 5,
      previewIcon: Icons.auto_awesome_mosaic,
    ),
    SkinDefinition(
      id: 'expert',
      name: 'Expert Familiar',
      tier: SkinTier.expert,
      description: 'An expert guide with arcane runes',
      levelsRequired: 15,
      previewIcon: Icons.auto_awesome_motion,
    ),
    SkinDefinition(
      id: 'master',
      name: 'Master Familiar',
      tier: SkinTier.master,
      description: 'A master of the arcane arts with golden trim',
      levelsRequired: 30,
      previewIcon: Icons.workspace_premium,
    ),
    SkinDefinition(
      id: 'grandmaster',
      name: 'Grandmaster Familiar',
      tier: SkinTier.grandmaster,
      description: 'The legendary form — radiant and all-knowing',
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
