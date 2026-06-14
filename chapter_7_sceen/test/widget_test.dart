import 'package:flutter_test/flutter_test.dart';
import 'package:chapter_7_sceen/main.dart';

void main() {
  testWidgets('App builds', (tester) async {
    await tester.pumpWidget(const Chapter7Screen());
    expect(find.byType(Chapter7Screen), findsOneWidget);
  });
}
