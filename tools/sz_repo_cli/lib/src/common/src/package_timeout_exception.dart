// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package.dart';

/// [package] hat länger als [packageTimeout] gebraucht, um eine Aktion
/// (z.B. flutter test) auszuführen.
class PackageTimoutException implements Exception {
  final Duration packageTimeout;
  final Package package;

  PackageTimoutException(
    this.packageTimeout,
    this.package,
  );

  @override
  String toString() {
    return 'Das Package "${package.name}" [${package.type.toReadableString()}] hat den Package-Timeout von ${packageTimeout.inMinutes} Minuten überschritten.';
  }
}
