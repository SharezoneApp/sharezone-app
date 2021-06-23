import '../remote_configuration.dart';

class StubRemoteConfiguration extends RemoteConfiguration {
  Map<String, dynamic> _defaultValues;

  String getString(String key) {
    return _defaultValues[key];
  }

  @override
  bool getBool(String key) {
    return _defaultValues[key];
  }

  @override
  Future<void> initialize(Map<String, dynamic> defaultValues) async {
    _defaultValues = defaultValues;
  }
}

RemoteConfiguration getRemoteConfiguration() {
  return StubRemoteConfiguration();
}
