import 'package:flutter_test/flutter_test.dart';
import 'package:littletech/src/features/game/constants/reward_pool.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';

void main() {
  group('RewardPool Tests', () {
    test('all rewards are defined', () {
      expect(RewardPool.all.length, greaterThan(0));
    });

    test('byId returns correct reward', () {
      final reward = RewardPool.byId('theme_dark');
      expect(reward, isNotNull);
      expect(reward?.type, equals(RewardType.theme));
    });

    test('byId returns null for invalid ID', () {
      final reward = RewardPool.byId('invalid');
      expect(reward, isNull);
    });

    test('badges filter works', () {
      final badges = RewardPool.badges;
      expect(badges.every((b) => b.type == RewardType.icon || b.type == RewardType.title), isTrue);
    });

    test('byRarity returns correct rewards', () {
      final common = RewardPool.byRarity(Rarity.common);
      expect(common.every((r) => r.rarity == Rarity.common), isTrue);
    });
  });

  group('SkinTierManager Tests', () {
    test('skins are defined', () {
      expect(SkinTierManager.skins.length, greaterThan(0));
    });

    test('skinForLevelsCleared returns progression skin', () {
      // Default skin unlocked at 0 levels
      final skin0 = SkinTierManager.skinForLevelsCleared(0);
      expect(skin0, isNotNull);
      expect(skin0!.id, equals('default'));
      
      // Rookie unlocked at 5 levels
      final skin5 = SkinTierManager.skinForLevelsCleared(5);
      expect(skin5, isNotNull);
      expect(skin5!.id, equals('rookie'));
      
      // Ninja unlocked at 15 levels
      final skin15 = SkinTierManager.skinForLevelsCleared(15);
      expect(skin15, isNotNull);
      expect(skin15!.id, equals('ninja'));
    });

    test('byId returns correct skin', () {
      final skin = SkinTierManager.byId('hacker');
      expect(skin, isNotNull);
      expect(skin?.tier, equals(SkinTier.hacker));
    });

    test('byId returns null for invalid ID', () {
      final skin = SkinTierManager.byId('invalid');
      expect(skin, isNull);
    });

    test('getActiveSkin returns default when null', () {
      final skin = SkinTierManager.getActiveSkin(null);
      expect(skin.id, equals('default'));
    });
  });
}