import 'package:flutter/material.dart';
import 'package:qr_code_scanner/src/scanner.dart';

Future<String?> scanQrCode(BuildContext context) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const _ScanQrCodePage()),
  );
}

class _ScanQrCodePage extends StatelessWidget {
  const _ScanQrCodePage({
    Key? key,
    this.title = 'Scan QR Code',
  }) : super(key: key);

  final String title;

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
        onDetect: (qrCode) {
          Navigator.pop(context, qrCode);
        },
      ),
    );
  }
}
