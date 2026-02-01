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

void main() {
  Widget wrapWithApp(Widget child, {ThemeData? theme}) {
    return MaterialApp(
      theme: theme,
      localizationsDelegates: SharezoneLocalizations.localizationsDelegates,
      supportedLocales: SharezoneLocalizations.supportedLocales,
      locale: const Locale('de'),
      home: child,
    );
  }

  group(CardListTile, () {
    Future<void> pushTile(
      WidgetTester tester, {
      ThemeData? themeData,
      Widget? leading,
      bool centerTitle = false,
      Widget? trailing,
      Widget? title,
    }) async {
      await tester.pumpWidgetBuilder(
        Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardListTile(
                leading: leading,
                centerTitle: centerTitle,
                trailing: trailing,
                title: title,
              ),
            ],
          ),
        ),
        wrapper: (child) => wrapWithApp(child, theme: themeData),
      );
    }

    testGoldens('renders with leading, trailing and center title', (
      tester,
    ) async {
      await pushTile(
        tester,
        themeData: getLightTheme(fontFamily: roboto),
        leading: IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        title: const Material(color: Colors.transparent, child: Text('Title')),
        trailing: const Icon(Icons.settings),
        centerTitle: true,
      );

      await multiScreenGolden(tester, 'card_list_tile');
    });
  });
}
