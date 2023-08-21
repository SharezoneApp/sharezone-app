// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class FakeMobileScannerController extends Fake
    implements MobileScannerController {
  @override
  final ValueNotifier<MobileScannerArguments?> startArguments = ValueNotifier(
    MobileScannerArguments(
      hasTorch: true,
      size: const Size(100, 100),
      textureId: 0,
    ),
  );

  final StreamController<BarcodeCapture> barcodesController =
      StreamController<BarcodeCapture>();

  @override
  Stream<BarcodeCapture> get barcodes => barcodesController.stream;

  @override
  bool torchEnabled = false;

  @override
  bool hasTorch = true;

  @override
  bool autoStart = true;

  @override
  Future<MobileScannerArguments?> start({
    CameraFacing? cameraFacingOverride,
  }) async {
    return null;
  }

  void handleEvent(Map map) {
    barcodesController.add(
      BarcodeCapture(
        barcodes: [
          Barcode(
            rawValue: map['data'],
          ),
        ],
        raw: map['data'],
      ),
    );
  }

  @override
  Future<void> toggleTorch() async {
    torchEnabled = !torchEnabled;
  }

  @override
  void dispose() {
    barcodesController.close();
  }

  @override
  Future<void> updateScanWindow(Rect? window) async {
    // Do nothing.
  }
}
