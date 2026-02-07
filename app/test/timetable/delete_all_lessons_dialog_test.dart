// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone/timetable/src/lesson_delete_all_suggestion_dialog.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';

void main() {
  testWidgets(
    'delete all lessons dialog keeps delete disabled until countdown finishes',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: SharezoneLocalizations.supportedLocales,
          localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed:
                        () => showDeleteAllLessonsConfirmationDialog(
                          context,
                          deletableLessonsCount: 5,
                        ),
                    child: const Text('open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final deleteButtonFinder = find.widgetWithText(TextButton, 'DELETE (10)');
      expect(deleteButtonFinder, findsOneWidget);
      expect(tester.widget<TextButton>(deleteButtonFinder).onPressed, isNull);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('DELETE (9)'), findsOneWidget);

      await tester.pump(const Duration(seconds: 9));
      await tester.pump();
      final enabledDeleteButtonFinder = find.widgetWithText(
        TextButton,
        'DELETE',
      );
      expect(enabledDeleteButtonFinder, findsOneWidget);
      expect(
        tester.widget<TextButton>(enabledDeleteButtonFinder).onPressed,
        isNotNull,
      );
    },
  );
}
