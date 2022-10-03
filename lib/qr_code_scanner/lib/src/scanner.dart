// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/src/overlay/scan_overlay.dart';

/// A scanner to scan QR codes and barcodes.
///
/// Usually, instead of including [Scanner] into the app, the [scanQrCode]
/// method is used to open a full screen scanner.
class Scanner extends StatefulWidget {
  const Scanner({
    Key? key,
    this.onDetect,
    this.description,
    this.controller,
  }) : super(key: key);

  /// A callback that is called when a code is detected.
  final ValueChanged<String>? onDetect;

  /// A description that is displayed below the scan selection or on the left
  /// side of the scan selection.
  ///
  /// Can be used to display instructions to the user.
  final Widget? description;

  /// A controller that can be used to control the scanner.
  ///
  /// Is primarily used for testing to mock the scanner.
  final MobileScannerController? controller;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? MobileScannerController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: controller,
          fit: BoxFit.cover,
          onDetect: (barcode, args) {
            if (widget.onDetect != null && barcode.rawValue != null) {
              widget.onDetect!(barcode.rawValue!);
            }
          },
        ),
        ScanOverlay(
          description: widget.description,
          hasTorch: controller.hasTorch,
          onTorchToggled: () => controller.toggleTorch(),
        )
      ],
    );
  }
}
