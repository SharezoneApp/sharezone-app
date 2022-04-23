// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class Sharecode {
  final String key;

  Sharecode(this.key) {
    ArgumentError.checkNotNull(key, 'sharecode');
  }

  factory Sharecode.tryCreateOrNull(final String key) {
    try {
      return Sharecode(key);
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || other is Sharecode && other.key == key;
  }

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() {
    return key;
  }
}
