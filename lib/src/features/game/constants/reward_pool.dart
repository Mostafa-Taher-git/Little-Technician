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

  const RewardDef({
    required this.id,
    required this.type,
    required this.value,
    required this.rarity,
    required this.displayName,
    required this.icon,
  });

  Color get color {
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
      displayName: 'Dagger Icon',
      icon: Icons.build,
    ),
    RewardDef(
      id: 'icon_screwdriver',
      type: RewardType.icon,
      value: '🪛',
      rarity: Rarity.common,
      displayName: 'Wand Icon',
      icon: Icons.build_circle,
    ),
    RewardDef(
      id: 'icon_gear',
      type: RewardType.icon,
      value: '⚙️',
      rarity: Rarity.common,
      displayName: 'Shield Icon',
      icon: Icons.settings,
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
      id: 'frame_simple',
      type: RewardType.nicknameFrame,
      value: 'simple_frame',
      rarity: Rarity.common,
      displayName: 'Simple Frame',
      icon: Icons.crop_square,
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
      displayName: 'Tome Icon',
      icon: Icons.computer,
    ),
    RewardDef(
      id: 'icon_server',
      type: RewardType.icon,
      value: '🖥️',
      rarity: Rarity.rare,
      displayName: 'Castle Icon',
      icon: Icons.dns,
    ),
    RewardDef(
      id: 'title_engineer',
      type: RewardType.title,
      value: 'Battle Mage',
      rarity: Rarity.rare,
      displayName: 'Title: Battle Mage',
      icon: Icons.badge,
    ),
    RewardDef(
      id: 'frame_tech',
      type: RewardType.nicknameFrame,
      value: 'tech_frame',
      rarity: Rarity.rare,
      displayName: 'Rune Frame',
      icon: Icons.border_style,
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
      displayName: 'Golem Icon',
      icon: Icons.smart_toy,
    ),
    RewardDef(
      id: 'title_architect',
      type: RewardType.title,
      value: 'Dungeon Master',
      rarity: Rarity.epic,
      displayName: 'Title: Dungeon Master',
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
      displayName: 'Enchanted Frame',
      icon: Icons.border_all,
    ),
    RewardDef(
      id: 'theme_ocean',
      type: RewardType.theme,
      value: 'ocean',
      rarity: Rarity.epic,
      displayName: 'Ocean Depths Theme',
      icon: Icons.water_drop,
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
      id: 'title_grandmaster',
      type: RewardType.title,
      value: 'Grand Master',
      rarity: Rarity.legendary,
      displayName: 'Title: Grand Master',
      icon: Icons.workspace_premium,
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

  static final Map<Rarity, List<RewardDef>> _byRarity = {};
  static final List<double> _cumulativeWeights = [];
  static final List<RewardDef> _weightedList = [];
  static bool _initialized = false;

  static void _ensureInit() {
    if (_initialized) return;
    for (final r in rewards) {
      _byRarity.putIfAbsent(r.rarity, () => []).add(r);
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

  static List<RewardDef> byRarity(Rarity r) {
    _ensureInit();
    return List.unmodifiable(_byRarity[r] ?? []);
  }

  static RewardDef? byId(String id) {
    _ensureInit();
    try {
      return rewards.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
