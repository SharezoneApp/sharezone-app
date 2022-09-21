import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class FakeMobileScannerController extends Fake
    implements MobileScannerController {
  @override
  final ValueNotifier<MobileScannerArguments?> args = ValueNotifier(
    MobileScannerArguments(
      hasTorch: true,
      size: const Size(100, 100),
      textureId: 0,
    ),
  );

  @override
  final StreamController<Barcode> barcodesController =
      StreamController<Barcode>();

  @override
  Stream<Barcode> get barcodes => barcodesController.stream;

  @override
  bool hasTorch = true;

  @override
  void handleEvent(Map map) {
    barcodesController.add(Barcode(
      rawValue: map['data'],
    ));
  }

  @override
  Future<void> toggleTorch() async {
    hasTorch = !hasTorch;
  }

  @override
  void dispose() {
    barcodesController.close();
  }
}

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
