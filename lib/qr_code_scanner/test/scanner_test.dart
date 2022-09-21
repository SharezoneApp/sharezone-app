import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'scanner_test.mocks.dart';

@GenerateMocks([MobileScannerController])
void main() {
  group('Scanner', () {
    testWidgets('should turn on the torch when pressing the torch icon',
        (tester) async {
      final controller = MockMobileScannerController();
      when(controller.hasTorch).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Scanner(controller: controller),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('torch-button-widget-test')));

      verify(controller.toggleTorch()).called(1);
    });

    testWidgets(
      ('should return the scanned qr code value when detecting an qr code'),
      (tester) async {
        final controller = MockMobileScannerController();
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

        controller.barcodesController.add(Barcode(rawValue: 'myQrCode'));

        expect(scannedQrCode, 'myQrCode');
      },
    );
  });
}
