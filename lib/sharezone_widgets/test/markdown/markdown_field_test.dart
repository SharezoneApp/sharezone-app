// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
      supportedLocales: SharezoneLocalizations.supportedLocales,
      locale: const Locale('de'),
      home: Scaffold(body: child),
    );
  }

  group(MarkdownField, () {
    testWidgets('should not display markdown helper text when not focused', (
      tester,
    ) async {
      await tester.pumpWidgetBuilder(
        MarkdownField(onChanged: (_) {}),
        wrapper: wrapWithApp,
      );

      expect(find.byType(MarkdownSupport), findsNothing);
    });

    testWidgets('should display markdown helper text when focused', (
      tester,
    ) async {
      await tester.pumpWidgetBuilder(
        MarkdownField(onChanged: (_) {}),
        wrapper: wrapWithApp,
      );

      await tester.tap(find.byType(PrefilledTextField));
      await tester.pump();

      expect(find.byType(MarkdownSupport), findsOneWidget);
    });
  });
}
