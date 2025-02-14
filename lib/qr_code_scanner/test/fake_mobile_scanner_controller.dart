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
  final StreamController<BarcodeCapture> barcodesController =
      StreamController<BarcodeCapture>();

  @override
  Stream<BarcodeCapture> get barcodes => barcodesController.stream;

  @override
  bool torchEnabled = false;

  @override
  Future<void> start({CameraFacing? cameraDirection}) async {
    return;
  }

  @override
  MobileScannerState get value => const MobileScannerState(
    isInitialized: true,
    isRunning: true,
    size: Size.zero,
    cameraDirection: CameraFacing.back,
    torchState: TorchState.off,
    zoomScale: 1.0,
    availableCameras: null,
    error: null,
  );

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  bool autoStart = true;

  @override
  Future<void> stop() async {}

  void handleEvent(Map map) {
    barcodesController.add(
      BarcodeCapture(
        barcodes: [Barcode(rawValue: map['data'])],
        raw: map['data'],
      ),
    );
  }

  @override
  Future<void> toggleTorch() async {
    torchEnabled = !torchEnabled;
  }

  @override
  Future<void> updateScanWindow(Rect? window) async {
    // Do nothing.
  }

  @override
  Future<void> dispose() async {
    barcodesController.close();
  }
}
