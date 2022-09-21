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
