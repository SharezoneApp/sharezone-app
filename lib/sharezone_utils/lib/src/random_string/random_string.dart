// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

// Shared instance for fast, non-secure random strings
final _rand = Random();

// Shared instance for secure random strings (IDs, tokens)
final _secureRand = Random.secure();

const _chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
final _charCodes = _chars.codeUnits;

/// Generates a fast random string using a non-secure PRNG.
/// Uses O(N) allocation via `List.filled` instead of O(N^2) string concatenation.
String randomString(int length) {
  final codeUnits = List<int>.filled(length, 0);
  for (var i = 0; i < length; i++) {
    codeUnits[i] = _rand.nextInt(33) + 89;
  }
  return String.fromCharCodes(codeUnits);
}

/// Generates a secure random ID string.
/// Uses O(N) allocation via `List.filled` instead of O(N^2) string concatenation.
String randomIDString(int length) {
  final result = List<int>.filled(length, 0);
  for (var i = 0; i < length; i++) {
    result[i] = _charCodes[_secureRand.nextInt(_charCodes.length)];
  }
  return String.fromCharCodes(result);
}
