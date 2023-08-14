// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone_common/api_errors.dart';

class Sharecode {
  final String value;

  Sharecode(this.value) : assert(isValid(value)) {
    if (!isValid(value)) {
      throw IncorrectSharecode();
    }
  }

  /// Checks if [sharecode] has the attributes of a sharecode:
  /// only small and big letters from alphabet and a length of 6.
  static bool isValid(String sharecode) {
    if (sharecode == null) return false;
    final sharecodeRegEx = RegExp(r"^[a-zA-Z0-9]{6}$");
    return sharecodeRegEx.hasMatch(sharecode);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Sharecode && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
