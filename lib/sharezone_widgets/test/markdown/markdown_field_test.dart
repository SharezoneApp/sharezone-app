// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  group(MarkdownField, () {
    testWidgets('should not display markdown helper text when not focused', (
      tester,
    ) async {
      await tester.pumpScene(tester);

      expect(find.byType(MarkdownSupport), findsNothing);
    });

    testWidgets('should display markdown helper text when focused', (
      tester,
    ) async {
      await tester.pumpScene(tester);

      await tester.tap(find.byType(PrefilledTextField));
      await tester.pump();

      expect(find.byType(MarkdownSupport), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpScene(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
        supportedLocales: [const Locale('de', 'DE')],
        home: Scaffold(body: MarkdownField(onChanged: (_) {})),
      ),
    );
  }
}
