import 'package:isar/isar.dart';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';
import 'package:littletech/src/features/game/data/models/player_progress.dart';

class GameRepository {
  final Isar _isar;

  GameRepository(this._isar);

  Future<PlayerProgress?> loadProgress(int userId) async {
    final progress = await _isar.playerProgress
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
    progress?.ensureMutableLists();
    return progress;
  }

  Future<PlayerProgress> getOrCreateProgress(int userId) async {
    final existing = await loadProgress(userId);
    if (existing != null) return existing;
    final progress = PlayerProgress()..userId = userId;
    await _isar.writeTxn(() async {
      await _isar.playerProgress.put(progress);
    });
    progress.ensureMutableLists();
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

  Future<void> completeWorld(PlayerProgress progress, int worldId) async {
    if (!progress.completedWorldIds.contains(worldId)) {
      progress.completedWorldIds.add(worldId);
    }
    await saveProgress(progress);
  }

  Future<void> completeCategory(PlayerProgress progress, String categoryId) async {
    if (!progress.completedCategoryIds.contains(categoryId)) {
      progress.completedCategoryIds.add(categoryId);
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

  Future<void> recordPlayDate(PlayerProgress progress) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final already = progress.playDates.any((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);
    if (!already) {
      progress.playDates.add(today);
    }
    progress.lastActiveDate = DateTime.now();
    await saveProgress(progress);
  }

  Future<void> setTheme(PlayerProgress progress, String themeId) async {
    progress.themeId = themeId;
    await saveProgress(progress);
  }

  Future<void> setActiveSkin(PlayerProgress progress, String? skinId) async {
    progress.activeSkinId = skinId;
    await saveProgress(progress);
  }

  Future<void> setActiveFrame(PlayerProgress progress, String? frameId) async {
    progress.activeFrameId = frameId;
    await saveProgress(progress);
  }

  Future<void> setCurrentLevel(
      PlayerProgress progress, int worldId, String? levelId) async {
    progress.currentWorldId = worldId;
    progress.currentLevelId = levelId;
    await saveProgress(progress);
  }

  Future<void> setCurrentCategory(
      PlayerProgress progress, String? categoryId, String? levelId) async {
    progress.currentCategoryId = categoryId;
    progress.currentLevelId = levelId;
    await saveProgress(progress);
  }

  Future<void> cleanupOrphanedProgress(List<int> validUserIds) async {
    final allProgress = await _isar.playerProgress.where().findAll();
    for (final progress in allProgress) {
      if (!validUserIds.contains(progress.userId)) {
        await _isar.writeTxn(() async {
          await _isar.playerProgress.delete(progress.id);
        });
      }
    }
  }

  /// Delete all progress for all users - use during testing
  Future<void> deleteAllProgress() async {
    await _isar.writeTxn(() async {
      await _isar.playerProgress.where().deleteAll();
    });
  }

  /// Create a test user with all achievements unlocked
  Future<PlayerProgress> createTestProgress(int userId) async {
    // Delete any existing progress for this user
    final existing = await loadProgress(userId);
    if (existing != null) {
      await _isar.writeTxn(() async {
        await _isar.playerProgress.delete(existing.id);
      });
    }

    final progress = PlayerProgress()
      ..userId = userId
      ..points = 99999
      ..completedCategoryIds = List<String>.from(CategoryManager.all.map((c) => c.id))
      ..completedLevelIds = List<String>.from(
        CategoryManager.all.expand((c) => c.problemKeys.map((p) => GameData.levelId(c.id, p)))
      )
      ..earnedRewardIds = List<String>.from(RewardPool.all.map((r) => r.id))
      ..unlockedSkinIds = List<String>.from(SkinTierManager.skins.where((s) => s.isRewardSkin).map((s) => s.id))
      ..purchasedItemIds = List<String>.from(RewardPool.all.where((r) => r.type != RewardType.skin).map((r) => r.id))
      ..levelsCleared = CategoryManager.all.length * 5
      ..bossesDefeated = CategoryManager.all.length
      ..supTechUsesThisLevel = 3
      ..extraSupTechUses = 999;

    await _isar.writeTxn(() async {
      await _isar.playerProgress.put(progress);
    });
    progress.ensureMutableLists();
    return progress;
  }
}
