// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../remote_configuration.dart';

class StubRemoteConfiguration extends RemoteConfiguration {
  Map<String, dynamic> _defaultValues = {};

  @override
  String getString(String key) {
    return _defaultValues[key] ?? '';
  }

  @override
  bool getBool(String key) {
    return _defaultValues[key] ?? false;
  }

  @override
  void initialize(
    Map<String, dynamic> defaultValues,
  ) {
    _defaultValues = defaultValues;
  }

  @override
  Future<bool> activate() async {
    return true;
  }

  @override
  Future<void> fetch() async {}
}

RemoteConfiguration getRemoteConfiguration() {
  return StubRemoteConfiguration();
}
