import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/src/overlay/scan_overlay.dart';

class Scanner extends StatelessWidget {
  const Scanner({
    Key? key,
    this.onDetect,
    this.description,
  }) : super(key: key);

  final ValueChanged<String?>? onDetect;
  final Widget? description;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          fit: BoxFit.cover,
          onDetect: (barcode, args) {
            if (onDetect != null) {
              onDetect!(barcode.rawValue);
            }
          },
        ),
        ScanOverlay(
          description: description,
        )
      ],
    );
  }
}
