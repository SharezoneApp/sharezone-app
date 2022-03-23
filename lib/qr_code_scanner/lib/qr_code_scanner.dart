import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> scanQrCode(BuildContext context) {
  return Navigator.push<String?>(
    context,
    MaterialPageRoute(builder: (_) => const _ScanQrCodePage()),
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
      body: MobileScanner(
        onDetect: (barcode, args) {
          Navigator.pop(context, barcode.rawValue);
        },
      ),
    );
  }
}
