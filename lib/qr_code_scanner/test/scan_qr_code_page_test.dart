import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  group('scanQrCode()', () {
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
                onPressed: () => scanQrCode(
                  context,
                  controller: controller,
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
  });
}
