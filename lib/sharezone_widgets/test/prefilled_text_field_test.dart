// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sharezone_widgets/src/widgets.dart';

void main() {
  Future<void> pumpTextField(
      {required WidgetTester tester, required Widget textField}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: textField,
        ),
      ),
    );
  }

  group('PrefilledTextField', () {
    const sharezone = 'sharezone';

    testWidgets('prefills the TextField with the string passed via label',
        (tester) async {
      await pumpTextField(
          tester: tester,
          textField: const PrefilledTextField(prefilledText: sharezone));
      final TextField textField = tester.firstWidget(find.byType(TextField));
      expect(textField.controller!.text, sharezone);
    });

    testWidgets(
        'auto select the prefilled text, if autoSelectAllCharactersAtBeginning is true',
        (tester) async {
      await pumpTextField(
        tester: tester,
        textField: const PrefilledTextField(
            prefilledText: sharezone,
            autoSelectAllCharactersOnFirstBuild: true),
      );

      final TextField tf1 = tester.firstWidget(find.byType(TextField));

      // Checks if 'sharezone' is selected in 'tf1'
      expect(
        tf1.controller!.selection,
        const TextSelection(baseOffset: 0, extentOffset: sharezone.length),
      );
    });

    testWidgets(
        'doesn\'t auto selected prefilled text, if autoSelectAllCharactersAtBeginning is false',
        (tester) async {
      await pumpTextField(
        tester: tester,
        textField: const PrefilledTextField(
            prefilledText: sharezone,
            autoSelectAllCharactersOnFirstBuild: false),
      );

      final TextField tf1 = tester.firstWidget(find.byType(TextField));

      // Checks if 'sharezone' is not selected in 'tf1'
      expect(
        tf1.controller!.selection,
        const TextSelection(baseOffset: -1, extentOffset: -1),
      );
    });
  });
}
