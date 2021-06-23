import 'package:package_info_plus/package_info_plus.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_retreiver.dart';

class FlutterPlatformInformationRetreiver extends PlatformInformationRetreiver {
  PackageInfo _packageInfo;

  @override
  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  String get appName {
    assertPackageInfoIsNotNull();
    return _packageInfo.appName;
  }

  @override
  String get packageName {
    assertPackageInfoIsNotNull();
    return _packageInfo.packageName;
  }

  @override
  String get version {
    assertPackageInfoIsNotNull();
    return _packageInfo.version;
  }

  @override
  String get versionNumber {
    assertPackageInfoIsNotNull();
    return _packageInfo.buildNumber;
  }

  void assertPackageInfoIsNotNull() {
    assert(_packageInfo != null,
        "PackageInfo should not be null. init() needs to be called before attributes can be read");
  }
}
