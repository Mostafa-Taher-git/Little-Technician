import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

class PlayerProgress {
  final int points;
  final List<String> completedLevelIds;
  final List<String> earnedRewardIds;
  final int levelsCleared;
  final int bossesDefeated;
  final String? themeId;
  final List<String> unlockedSkinIds;

  const PlayerProgress({
    this.points = 0,
    this.completedLevelIds = const [],
    this.earnedRewardIds = const [],
    this.levelsCleared = 0,
    this.bossesDefeated = 0,
    this.themeId,
    this.unlockedSkinIds = const [],
  });

  PlayerProgress copyWith({
    int? points,
    List<String>? completedLevelIds,
    List<String>? earnedRewardIds,
    int? levelsCleared,
    int? bossesDefeated,
    String? themeId,
    List<String>? unlockedSkinIds,
  }) {
    return PlayerProgress(
      points: points ?? this.points,
      completedLevelIds: completedLevelIds ?? this.completedLevelIds,
      earnedRewardIds: earnedRewardIds ?? this.earnedRewardIds,
      levelsCleared: levelsCleared ?? this.levelsCleared,
      bossesDefeated: bossesDefeated ?? this.bossesDefeated,
      themeId: themeId ?? this.themeId,
      unlockedSkinIds: unlockedSkinIds ?? this.unlockedSkinIds,
    );
  }
}

class GameState {
  final int points;
  final int currentWorldId;
  final int currentLevelId;
  final int supTechUsesThisLevel;
  final int extraSupTechUses;
  final List<RewardDef> earnedRewards;
  final int? currentBossHp;
  final RewardDef? lastDrawnReward;
  final int? currentStepIndex;
  final String? hintText;
  final PlayerProgress progress;
  final WorldDef? currentWorld;

  const GameState({
    this.points = 0,
    this.currentWorldId = 1,
    this.currentLevelId = 1,
    this.supTechUsesThisLevel = 1,
    this.extraSupTechUses = 0,
    this.earnedRewards = const [],
    this.currentBossHp,
    this.lastDrawnReward,
    this.currentStepIndex,
    this.hintText,
    this.progress = const PlayerProgress(),
    this.currentWorld,
  });

  GameState copyWith({
    int? points,
    int? currentWorldId,
    int? currentLevelId,
    int? supTechUsesThisLevel,
    int? extraSupTechUses,
    List<RewardDef>? earnedRewards,
    int? currentBossHp,
    RewardDef? lastDrawnReward,
    int? currentStepIndex,
    String? hintText,
    PlayerProgress? progress,
    WorldDef? currentWorld,
  }) {
    return GameState(
      points: points ?? this.points,
      currentWorldId: currentWorldId ?? this.currentWorldId,
      currentLevelId: currentLevelId ?? this.currentLevelId,
      supTechUsesThisLevel: supTechUsesThisLevel ?? this.supTechUsesThisLevel,
      extraSupTechUses: extraSupTechUses ?? this.extraSupTechUses,
      earnedRewards: earnedRewards ?? this.earnedRewards,
      currentBossHp: currentBossHp ?? this.currentBossHp,
      lastDrawnReward: lastDrawnReward ?? this.lastDrawnReward,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      hintText: hintText ?? this.hintText,
      progress: progress ?? this.progress,
      currentWorld: currentWorld ?? this.currentWorld,
    );
  }

  int get availableSupTechUses => supTechUsesThisLevel + extraSupTechUses;
  bool get canUseSupTech => availableSupTechUses > 0;

  int get totalPoints => points;
  
  LevelDef? get currentLevel {
    final world = currentWorld;
    if (world == null) return null;
    return world.levels.firstWhere((l) => l.id == currentLevelId.toString(), orElse: () => world.levels.first);
  }
}