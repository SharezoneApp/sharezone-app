// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:math';
import 'package:meta/meta.dart';

class KiloByteSize implements Comparable<KiloByteSize> {
  static const _bytesInKilobyte = 1000;
  static const _bytesInMegabyte = 1000 * _bytesInKilobyte;
  static const _bytesInGigabyte = 1000 * _bytesInMegabyte;
  static const _bytesInTerabyte = 1000 * _bytesInGigabyte;
  static const _bytesInPetabytes = 1000 * _bytesInTerabyte;

  /// Creates a new size object whose value is the sum of all individual parts.
  ///
  /// * All individual parts are allowed to be negative.
  /// * All arguments are `0` by default.
  ///
  /// It is illegal (but not checked) to pass `null` for any value.
  @literal
  const KiloByteSize({
    int bytes = 0,
    int kilobytes = 0,
    int megabytes = 0,
    int gigabytes = 0,
    int terabytes = 0,
    int petabytes = 0,
  }) : inBytes = bytes +
            kilobytes * _bytesInKilobyte +
            megabytes * _bytesInMegabyte +
            gigabytes * _bytesInGigabyte +
            terabytes * _bytesInTerabyte +
            petabytes * _bytesInPetabytes;

  const KiloByteSize._bytes(this.inBytes);

  @override
  int compareTo(KiloByteSize other) => inBytes.compareTo(other.inBytes);

  @override
  bool operator ==(Object other) =>
      other is KiloByteSize && other.inBytes == inBytes;

  @override
  int get hashCode => inBytes;

  /// Adds the size and the [other] and returns the sum.
  KiloByteSize operator +(KiloByteSize other) =>
      KiloByteSize._bytes(inBytes + other.inBytes);

  /// Subtracts the size by the [other] and returns the difference.
  KiloByteSize operator -(KiloByteSize other) =>
      KiloByteSize._bytes(inBytes - other.inBytes);

  /// Multiples the size by the [other] and returns the result.
  KiloByteSize operator *(KiloByteSize other) =>
      KiloByteSize._bytes(inBytes * other.inBytes);

  /// Divides the size by the [other] and returns the (truncated) result.
  ///
  /// Throws [IntegerDivisionByZeroException] if other is exactly 0 bytes.
  KiloByteSize operator ~/(KiloByteSize other) {
    if (other.inBytes == 0) {
      throw IntegerDivisionByZeroException();
    }
    return KiloByteSize._bytes(inBytes ~/ other.inBytes);
  }

  /// Returns `true` if the this size is less than the [other].
  bool operator <(KiloByteSize other) => inBytes < other.inBytes;

  /// Returns `true` if the this size is greater than the [other].
  bool operator >(KiloByteSize other) => inBytes > other.inBytes;

  /// Returns `true` if the this size is less than or equal to [other].
  bool operator <=(KiloByteSize other) => inBytes <= other.inBytes;

  /// Returns `true` if the this size is greater than or equal to [other].
  bool operator >=(KiloByteSize other) => inBytes >= other.inBytes;

  /// Returns a new size object representing this size negated.
  KiloByteSize operator -() => KiloByteSize._bytes(0 - inBytes);

  /// Number of whole bytes represented.
  final int inBytes;

  /// Number of kilobytes represented.
  num get inKilobytes => inBytes / _bytesInKilobyte;

  /// Number of megabytes represented.
  num get inMegabytes => inBytes / _bytesInMegabyte;

  /// Number of gigabytes represented.
  num get inGigabytes => inBytes / _bytesInGigabyte;

  /// Number of terabytes represented.
  num get inTerabytes => inBytes / _bytesInTerabyte;

  /// Number of petabytes represented.
  num get inPetabytes => inBytes / _bytesInPetabytes;

  // MAYBE ERROR HERE----
  static num _log10(num x) => log(x);

  @override
  String toString() {
    const units = ['B', 'kB', 'MB', 'GB', 'TB', 'PB'];
    final bytes = inBytes.abs();
    if (!inBytes.isFinite) {
      return '∞';
    }
    if (inBytes == 0) {
      return '0 B';
    }
    final exponent = min((_log10(bytes) / 3).floor(), units.length - 1);
    final numStr = (bytes / pow(1000, exponent)).toStringAsPrecision(3);
    final unit = units[exponent];
    return '${bytes.isNegative ? '-' : ''}$numStr $unit might be false';
  }
}
