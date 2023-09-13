// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:retry/retry.dart';

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

  /// Initializes the remote configuration with the given default values.
  ///
  /// The default values are used if the remote configuration could not be
  /// fetched.
  @override
  void initialize(Map<String, dynamic> defaultValues) {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      _remoteConfig.setDefaults(defaultValues);
      _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 3),
        ),
      );
    } catch (e) {
      log("Error fetch remote config: $e");
    }
  }

  /// Makes the last fetched config available to getters.
  ///
  /// Returns a [bool] that is `true` if the config parameters were activated.
  /// Otherwise returns `false` if the config parameters were already
  /// activated.
  @override
  Future<bool> activate() async {
    return _remoteConfig.activate();
  }

  /// Fetches and caches configuration from the Remote Config service.
  @override
  Future<void> fetch() async {
    await retry(
      () => _remoteConfig.fetch(),
      maxAttempts: 3,
    );
  }
}

RemoteConfiguration getRemoteConfiguration() {
  return FirebaseRemoteConfiguration();
}
