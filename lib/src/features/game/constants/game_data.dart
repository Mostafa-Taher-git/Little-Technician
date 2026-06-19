import 'package:flutter/material.dart';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'package:littletech/src/core/services/rule_engine.dart';

enum DifficultyLevel { easy, medium, hard }

class LevelDef {
  final String id;
  final String title;
  final String description;
  final List<String> steps;
  final int points;
  final String? imageUrl;
  final String? deviceType;
  final String? symptoms;
  final String? cause;
  final String? estimatedTime;
  final DifficultyLevel difficulty;

  const LevelDef({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    this.points = 100,
    this.imageUrl,
    this.deviceType,
    this.symptoms,
    this.cause,
    this.estimatedTime,
    this.difficulty = DifficultyLevel.easy,
  });
}

class BossDef {
  final String name;
  final String lore;
  final int hp;
  final int points;

  const BossDef({
    required this.name,
    required this.lore,
    required this.hp,
    this.points = 500,
  });
}

class WorldDef {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<LevelDef> levels;
  final BossDef boss;

  const WorldDef({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.levels,
    required this.boss,
  });
}

class GameData {
  static List<WorldDef> get worlds {
    return CategoryManager.all.map((cat) => _generateWorld(cat)).toList();
  }

  static String levelId(String categoryId, String problemKey) {
    final slug = problemKey.replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return '${categoryId}_$slug';
  }

  static WorldDef _generateWorld(CategoryDef cat) {
    final levels = cat.problemKeys.map((pk) => _generateLevel(cat.id, pk)).toList();
    return WorldDef(
      id: cat.id,
      name: cat.name,
      description: cat.description,
      icon: cat.icon,
      levels: levels,
      boss: BossDef(name: cat.bossName, lore: cat.bossLore, hp: cat.bossHp, points: 500),
    );
  }

  static LevelDef _generateLevel(String categoryId, String problemKey) {
    final id = levelId(categoryId, problemKey);
    final solution = RuleEngine.solve(problemKey);
    final title = problemKey.split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1);
    }).join(' ');
    return LevelDef(
      id: id,
      title: title,
      description: 'Troubleshooting: $problemKey',
      steps: solution?.steps ?? ['Investigate the issue and apply known fixes.'],
      points: 100,
      difficulty: DifficultyLevel.easy,
    );
  }

  static final Map<String, List<String>> levelHints = Map.fromEntries(
    CategoryManager.all.expand((cat) => cat.problemKeys.map((pk) {
      final id = levelId(cat.id, pk);
      return MapEntry(id, [
        'Start with the most common causes first.',
        'Check the basics before diving deeper.',
      ]);
    })),
  );

  static final Map<String, String> solutionIdMap = Map.fromEntries(
    CategoryManager.all.expand((cat) => cat.problemKeys.map((pk) {
      final id = levelId(cat.id, pk);
      final title = pk.split(' ').map((w) {
        if (w.isEmpty) return w;
        return w[0].toUpperCase() + w.substring(1);
      }).join(' ');
      return MapEntry(id, title);
    })),
  );

  static String? solutionForLevel(String levelId) => solutionIdMap[levelId];

  static bool isWorldComplete(WorldDef world, List<String> completedLevelIds) {
    return world.levels.every((level) => completedLevelIds.contains(level.id));
  }
}
