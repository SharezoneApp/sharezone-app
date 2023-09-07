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
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../test/fake_mobile_scanner_controller.dart';

class RouteSettingsObserver extends NavigatorObserver {
  String? routeName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    routeName = route.settings.name;
    super.didPush(route, previousRoute);
  }
}

void main() {
  group('showQrCodeScanner()', () {
    late FakeMobileScannerController controller;

    setUp(() {
      controller = FakeMobileScannerController();
    });

    testGoldens('displays scanner page as expected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () => showQrCodeScanner(
                  context,
                  mockController: controller,
                ),
                child: const Text('Scan QR Code'),
              );
            }),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));

      await screenMatchesGolden(
        tester,
        'scanner_page',
      );
    });
  });
}
