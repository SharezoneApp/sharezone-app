import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_code_scanner_example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Before running the test, add the screenshot "qr_code.jpg" to your Android
  // emulator camera: https://stackoverflow.com/a/64922184/8358501
  //
  // And you need to grand the permission to access the camera.
  testWidgets(
    "scan qr code",
    (tester) async {
      await tester.pumpWidget(const ExampleApp());

      await tester.tap(find.byKey(const Key('scan-qr-code-button-e2e')));
      await tester.pumpAndSettle();

      // await tester.pump(const Duration(seconds: 10));

      await waitFor(tester, find.byKey(const Key('scan-qr-code-button-e2e')));

      print("FSA");

      expect(
        find.text('Received QR code: https://sharez.one/pGmfH4rTQeuxXbLE6'),
        findsOneWidget,
      );
    },
    // Not working at the moment. Sometimes the camera does not include the
    // screenshot and otherwise you get a 'PlatformException(error, No active
    // stream to cancel, null, null)' error.
    skip: false,
    // At the moment only for Android the setup for this test is known.
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );
}

Future<void> waitFor(WidgetTester tester, Finder finder) async {
  do {
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 100));
  } while (finder.evaluate().isEmpty);
}
