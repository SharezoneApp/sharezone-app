import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:remote_configuration/src/implementation/stub_remote_configuration.dart';
import 'package:sharezone_utils/platform.dart';
import '../remote_configuration.dart';

class FirebaseRemoteConfiguration extends RemoteConfiguration {
  RemoteConfig _remoteConfig;
  Map<String, dynamic> _defaultValues;
  FirebaseRemoteConfiguration();

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
      _defaultValues = defaultValues;
      _remoteConfig = await RemoteConfig.instance;
      _remoteConfig.setDefaults(_defaultValues);
      await _remoteConfig.fetch(expiration: const Duration(hours: 3));
      await _remoteConfig.activateFetched();
    } catch (e) {
      print("Error fetch remote confing: $e");
    }
  }
}

RemoteConfiguration getRemoteConfiguration() {
  if (PlatformCheck.isMacOS) return StubRemoteConfiguration();
  return FirebaseRemoteConfiguration();
}
