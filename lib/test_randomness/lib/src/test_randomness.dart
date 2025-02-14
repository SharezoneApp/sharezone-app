// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';

import 'package:random_string/random_string.dart' as lib;

/// The seed to use for randomness.
///
/// This is used to ensure that tests are deterministic.
/// The `TEST_RANDOMNESS_SEED` environment variable will be provided when
/// running `sz test`.
const randomnessSeed = int.fromEnvironment(
  'TEST_RANDOMNESS_SEED',
  defaultValue: 0,
);

/// The [Random] that should be used for randomness in tests.
///
/// This is a [Random] that is seeded with [randomnessSeed].
/// This is used to ensure that tests are deterministic.
final szTestRandom = Random(randomnessSeed);

final _randomProvider = lib.CoreRandomProvider.from(szTestRandom);

/// Generates a random integer where [from] <= [to] inclusive
/// where 0 <= from <= to <= 999999999999999
int randomBetween(int from, int to) =>
    lib.randomBetween(from, to, provider: _randomProvider);

/// Generates a random string of [length] with characters
/// between ascii [from] to [to].
/// Defaults to characters of ascii '!' to '~'.
String randomString(
  int length, {
  int from = lib.asciiStart,
  int to = lib.asciiEnd,
}) => lib.randomString(length, from: from, to: to, provider: _randomProvider);

/// Generates a random string of [length] with only numeric characters.
String randomNumeric(int length) =>
    lib.randomNumeric(length, provider: _randomProvider);

/// Generates a random string of [length] with only alpha characters.
String randomAlpha(int length) =>
    lib.randomAlpha(length, provider: _randomProvider);

/// Generates a random string of [length] with alpha-numeric characters.
String randomAlphaNumeric(int length) =>
    lib.randomAlphaNumeric(length, provider: _randomProvider);

/// Merge [a] with [b] and shuffle.
String randomMerge(String a, String b) => lib.randomMerge(a, b);
