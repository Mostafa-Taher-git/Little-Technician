import 'package:flutter_bloc/flutter_bloc.dart';
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

  GameCubit(this._repository, this._userId)
      : super(GameState(progress: PlayerProgress()..userId = _userId));

  Future<void> loadGame() async {
    final progress = await _repository.getOrCreateProgress(_userId);
    final world = GameData.worlds.isNotEmpty
        ? GameData.worlds[progress.currentWorldId]
        : null;
    emit(GameState(progress: progress, currentWorld: world));
  }

  void selectWorld(WorldDef world) {
    final progress = state.progress;
    _repository.setCurrentLevel(progress, world.id, null);
    emit(state.copyWith(progress: progress, currentWorld: world, bossHpMultiplier: 1));
  }

  void setBossMultiplier(int multiplier) {
    emit(state.copyWith(bossHpMultiplier: multiplier));
  }

  void selectLevel(LevelDef level) {
    final progress = state.progress;
    progress.currentLevelId = level.id;
    _repository.setCurrentLevel(progress, state.currentWorld!.id, level.id);
    emit(state.copyWith(
      progress: progress,
      currentLevel: level,
      currentStepIndex: 0,
      isBossMode: false,
      hintText: null,
    ));
  }

  void startBoss() {
    final boss = state.currentWorld!.boss;
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

    _repository.addPoints(progress, 10);
    if (nextIndex >= steps.length) {
      _completeLevel(progress);
    } else {
      emit(state.copyWith(
        progress: progress,
        currentStepIndex: nextIndex,
        hintText: null,
      ));
    }
  }

  void _completeLevel(PlayerProgress progress) {
    final basePoints = state.currentLevel!.points;
    _repository.addPoints(progress, basePoints);
    _repository.completeLevel(progress, state.currentLevel!.id);
    _repository.resetLevelUses(progress);
    _drawReward(progress);
    emit(state.copyWith(progress: progress, hintText: null));
  }

  void attackBoss({int damage = 1}) {
    if (!state.isBossMode) return;
    final hpLeft = state.currentBossHp - damage;
    final progress = state.progress;

    _repository.addPoints(progress, 10);
    if (hpLeft <= 0) {
      _defeatBoss(progress);
    } else {
      emit(state.copyWith(progress: progress, currentBossHp: hpLeft));
    }
  }

  void _defeatBoss(PlayerProgress progress) {
    final boss = state.currentWorld!.boss;
    _repository.addPoints(progress, boss.points);
    _repository.defeatBoss(progress);
    _drawReward(progress);
    emit(state.copyWith(progress: progress, currentBossHp: 0));
  }

  void _drawReward(PlayerProgress progress) {
    final rewardDef = RewardPool.draw();
    _repository.addReward(progress, rewardDef.id);
    if (rewardDef.type == RewardType.skin) {
      _repository.unlockSkin(progress, rewardDef.value);
    }
    emit(state.copyWith(progress: progress, lastDrawnReward: rewardDef));
  }

  void collectReward() {
    emit(state.copyWith(lastDrawnReward: null));
  }

  void useSupTech(String action) {
    final progress = state.progress;
    if (state.availableSupTechUses <= 0) return;

    _repository.useSupTech(progress);

    switch (action) {
      case 'hint':
        final hints = GameData.levelHints[state.currentLevel?.id];
        if (hints != null && hints.isNotEmpty) {
          emit(state.copyWith(
            progress: progress,
            hintText: hints[state.currentStepIndex % hints.length],
          ));
        }
      case 'skip':
        solveStep();
      case 'diagnose':
        emit(state.copyWith(
          progress: progress,
          hintText: 'Try checking the most common causes first. '
              'Is the device powered on? Are cables secure? Is the driver updated?',
        ));
      case 'explain':
        if (state.currentLevel != null &&
            state.currentStepIndex < state.currentLevel!.steps.length) {
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
    p.points += amount;
    emit(state.copyWith(progress: p));
  }

  Future<void> setThemeId(String? themeId) async {
    final progress = state.progress;
    progress.themeId = themeId;
    await _repository.saveProgress(progress);
    emit(state.copyWith(progress: progress));
  }

  void selectWorldById(int worldId) {
    if (worldId < GameData.worlds.length) {
      selectWorld(GameData.worlds[worldId]);
    }
  }
}
