// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone/main/constants.dart';
import 'package:sharezone/widgets/development_stage_banner.dart';

void main() {
  group('$DevelopmentStageBanner', () {
    testGoldens('displays the banner at the correct position', (tester) async {
      kDevelopmentStage = 'alpha';

      await tester.pumpWidgetBuilder(
        const DevelopmentStageBanner(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Text("Text")),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'alpha_version_banner');
    });

    testWidgets("does display the banner if stage is alpha, beta or preview", (
      tester,
    ) async {
      for (var stage in ['alpha', 'beta', 'preview']) {
        kDevelopmentStage = stage;

        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.ltr,
            child: DevelopmentStageBanner(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(body: Text("Text")),
              ),
            ),
          ),
        );

        expect(
          find.byType(Banner),
          findsOneWidget,
          reason: 'Stage "$stage" should display the banner',
        );
      }
    });

    testWidgets("does not display the banner if stage is 'stable' or null", (
      tester,
    ) async {
      for (var stage in ['stable', null]) {
        kDevelopmentStage = stage;

        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.ltr,
            child: DevelopmentStageBanner(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(body: Text("Text")),
              ),
            ),
          ),
        );

        expect(
          find.byType(Banner),
          findsNothing,
          reason: 'Stage "$stage" should not display the banner',
        );
      }
    });
  });
}
