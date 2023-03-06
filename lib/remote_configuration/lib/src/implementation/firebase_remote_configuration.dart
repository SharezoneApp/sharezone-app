// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:remote_configuration/src/implementation/stub_remote_configuration.dart';
import 'package:sharezone_utils/platform.dart';
import '../remote_configuration.dart';

class FirebaseRemoteConfiguration extends RemoteConfiguration {
  FirebaseRemoteConfiguration();

  FirebaseRemoteConfig? _remoteConfig;
  Map<String, dynamic>? _defaultValues;

  @override
  String getString(String key) {
    if (_remoteConfig == null) {
      throw RemoteConfigurationNotInitializedException();
    }
    return _remoteConfig!.getString(key);
  }

  @override
  bool getBool(String key) {
    if (_remoteConfig == null) {
      throw RemoteConfigurationNotInitializedException();
    }
    return _remoteConfig!.getBool(key);
  }

  @override
  Future<void> initialize(Map<String, dynamic> defaultValues) async {
    try {
      _defaultValues = defaultValues;
      _remoteConfig = FirebaseRemoteConfig.instance;
      _remoteConfig!.setDefaults(_defaultValues!);
      _remoteConfig!.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 3)));
      await _remoteConfig!.fetchAndActivate();
    } catch (e) {
      print("Error fetch remote config: $e");
    }
  }
}

RemoteConfiguration getRemoteConfiguration() {
  if (PlatformCheck.isMacOS) return StubRemoteConfiguration();
  return FirebaseRemoteConfiguration();
}
