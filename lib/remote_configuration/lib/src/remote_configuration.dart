abstract class RemoteConfiguration {
  Future<void> initialize(Map<String, dynamic> defaultValues);
  String getString(String key);
  bool getBool(String key);
}
