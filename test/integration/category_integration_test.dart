import 'package:flutter_test/flutter_test.dart';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

void main() {
  group('Integration Tests - Category System', () {
    test('All categories generate valid worlds', () {
      final worlds = GameData.worlds;
      
      // Each category should generate one world
      expect(worlds.length, equals(CategoryManager.all.length));
      
      // Each world should have levels (problems + boss levels)
      for (final world in worlds) {
        final category = CategoryManager.byId(world.id);
        expect(category, isNotNull, reason: 'World ${world.id} should have matching category');
        expect(world.name, equals(category?.name));
        expect(world.description, equals(category?.description));
        expect(world.levels.length, greaterThanOrEqualTo(10), 
            reason: 'World ${world.id} should have at least 10 levels');
      }
    });

    test('All levels have unique IDs within their worlds', () {
      final allIds = <String>{};
      for (final world in GameData.worlds) {
        for (final level in world.levels) {
          expect(allIds.contains(level.id), isFalse, 
              reason: 'Level ID ${level.id} should be unique');
          allIds.add(level.id);
        }
      }
    });
  });
}