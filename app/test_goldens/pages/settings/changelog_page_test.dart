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
import 'package:sharezone/pages/settings/changelog_page.dart';
import 'package:sharezone_utils/platform.dart';

void main() {
  group(UpdatePromptCard, () {
    for (final platform in [
      Platform.android,
      Platform.iOS,
      Platform.web,
      Platform.macOS
    ]) {
      testGoldens('display card for ${platform.name} as expected',
          (tester) async {
        // ignore: invalid_use_of_visible_for_testing_member
        PlatformCheck.setCurrentPlatformForTesting(platform);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    UpdatePromptCard(),
                  ],
                ),
              ),
            ),
          ),
        );

        await screenMatchesGolden(
          tester,
          'update_prompt_card_${platform.name.toLowerCase()}',
        );
      });
    }
  });
}
