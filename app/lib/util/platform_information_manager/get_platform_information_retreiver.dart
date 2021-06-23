import 'flutter_platform_information_retreiver.dart';
import 'platform_information_retreiver.dart';

PlatformInformationRetreiver getPlatformInformationRetreiver() {
  return FlutterPlatformInformationRetreiver();
}

Future<PlatformInformationRetreiver>
    getPlatformInformationRetreiverWithInit() async {
  final retriever = FlutterPlatformInformationRetreiver();
  await retriever.init();
  return retriever;
}
