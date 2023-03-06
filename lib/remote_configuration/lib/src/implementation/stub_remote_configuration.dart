// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import '../remote_configuration.dart';

class StubRemoteConfiguration extends RemoteConfiguration {
  Map<String, dynamic>? _defaultValues;

  String getString(String key) {
    if (_defaultValues == null) {
      throw RemoteConfigurationNotInitializedException();
    }
    return _defaultValues![key];
  }

  @override
  bool getBool(String key) {
    if (_defaultValues == null) {
      throw RemoteConfigurationNotInitializedException();
    }
    return _defaultValues![key];
  }

  @override
  Future<void> initialize(Map<String, dynamic> defaultValues) async {
    _defaultValues = defaultValues;
  }
}

RemoteConfiguration getRemoteConfiguration() {
  return StubRemoteConfiguration();
}
