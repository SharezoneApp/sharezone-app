// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package.dart';

/// Exception thrown when [package] executed longer than [packageTimeout] for an
/// action like running "flutter test".
class PackageTimeoutException implements Exception {
  final Duration packageTimeout;
  final Package package;

  PackageTimeoutException(
    this.packageTimeout,
    this.package,
  );

  @override
  String toString() {
    return 'The Package "${package.name}" [${package.type.toReadableString()}] has passed timeout of ${packageTimeout.inMinutes} minutes.';
  }
}
