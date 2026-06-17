import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:littletech/app.dart';
import 'package:littletech/src/features/game/data/models/player_progress.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    Isar? isar;
    try {
      isar = await Isar.open(
        [PlayerProgressSchema],
        directory: '.',
        inspector: false,
      );
    } catch (e) {
      // Skip test if Isar native library is not available
      return;
    }

    await tester.pumpWidget(LittleTechApp(isar: isar));
    expect(find.byType(LittleTechApp), findsOneWidget);
    await isar.close();
  });
}
