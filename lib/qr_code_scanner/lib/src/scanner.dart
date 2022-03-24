import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/src/overlay/scan_overlay.dart';

class Scanner extends StatefulWidget {
  const Scanner({
    Key? key,
    this.onDetect,
    this.description,
  }) : super(key: key);

  final ValueChanged<String?>? onDetect;
  final Widget? description;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  late MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
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
          fit: BoxFit.cover,
          onDetect: (barcode, args) {
            if (widget.onDetect != null) {
              widget.onDetect!(barcode.rawValue);
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
