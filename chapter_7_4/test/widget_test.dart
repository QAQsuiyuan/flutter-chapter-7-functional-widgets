import 'package:flutter_test/flutter_test.dart';
import 'package:chapter_7_4/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // Verify the app builds without errors
    expect(find.byType(MyApp), findsOneWidget);
  });
}
