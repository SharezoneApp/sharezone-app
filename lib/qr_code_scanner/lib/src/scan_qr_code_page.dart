// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
///
/// For testing purposes, you can pass a [controller] to mock the scanner.
Future<String?> showQrCodeScanner(
  BuildContext context, {
  Widget? title = const Text('Scan QR Code'),
  Widget? description,
  RouteSettings? settings,
  MobileScannerController? controller,
}) {
  return Navigator.push<String?>(
    context,
    MaterialPageRoute(
      builder: (context) => _ScanQrCodePage(
        title: title,
        description: description,
        controller: controller,
      ),
      settings: settings,
    ),
  );
}

/// A page with the [Scanner] and the [title] at the top.
class _ScanQrCodePage extends StatelessWidget {
  const _ScanQrCodePage({
    Key? key,
    required this.title,
    this.description,
    this.controller,
  }) : super(key: key);

  /// The title that is displayed at the top in the [AppBar]
  final Widget? title;

  /// A description that is displayed above the scan area or on the left side of
  /// the scan area.
  final Widget? description;

  /// A controller that can be used to control the scanner.
  ///
  /// Is primarily used for testing to mock the scanner.
  final MobileScannerController? controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Builder(builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // systemOverlayStyle: SystemUiOverlayStyle.dark,
              titleTextStyle: AppBarTheme.of(context).titleTextStyle?.copyWith(
                    color: Colors.white,
                  ),
              iconTheme: IconTheme.of(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(title: title),
            body: Scanner(
              controller: controller,
              description: description,
              onDetect: (qrCode) => Navigator.pop(context, qrCode),
            ),
          ),
        );
      }),
    );
  }
}
