// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/src/shared/color.dart';

class Subject extends Equatable {
  final String name;
  final Color? color;
  final String abbreviation;

  @override
  List<Object?> get props => [name, color, abbreviation];

  Subject(this.name, {this.color, required this.abbreviation}) {
    if (name.isEmpty) {
      throw ArgumentError.value(
        name,
        'name',
        "The subject name can't be empty",
      );
    }
  }
}
