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
List<String> earnedRewardIds = [];
  List<String> unlockedSkinIds = [];
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
    playDates = List<DateTime>.from(playDates);
    prepResults = List<String>.from(prepResults);
  }
}
