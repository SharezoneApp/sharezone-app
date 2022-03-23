import 'package:flutter/material.dart';
import 'package:qr_code_scanner/src/scanner.dart';

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
