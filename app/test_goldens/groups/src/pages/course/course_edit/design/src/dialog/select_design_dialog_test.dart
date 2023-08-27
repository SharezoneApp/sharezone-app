// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:sharezone/groups/src/pages/course/course_edit/design/course_edit_design.dart';

void main() {
  group('selectDesign', () {
    testGoldens('display select design dialog as expected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(builder: (context) {
                return ElevatedButton(
                  // @visibleForTesting is not working for our `test_goldens`
                  // folder. Therefore we have to ignore the warning.
                  //
                  // ignore: invalid_use_of_visible_for_testing_member
                  onPressed: () => selectDesign(context, null),
                  child: Text("Select"),
                );
              }),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'select_design_dialog');
    });
  });
}
