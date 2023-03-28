// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

/// Der ID-Generator für Firestore-Dokumente, übernommen vom Cloud-Firestore
/// Client
class AutoIdGenerator {
  static const int idLength = 20;

  static const String alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  static final Random _random = Random();

  /// Automatically Generates a random new Id
  static String autoId() {
    final stringBuffer = StringBuffer();
    const maxRandom = alphabet.length;

    for (var i = 0; i < idLength; ++i) {
      stringBuffer.write(alphabet[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }
}
