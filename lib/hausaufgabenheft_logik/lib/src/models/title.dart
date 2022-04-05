// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class Title implements Comparable<Title> {
  final String value;

  const Title(this.value);

  @override
  bool operator ==(other) {
    return identical(this, other) || other is Title && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  int compareTo(Title other) {
    return value.compareTo(other.value);
  }

  @override
  String toString() {
    return 'Title(value: $value)';
  }
}
