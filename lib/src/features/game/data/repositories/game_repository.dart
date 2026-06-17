import 'package:isar/isar.dart';
import 'package:littletech/src/features/game/data/models/player_progress.dart';

class GameRepository {
  final Isar _isar;

  GameRepository(this._isar);

  Future<PlayerProgress?> loadProgress(int userId) async {
    return await _isar.playerProgress
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
  }

  Future<PlayerProgress> getOrCreateProgress(int userId) async {
    final existing = await loadProgress(userId);
    if (existing != null) return existing;
    final progress = PlayerProgress()..userId = userId;
    await _isar.writeTxn(() async {
      await _isar.playerProgress.put(progress);
    });
    return progress;
  }

  Future<void> saveProgress(PlayerProgress progress) async {
    await _isar.writeTxn(() async {
      await _isar.playerProgress.put(progress);
    });
  }

  Future<void> addPoints(PlayerProgress progress, int points) async {
    progress.points += points;
    await saveProgress(progress);
  }

  Future<void> useSupTech(PlayerProgress progress) async {
    if (progress.supTechUsesThisLevel > 0) {
      progress.supTechUsesThisLevel--;
    } else if (progress.extraSupTechUses > 0) {
      progress.extraSupTechUses--;
    }
    await saveProgress(progress);
  }

  Future<void> resetLevelUses(PlayerProgress progress) async {
    progress.supTechUsesThisLevel = 1 + progress.extraSupTechUses;
    await saveProgress(progress);
  }

  Future<void> completeLevel(PlayerProgress progress, String levelId) async {
    if (!progress.completedLevelIds.contains(levelId)) {
      progress.completedLevelIds.add(levelId);
      progress.levelsCleared++;
    }
    await saveProgress(progress);
  }

  Future<void> defeatBoss(PlayerProgress progress) async {
    progress.bossesDefeated++;
    progress.extraSupTechUses++;
    await saveProgress(progress);
  }

  Future<void> addReward(PlayerProgress progress, String rewardId) async {
    if (!progress.earnedRewardIds.contains(rewardId)) {
      progress.earnedRewardIds.add(rewardId);
    }
    await saveProgress(progress);
  }

  Future<void> unlockSkin(PlayerProgress progress, String skinId) async {
    if (!progress.unlockedSkinIds.contains(skinId)) {
      progress.unlockedSkinIds.add(skinId);
    }
    await saveProgress(progress);
  }

  Future<void> setTheme(PlayerProgress progress, String themeId) async {
    progress.themeId = themeId;
    await saveProgress(progress);
  }

  Future<void> setCurrentLevel(
      PlayerProgress progress, int worldId, String? levelId) async {
    progress.currentWorldId = worldId;
    progress.currentLevelId = levelId;
    await saveProgress(progress);
  }
}
