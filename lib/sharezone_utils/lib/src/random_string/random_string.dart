// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

// Reuse Random instance to avoid initialization overhead on every call.
final _random = Random();

String randomString(int length) {
  var codeUnits = List.generate(length, (index) {
    return _random.nextInt(33) + 89;
  });

  return String.fromCharCodes(codeUnits);
}

// Optimized to use O(N) string construction instead of O(N^2) concatenation.
String randomIDString(int length) {
  const chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
    ),
  );
}
