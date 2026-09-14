import 'package:flutter_test/flutter_test.dart';
import 'package:catchcar/main.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const CatchCarApp());
    expect(find.byType(CatchCarApp), findsOneWidget);
  });
}
