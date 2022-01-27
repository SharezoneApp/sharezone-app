// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Sharezone App', () {
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await setupAndGetDriver();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('check flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    test('Can log in with email and password', () async {
      // Auf Desktop werden direkt das E-Mail- und Password-Feld mit angezeigt,
      // auf dem Handy muss man erst auf den "ich habe bereits ein Konto"-Knopf
      // drücken.
      // Der Test funktioniert so also gerade erstmal nur auf dem Handy.
      await driver.tap(find.byValueKey('go-to-login-button-E2E'));

      await driver.tap(find.byValueKey('email-text-field-E2E'));
      await driver.enterText('TODO@SOME-ACCOUNT.com');

      // The credentials should be randomly generated or passed via environment
      // variables in a CI pipeline or sth.
      // Can't be plain text as this is open source.
      await driver.tap(find.byValueKey('password-text-field-E2E'));
      await driver.enterText('[TODO]');

      await driver.tap(find.byValueKey('login-button-E2E'));

      await driver.waitFor(find.byValueKey('dashboard-appbar-title-E2E'));

      await driver.tap(find.byValueKey('my-profile-button-E2E'));
      await driver.tap(find.byValueKey('sign-out-button-E2E'));
      await driver.tap(find.byValueKey('sign-out-dialog-action-E2E'));
    },
        skip:
            'Cant be run as we need to solve how credentials are passed to the e2e tests.');
  });
}

/// Siehe: https://github.com/flutter/flutter/issues/41029
Future<FlutterDriver> setupAndGetDriver() async {
  FlutterDriver driver = await FlutterDriver.connect();
  var connected = false;
  while (!connected) {
    try {
      await driver.waitUntilFirstFrameRasterized();
      connected = true;
    } catch (error) {
      print('Error connecting, retrying...');
    }
  }
  return driver;
}
