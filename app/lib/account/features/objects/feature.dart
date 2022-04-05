// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

abstract class Feature {
  /// Der Name wird ebenfalls auch in der Speicherung der Daten benöigt.
  /// Im Namen darf kein Leerzeichen vorkommen, da dies in der Zukunuft
  /// zu Problemen bei der Speicherung in Firestore kommen könnte.
  final String name;

  Feature(this.name)
      : assert(name != null && name.isNotEmpty && !name.contains(" "));

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Feature && name == other.name);
  }

  @override
  int get hashCode => name.hashCode;
}
