// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

extension StringToDateTimeExtension on String {
  /// Ruft DateTime.parse für diesen String auf.
  DateTime toDateTime() => this != null ? DateTime.parse(this) : null;
}
