// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'fake_mobile_scanner_controller.dart';

void main() {
  group('Scanner', () {
    late FakeMobileScannerController controller;

    setUp(() {
      controller = FakeMobileScannerController();
    });

    testWidgets('should turn on the torch when pressing the torch icon',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Scanner(controller: controller),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('torch-button-widget-test')));

      expect(controller.hasTorch, false);
    });

    testWidgets('should not display the torch if device has no torch',
        (tester) async {
      controller.hasTorch = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Scanner(controller: controller),
          ),
        ),
      );

      expect(find.byKey(const Key('torch-button-widget-test')), findsNothing);
    });

    testWidgets('should display the description', (tester) async {
      controller.hasTorch = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Scanner(
              controller: controller,
              description: const Text('Hello! I am a description!'),
            ),
          ),
        ),
      );

      expect(find.text('Hello! I am a description!'), findsOneWidget);
    });

    testWidgets('should return the detected qr code', (tester) async {
      String? scannedQrCode;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Scanner(
              controller: controller,
              onDetect: (qrCode) {
                scannedQrCode = qrCode;
              },
            ),
          ),
        ),
      );

      // Simulate a detected qr code
      controller.handleEvent({'data': 'myQrCode'});
      await tester.pump();

      expect(scannedQrCode, 'myQrCode');
    });
  });
}
