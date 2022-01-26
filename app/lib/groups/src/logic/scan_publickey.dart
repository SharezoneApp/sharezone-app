// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

Future<String> scanPublicKey() async {
  try {
    final scanResult = await BarcodeScanner.scan();
    return scanResult;
  } on PlatformException catch (e) {
    return Future.error('Unbekannter Fehler: $e');
  } on FormatException {
    return Future.error(
        'QR-Code funktioniert nicht? Dann gib bitte den Public-Key per Hand ein.');
  } catch (e) {
    return Future.error('Unbekannter Fehler: $e');
  }
}
