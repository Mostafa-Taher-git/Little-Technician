import 'dart:math';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'game_data.dart';

class DailyChallenge {
  final String levelId;
  final String title;
  final String description;
  final int bonusPoints;
  final int pointsMultiplier;
  final DateTime date;

  const DailyChallenge({
    required this.levelId,
    required this.title,
    required this.description,
    this.bonusPoints = 50,
    this.pointsMultiplier = 2,
    required this.date,
  });
}

class WeeklyBoss {
  final String categoryId;
  final String title;
  final String description;
  final int bonusPoints;
  final int pointsMultiplier;
  final DateTime weekStart;
  final String specialRule;

  const WeeklyBoss({
    required this.categoryId,
    this.title = 'Weekly Boss',
    this.description = 'harder problem, bigger reward',
    this.bonusPoints = 200,
    this.pointsMultiplier = 3,
    required this.weekStart,
    this.specialRule = '',
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
      date: today,
    );
  }

  static WeeklyBoss getWeeklyBoss() {
    final now = DateTime.now();
    final daysSinceEpoch = now.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
    final weekNumber = daysSinceEpoch ~/ 7;
    final rng = Random(weekNumber);

    final catIndex = rng.nextInt(CategoryManager.all.length);
    final cat = CategoryManager.all[catIndex];

    final rules = [
      'Defeat the boss in ${cat.name} with no hints!',
      'Defeat the boss using only basic attacks!',
      'Defeat the boss in under 3 attacks!',
    ];

    return WeeklyBoss(
      categoryId: cat.id,
      bonusPoints: 200,
      weekStart: DateTime(now.year, now.month, now.day - now.weekday + 1),
      specialRule: rules[rng.nextInt(rules.length)],
    );
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameWeek(DateTime a, DateTime b) {
    final dayA = DateTime(a.year, a.month, a.day - a.weekday + 1);
    final dayB = DateTime(b.year, b.month, b.day - b.weekday + 1);
    return isSameDay(dayA, dayB);
  }
}
