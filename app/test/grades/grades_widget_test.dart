import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page.dart';

void main() {
  group('Grades Page', () {
    testWidgets('Creating a simple term works', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: GradesPage(),
        ),
      ));
      expect(find.text('Hello, World!'), findsOneWidget);
    });
  });
}
