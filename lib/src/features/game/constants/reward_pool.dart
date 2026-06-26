import 'dart:math';
import 'package:flutter/material.dart';

enum RewardType { icon, title, nicknameFrame, theme, skin }

enum Rarity { common, rare, epic, legendary }

class RewardDef {
  final String id;
  final RewardType type;
  final String value;
  final Rarity rarity;
  final String displayName;
  final IconData icon;
  final Color? frameColor;

  const RewardDef({
    required this.id,
    required this.type,
    required this.value,
    required this.rarity,
    required this.displayName,
    required this.icon,
    this.frameColor,
  });

  Color get color {
    if (frameColor != null) return frameColor!;
    return switch (rarity) {
      Rarity.common => Colors.grey,
      Rarity.rare => Colors.blue,
      Rarity.epic => Colors.purple,
      Rarity.legendary => Colors.amber,
    };
  }

  double get weight {
    return switch (rarity) {
      Rarity.common => 60,
      Rarity.rare => 25,
      Rarity.epic => 12,
      Rarity.legendary => 3,
    };
  }
}

class RewardPool {
  static const List<RewardDef> rewards = [
    // Common rewards (60%)
    RewardDef(
      id: 'icon_wrench',
      type: RewardType.icon,
      value: '🔧',
      rarity: Rarity.common,
      displayName: 'Wrench Icon',
      icon: Icons.build,
    ),
    RewardDef(
      id: 'icon_screwdriver',
      type: RewardType.icon,
      value: '🪛',
      rarity: Rarity.common,
      displayName: 'Screwdriver Icon',
      icon: Icons.build_circle,
    ),
    RewardDef(
      id: 'icon_gear',
      type: RewardType.icon,
      value: '⚙️',
      rarity: Rarity.common,
      displayName: 'Gear Icon',
      icon: Icons.settings,
    ),
    RewardDef(
      id: 'icon_mouse',
      type: RewardType.icon,
      value: '🖱️',
      rarity: Rarity.common,
      displayName: 'Mouse Icon',
      icon: Icons.mouse,
    ),
    RewardDef(
      id: 'icon_keyboard',
      type: RewardType.icon,
      value: '⌨️',
      rarity: Rarity.common,
      displayName: 'Keyboard Icon',
      icon: Icons.keyboard,
    ),
    RewardDef(
      id: 'icon_plug',
      type: RewardType.icon,
      value: '🔌',
      rarity: Rarity.common,
      displayName: 'Plug Icon',
      icon: Icons.power,
    ),
    RewardDef(
      id: 'title_tech_novice',
      type: RewardType.title,
      value: 'Squire',
      rarity: Rarity.common,
      displayName: 'Title: Squire',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'title_fixer',
      type: RewardType.title,
      value: 'The Fixer',
      rarity: Rarity.common,
      displayName: 'Title: The Fixer',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'title_helper',
      type: RewardType.title,
      value: 'Helper',
      rarity: Rarity.common,
      displayName: 'Title: Helper',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'frame_simple',
      type: RewardType.nicknameFrame,
      value: 'simple_frame',
      rarity: Rarity.common,
      displayName: 'Simple Frame',
      icon: Icons.crop_square,
      frameColor: Color(0xFF9CA3AF),
    ),
    RewardDef(
      id: 'frame_dotted',
      type: RewardType.nicknameFrame,
      value: 'dotted_frame',
      rarity: Rarity.common,
      displayName: 'Dotted Frame',
      icon: Icons.border_style,
      frameColor: Color(0xFF9CA3AF),
    ),
    RewardDef(
      id: 'theme_dark',
      type: RewardType.theme,
      value: 'dark',
      rarity: Rarity.common,
      displayName: 'Midnight Theme',
      icon: Icons.dark_mode,
    ),

    // Rare rewards (25%)
    RewardDef(
      id: 'icon_laptop',
      type: RewardType.icon,
      value: '💻',
      rarity: Rarity.rare,
      displayName: 'Laptop Icon',
      icon: Icons.computer,
    ),
    RewardDef(
      id: 'icon_server',
      type: RewardType.icon,
      value: '🖥️',
      rarity: Rarity.rare,
      displayName: 'Server Icon',
      icon: Icons.dns,
    ),
    RewardDef(
      id: 'icon_battery',
      type: RewardType.icon,
      value: '🔋',
      rarity: Rarity.rare,
      displayName: 'Battery Icon',
      icon: Icons.battery_std,
    ),
    RewardDef(
      id: 'icon_wifi',
      type: RewardType.icon,
      value: '📶',
      rarity: Rarity.rare,
      displayName: 'WiFi Icon',
      icon: Icons.wifi,
    ),
    RewardDef(
      id: 'title_engineer',
      type: RewardType.title,
      value: 'Engineer',
      rarity: Rarity.rare,
      displayName: 'Title: Engineer',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'title_debugger',
      type: RewardType.title,
      value: 'Debugger',
      rarity: Rarity.rare,
      displayName: 'Title: Debugger',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'title_analyst',
      type: RewardType.title,
      value: 'Analyst',
      rarity: Rarity.rare,
      displayName: 'Title: Analyst',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'frame_tech',
      type: RewardType.nicknameFrame,
      value: 'tech_frame',
      rarity: Rarity.rare,
      displayName: 'Tech Frame',
      icon: Icons.border_style,
      frameColor: Color(0xFF3B82F6),
    ),
    RewardDef(
      id: 'frame_circuit',
      type: RewardType.nicknameFrame,
      value: 'circuit_frame',
      rarity: Rarity.rare,
      displayName: 'Circuit Frame',
      icon: Icons.cable,
      frameColor: Color(0xFF10B981),
    ),
    RewardDef(
      id: 'frame_neon',
      type: RewardType.nicknameFrame,
      value: 'neon_frame',
      rarity: Rarity.epic,
      displayName: 'Neon Frame',
      icon: Icons.lightbulb_outline,
      frameColor: Color(0xFF22D3EE),
    ),
    RewardDef(
      id: 'skin_hacker',
      type: RewardType.skin,
      value: 'hacker',
      rarity: Rarity.rare,
      displayName: 'Skin: Hacker',
      icon: Icons.terminal,
    ),
    RewardDef(
      id: 'theme_amber',
      type: RewardType.theme,
      value: 'amber',
      rarity: Rarity.rare,
      displayName: 'Amber Glow Theme',
      icon: Icons.light_mode,
    ),

    // Epic rewards (12%)
    RewardDef(
      id: 'icon_robot',
      type: RewardType.icon,
      value: '🤖',
      rarity: Rarity.epic,
      displayName: 'Robot Icon',
      icon: Icons.smart_toy,
    ),
    RewardDef(
      id: 'icon_satellite',
      type: RewardType.icon,
      value: '🛰️',
      rarity: Rarity.epic,
      displayName: 'Satellite Icon',
      icon: Icons.satellite_alt,
    ),
    RewardDef(
      id: 'icon_chip',
      type: RewardType.icon,
      value: '🔬',
      rarity: Rarity.epic,
      displayName: 'Chip Icon',
      icon: Icons.memory,
    ),
    RewardDef(
      id: 'title_architect',
      type: RewardType.title,
      value: 'Architect',
      rarity: Rarity.epic,
      displayName: 'Title: Architect',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'title_specialist',
      type: RewardType.title,
      value: 'Specialist',
      rarity: Rarity.epic,
      displayName: 'Title: Specialist',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'title_sysadmin',
      type: RewardType.title,
      value: 'SysAdmin',
      rarity: Rarity.epic,
      displayName: 'Title: SysAdmin',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'skin_engineer',
      type: RewardType.skin,
      value: 'engineer',
      rarity: Rarity.epic,
      displayName: 'Skin: Engineer',
      icon: Icons.engineering,
    ),
    RewardDef(
      id: 'frame_cyber',
      type: RewardType.nicknameFrame,
      value: 'cyber_frame',
      rarity: Rarity.epic,
      displayName: 'Cyber Frame',
      icon: Icons.border_all,
      frameColor: Color(0xFF06B6D4),
    ),
    RewardDef(
      id: 'theme_ocean',
      type: RewardType.theme,
      value: 'ocean',
      rarity: Rarity.epic,
      displayName: 'Ocean Depths Theme',
      icon: Icons.water_drop,
    ),
    RewardDef(
      id: 'skin_cyber',
      type: RewardType.skin,
      value: 'cyber',
      rarity: Rarity.epic,
      displayName: 'Skin: Cyber Scout',
      icon: Icons.phonelink,
    ),
    RewardDef(
      id: 'skin_shadow',
      type: RewardType.skin,
      value: 'shadow',
      rarity: Rarity.epic,
      displayName: 'Skin: Shadow Coder',
      icon: Icons.visibility_off,
    ),
    RewardDef(
      id: 'skin_neon',
      type: RewardType.skin,
      value: 'neon',
      rarity: Rarity.epic,
      displayName: 'Skin: Neon Rider',
      icon: Icons.bolt,
    ),
    RewardDef(
      id: 'skin_phoenix',
      type: RewardType.skin,
      value: 'phoenix',
      rarity: Rarity.epic,
      displayName: 'Skin: Phoenix Coder',
      icon: Icons.local_fire_department,
    ),
    RewardDef(
      id: 'skin_titan',
      type: RewardType.skin,
      value: 'titan',
      rarity: Rarity.epic,
      displayName: 'Skin: Titan Tech',
      icon: Icons.hardware,
    ),
    RewardDef(
      id: 'skin_glitch',
      type: RewardType.skin,
      value: 'glitch',
      rarity: Rarity.epic,
      displayName: 'Skin: Glitch Master',
      icon: Icons.bug_report,
    ),
    RewardDef(
      id: 'skin_frost',
      type: RewardType.skin,
      value: 'frost',
      rarity: Rarity.epic,
      displayName: 'Skin: Frost Byte',
      icon: Icons.ac_unit,
    ),
    RewardDef(
      id: 'skin_viper',
      type: RewardType.skin,
      value: 'viper',
      rarity: Rarity.epic,
      displayName: 'Skin: Viper Security',
      icon: Icons.security,
    ),
    RewardDef(
      id: 'skin_spark',
      type: RewardType.skin,
      value: 'spark',
      rarity: Rarity.epic,
      displayName: 'Skin: Spark Circuit',
      icon: Icons.electric_bolt,
    ),
    RewardDef(
      id: 'frame_glitch',
      type: RewardType.nicknameFrame,
      value: 'glitch_frame',
      rarity: Rarity.rare,
      displayName: 'Glitch Frame',
      icon: Icons.error_outline,
      frameColor: Color(0xFFF472B6),
    ),
    RewardDef(
      id: 'frame_binary',
      type: RewardType.nicknameFrame,
      value: 'binary_frame',
      rarity: Rarity.rare,
      displayName: 'Binary Frame',
      icon: Icons.code,
      frameColor: Color(0xFF4ADE80),
    ),

    // Legendary rewards (3%)
    RewardDef(
      id: 'icon_unicorn',
      type: RewardType.icon,
      value: '🦄',
      rarity: Rarity.legendary,
      displayName: 'Unicorn Icon',
      icon: Icons.auto_awesome,
    ),
    RewardDef(
      id: 'icon_crown',
      type: RewardType.icon,
      value: '👑',
      rarity: Rarity.legendary,
      displayName: 'Crown Icon',
      icon: Icons.workspace_premium,
    ),
    RewardDef(
      id: 'icon_dragon',
      type: RewardType.icon,
      value: '🐉',
      rarity: Rarity.legendary,
      displayName: 'Dragon Icon',
      icon: Icons.restaurant,
    ),
    RewardDef(
      id: 'title_grandmaster',
      type: RewardType.title,
      value: 'Grand Master',
      rarity: Rarity.legendary,
      displayName: 'Title: Grand Master',
      icon: Icons.workspace_premium,
    ),
    RewardDef(
      id: 'title_overlord',
      type: RewardType.title,
      value: 'Overlord',
      rarity: Rarity.legendary,
      displayName: 'Title: Overlord',
      icon: Icons.workspace_premium,
    ),
    RewardDef(
      id: 'title_legend',
      type: RewardType.title,
      value: 'Legend',
      rarity: Rarity.legendary,
      displayName: 'Title: Legend',
      icon: Icons.workspace_premium,
    ),
    RewardDef(
      id: 'skin_void_',
      type: RewardType.skin,
      value: 'void_',
      rarity: Rarity.legendary,
      displayName: 'Skin: Void Walker',
      icon: Icons.all_inclusive,
    ),
    RewardDef(
      id: 'skin_chrono',
      type: RewardType.skin,
      value: 'chrono',
      rarity: Rarity.legendary,
      displayName: 'Skin: Chrono Tech',
      icon: Icons.schedule,
    ),
    RewardDef(
      id: 'skin_spectre',
      type: RewardType.skin,
      value: 'spectre',
      rarity: Rarity.legendary,
      displayName: 'Skin: Spectre Admin',
      icon: Icons.admin_panel_settings,
    ),
    RewardDef(
      id: 'skin_grandmaster',
      type: RewardType.skin,
      value: 'grandmaster',
      rarity: Rarity.legendary,
      displayName: 'Skin: Grandmaster',
      icon: Icons.auto_awesome,
    ),
    RewardDef(
      id: 'frame_legendary',
      type: RewardType.nicknameFrame,
      value: 'legendary_frame',
      rarity: Rarity.legendary,
      displayName: 'Legendary Frame',
      icon: Icons.star_border,
      frameColor: Color(0xFFF59E0B),
    ),
    RewardDef(
      id: 'frame_dragon',
      type: RewardType.nicknameFrame,
      value: 'dragon_frame',
      rarity: Rarity.legendary,
      displayName: 'Dragon Frame',
      icon: Icons.star_border,
      frameColor: Color(0xFFEF4444),
    ),
    RewardDef(
      id: 'frame_platinum',
      type: RewardType.nicknameFrame,
      value: 'platinum_frame',
      rarity: Rarity.legendary,
      displayName: 'Platinum Frame',
      icon: Icons.diamond,
      frameColor: Color(0xFFE2E8F0),
    ),
    RewardDef(
      id: 'theme_neon',
      type: RewardType.theme,
      value: 'neon',
      rarity: Rarity.legendary,
      displayName: 'Neon Nights Theme',
      icon: Icons.nights_stay,
    ),
  ];

  static final List<double> _cumulativeWeights = [];
  static final List<RewardDef> _weightedList = [];
  static bool _initialized = false;

  static void _ensureInit() {
    if (_initialized) return;
    for (final r in rewards) {
      _weightedList.add(r);
      _cumulativeWeights.add(_cumulativeWeights.isEmpty
          ? r.weight
          : _cumulativeWeights.last + r.weight);
    }
    _initialized = true;
  }

  static RewardDef draw() {
    _ensureInit();
    final total = _cumulativeWeights.last;
    final roll = Random().nextDouble() * total;
    for (var i = 0; i < _cumulativeWeights.length; i++) {
      if (roll <= _cumulativeWeights[i]) return _weightedList[i];
    }
    return _weightedList.last;
  }

  static List<RewardDef> get all {
    _ensureInit();
    return List.unmodifiable(rewards);
  }

  static RewardDef? byId(String id) {
    _ensureInit();
    try {
      return rewards.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<RewardDef> get badges {
    _ensureInit();
    return List.unmodifiable(rewards.where((r) => r.type == RewardType.icon || r.type == RewardType.title));
  }

}
