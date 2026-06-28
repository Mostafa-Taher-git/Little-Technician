import 'package:flutter/material.dart';

enum SkinTier {
  default_, rookie, ninja, wizard, golden, hacker, engineer, grandmaster,
  cyber, shadow, neon, phoenix, titan, void_, glitch, frost, chrono, spectre, viper, spark
}

enum SupTechExpression { neutral, happy, angry, surprised, determined, wink, sleep, error }

enum SupTechHeadAccessory { none, antenna }

enum SupTechEarAccessory { none, headset }

enum SupTechChestAccessory { none, badge }

class AvatarState {
  final SupTechExpression expression;
  final bool blinking;
  final Offset lookDirection;

  const AvatarState({
    this.expression = SupTechExpression.neutral,
    this.blinking = false,
    this.lookDirection = Offset.zero,
  });
}

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
  final SupTechHeadAccessory headAccessory;
  final SupTechEarAccessory earAccessory;
  final SupTechChestAccessory chestAccessory;
  final bool showLogo;

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
    this.headAccessory = SupTechHeadAccessory.none,
    this.earAccessory = SupTechEarAccessory.none,
    this.chestAccessory = SupTechChestAccessory.none,
    this.showLogo = true,
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
      description: 'A dark hooded chibi with a gray robe and blue glow',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
      bodyColor: Color(0xFF5A626A),
      accentColor: Color(0xFF38BDF8),
      chestAccessory: SupTechChestAccessory.badge,
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
      headAccessory: SupTechHeadAccessory.antenna,
    ),
    SkinDefinition(
      id: 'ninja',
      name: 'Network Ninja',
      tier: SkinTier.ninja,
      description: 'A purple hooded stealth specialist with a headset',
      levelsRequired: 15,
      previewIcon: Icons.auto_awesome_motion,
      bodyColor: Color(0xFF7C3AED),
      accentColor: Color(0xFFA78BFA),
      earAccessory: SupTechEarAccessory.headset,
    ),
    SkinDefinition(
      id: 'wizard',
      name: 'System Wizard',
      tier: SkinTier.wizard,
      description: 'A brown-robed mage with deep system knowledge',
      levelsRequired: 30,
      previewIcon: Icons.workspace_premium,
      bodyColor: Color(0xFF92400E),
      accentColor: Color(0xFFF59E0B),
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
      chestAccessory: SupTechChestAccessory.badge,
    ),
    SkinDefinition(
      id: 'hacker',
      name: 'Hacker',
      tier: SkinTier.hacker,
      description: 'A green phantom who sees through firewalls',
      levelsRequired: 0,
      previewIcon: Icons.terminal,
      isRewardSkin: true,
      bodyColor: Color(0xFF059669),
      accentColor: Color(0xFF34D399),
      earAccessory: SupTechEarAccessory.headset,
    ),
    SkinDefinition(
      id: 'engineer',
      name: 'Engineer',
      tier: SkinTier.engineer,
      description: 'An indigo-robed builder with gear of creation',
      levelsRequired: 0,
      previewIcon: Icons.engineering,
      isRewardSkin: true,
      bodyColor: Color(0xFF4338CA),
      accentColor: Color(0xFF818CF8),
      chestAccessory: SupTechChestAccessory.badge,
    ),
    SkinDefinition(
      id: 'grandmaster',
      name: 'Grandmaster',
      tier: SkinTier.grandmaster,
      description: 'An amber legend radiating golden power',
      levelsRequired: 0,
      previewIcon: Icons.auto_awesome,
      isRewardSkin: true,
      bodyColor: Color(0xFFD97706),
      accentColor: Color(0xFFFDE68A),
      chestAccessory: SupTechChestAccessory.badge,
    ),
    SkinDefinition(
      id: 'cyber',
      name: 'Cyber Scout',
      tier: SkinTier.cyber,
      description: 'A cyan scout with enhanced digital senses',
      levelsRequired: 0,
      previewIcon: Icons.phonelink,
      isRewardSkin: true,
      bodyColor: Color(0xFF06B6D4),
      accentColor: Color(0xFF22D3EE),
      earAccessory: SupTechEarAccessory.headset,
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
      showLogo: false,
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
      headAccessory: SupTechHeadAccessory.antenna,
    ),
    SkinDefinition(
      id: 'phoenix',
      name: 'Phoenix Coder',
      tier: SkinTier.phoenix,
      description: 'An orange flame reborn from every system crash',
      levelsRequired: 0,
      previewIcon: Icons.local_fire_department,
      isRewardSkin: true,
      bodyColor: Color(0xFFEA580C),
      accentColor: Color(0xFFFB923C),
      chestAccessory: SupTechChestAccessory.badge,
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
      chestAccessory: SupTechChestAccessory.badge,
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
      earAccessory: SupTechEarAccessory.headset,
      showLogo: false,
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
      earAccessory: SupTechEarAccessory.headset,
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
      chestAccessory: SupTechChestAccessory.badge,
    ),
    SkinDefinition(
      id: 'spectre',
      name: 'Spectre Admin',
      tier: SkinTier.spectre,
      description: 'A white phantom with supreme admin access',
      levelsRequired: 0,
      previewIcon: Icons.admin_panel_settings,
      isRewardSkin: true,
      bodyColor: Color(0xFFE2E8F0),
      accentColor: Color(0xFFF1F5F9),
      showLogo: false,
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
      earAccessory: SupTechEarAccessory.headset,
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
      headAccessory: SupTechHeadAccessory.antenna,
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
