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
    group(SharezonePlusChip, () {
      Future<void> pumpSharezonePlusChip(
        WidgetTester tester, {
        ThemeData? theme,
      }) async {
        await tester.pumpWidgetBuilder(
          Builder(
            builder: (context) {
              return Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Center(
                  child: SharezonePlusChip(),
                ),
              );
            },
          ),
          wrapper: materialAppWrapper(theme: theme),
        );
      }

      testGoldens('renders as expected (light mode)', (tester) async {
        await pumpSharezonePlusChip(
          tester,
          theme: getLightTheme(fontFamily: roboto),
        );

        await screenMatchesGolden(tester, 'sharezone_plus_chip_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pumpSharezonePlusChip(
          tester,
          theme: getDarkTheme(fontFamily: roboto),
        );

        await screenMatchesGolden(tester, 'sharezone_plus_chip_dark');
      });
    });

    group(SharezonePlusFeatureInfoCard, () {
      Future<void> pumpSharezonePlusFeatureInfoCard(
        WidgetTester tester, {
        ThemeData? theme,
      }) async {
        await tester.pumpWidgetBuilder(
          Builder(
            builder: (context) {
              return Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                    child: SharezonePlusFeatureInfoCard(
                  withLearnMoreButton: true,
                  child: const Text(
                      'Erwerbe Sharezone Plus, um nachzuvollziehen, wer den Infozettel bereits gelesen hat.'),
                  onLearnMorePressed: () {},
                )),
              );
            },
          ),
          wrapper: materialAppWrapper(theme: theme),
        );
      }

      testGoldens('renders as expected (light mode)', (tester) async {
        await pumpSharezonePlusFeatureInfoCard(
          tester,
          theme: getLightTheme(fontFamily: roboto),
        );

        await screenMatchesGolden(
            tester, 'sharezone_plus_feature_info_card_light');
      });

      testGoldens('renders as expected (dark mode)', (tester) async {
        await pumpSharezonePlusFeatureInfoCard(tester,
            theme: getDarkTheme(fontFamily: roboto));

        await screenMatchesGolden(
            tester, 'sharezone_plus_feature_info_card_dark');
      });
    });
  });
}
