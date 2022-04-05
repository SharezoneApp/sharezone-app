// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

abstract class RemoteConfiguration {
  Future<void> initialize(Map<String, dynamic> defaultValues);
  String getString(String key);
  bool getBool(String key);
}
