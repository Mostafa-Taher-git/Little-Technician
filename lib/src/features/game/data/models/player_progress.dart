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
  String? currentLevelId;
  List<String> completedLevelIds = [];
  List<String> earnedRewardIds = [];
  List<String> unlockedSkinIds = [];
  String? themeId;
  int levelsCleared = 0;
  int bossesDefeated = 0;
}
