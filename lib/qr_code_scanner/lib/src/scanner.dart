// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/src/overlay/scan_overlay.dart';

/// A scanner to scan QR codes and barcodes.
///
/// Usually, instead of including [Scanner] into the app, the
/// [scanQrCodeScanner] method is used to open a full screen scanner.
class Scanner extends StatefulWidget {
  const Scanner({
    super.key,
    this.onDetect,
    this.description,
    this.mockController,
  });

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
  final MobileScannerController? mockController;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late MobileScannerController controller;
  late StreamSubscription<BarcodeCapture> barcodeSubscription;

  @override
  void initState() {
    super.initState();
    controller = widget.mockController ?? MobileScannerController();
    listenToDetections();
  }

  void listenToDetections() {
    barcodeSubscription = controller.barcodes.listen((capture) {
      final firstBarcode = capture.barcodes.firstOrNull;
      if (firstBarcode == null) {
        return;
      }

      if (widget.onDetect != null && firstBarcode.rawValue != null) {
        widget.onDetect!(firstBarcode.rawValue!);
      }
    });
  }

  @override
  void dispose() {
    barcodeSubscription.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      fit: BoxFit.cover,
      errorBuilder: (context, exception, child) {
        return _Error(exception: exception);
      },
      // The overlay (including controls like torch and text) that is
      // displayed above the camera view of the scanner.
      overlayBuilder: (context, constraints) {
        final hasTorch = controller.value.torchState != TorchState.unavailable;
        return ScanOverlay(
          description: widget.description,
          hasTorch: hasTorch,
          onTorchToggled: () => controller.toggleTorch(),
        );
      },
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    required this.exception,
  });

  final MobileScannerException exception;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ColoredBox(
          color: Colors.black,
          child: Center(child: Icon(Icons.error, color: Colors.white)),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: Text(
            'QR-Code-Scanner konnte nicht gestartet werden: ${exception.errorDetails?.message} (${exception.errorDetails?.message}, ${exception.errorCode})',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
