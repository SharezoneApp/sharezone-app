// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

class CooldownException implements Exception {
  final String message;
  final Duration cooldown;

  CooldownException([this.message, this.cooldown]);

  @override
  String toString() {
    String report = "CooldownException";
    if (message != null && "" != message) {
      report = "$report: $message";
    }
    if (cooldown != null) {
      report += " Cooldown: $cooldown";
    }
    return report;
  }
}