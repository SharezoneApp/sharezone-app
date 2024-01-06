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
import 'package:sharezone_plus_page_ui/sharezone_plus_page_ui.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

void main() {
  group('sharezone_plus_page_ui', () {
    Future<void> tapEveryExpansionCard(WidgetTester tester) async {
      for (final element in find.byType(ExpansionCard).evaluate()) {
        // We need to scroll the element into view before we can tap it.
        await tester.dragUntilVisible(
          find.byWidget(element.widget),
          find.byType(SingleChildScrollView),
          const Offset(0, 50),
        );

        await tester.tap(find.byWidget(element.widget));
      }
      await tester.pumpAndSettle();
    }

    // ignore: invalid_use_of_visible_for_testing_member
    group(SharezonePlusAdvantages, () {
      for (final typeOfUser in [
        TypeOfUser.parent,
        TypeOfUser.teacher,
        TypeOfUser.student
      ]) {
        Future<void> pumpPlusAdvantages(
          WidgetTester tester, {
          required ThemeData theme,
          required TypeOfUser typeOfUser,
        }) async {
          await tester.pumpWidgetBuilder(
            SingleChildScrollView(
              child: SharezonePlusAdvantages(
                typeOfUser: typeOfUser,
              ),
            ),
            wrapper: materialAppWrapper(theme: theme),
          );
        }

        testGoldens(
            'renders advantages for ${typeOfUser.name} as expected (dark theme)',
            (tester) async {
          await pumpPlusAdvantages(
            tester,
            theme: getDarkTheme(fontFamily: roboto),
            typeOfUser: typeOfUser,
          );

          await tapEveryExpansionCard(tester);

          await multiScreenGolden(
            tester,
            'sharezone_plus_advantages_${typeOfUser.name}_dark_theme',
            // Since we only need to test the expanded advantages and we have
            // already tested the Sharezone Plus page for all devices, we don't
            // need to test it for all devices. Using a tablet portrait is
            // sufficient.
            devices: [Device.tabletPortrait],
          );
        });

        testGoldens(
            'renders advantages for ${typeOfUser.name} as expected (light theme)',
            (tester) async {
          await pumpPlusAdvantages(
            tester,
            theme: getLightTheme(fontFamily: roboto),
            typeOfUser: typeOfUser,
          );

          await tapEveryExpansionCard(tester);

          await multiScreenGolden(
            tester,
            'sharezone_plus_advantages_${typeOfUser.name}_light_theme',
            // See comment above.
            devices: [Device.tabletPortrait],
          );
        });
      }
    });

    // ignore: invalid_use_of_visible_for_testing_member
    group(SharezonePlusFaq, () {
      testGoldens('renders faq section as expected (dark theme)',
          (tester) async {
        await tester.pumpWidgetBuilder(
          const SingleChildScrollView(child: SharezonePlusFaq()),
          wrapper: materialAppWrapper(theme: getDarkTheme(fontFamily: roboto)),
        );

        await tapEveryExpansionCard(tester);

        await multiScreenGolden(
          tester,
          'sharezone_plus_faq_section_dark_theme',
          // See comment above.
          devices: [Device.tabletPortrait],
        );
      });

      testGoldens('renders faq section as expected (light theme)',
          (tester) async {
        await tester.pumpWidgetBuilder(
          const SingleChildScrollView(child: SharezonePlusFaq()),
          wrapper: materialAppWrapper(theme: getLightTheme(fontFamily: roboto)),
        );

        await tapEveryExpansionCard(tester);

        await multiScreenGolden(
          tester,
          'sharezone_plus_faq_section_light_theme',
          // See comment above.
          devices: [Device.tabletPortrait],
        );
      });
    });
  });
}
