import 'package:flutter_test/flutter_test.dart';
import 'package:littletech/src/core/constants/category_manager.dart';
import 'package:littletech/src/features/game/constants/game_data.dart';

void main() {
  group('CategoryManager Tests', () {
    test('all categories are defined', () {
      expect(CategoryManager.all.length, greaterThan(0));
    });

    test('category IDs are unique', () {
      final ids = CategoryManager.all.map((c) => c.id).toList();
      expect(ids.length, ids.toSet().length);
    });

    test('byId returns correct category', () {
      final cat = CategoryManager.byId('core_components');
      expect(cat, isNotNull);
      expect(cat?.name, equals('Core Components'));
    });

    test('byId returns null for invalid ID', () {
      final cat = CategoryManager.byId('invalid_id');
      expect(cat, isNull);
    });

    test('byIndex returns correct category', () {
      final cat = CategoryManager.byIndex(0);
      expect(cat, isNotNull);
      expect(cat?.id, equals('core_components'));
    });

    test('byIndex returns null for invalid index', () {
      final cat = CategoryManager.byIndex(-1);
      expect(cat, isNull);
      final cat2 = CategoryManager.byIndex(100);
      expect(cat2, isNull);
    });

    test('indexOf returns correct index', () {
      expect(CategoryManager.indexOf('core_components'), equals(0));
      expect(CategoryManager.indexOf('ram'), equals(1));
    });

    test('indexOf returns -1 for unknown ID', () {
      expect(CategoryManager.indexOf('unknown'), equals(-1));
    });
  });

  group('GameData Tests', () {
    test('worlds are generated from categories', () {
      final worlds = GameData.worlds;
      expect(worlds.length, equals(CategoryManager.all.length));
    });

    test('levelId generates correct slug', () {
      expect(GameData.levelId('core_components', 'high cpu usage'), equals('core_components_high_cpu_usage'));
      expect(GameData.levelId('test', 'boot loop'), equals('test_boot_loop'));
    });

    test('isWorldComplete detects completion', () {
      final world = GameData.worlds.first;
      final completed = world.levels.map((l) => l.id).toList();
      expect(GameData.isWorldComplete(world, completed), isTrue);
    });

    test('isWorldComplete detects incomplete', () {
      final world = GameData.worlds.first;
      final incomplete = <String>[];
      expect(GameData.isWorldComplete(world, incomplete), isFalse);
    });
  });
}