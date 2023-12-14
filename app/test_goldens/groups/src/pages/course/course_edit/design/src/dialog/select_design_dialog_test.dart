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
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/design/course_edit_design.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'select_design_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionService>()])
void main() {
  group('selectDesign', () {
    late MockSubscriptionService subscriptionService;

    setUp(() {
      subscriptionService = MockSubscriptionService();
    });

    Future<void> pumpSelectDesignDialog(
      WidgetTester tester, {
      ThemeData? theme,
    }) async {
      await tester.pumpWidget(
        Provider<SubscriptionService>(
          create: (_) => subscriptionService,
          child: MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Center(
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    // @visibleForTesting is not working for our `test_goldens`
                    // folder. Therefore we have to ignore the warning.
                    //
                    // ignore: invalid_use_of_visible_for_testing_member
                    onPressed: () => selectDesign(context, null),
                    child: const Text("Select"),
                  );
                }),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    }

    group('with Sharezone Plus', () {
      setUp(() {
        when(subscriptionService
                .hasFeatureUnlocked(SharezonePlusFeature.moreGroupColors))
            .thenReturn(true);
      });

      testGoldens('displays select base color dialog as expected (light mode)',
          (tester) async {
        await pumpSelectDesignDialog(tester, theme: lightTheme);

        await multiScreenGolden(tester, 'select_base_color_dialog_light');
      });

      testGoldens('displays select base color dialog as expected (dark mode)',
          (tester) async {
        await pumpSelectDesignDialog(tester, theme: darkTheme);

        await multiScreenGolden(tester, 'select_base_color_dialog_dark');
      });

      testGoldens(
          'displays select a color shade dialog as expected (light mode)',
          (tester) async {
        await pumpSelectDesignDialog(tester, theme: lightTheme);

        await tester
            .tap(find.byKey(Key('color-circle-${Colors.blue.value}')).last);
        await tester.pumpAndSettle();

        await multiScreenGolden(tester, 'select_accurate_color_dialog_light');
      });

      testGoldens(
          'displays select a color shade dialog as expected (dark mode)',
          (tester) async {
        await pumpSelectDesignDialog(tester, theme: darkTheme);

        await tester
            .tap(find.byKey(Key('color-circle-${Colors.blue.value}')).last);
        await tester.pumpAndSettle();

        await multiScreenGolden(tester, 'select_accurate_color_dialog_dark');
      });
    });

    group('without Sharezone Plus', () {
      setUp(() {
        when(subscriptionService
                .hasFeatureUnlocked(SharezonePlusFeature.moreGroupColors))
            .thenReturn(false);
      });

      testGoldens('displays select design dialog as expected (light mode)',
          (tester) async {
        await pumpSelectDesignDialog(tester, theme: lightTheme);

        await multiScreenGolden(tester, 'select_free_design_dialog_light');
      });

      testGoldens('displays select design dialog as expected (dark mode)',
          (tester) async {
        await pumpSelectDesignDialog(tester, theme: darkTheme);

        await multiScreenGolden(tester, 'select_free_design_dialog_dark');
      });
    });
  });
}
