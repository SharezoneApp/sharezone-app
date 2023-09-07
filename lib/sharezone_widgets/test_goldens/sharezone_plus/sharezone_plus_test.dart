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
  group('Sharezone Plus Widgets', () {
    group(SharezonePlusCard, () {
      Future<void> pumpSharezonePlusCard(
        WidgetTester tester, {
        ThemeData? theme,
      }) async {
        await tester.pumpWidgetBuilder(
          const Center(child: SharezonePlusCard()),
          wrapper: materialAppWrapper(theme: theme),
        );
      }

      testGoldens('renders as expected (light mode)', (tester) async {
        await pumpSharezonePlusCard(tester);

        await screenMatchesGolden(tester, 'sharezone_plus_card_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pumpSharezonePlusCard(
          tester,
          // We can't use our Sharezone `darkTheme` here because we a custom
          // font that is not included in this package and the `golden_toolkit`
          // package can't load the font.
          //
          // See: https://github.com/eBay/flutter_glove_box/issues/158
          theme: ThemeData.dark().copyWith(
            primaryColor: primaryColor,
          ),
        );

        await screenMatchesGolden(tester, 'sharezone_plus_card_dark');
      });
    });
  });
}
