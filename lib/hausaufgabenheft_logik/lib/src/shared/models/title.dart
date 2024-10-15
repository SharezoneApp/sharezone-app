// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';

class Title extends Equatable implements Comparable<Title> {
  final String value;

  @override
  List<Object> get props => [value];

  const Title(this.value);

  @override
  int compareTo(Title other) {
    return value.compareTo(other.value);
  }
}
