// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../remote_configuration.dart';

class FirebaseRemoteConfiguration extends RemoteConfiguration {
  FirebaseRemoteConfiguration() {
    _remoteConfig = FirebaseRemoteConfig.instance;
  }

  late FirebaseRemoteConfig _remoteConfig;

  @override
  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  @override
  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  @override
  Future<void> initialize(Map<String, dynamic> defaultValues) async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      _remoteConfig.setDefaults(defaultValues);
      _remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 3)));
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      log("Error fetch remote config: $e");
    }
  }
}

RemoteConfiguration getRemoteConfiguration() {
  return FirebaseRemoteConfiguration();
}
