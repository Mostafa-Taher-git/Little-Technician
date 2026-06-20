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
  final bool isBossLevel;

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
    this.isBossLevel = false,
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
    final levels = <LevelDef>[];
    final totalLevels = cat.levelCount;
    final bossRewards = [200, 350, 500, 750, 1000, 1500];
    
    var problemIndex = 0;
    for (var levelNum = 1; levelNum <= totalLevels; levelNum++) {
      // Check if this is a boss level (levels 5, 10, 15, 20, 25, 30)
      if (levelNum % 5 == 0 && cat.bossKeys.isNotEmpty) {
        final bossStage = levelNum ~/ 5;
        final bossIndex = (bossStage - 1).clamp(0, cat.bossKeys.length - 1);
        final bossKey = cat.bossKeys[bossIndex];
        final solution = RuleEngine.solve(bossKey);
        final difficulty = bossIndex < 2 
            ? DifficultyLevel.easy 
            : bossIndex < 4 
                ? DifficultyLevel.medium 
                : DifficultyLevel.hard;
        
        levels.add(LevelDef(
          id: '${cat.id}_boss_$bossStage',
          title: 'Boss: ${cat.bossName}',
          description: 'Defeat the ${cat.bossName}!',
          steps: solution?.steps ?? ['Prepare for boss battle!'],
          points: bossRewards[bossStage - 1],
          difficulty: difficulty,
          isBossLevel: true,
        ));
      }
      
      // Add regular problem level
      if (problemIndex < cat.problemKeys.length) {
        levels.add(_generateLevel(cat.id, cat.problemKeys[problemIndex], problemIndex));
        problemIndex++;
      }
    }
    
    // If we have fewer problems than levels, fill remaining with challenges
    while (levels.length < totalLevels) {
      final extraIndex = levels.length;
      levels.add(LevelDef(
        id: '${cat.id}_challenge_$extraIndex',
        title: 'Expert Challenge ${extraIndex + 1}',
        description: 'Advanced troubleshooting challenge.',
        steps: ['Apply all your knowledge to solve this advanced case.'],
        points: 150,
        difficulty: DifficultyLevel.hard,
      ));
    }
    
    final bossPoints = _getBossPoints(cat.id);
    return WorldDef(
      id: cat.id,
      name: cat.name,
      description: cat.description,
      icon: cat.icon,
      levels: levels,
      boss: BossDef(name: cat.bossName, lore: cat.bossLore, hp: cat.bossHp, points: bossPoints),
    );
  }

  static int _getBossPoints(String categoryId) {
    switch (categoryId) {
      case 'mobile':
        return 700;
      case 'gaming':
        return 800;
      case 'audio':
      case 'smart_home':
        return 600;
      default:
        return 500;
    }
  }

  static LevelDef _generateLevel(String categoryId, String problemKey, int index) {
    final id = levelId(categoryId, problemKey);
    final solution = RuleEngine.solve(problemKey);
    final title = problemKey.split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1);
    }).join(' ');
    
    final difficulty = index < 5 
        ? DifficultyLevel.easy 
        : index < 15 
            ? DifficultyLevel.medium 
            : DifficultyLevel.hard;
    
    return LevelDef(
      id: id,
      title: title,
      description: 'Troubleshooting: $problemKey',
      steps: solution?.steps ?? ['Investigate the issue and apply known fixes.'],
      points: 100,
      difficulty: difficulty,
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