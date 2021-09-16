// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:random_string/random_string.dart';
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

      // Die Account-Daten funktionieren auf dem "sharzone-debug" (--flavor dev)
      // und dem "sharezone-c2bd8" (--flavor prod) Projekt.
      await driver.tap(find.byValueKey('email-text-field-E2E'));
      await driver.enterText('schueler1@e2e-test.com');

      await driver.tap(find.byValueKey('password-text-field-E2E'));
      await driver.enterText('123seife');

      await driver.tap(find.byValueKey('login-button-E2E'));

      await driver.waitFor(find.byValueKey('dashboard-appbar-title-E2E'));

      await driver.tap(find.byValueKey('my-profile-button-E2E'));
      await driver.tap(find.byValueKey('sign-out-button-E2E'));
      await driver.tap(find.byValueKey('sign-out-dialog-action-E2E'));
    });

    test('can write text message from teacher to student in same course',
        () async {
      // - Einloggen mit Lehrer-Account
      await driver.tap(find.byValueKey('go-to-login-button-E2E'));

      // Die Account-Daten funktionieren auf dem "sharzone-debug" (--flavor dev)
      await driver.tap(find.byValueKey('email-text-field-E2E'));
      await driver.enterText('lehrer1-chat@e2e-test.com');

      await driver.tap(find.byValueKey('password-text-field-E2E'));
      await driver.enterText('12345678');
      await driver.tap(find.byValueKey('login-button-E2E'));

      // - Zum Chat mit Schüler gehen
      await driver.tap(find.byValueKey('drawer-open-icon-E2E'));
      await driver.tap(find.byValueKey('chats-page'));
      await driver.tap(find.byValueKey('chat-list-tile-E2E'));

      // - Nachricht schreiben

      final rdm = randomAlpha(10);
      final msg = 'Hallo Roboter🤖 $rdm';

      await driver.tap(find.byValueKey('write-message-text-field-E2E'));
      await driver.enterText(msg);
      // Es muss gewartet werden, weil ansonsten der "Senden"-FAB noch
      // deaktiviert ist, vermutlich weil der StreamBuilder nicht schnell
      // genug ist.
      await Future.delayed(Duration(milliseconds: 250));
      await driver.tap(find.byValueKey('write-message-send-button-E2E'));

      // - Überprüfen, dass die Nachricht gesendet wurdes

      await driver.waitFor(find.text(msg));

      // - Ausloggen

      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('drawer-open-icon-E2E'));
      await driver.tap(find.byValueKey('account-drawer-tile-E2E'));
      await driver.tap(find.byValueKey('sign-out-button-E2E'));
      await driver.tap(find.byValueKey('sign-out-dialog-action-E2E'));

      // - Einloggen mit Schüler-Account

      await driver.tap(find.byValueKey('go-to-login-button-E2E'));

      // Die Account-Daten funktionieren auf dem "sharzone-debug" (--flavor dev)
      await driver.tap(find.byValueKey('email-text-field-E2E'));
      await driver.enterText('schueler1-chat@e2e-test.com');

      await driver.tap(find.byValueKey('password-text-field-E2E'));
      await driver.enterText('12345678');
      await driver.tap(find.byValueKey('login-button-E2E'));

      // - Zur Chat-Seite gehen

      await driver.tap(find.byValueKey('drawer-open-icon-E2E'));
      await driver.tap(find.byValueKey('chats-page'));
      await driver.tap(find.byValueKey('chat-list-tile-E2E'));

      // - Überprüfen, dass die Nachricht angekommen ist.

      await driver.waitFor(find.text(msg));

      // - Ausloggen

      await driver.tap(find.pageBack());
      await driver.tap(find.byValueKey('drawer-open-icon-E2E'));
      await driver.tap(find.byValueKey('account-drawer-tile-E2E'));
      await driver.tap(find.byValueKey('sign-out-button-E2E'));
      await driver.tap(find.byValueKey('sign-out-dialog-action-E2E'));
    },
        skip:
            'Aktuell fehlt der entsprende Code für den Chat in der App, weswegen der Test nicht funktionieren kann.');
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
