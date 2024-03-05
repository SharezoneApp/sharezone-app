import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  group(ErrorCard, () {
    testWidgets('Does not show Wrap widget if all callbacks are null',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: Text('Test Message'),
          ),
        ),
      ));

      expect(find.byType(Wrap), findsNothing);
    });

    testWidgets('Does not show retry button if onRetry is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onContactSupport: () {},
          ),
        ),
      ));

      expect(find.byKey(const Key('retry-button')), findsNothing);
    });

    testWidgets('Does show retry button if onRetry is not null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onRetry: () {},
          ),
        ),
      ));

      expect(find.byKey(const Key('retry-button')), findsOneWidget);
    });

    testWidgets('onRetry is called when retry button is pressed',
        (WidgetTester tester) async {
      bool wasCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onRetry: () {
              wasCalled = true;
            },
          ),
        ),
      ));

      await tester.tap(find.byKey(const Key('retry-button')));
      expect(wasCalled, true);
    });

    testWidgets(
        'Does not show contact support button if onContactSupport is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onRetry: () {},
          ),
        ),
      ));

      expect(find.byKey(const Key('contact-support-button')), findsNothing);
    });

    testWidgets(
        'Does show contact support button if onContactSupport is not null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onContactSupport: () {},
          ),
        ),
      ));

      expect(find.byKey(const Key('contact-support-button')), findsOneWidget);
    });

    testWidgets(
        'onContactSupport is called when contact support button is pressed',
        (WidgetTester tester) async {
      bool wasCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onContactSupport: () {
              wasCalled = true;
            },
          ),
        ),
      ));

      await tester.tap(find.byKey(const Key('contact-support-button')));
      expect(wasCalled, true);
    });
  });
}
