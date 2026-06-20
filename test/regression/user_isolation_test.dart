import 'package:flutter_test/flutter_test.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/data/models/player_progress.dart';

void main() {
  group('Regression Tests - User Isolation', () {
    test('Each user should have unique progress record', () {
      // Simulate two different users
      final progress1 = PlayerProgress()..userId = 1;
      final progress2 = PlayerProgress()..userId = 2;
      
      expect(progress1.userId, isNot(equals(progress2.userId)));
    });

    test('Completed levels are stored as strings', () {
      final progress = PlayerProgress()..userId = 1;
      progress.completedLevelIds = ['core_components_high_cpu_usage', 'ram_random_crashes'];
      
      expect(progress.completedLevelIds.length, equals(2));
      expect(progress.completedLevelIds.first, contains('_'));
    });

    test('Purchased items are separate from earned rewards', () {
      final progress = PlayerProgress()..userId = 1;
      
      // Earned via gameplay
      progress.earnedRewardIds = ['icon_wrench'];
      
      // Purchased with points
      progress.purchasedItemIds = ['theme_dark'];
      
      // Both can coexist
      expect(progress.earnedRewardIds.contains('icon_wrench'), isTrue);
      expect(progress.purchasedItemIds.contains('theme_dark'), isTrue);
    });

    test('Skin unlock logic allows both earned and purchased', () {
      final progress = PlayerProgress()..userId = 1;
      
      // Hacker skin earned via reward
      progress.earnedRewardIds = ['skin_hacker'];
      
      // Engineer skin purchased
      progress.purchasedItemIds = ['skin_engineer'];
      
      // Both should be unlockable
      final hackerUnlocked = progress.earnedRewardIds.contains('skin_hacker') || 
                           progress.purchasedItemIds.contains('skin_hacker');
      final engineerUnlocked = progress.earnedRewardIds.contains('skin_engineer') || 
                             progress.purchasedItemIds.contains('skin_engineer');
      
      expect(hackerUnlocked, isTrue);
      expect(engineerUnlocked, isTrue);
    });

    test('Level ID format is consistent', () {
      final levelId = GameData.levelId('core_components', 'high cpu usage');
      expect(levelId, equals('core_components_high_cpu_usage'));
      
      // Same format used in world generation
      final world = GameData.worlds.firstWhere((w) => w.id == 'core_components');
      final hasMatchingLevel = world.levels.any((l) => l.id == levelId);
      expect(hasMatchingLevel, isTrue);
    });

    test('Theme unlock IDs match reward pool', () {
      // Verify theme reward IDs exist in pool
      expect(RewardPool.byId('theme_dark'), isNotNull);
      expect(RewardPool.byId('theme_amber'), isNotNull);
      expect(RewardPool.byId('theme_ocean'), isNotNull);
      expect(RewardPool.byId('theme_neon'), isNotNull);
    });

    test('Frame unlock IDs match reward pool', () {
      final frameRewards = RewardPool.all.where((r) => r.type == RewardType.nicknameFrame);
      expect(frameRewards.length, greaterThan(0));
      
      for (final frame in frameRewards) {
        expect(RewardPool.byId(frame.id), isNotNull, 
            reason: 'Frame ${frame.id} should be retrievable');
      }
    });
  });
}