import 'package:sharezone/util/platform_information_manager/platform_information_retreiver.dart';

class MockPlatformInformationRetreiver extends PlatformInformationRetreiver {
  @override
  String appName = "";

  @override
  String packageName = "";

  @override
  String version = "";

  @override
  String versionNumber = "";

  @override
  Future<void> init() {
    return null;
  }
}