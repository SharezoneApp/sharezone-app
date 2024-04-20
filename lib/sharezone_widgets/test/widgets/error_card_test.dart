// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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

    testWidgets('Does not show retry button if onRetryPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onContactSupportPressed: () {},
          ),
        ),
      ));

      expect(find.byKey(const Key('retry-button')), findsNothing);
    });

    testWidgets('Does show retry button if onRetryPressed is not null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onRetryPressed: () {},
          ),
        ),
      ));

      expect(find.byKey(const Key('retry-button')), findsOneWidget);
    });

    testWidgets('onRetryPressed is called when retry button is pressed',
        (WidgetTester tester) async {
      bool wasCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onRetryPressed: () {
              wasCalled = true;
            },
          ),
        ),
      ));

      await tester.tap(find.byKey(const Key('retry-button')));
      expect(wasCalled, true);
    });

    testWidgets(
        'Does not show contact support button if onContactSupportPressed is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onRetryPressed: () {},
          ),
        ),
      ));

      expect(find.byKey(const Key('contact-support-button')), findsNothing);
    });

    testWidgets(
        'Does show contact support button if onContactSupportPressed is not null',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onContactSupportPressed: () {},
          ),
        ),
      ));

      expect(find.byKey(const Key('contact-support-button')), findsOneWidget);
    });

    testWidgets(
        'onContactSupportPressed is called when contact support button is pressed',
        (WidgetTester tester) async {
      bool wasCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ErrorCard(
            message: const Text('Test Message'),
            onContactSupportPressed: () {
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
