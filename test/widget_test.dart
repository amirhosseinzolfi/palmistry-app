// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:palmistry_app/main.dart';
import 'package:palmistry_app/screens/home_screen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PalmistryApp(startScreen: HomeScreen()));

    // Verify that our app opens and displays the main title
    expect(find.textContaining('کف‌بینی'), findsOneWidget);
  });
}
