import 'package:flutter_test/flutter_test.dart';
import 'package:littletech/src/Core/services/rule_engine.dart';

void main() {
  group('RuleEngine Tests', () {
    test('should return solution for no display', () {
      final result = RuleEngine.solve('no display');
      expect(result, isNotNull);
      expect(result!.problem, contains('No display'));
    });

    test('should return solution for slow internet', () {
      final result = RuleEngine.solve('slow internet');
      expect(result, isNotNull);
      expect(result!.problem, contains('Wi-Fi'));
    });

    test('should return null for unknown problem', () {
      final result = RuleEngine.solve('unknown issue that is not in rules');
      expect(result, isNull);
    });
  });
}
