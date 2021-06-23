abstract class PlatformInformationRetreiver {
  String get appName;
  String get packageName;
  String get version;
  String get versionNumber;
  PlatformInfo get platformInfo => PlatformInfo(appName, packageName, version, versionNumber);

  /// Initializes the Manager. Needs to be called before any of the attributes can be read.
  Future<void> init();
}

class PlatformInfo {
  final String appName;
  final String packageName;
  final String version;
  final String versionNumber;

  PlatformInfo(this.appName, this.packageName, this.version, this.versionNumber);
}