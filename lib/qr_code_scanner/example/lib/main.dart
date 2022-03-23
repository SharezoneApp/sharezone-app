import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(const _ExampleApp());
}

class _ExampleApp extends StatelessWidget {
  const _ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'QR code Example',
      home: _Home(),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({Key? key}) : super(key: key);

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  String? receivedQrCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final qrCode = await scanQrCode(context);

                  setState(() {
                    receivedQrCode = qrCode;
                  });
                },
                child: const Text('Scan QR code'),
              ),
              if (receivedQrCode != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text("Received QR code: $receivedQrCode"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
