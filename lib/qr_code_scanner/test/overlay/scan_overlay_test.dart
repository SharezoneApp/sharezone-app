// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:qr_code_scanner/src/overlay/scan_overlay.dart';

void main() {
  group('ScanOverlay', () {
    testGoldens('display overlay as expected', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.orange,
            body: ScanOverlay(
              // Even with the use of 'golden_toolkit' is the font for this
              // widget not loaded. Therefore, will Flutter use the default font
              // "Ahem".
              description: Text(
                'Go to web.sharezone.net to get a QR Code',
              ),
              hasTorch: true,
            ),
          ),
        ),
      );

      await multiScreenGolden(
        tester,
        'scan_overlay',
      );
    });
  });
}
