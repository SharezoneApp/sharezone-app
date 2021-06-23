import 'android_information.dart';
import 'ios_information.dart';

abstract class DeviceInformationRetreiver {
  Future<AndroidDeviceInformation> get androidInfo;
  Future<IosDeviceInformation> get iosInfo;
}
