import 'package:flutter_test/flutter_test.dart';
import 'package:littletech/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LittleTechApp());

    // Verify that the splash screen is shown
    expect(find.text('LittleTech'), findsOneWidget);
  });
}
