// Copyright (c) 2023 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  group('showSharezonePlusFeatureInfoDialog', () {
    Future<void> pumpScaffoldWithButtonForDialog(
      WidgetTester tester, {
      ThemeData? theme,
    }) async {
      await tester.pumpWidgetBuilder(
        Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => showSharezonePlusFeatureInfoDialog(
                  context: context,
                  navigateToPlusPage: () {},
                  description: const Text(
                      'With Sharezone Plus you receive this awesome feature that changes your life!'),
                  title: const Text('Awesome feature'),
                ),
                child: const Text('SHOW DIALOG'),
              ),
            ),
          ),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    Future<void> openDialog(WidgetTester tester) async {
      await tester.tap(find.text('SHOW DIALOG'));
      await tester.pumpAndSettle();
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      await pumpScaffoldWithButtonForDialog(
        tester,
        theme: getLightTheme(fontFamily: roboto),
      );

      await openDialog(tester);

      await screenMatchesGolden(
          tester, 'sharezone_plus_feature_info_dialog_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      await pumpScaffoldWithButtonForDialog(
        tester,
        theme: getDarkTheme(fontFamily: roboto),
      );

      await openDialog(tester);

      await screenMatchesGolden(
          tester, 'sharezone_plus_feature_info_dialog_dark');
    });
  });
}
