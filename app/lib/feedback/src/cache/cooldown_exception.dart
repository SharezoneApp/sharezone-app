// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

class CoolDownException implements Exception {
  final String? message;
  final Duration? coolDown;

  CoolDownException([this.message, this.coolDown]);

  @override
  String toString() {
    String report = "CooldownException";
    if (message != null && "" != message) {
      report = "$report: $message";
    }
    if (coolDown != null) {
      report += " Cooldown: $coolDown";
    }
    return report;
  }
}
