// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

// Optimized: Reuse Random instance to avoid initialization overhead.
final _random = Random();

String randomString(int length) {
  // Optimized: Use List.generate to avoid O(N^2) string concatenation.
  var codeUnits = List.generate(length, (index) {
    return _random.nextInt(33) + 89;
  });

  return String.fromCharCodes(codeUnits);
}

String randomIDString(int length) {
  const chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  // Optimized: Use String.fromCharCodes with List.generate to avoid O(N^2) string concatenation.
  // Accessing code units directly is more efficient than creating intermediate 1-char strings.
  return String.fromCharCodes(
    List.generate(length, (_) {
      return chars.codeUnitAt(_random.nextInt(chars.length));
    }),
  );
}
