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
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  group(ErrorCard, () {
    Future<void> pushErrorCard(
      WidgetTester tester, {
      ThemeData? themeData,
    }) async {
      await tester.pumpWidgetBuilder(
        Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ErrorCard(
                message: const Text(
                  '[cloud_firestore/permission-denied] The caller does not have permission to execute the specified operation.',
                ),
                onContactSupportPressed: () {},
                onRetryPressed: () {},
              ),
            ],
          ),
        ),
        wrapper: materialAppWrapper(theme: themeData),
      );
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      await pushErrorCard(tester, themeData: getLightTheme(fontFamily: roboto));

      await multiScreenGolden(tester, 'error_card_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      await pushErrorCard(tester, themeData: getDarkTheme(fontFamily: roboto));

      await multiScreenGolden(tester, 'error_card_dark');
    });
  });
}
