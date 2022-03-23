import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/src/overlay/scan_overlay.dart';

class Scanner extends StatelessWidget {
  const Scanner({
    Key? key,
    this.onDetect,
  }) : super(key: key);

  final ValueChanged<String?>? onDetect;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          onDetect: (barcode, args) {
            if (onDetect != null) {
              onDetect!(barcode.rawValue);
            }
          },
        ),
        const ScanOverlay()
      ],
    );
  }
}
