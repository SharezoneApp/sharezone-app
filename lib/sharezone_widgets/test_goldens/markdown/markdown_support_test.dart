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
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../flutter_test_config.dart';

void main() {
  group(MarkdownSupport, () {
    // In the golden tests, the **fett** is not rendered as bold, because the
    // font family is not properly load by golden_toolkit. This is not a problem
    // in the app.

    testGoldens('renders as expected (dark mode)', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(child: MarkdownSupport()),
        wrapper: materialAppWrapper(
          theme: getDarkTheme(fontFamily: roboto),
          localizations: SharezoneLocalizations.localizationsDelegates,
          localeOverrides: defaultLocales,
        ),
      );

      await screenMatchesGolden(tester, 'markdown_support_dark');
    });

    testGoldens('renders as expected (light mode)', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(child: MarkdownSupport()),
        wrapper: materialAppWrapper(
          theme: getLightTheme(fontFamily: roboto),
          localizations: SharezoneLocalizations.localizationsDelegates,
          localeOverrides: defaultLocales,
        ),
      );

      await screenMatchesGolden(tester, 'markdown_support_light');
    });

    testGoldens('should break lines as expected', (tester) async {
      await tester.pumpWidgetBuilder(
        const Center(child: SizedBox(width: 100, child: MarkdownSupport())),
        wrapper: materialAppWrapper(
          theme: getLightTheme(fontFamily: roboto),
          localizations: SharezoneLocalizations.localizationsDelegates,
          localeOverrides: defaultLocales,
        ),
      );

      await screenMatchesGolden(tester, 'markdown_support_lines');
    });
  });
}
