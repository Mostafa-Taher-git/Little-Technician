import 'package:isar/isar.dart';

part 'player_progress.g.dart';

@collection
class PlayerProgress {
  Id id = Isar.autoIncrement;

  @Index()
  late int userId;

int points = 0;
   int supTechUsesThisLevel = 1;
   int extraSupTechUses = 0;
   int currentWorldId = 0;
   String? currentCategoryId;
   String? currentLevelId;
   List<String> completedLevelIds = [];
   List<int> completedWorldIds = [];
   List<String> completedCategoryIds = [];
   List<String> purchasedItemIds = [];
   List<String> earnedRewardIds = [];
   List<String> unlockedSkinIds = [];
   List<String> defeatedBossIds = [];
   String? activeSkinId;  // Currently equipped skin
   String? activeFrameId; // Currently equipped nickname frame
   String? themeId;
   int levelsCleared = 0;
   int bossesDefeated = 0;
   List<DateTime> playDates = [];
   DateTime? lastActiveDate;
   int totalPlayTimeSeconds = 0;
   int correctAnswers = 0;
   int totalAnswers = 0;
    List<String> prepResults = [];  // "levelId\x01json" entries
     DateTime? lastDailyQuestDate;  // Track daily quest completion
     DateTime? lastWeeklyBossDate;  // Track weekly boss completion
     List<String> unlockedAchievementIds = [];  // Persisted achievement unlocks
    List<String> pendingAchievementIds = [];   // Temporary: newly unlocked, shown on Level Complete

  static const _sep = '\x01';

  String? getPrepResult(String levelId) {
    for (final e in prepResults) {
      final idx = e.indexOf(_sep);
      if (idx >= 0 && e.substring(0, idx) == levelId) return e.substring(idx + 1);
    }
    return null;
  }

  void setPrepResult(String levelId, String json) {
    final mutable = List<String>.from(prepResults);
    mutable.removeWhere((e) => e.startsWith('$levelId$_sep'));
    mutable.add('$levelId$_sep$json');
    prepResults = mutable;
  }

  /// Call after loading from Isar to ensure all lists are growable.
  void ensureMutableLists() {
    completedLevelIds = List<String>.from(completedLevelIds);
    completedWorldIds = List<int>.from(completedWorldIds);
    completedCategoryIds = List<String>.from(completedCategoryIds);
    earnedRewardIds = List<String>.from(earnedRewardIds);
    unlockedSkinIds = List<String>.from(unlockedSkinIds);
    defeatedBossIds = List<String>.from(defeatedBossIds);
    playDates = List<DateTime>.from(playDates);
    prepResults = List<String>.from(prepResults);
    purchasedItemIds = List<String>.from(purchasedItemIds);
    unlockedAchievementIds = List<String>.from(unlockedAchievementIds);
    pendingAchievementIds = List<String>.from(pendingAchievementIds);
  }

  bool getDailyQuestCompleted() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return lastDailyQuestDate != null &&
        lastDailyQuestDate!.year == todayDate.year &&
        lastDailyQuestDate!.month == todayDate.month &&
        lastDailyQuestDate!.day == todayDate.day;
  }

  void setDailyQuestCompleted() {
    lastDailyQuestDate = DateTime.now();
  }

  bool getWeeklyBossCompleted() {
    if (lastWeeklyBossDate == null) return false;
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(monday.year, monday.month, monday.day);
    final weekEnd = weekStart.add(const Duration(days: 7));
    return lastWeeklyBossDate!.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
        lastWeeklyBossDate!.isBefore(weekEnd);
  }

  void setWeeklyBossCompleted() {
    lastWeeklyBossDate = DateTime.now();
  }
}
