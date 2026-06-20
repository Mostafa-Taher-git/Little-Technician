import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/auth/data/services/auth_service.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/data/models/player_progress.dart';
import 'package:littletech/src/features/game/data/repositories/game_repository.dart';

class GameState {
  final PlayerProgress progress;
  final WorldDef? currentWorld;
  final LevelDef? currentLevel;
  final int currentStepIndex;
  final int currentBossHp;
  final int bossHpMultiplier;
  final RewardDef? lastDrawnReward;
  final bool isBossMode;
  final String? hintText;
  final int pointsMultiplier;

  const GameState({
    required this.progress,
    this.currentWorld,
    this.currentLevel,
    this.currentStepIndex = 0,
    this.currentBossHp = 0,
    this.bossHpMultiplier = 1,
    this.lastDrawnReward,
    this.isBossMode = false,
    this.hintText,
    this.pointsMultiplier = 1,
  });

  GameState copyWith({
    PlayerProgress? progress,
    WorldDef? currentWorld,
    LevelDef? currentLevel,
    int? currentStepIndex,
    int? currentBossHp,
    int? bossHpMultiplier,
    RewardDef? lastDrawnReward,
    bool? isBossMode,
    String? hintText,
    int? pointsMultiplier,
  }) {
    return GameState(
      progress: progress ?? this.progress,
      currentWorld: currentWorld ?? this.currentWorld,
      currentLevel: currentLevel ?? this.currentLevel,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentBossHp: currentBossHp ?? this.currentBossHp,
      bossHpMultiplier: bossHpMultiplier ?? this.bossHpMultiplier,
      lastDrawnReward: lastDrawnReward ?? this.lastDrawnReward,
      isBossMode: isBossMode ?? this.isBossMode,
      hintText: hintText ?? this.hintText,
      pointsMultiplier: pointsMultiplier ?? this.pointsMultiplier,
    );
  }

  bool get canUseSupTech =>
      progress.supTechUsesThisLevel > 0 || progress.extraSupTechUses > 0;

  int get totalPoints =>
      progress.points;

  int get availableSupTechUses =>
      progress.supTechUsesThisLevel + progress.extraSupTechUses;
}

class GameCubit extends Cubit<GameState> {
  final GameRepository _repository;
  final int _userId;
  DateTime? _levelStartTime;

  GameCubit(this._repository, this._userId)
      : super(GameState(progress: PlayerProgress()..userId = _userId));

  Future<void> loadGame() async {
    try {
      final validUsers = await AuthService.getAllUsers();
      final validIds = validUsers.map((u) => u.id).toList();
      await _repository.cleanupOrphanedProgress(validIds);
      final progress = await _repository.getOrCreateProgress(_userId);
      WorldDef? world;
      if (progress.currentCategoryId != null) {
        world = GameData.worlds.cast<WorldDef?>().firstWhere(
          (w) => w!.id == progress.currentCategoryId,
          orElse: () => GameData.worlds.isNotEmpty ? GameData.worlds.first : null,
        );
      } else if (progress.currentWorldId < GameData.worlds.length) {
        world = GameData.worlds[progress.currentWorldId];
      } else if (GameData.worlds.isNotEmpty) {
        world = GameData.worlds.first;
      }
      emit(GameState(progress: progress, currentWorld: world));
    } catch (e, st) {
      debugPrint('loadGame failed: $e\n$st');
    }
  }

  void selectWorld(WorldDef world) {
    final progress = state.progress;
    _safePersist(() => _repository.setCurrentCategory(progress, world.id, null));
    emit(state.copyWith(progress: progress, currentWorld: world, bossHpMultiplier: 1));
  }

  void setBossMultiplier(int multiplier) {
    emit(state.copyWith(bossHpMultiplier: multiplier));
  }

  void setPointsMultiplier(int multiplier) {
    emit(state.copyWith(pointsMultiplier: multiplier));
  }

  void completeDailyQuest() {
    final progress = state.progress;
    progress.setDailyQuestCompleted();
    _safePersist(() => _repository.saveProgress(progress));
    emit(state.copyWith(progress: progress));
  }

  void selectLevel(LevelDef level, {WorldDef? worldOverride}) {
    final progress = state.progress;
    final world = worldOverride ?? state.currentWorld;
    progress.currentLevelId = level.id;
    _levelStartTime = DateTime.now();
    _safePersist(() => _repository.setCurrentCategory(progress, world?.id, level.id));
    emit(state.copyWith(
      progress: progress,
      currentWorld: world ?? state.currentWorld,
      currentLevel: level,
      currentStepIndex: 0,
      isBossMode: false,
      hintText: null,
    ));
  }

  void saveFeedback(String levelId, bool wasHelpful) {
    final p = state.progress;
    final raw = p.getPrepResult(levelId);
    final data = raw != null
        ? json.decode(raw) as Map<String, dynamic>
        : <String, dynamic>{};
    data['feedback'] = {'helpful': wasHelpful, 'timestamp': DateTime.now().toIso8601String()};
    p.setPrepResult(levelId, json.encode(data));
    _safePersist(() => _repository.saveProgress(p));
    emit(state.copyWith(progress: p));
  }

  void addChallengeBonus(int bonusPoints) {
    final p = state.progress;
    _safePersist(() => _repository.addPoints(p, bonusPoints));
    emit(state.copyWith(progress: p));
  }

  void startBoss() {
    final world = state.currentWorld;
    if (world == null) return;
    final boss = world.boss;
    emit(state.copyWith(
      isBossMode: true,
      currentBossHp: boss.hp * state.bossHpMultiplier,
      hintText: null,
    ));
  }

  void solveStep() {
    if (state.currentLevel == null) return;
    final steps = state.currentLevel!.steps;
    final nextIndex = state.currentStepIndex + 1;
    final progress = state.progress;

    _safePersist(() => _repository.addPoints(progress, 10));
    if (nextIndex >= steps.length) {
      _completeLevel(progress, nextIndex);
    } else {
      emit(state.copyWith(
        progress: progress,
        currentStepIndex: nextIndex,
        hintText: null,
      ));
    }
  }

  void _safePersist(Future<void> Function() op) {
    op().catchError((e, st) {
      debugPrint('Persist error: $e');
    });
  }

  void _completeLevel(PlayerProgress progress, int finalStepIndex) {
    final level = state.currentLevel!;
    final basePoints = level.points * state.pointsMultiplier;

    int bonusPoints = 0;
    if (progress.supTechUsesThisLevel >= 1) {
      bonusPoints += 25;
    }

    final elapsed = _levelStartTime != null
        ? DateTime.now().difference(_levelStartTime!).inSeconds
        : 999;
    if (elapsed <= 30) {
      bonusPoints += 50;
    } else if (elapsed <= 60) {
      bonusPoints += 30;
    } else if (elapsed <= 120) {
      bonusPoints += 15;
    }

    final totalPoints = basePoints + bonusPoints;
    _safePersist(() => _repository.addPoints(progress, totalPoints));
    _safePersist(() => _repository.completeLevel(progress, level.id));
    _safePersist(() => _repository.resetLevelUses(progress));
    final world = state.currentWorld;
    if (world != null && GameData.isWorldComplete(world, progress.completedLevelIds)) {
      _safePersist(() => _repository.completeWorld(progress, 0));
      _safePersist(() => _repository.completeCategory(progress, world.id));
    }

    // Draw reward safely — ensure state always emits even if reward fails
    RewardDef? reward;
    try {
      reward = RewardPool.draw();
      _safePersist(() => _repository.addReward(progress, reward!.id));
      if (reward.type == RewardType.skin) {
        _safePersist(() => _repository.unlockSkin(progress, reward!.value));
      }
    } catch (e, st) {
      debugPrint('Reward draw failed: $e\n$st');
    }

    _safePersist(() => _repository.recordPlayDate(progress));
    
    // Complete daily quest if this level was from a daily challenge
    if (state.pointsMultiplier > 1) {
      _safePersist(() => _repository.saveProgress(progress..setDailyQuestCompleted()));
    }
    
    emit(state.copyWith(
      progress: progress,
      currentStepIndex: finalStepIndex,
      lastDrawnReward: reward,
      hintText: null,
      pointsMultiplier: 1,
    ));
  }

  void attackBoss({int damage = 1}) {
    if (!state.isBossMode) return;
    final hpLeft = state.currentBossHp - damage;
    final progress = state.progress;

    _safePersist(() => _repository.addPoints(progress, 10));
    if (hpLeft <= 0) {
      _defeatBoss(progress);
    } else {
      emit(state.copyWith(progress: progress, currentBossHp: hpLeft));
    }
  }

  void _defeatBoss(PlayerProgress progress) {
    final world = state.currentWorld;
    if (world == null) return;
    final boss = world.boss;
    _safePersist(() => _repository.addPoints(progress, boss.points * state.pointsMultiplier));
    _safePersist(() => _repository.defeatBoss(progress));
    _safePersist(() => _repository.recordPlayDate(progress));

    RewardDef? reward;
    try {
      reward = RewardPool.draw();
      _safePersist(() => _repository.addReward(progress, reward!.id));
      if (reward.type == RewardType.skin) {
        _safePersist(() => _repository.unlockSkin(progress, reward!.value));
      }
    } catch (e, st) {
      debugPrint('Boss reward draw failed: $e\n$st');
    }

    emit(state.copyWith(
      progress: progress,
      currentBossHp: 0,
      lastDrawnReward: reward,
      pointsMultiplier: 1,
    ));
  }

  void collectReward() {
    emit(state.copyWith(lastDrawnReward: null));
  }

  void useSupTech(String action) {
    final progress = state.progress;
    if (state.availableSupTechUses <= 0) return;

    switch (action) {
      case 'hint':
        final hints = GameData.levelHints[state.currentLevel?.id];
        if (hints != null && hints.isNotEmpty) {
          _safePersist(() => _repository.useSupTech(progress));
          emit(state.copyWith(
            progress: progress,
            hintText: hints[state.currentStepIndex % hints.length],
          ));
        }
      case 'skip':
        if (state.currentLevel == null) return;
        _safePersist(() => _repository.useSupTech(progress));
        solveStep();
      case 'diagnose':
        _safePersist(() => _repository.useSupTech(progress));
        emit(state.copyWith(
          progress: progress,
          hintText: 'Try checking the most common causes first. '
              'Is the device powered on? Are cables secure? Is the driver updated?',
        ));
      case 'explain':
        if (state.currentLevel != null &&
            state.currentStepIndex < state.currentLevel!.steps.length) {
          _safePersist(() => _repository.useSupTech(progress));
          emit(state.copyWith(
            progress: progress,
            hintText: state.currentLevel!.steps[state.currentStepIndex],
          ));
        }
    }
  }

  void refreshProgress() {
    emit(state.copyWith(progress: state.progress));
  }

  void addPoints(int amount) {
    final p = state.progress;
    _safePersist(() => _repository.addPoints(p, amount));
    emit(state.copyWith(progress: p));
  }

  void saveQuizResult(String levelId, int correct, int total, int hearts) {
    final p = state.progress;
    final raw = p.getPrepResult(levelId);
    final data = raw != null
        ? json.decode(raw) as Map<String, dynamic>
        : <String, dynamic>{};
    data['quiz'] = {'correct': correct, 'total': total, 'hearts': hearts};
    p.setPrepResult(levelId, json.encode(data));
    _safePersist(() => _repository.saveProgress(p));
    emit(state.copyWith(progress: p));
  }

  void saveOrderingResult(String levelId, int attempts, bool passed) {
    final p = state.progress;
    final raw = p.getPrepResult(levelId);
    final data = raw != null
        ? json.decode(raw) as Map<String, dynamic>
        : <String, dynamic>{};
    data['ordering'] = {'attempts': attempts, 'passed': passed};
    p.setPrepResult(levelId, json.encode(data));
    _safePersist(() => _repository.saveProgress(p));
    emit(state.copyWith(progress: p));
  }

  void saveTrapsResult(String levelId, int correct, int total, bool passed) {
    final p = state.progress;
    final raw = p.getPrepResult(levelId);
    final data = raw != null
        ? json.decode(raw) as Map<String, dynamic>
        : <String, dynamic>{};
    data['traps'] = {'correct': correct, 'total': total, 'passed': passed};
    p.setPrepResult(levelId, json.encode(data));
    _safePersist(() => _repository.saveProgress(p));
    emit(state.copyWith(progress: p));
  }

  void saveScenariosResult(String levelId, int correct, int total, bool passed) {
    final p = state.progress;
    final raw = p.getPrepResult(levelId);
    final data = raw != null
        ? json.decode(raw) as Map<String, dynamic>
        : <String, dynamic>{};
    data['scenarios'] = {'correct': correct, 'total': total, 'passed': passed};
    p.setPrepResult(levelId, json.encode(data));
    _safePersist(() => _repository.saveProgress(p));
    emit(state.copyWith(progress: p));
  }

  void saveMistakeResult(String levelId, bool passed) {
    final p = state.progress;
    final raw = p.getPrepResult(levelId);
    final data = raw != null
        ? json.decode(raw) as Map<String, dynamic>
        : <String, dynamic>{};
    data['mistakes'] = {'passed': passed};
    p.setPrepResult(levelId, json.encode(data));
    _safePersist(() => _repository.saveProgress(p));
    emit(state.copyWith(progress: p));
  }

  Future<void> setThemeId(String? themeId) async {
    final progress = state.progress;
    progress.themeId = themeId;
    _safePersist(() => _repository.saveProgress(progress));
    emit(state.copyWith(progress: progress));
  }

  Future<void> setActiveSkin(String? skinId) async {
    final progress = state.progress;
    if (skinId != null &&
        !progress.unlockedSkinIds.contains(skinId) &&
        !progress.earnedRewardIds.contains('skin_$skinId')) {
      return; // Can't equip locked skin
    }
    progress.activeSkinId = skinId;
    _safePersist(() => _repository.setActiveSkin(progress, skinId));
    emit(state.copyWith(progress: progress));
  }

  Future<void> setActiveFrame(String? frameId) async {
    final progress = state.progress;
    if (frameId != null && !progress.earnedRewardIds.contains(frameId)) {
      return; // Can't equip locked frame
    }
    progress.activeFrameId = frameId;
    _safePersist(() => _repository.setActiveFrame(progress, frameId));
    emit(state.copyWith(progress: progress));
  }

  void purchaseItem(String itemId) {
    final progress = state.progress;
    if (progress.points < 1000) return;
    if (progress.purchasedItemIds.contains(itemId)) return;
    if (progress.earnedRewardIds.contains(itemId)) return;
    progress.points -= 1000;
    progress.purchasedItemIds = List<String>.from(progress.purchasedItemIds)..add(itemId);
    _safePersist(() => _repository.saveProgress(progress));
    emit(state.copyWith(progress: progress));
  }

  void selectWorldById(String worldId) {
    final world = GameData.worlds.cast<WorldDef?>().firstWhere(
      (w) => w!.id == worldId,
      orElse: () => null,
    );
    if (world != null) {
      selectWorld(world);
    }
  }

  void resetSteps() {
    emit(state.copyWith(currentStepIndex: 0, hintText: null));
  }

  Future<void> unlockEverything() async {
    final progress = await _repository.createTestProgress(_userId);
    emit(GameState(progress: progress, currentWorld: state.currentWorld));
  }
}
