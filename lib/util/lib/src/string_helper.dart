// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

bool isNotEmptyOrNull(String value) => !isEmptyOrNull(value);

bool isEmptyOrNull(String value) {
  return value == null || value.isEmpty;
}

void throwIfNullOrEmpty(String string, [String name]) {
  ArgumentError.checkNotNull(string, name);
  if (string.isEmpty) {
    throw ArgumentError.value(string, name ?? 'string', "can't be empty");
  }
}
