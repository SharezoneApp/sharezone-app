import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/src/overlay/scan_overlay.dart';

class Scanner extends StatefulWidget {
  const Scanner({
    Key? key,
    this.onDetect,
    this.description,
    this.controller,
  }) : super(key: key);

  final ValueChanged<String?>? onDetect;
  final Widget? description;
  final MobileScannerController? controller;

  @override
  State<Scanner> createState() => ScannerState();
}

@visibleForTesting
class ScannerState extends State<Scanner> {
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

/// Opens a full screen scanner to scan a QR code.
///
/// The content of the detected QR code will returned as a string. If the user
/// leaves the page without scanning a QR code, the returned value will be null.
///
/// The [title] will be display at the top.
///
/// The [description] will be displayed above the scanning area. A [description]
/// can an assistance for the user, like "Go to web.sharezone.net to get a QR
/// code".
Future<String?> scanQrCode(
  BuildContext context, {
  String title = 'Scan QR Code',
  Widget? description,
}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => _ScanQrCodePage(
        title: title,
        description: description,
      ),
    ),
  );
}

/// A page with the [Scanner] and the [title] at the top.
class _ScanQrCodePage extends StatelessWidget {
  const _ScanQrCodePage({
    Key? key,
    required this.title,
    this.description,
  }) : super(key: key);

  final String title;
  final Widget? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(title),
      ),
      body: Scanner(
        description: description,
        onDetect: (qrCode) {
          Navigator.pop(context, qrCode);
        },
      ),
    );
  }
}
