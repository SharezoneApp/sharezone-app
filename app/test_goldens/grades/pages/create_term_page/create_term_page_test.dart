// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'create_term_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GradesService>(),
  MockSpec<CrashAnalytics>(),
  MockSpec<Analytics>(),
])
void main() {
  group(CreateTermPage, () {
    Future<void> pushCreateTermPage(
      WidgetTester tester,
      ThemeData theme,
    ) async {
      await tester.pumpWidgetBuilder(
        MultiProvider(
          providers: [
            Provider<GradesService>.value(value: MockGradesService()),
            Provider<CrashAnalytics>.value(value: MockCrashAnalytics()),
            Provider<Analytics>.value(value: MockAnalytics()),
          ],
          child: const CreateTermPage(),
        ),
        wrapper: materialAppWrapper(theme: theme),
      );
    }

    testGoldens('renders as expected (light mode)', (tester) async {
      await pushCreateTermPage(tester, getLightTheme());
      await multiScreenGolden(tester, 'create_term_page_light');
    });

    testGoldens('renders as expected (dark mode)', (tester) async {
      await pushCreateTermPage(tester, getDarkTheme());
      await multiScreenGolden(tester, 'create_term_page_dark');
    });
  });
}
