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

import 'fake_mobile_scanner_controller.dart';

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

    testWidgets('passes route settings', (tester) async {
      final routeSettingsObserver = RouteSettingsObserver();
      const route = 'my-route';

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [routeSettingsObserver],
          home: Scaffold(
            body: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () => showQrCodeScanner(
                  context,
                  mockController: controller,
                  settings: const RouteSettings(name: route),
                ),
                child: const Text('Scan QR Code'),
              );
            }),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));

      expect(routeSettingsObserver.routeName, route);
    });

    testWidgets('returns the scanned qr code', (tester) async {
      const qrCode = 'my-qr-code';
      String? scannedQrCode;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  scannedQrCode = await showQrCodeScanner(
                    context,
                    mockController: controller,
                  );
                },
                child: const Text('Scan QR Code'),
              );
            }),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));

      // Simulate a detected qr code
      controller.handleEvent({'data': qrCode});
      await tester.pump();

      expect(scannedQrCode, qrCode);
    });

    testWidgets('passes description', (tester) async {
      const description = 'my-description';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () => showQrCodeScanner(
                  context,
                  mockController: controller,
                  description: const Text(description),
                ),
                child: const Text('Scan QR Code'),
              );
            }),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(description), findsOneWidget);
    });

    testWidgets('passes title', (tester) async {
      const title = 'my-title';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () => showQrCodeScanner(
                  context,
                  mockController: controller,
                  title: const Text(title),
                ),
                child: const Text('Scan QR Code'),
              );
            }),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
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
