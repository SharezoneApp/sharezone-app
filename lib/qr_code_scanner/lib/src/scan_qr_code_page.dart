import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  Widget? title = const Text('Scan QR Code'),
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

  /// The title that is displayed at the top in the [AppBar]
  final Widget? title;

  /// A description that is displayed above the scan area or on the left side of
  /// the scan area.
  final Widget? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: title,
      ),
      body: Scanner(
        description: description,
        onDetect: (qrCode) => Navigator.pop(context, qrCode),
      ),
    );
  }
}
