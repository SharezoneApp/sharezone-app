// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

bool isNotEmptyOrNull(String? value) => !isEmptyOrNull(value);

bool isEmptyOrNull(String? value) {
  return value == null || value.isEmpty;
}

extension EnumByNameWithDefault<T extends Enum> on Iterable<T> {
  T tryByName(String? name, {T? defaultValue}) {
    for (T value in this) {
      if (value.name == name) return value;
    }

    if (defaultValue != null) return defaultValue;
    throw ArgumentError.value(name, "name", "No enum value with that name");
  }

  T? byNameOrNull(String? name) {
    for (T value in this) {
      if (value.name == name) return value;
    }

    return null;
  }
}
