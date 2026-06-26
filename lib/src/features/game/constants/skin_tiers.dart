import 'package:flutter/material.dart';

enum SkinTier {
  default_, rookie, ninja, wizard, golden, hacker, engineer, grandmaster,
  cyber, shadow, neon, phoenix, titan, void_, glitch, frost, chrono, spectre, viper, spark
}

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
      SkinTier.cyber => const Color(0xFF06B6D4),
      SkinTier.shadow => const Color(0xFF581C87),
      SkinTier.neon => const Color(0xFF16A34A),
      SkinTier.phoenix => const Color(0xFFEA580C),
      SkinTier.titan => const Color(0xFF475569),
      SkinTier.void_ => const Color(0xFF4C1D95),
      SkinTier.glitch => const Color(0xFFDB2777),
      SkinTier.frost => const Color(0xFF0284C7),
      SkinTier.chrono => const Color(0xFFCA8A04),
      SkinTier.spectre => const Color(0xFFE2E8F0),
      SkinTier.viper => const Color(0xFF15803D),
      SkinTier.spark => const Color(0xFFEAB308),
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
      SkinTier.cyber => 'Cyber Scout',
      SkinTier.shadow => 'Shadow Coder',
      SkinTier.neon => 'Neon Rider',
      SkinTier.phoenix => 'Phoenix Coder',
      SkinTier.titan => 'Titan Tech',
      SkinTier.void_ => 'Void Walker',
      SkinTier.glitch => 'Glitch Master',
      SkinTier.frost => 'Frost Byte',
      SkinTier.chrono => 'Chrono Tech',
      SkinTier.spectre => 'Spectre Admin',
      SkinTier.viper => 'Viper Security',
      SkinTier.spark => 'Spark Circuit',
    };
  }
}

class SkinTierManager {
  static SkinDefinition fromId(String? id) {
    return skins.firstWhere(
      (s) => s.id == id,
      orElse: () => skins.first,
    );
  }

  static const List<SkinDefinition> skins = [
    SkinDefinition(
      id: 'default',
      name: 'Default SupTech',
      tier: SkinTier.default_,
      description: 'A dark hooded chibi with a gray robe and silver glow',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
      bodyColor: Color(0xFF6B7280),
      accentColor: Color(0xFF9CA3AF),
    ),
    SkinDefinition(
      id: 'rookie',
      name: 'Tech Rookie',
      tier: SkinTier.rookie,
      description: 'A blue-robed novice with an antenna for detecting signals',
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
      description: 'A purple hooded stealth specialist with a headband',
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
      description: 'A dark-robed figure crowned with golden authority',
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
      description: 'An indigo-robed builder with a gear of creation',
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
    SkinDefinition(
      id: 'cyber',
      name: 'Cyber Scout',
      tier: SkinTier.cyber,
      description: 'A cyan-robed scout with enhanced digital senses',
      levelsRequired: 0,
      previewIcon: Icons.phonelink,
      isRewardSkin: true,
      bodyColor: Color(0xFF06B6D4),
      accentColor: Color(0xFF22D3EE),
      accessory: SupTechAccessory.headband,
    ),
    SkinDefinition(
      id: 'shadow',
      name: 'Shadow Coder',
      tier: SkinTier.shadow,
      description: 'A dark phantom who moves unseen through firewalls',
      levelsRequired: 0,
      previewIcon: Icons.visibility_off,
      isRewardSkin: true,
      bodyColor: Color(0xFF581C87),
      accentColor: Color(0xFF7C3AED),
      accessory: SupTechAccessory.visor,
    ),
    SkinDefinition(
      id: 'neon',
      name: 'Neon Rider',
      tier: SkinTier.neon,
      description: 'A green-glowing speedster powered by pure energy',
      levelsRequired: 0,
      previewIcon: Icons.bolt,
      isRewardSkin: true,
      bodyColor: Color(0xFF16A34A),
      accentColor: Color(0xFF4ADE80),
      accessory: SupTechAccessory.antenna,
    ),
    SkinDefinition(
      id: 'phoenix',
      name: 'Phoenix Coder',
      tier: SkinTier.phoenix,
      description: 'An orange-robed flame reborn from every system crash',
      levelsRequired: 0,
      previewIcon: Icons.local_fire_department,
      isRewardSkin: true,
      bodyColor: Color(0xFFEA580C),
      accentColor: Color(0xFFFB923C),
      accessory: SupTechAccessory.crown,
    ),
    SkinDefinition(
      id: 'titan',
      name: 'Titan Tech',
      tier: SkinTier.titan,
      description: 'A steel-gray colossus of hardware engineering',
      levelsRequired: 0,
      previewIcon: Icons.hardware,
      isRewardSkin: true,
      bodyColor: Color(0xFF475569),
      accentColor: Color(0xFF94A3B8),
      accessory: SupTechAccessory.gear,
    ),
    SkinDefinition(
      id: 'void_',
      name: 'Void Walker',
      tier: SkinTier.void_,
      description: 'A deep purple entity from the digital void',
      levelsRequired: 0,
      previewIcon: Icons.all_inclusive,
      isRewardSkin: true,
      bodyColor: Color(0xFF4C1D95),
      accentColor: Color(0xFF7C3AED),
      accessory: SupTechAccessory.cape,
    ),
    SkinDefinition(
      id: 'glitch',
      name: 'Glitch Master',
      tier: SkinTier.glitch,
      description: 'A pink-glitched anomaly bending reality',
      levelsRequired: 0,
      previewIcon: Icons.bug_report,
      isRewardSkin: true,
      bodyColor: Color(0xFFDB2777),
      accentColor: Color(0xFFF472B6),
      accessory: SupTechAccessory.headband,
    ),
    SkinDefinition(
      id: 'frost',
      name: 'Frost Byte',
      tier: SkinTier.frost,
      description: 'An ice-cold specialist who freezes system errors',
      levelsRequired: 0,
      previewIcon: Icons.ac_unit,
      isRewardSkin: true,
      bodyColor: Color(0xFF0284C7),
      accentColor: Color(0xFF7DD3FC),
      accessory: SupTechAccessory.pointedHat,
    ),
    SkinDefinition(
      id: 'chrono',
      name: 'Chrono Tech',
      tier: SkinTier.chrono,
      description: 'A golden time-bender mastering system clocks',
      levelsRequired: 0,
      previewIcon: Icons.schedule,
      isRewardSkin: true,
      bodyColor: Color(0xFFCA8A04),
      accentColor: Color(0xFFFACC15),
      accessory: SupTechAccessory.crown,
    ),
    SkinDefinition(
      id: 'spectre',
      name: 'Spectre Admin',
      tier: SkinTier.spectre,
      description: 'A white phantom with supreme administrative access',
      levelsRequired: 0,
      previewIcon: Icons.admin_panel_settings,
      isRewardSkin: true,
      bodyColor: Color(0xFFE2E8F0),
      accentColor: Color(0xFFF1F5F9),
      accessory: SupTechAccessory.cape,
    ),
    SkinDefinition(
      id: 'viper',
      name: 'Viper Security',
      tier: SkinTier.viper,
      description: 'A green venomous defender against digital threats',
      levelsRequired: 0,
      previewIcon: Icons.security,
      isRewardSkin: true,
      bodyColor: Color(0xFF15803D),
      accentColor: Color(0xFF86EFAC),
      accessory: SupTechAccessory.visor,
    ),
    SkinDefinition(
      id: 'spark',
      name: 'Spark Circuit',
      tier: SkinTier.spark,
      description: 'An electric yellow powerhouse surging with energy',
      levelsRequired: 0,
      previewIcon: Icons.electric_bolt,
      isRewardSkin: true,
      bodyColor: Color(0xFFEAB308),
      accentColor: Color(0xFFFDE047),
      accessory: SupTechAccessory.antenna,
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
