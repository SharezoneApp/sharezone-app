// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  group('AlternatingColoredList', () {
    const list = [0, 1, 2, 3, 4, 5];

    void testRowWith({
      required Color? color,
      required int index,
      required WidgetTester tester,
    }) {
      assert(color != null);

      final row = tester.firstWidget<Material>(
          find.byKey(ValueKey('AlternatingColoredList;Item:$index')));
      expect(row.color, color);
    }

    testWidgets('colors alternately with given interval', (tester) async {
      const theme = AlternatingColoredListTheme(
        highlightedColor: Colors.green,
        notHighlightedColor: Colors.amberAccent,
      );

      await tester.pumpWidget(MaterialApp(
        home: AlternatingColoredList(
          itemCount: list.length,
          theme: theme,
          alternatingInterval: 3,
          itemBuilder: (context, i) => Text('$i'),
        ),
      ));

      testRowWith(color: theme.notHighlightedColor, tester: tester, index: 0);
      testRowWith(color: theme.notHighlightedColor, tester: tester, index: 1);
      testRowWith(color: theme.highlightedColor, tester: tester, index: 2);
      testRowWith(color: theme.notHighlightedColor, tester: tester, index: 3);
      testRowWith(color: theme.notHighlightedColor, tester: tester, index: 4);
      testRowWith(color: theme.highlightedColor, tester: tester, index: 5);
    });

    testWidgets('colors alternately with given Colors', (tester) async {
      const theme = AlternatingColoredListTheme(
        highlightedColor: Colors.green,
        notHighlightedColor: Colors.amberAccent,
      );

      await tester.pumpWidget(MaterialApp(
        home: AlternatingColoredList(
          itemCount: list.length,
          theme: theme,
          itemBuilder: (context, i) => Text('$i'),
        ),
      ));

      testRowWith(color: theme.notHighlightedColor, tester: tester, index: 0);
      testRowWith(color: theme.highlightedColor, tester: tester, index: 1);
      testRowWith(color: theme.notHighlightedColor, tester: tester, index: 2);
      testRowWith(color: theme.highlightedColor, tester: tester, index: 3);
      testRowWith(color: theme.notHighlightedColor, tester: tester, index: 4);
      testRowWith(color: theme.highlightedColor, tester: tester, index: 5);
    });
  });
}
