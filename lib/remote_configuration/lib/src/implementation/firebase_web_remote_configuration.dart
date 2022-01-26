// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:firebase/firebase.dart' as firebase;
import '../remote_configuration.dart';

class FirebaseWebRemoteConfiguration extends RemoteConfiguration {
  firebase.RemoteConfig _remoteConfig;
  Map<String, dynamic> _defaultValues;
  FirebaseWebRemoteConfiguration();

  @override
  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  @override
  bool getBool(String key) {
    return _remoteConfig.getBoolean(key);
  }

  @override
  Future<void> initialize(Map<String, dynamic> defaultValues) async {
    try {
      _defaultValues = defaultValues;
      _remoteConfig = firebase.remoteConfig();
      _remoteConfig.defaultConfig = _defaultValues;
      await _remoteConfig.fetch();
      await _remoteConfig.ensureInitialized();
    } catch (e) {
      print("Error fetch remote confing: $e");
    }
  }
}

RemoteConfiguration getRemoteConfiguration() {
  return FirebaseWebRemoteConfiguration();
}
