import 'dart:math';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'game_data.dart';

class DailyChallenge {
  final String levelId;
  final String title;
  final String description;
  final int bonusPoints;
  final int pointsMultiplier;

  const DailyChallenge({
    required this.levelId,
    required this.title,
    required this.description,
    this.bonusPoints = 50,
    this.pointsMultiplier = 2,
  });
}

class WeeklyBoss {
  final String categoryId;
  final String title;
  final String description;
  final int bonusPoints;
  final int pointsMultiplier;

  const WeeklyBoss({
    required this.categoryId,
    this.title = 'Weekly Boss',
    this.description = 'harder problem, bigger reward',
    this.bonusPoints = 200,
    this.pointsMultiplier = 3,
  });
}

class ChallengeManager {
  static DailyChallenge getDailyChallenge({int streak = 0}) {
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final rng = Random(seed);

    final allLevelIds = GameData.worlds
        .expand((w) => w.levels)
        .map((l) => l.id)
        .toList();

    final levelId = allLevelIds[rng.nextInt(allLevelIds.length)];

    return DailyChallenge(
      levelId: levelId,
      title: 'Daily Challenge',
      description: 'Daily Challenge — one new tech problem every day',
      bonusPoints: 50,
      pointsMultiplier: streak >= 7 ? 3 : 2,
    );
  }

  static WeeklyBoss getWeeklyBoss() {
    final now = DateTime.now();
    final daysSinceEpoch = now.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    final weekNumber = daysSinceEpoch ~/ 7;
    final rng = Random(weekNumber);

    final catIndex = rng.nextInt(CategoryManager.all.length);
    final cat = CategoryManager.all[catIndex];

    return WeeklyBoss(
      categoryId: cat.id,
      bonusPoints: 200,
    );
  }
}
