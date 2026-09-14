import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catchcar/screens/profile_screen.dart';

void main() {
  testWidgets('ProfileScreen renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
