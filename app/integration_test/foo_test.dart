import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sharezone/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets("succeeding test example", (WidgetTester tester) async {
    expect(2 + 2, equals(4));
  });

  testWidgets("login test", (WidgetTester tester) async {
    await app.main(isDriverTest: true);
    await tester.pumpAndSettle();
    // Auf Desktop werden direkt das E-Mail- und Password-Feld mit angezeigt,
    // auf dem Handy muss man erst auf den "ich habe bereits ein Konto"-Knopf
    // drücken.
    // Der Test funktioniert so also gerade erstmal nur auf dem Handy.
    await tester.tap(find.byKey(ValueKey('go-to-login-button-E2E')));
    await tester.pumpAndSettle();

    // Die Account-Daten funktionieren auf dem "sharzone-debug" (--flavor dev)
    // und dem "sharezone-c2bd8" (--flavor prod) Projekt.
    await tester.enterText(
        find.byKey(ValueKey('email-text-field-E2E')), 'schueler1@e2e-test.com');

    await tester.enterText(
        find.byKey(ValueKey('password-text-field-E2E')), '123seife');

    await tester.tap(find.byKey(ValueKey('login-button-E2E')));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ValueKey('my-profile-button-E2E')));
    await tester.pumpAndSettle();

    expect(find.text('schueler1@e2e-test.com'), findsOneWidget);

    // Logging out does currently not work. It will get to the last step but
    // then the app will just display a white screen instead of showing the
    // "choose your account type" screen from the onboarding (means that log out
    // was successful). The last pumpAndSettle does not complete aswell.

    // await tester.tap(find.byKey(ValueKey('sign-out-button-E2E')));
    // await tester.pumpAndSettle();

    // await Future.delayed(Duration(seconds: 7));

    // await tester.tap(find.byKey(ValueKey('sign-out-dialog-action-E2E')));

    // await tester.pumpAndSettle();
  });
}
