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
import 'package:sharezone/widgets/common/picker.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import '../../flutter_test_config.dart';

void main() {
  group('selectItem()', () {
    Future<void> pumpPage(WidgetTester tester, ThemeData theme) async {
      await tester.pumpWidgetBuilder(
        Scaffold(
          body: Builder(
            builder:
                (context) => ElevatedButton(
                  onPressed: () async {
                    await selectItem<String>(
                      context: context,
                      items: ['a', 'b', 'c'],
                      builder:
                          (context, item) => ListTile(
                            title: Text(item),
                            onTap: () {
                              Navigator.pop(context, item);
                            },
                          ),
                    );
                  },
                  child: const Text('Open Picker'),
                ),
          ),
        ),
        wrapper: materialAppWrapper(
          theme: theme,
          localizations: SharezoneLocalizations.localizationsDelegates,
          localeOverrides: defaultLocales,
        ),
      );
    }

    testGoldens('should render as expected (light mode)', (tester) async {
      await pumpPage(tester, getLightTheme());

      await tester.tap(find.text('Open Picker'));

      await screenMatchesGolden(tester, 'picker_light');
    });

    testGoldens('should render as expected (dark mode)', (tester) async {
      await pumpPage(tester, getDarkTheme());

      await tester.tap(find.text('Open Picker'));

      await screenMatchesGolden(tester, 'picker_dark');
    });
  });
}
