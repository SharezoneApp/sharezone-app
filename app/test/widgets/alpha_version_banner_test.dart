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
import 'package:sharezone/widgets/alpha_version_banner.dart';

void main() {
  group('AlphaVersionBanner', () {
    testGoldens(
      'displays the banner correct',
      (tester) async {
        await tester.pumpWidgetBuilder(
          AlphaVersionBanner(
            isAlphaVersion: true,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Text("Text"),
              ),
            ),
          ),
        );

        await screenMatchesGolden(tester, 'alpha_version_banner');
      },
    );

    testWidgets(
      "does not display the banner if app is not an alpha version",
      (tester) async {
        await tester.pumpWidgetBuilder(
          AlphaVersionBanner(
            isAlphaVersion: false,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Text("Text"),
              ),
            ),
          ),
        );

        expect(find.byType(Banner), findsNothing);
      },
    );
  });
}
