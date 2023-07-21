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

  /// Initializes the remote configuration with the given default values and
  /// fetches the remote configuration in the background.
  ///
  /// The default values are used if the remote configuration could not be
  /// fetched.
  ///
  /// This method follows the "Load new values for next startup" strategy:
  /// https://firebase.google.com/docs/remote-config/loading.
  @override
  Future<void> initializeAndFetchInBackground(
    Map<String, dynamic> defaultValues,
  ) async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      _remoteConfig.setDefaults(defaultValues);
      _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 3),
        ),
      );
      // Activate the fetched remote config from the last fetch.
      await _remoteConfig.activate();

      // Fetch remote config in the background. They will be available on the
      // next app start.
      unawaited(_remoteConfig.fetch());
    } catch (e) {
      log("Error fetch remote config: $e");
    }
  }
}

RemoteConfiguration getRemoteConfiguration() {
  return FirebaseRemoteConfiguration();
}
