// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/views/color.dart';

class Subject {
  final String name;
  final Color? color;
  final String abbreviation;

  Subject(this.name, {this.color, required this.abbreviation}) {
    if (name.isEmpty) {
      throw ArgumentError.value(
          name, 'name', "The subject name can't be empty");
    }
  }

  @override
  int get hashCode => name.hashCode;

  bool get isValid => name.isNotEmpty;

  @override
  bool operator ==(other) {
    return identical(this, other) ||
        other is Subject && name == other.name && color == other.color;
  }

  @override
  String toString() {
    return 'Subject(name: $name, color: $color)';
  }
}
