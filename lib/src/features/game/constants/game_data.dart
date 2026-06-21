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
  final BossEncounterDef? boss;

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
    this.boss,
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

class BossEncounterDef {
  final String id;
  final String name;
  final String lore;
  final int hp;
  final int points;
  final int visualType;
  final List<String> abilities;
  final Map<String, dynamic> diagnosis;
  final List<Map<String, dynamic>> strategies;
  final int armor;
  final int challengeRating;
  final String bossKey;
  final DifficultyLevel difficulty;

  const BossEncounterDef({
    required this.id,
    required this.name,
    required this.lore,
    required this.hp,
    this.points = 500,
    required this.visualType,
    required this.abilities,
    required this.diagnosis,
    required this.strategies,
    required this.armor,
    required this.challengeRating,
    required this.bossKey,
    this.difficulty = DifficultyLevel.medium,
  });
}

class WorldDef {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<LevelDef> levels;
  final BossDef boss;
  final List<BossEncounterDef> bosses;

  const WorldDef({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.levels,
    required this.boss,
    this.bosses = const [],
  });
}

class GameData {
  static const bossPositions = {3, 6, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29};

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
    final bosses = cat.bosses;

    var problemIndex = 0;
    var bossIndex = 0;

    for (var levelNum = 1; levelNum <= totalLevels; levelNum++) {
      if (bossPositions.contains(levelNum) && bossIndex < bosses.length) {
        final boss = bosses[bossIndex];
        final solution = RuleEngine.solve(boss.bossKey);

        levels.add(LevelDef(
          id: '${cat.id}_boss_${bossIndex + 1}',
          title: 'Boss: ${boss.name}',
          description: 'Defeat the ${boss.name}!',
          steps: solution?.steps ?? ['Prepare for boss battle!'],
          points: boss.points,
          difficulty: boss.difficulty,
          isBossLevel: true,
          boss: boss,
        ));
        bossIndex++;
      } else if (problemIndex < cat.problemKeys.length) {
        levels.add(_generateLevel(cat.id, cat.problemKeys[problemIndex], problemIndex));
        problemIndex++;
      }
    }

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

    final primaryBoss = bosses.isNotEmpty
        ? BossDef(name: bosses.first.name, lore: bosses.first.lore, hp: bosses.first.hp, points: bosses.first.points)
        : BossDef(name: cat.bossName, lore: cat.bossLore, hp: cat.bossHp);

    return WorldDef(
      id: cat.id,
      name: cat.name,
      description: cat.description,
      icon: cat.icon,
      levels: levels,
      boss: primaryBoss,
      bosses: bosses,
    );
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
