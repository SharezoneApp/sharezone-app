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
import 'package:sharezone_widgets/sharezone_widgets.dart';

void main() {
  group(ExpansionCard, () {
    testGoldens('renders collapsed as expected', (tester) async {
      const widget = Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: ExpansionCard(
              header: Text('This is a very long header'),
              body: Text('And this is a very long body'),
              backgroundColor: Colors.lightBlue,
            ),
          ),
        ],
      );

      await tester.pumpWidgetBuilder(widget);

      await screenMatchesGolden(tester, 'expansion_card_collapsed');
    });

    testGoldens('renders expanded as expected', (tester) async {
      const widget = Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: ExpansionCard(
              header:
                  Text('This is a very very very very very very long header'),
              body: Text('And this is a very long body'),
              backgroundColor: Colors.lightBlue,
            ),
          ),
        ],
      );

      await tester.pumpWidgetBuilder(widget);

      await tester.tap(find.byType(ExpansionCard));
      await tester.pumpAndSettle();

      await multiScreenGolden(tester, 'expansion_card_expanded', devices: [
        Device.phone,
      ]);
    });
  });
}
