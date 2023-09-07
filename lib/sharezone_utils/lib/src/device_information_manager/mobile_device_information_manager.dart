// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:device_info_plus/device_info_plus.dart'
    hide AndroidBuildVersion, IosUtsname;
import 'package:flutter/cupertino.dart';

import 'android_information.dart';
import 'device_information_retreiver.dart';
import 'ios_information.dart';

class MobileDeviceInformationRetriever extends DeviceInformationRetriever {
  final _deviceInfoPlugin = DeviceInfoPlugin();

  @override
  Future<AndroidDeviceInformation> get androidInfo async {
    final android = await _deviceInfoPlugin.androidInfo;
    return AndroidDeviceInformation(
      board: android.board,
      bootloader: android.bootloader,
      brand: android.board,
      device: android.device,
      display: android.display,
      fingerprint: android.fingerprint,
      hardware: android.hardware,
      host: android.host,
      id: android.id,
      isPhysicalDevice: android.isPhysicalDevice,
      manufacturer: android.manufacturer,
      model: android.model,
      product: android.product,
      supported32BitAbis: android.supported32BitAbis,
      supported64BitAbis: android.supported64BitAbis,
      supportedAbis: android.supportedAbis,
      tags: android.tags,
      type: android.type,
      version: AndroidBuildVersion(
        baseOS: android.version.baseOS,
        codename: android.version.codename,
        incremental: android.version.incremental,
        previewSdkInt: android.version.previewSdkInt,
        release: android.version.release,
        sdkInt: android.version.sdkInt,
        securityPatch: android.version.securityPatch,
      ),
    );
  }

  /// Returns Android SDK level, e. g. 21
  ///
  /// Android SDK - Version - Codename\
  /// 01 - v1.0 - (no codename)\
  /// 02 - v1.1 - (no codename)\
  /// 03 - v1.5 - Cupcake\
  /// 04 - v1.6 - Donut\
  /// 05 - v2.0 - Eclair\
  /// 06 - v2.0.1 - Eclair\
  /// 07 - v2.1 - Eclair\
  /// 08 - v2.2.x - Froyo\
  /// 09 - v2.3, v2.3.2 - Gingerbread\
  /// 10 - v2.3.3, v2.3.7 - Gingerbread\
  /// 11 - v3.0 - Honeycomb\
  /// 12 - v3.1 - Honeycomb\
  /// 13 - v3.2.x - Honeycomb\
  /// 14 - v4.0.1, 4.0.2 - Ice Cream Sandwich\
  /// 15 - v4.0.3, 4.0.4 - Ice Cream Sandwich\
  /// 16 - v4.1.x - Jelly Bean\
  /// 17 - v4.2.x - Jelly Bean\
  /// 18 - v4.3.x - Jelly Bean\
  /// 19 - v4.4, 4.4.4 - Kit Kat\
  /// 21 - v5.0 - Lollipop\
  /// 22 - v5.1 - Lollipop\
  /// 23 - v6.0 - Marshmallow\
  /// 24 - v7.0 - Nougat\
  /// 25 - v7.1 - Nougat\
  /// 26 - v8.0.0 - Oreo\
  /// 27 - v8.0.1 - Oreo\
  /// 28 - v9 - Pie\
  /// 29 - v10 - Android10\
  /// 30 - v11 - Android11\
  ///
  /// Source: https://source.android.com/setup/start/build-numbers
  Future<int?> androidSdkInt() async {
    final info = await androidInfo;
    return info.version.sdkInt;
  }

  @override
  Future<IosDeviceInformation> get iosInfo async {
    final ios = await _deviceInfoPlugin.iosInfo;
    return IosDeviceInformation(
      name: ios.name,
      systemName: ios.systemName,
      systemVersion: ios.systemVersion,
      model: ios.model,
      localizedModel: ios.localizedModel,
      identifierForVendor: ios.identifierForVendor,
      isPhysicalDevice: ios.isPhysicalDevice,
      utsname: IosUtsname(
        sysname: ios.utsname.sysname,
        nodename: ios.utsname.nodename,
        release: ios.utsname.release,
        version: ios.utsname.version,
        machine: ios.utsname.machine,
      ),
    );
  }
}

@visibleForTesting
class MockMobileDeviceInformationRetriever
    implements MobileDeviceInformationRetriever {
  int? _androidSdkInt;

  @override
  Future<AndroidDeviceInformation> get androidInfo =>
      throw UnimplementedError();

  @override
  Future<int?> androidSdkInt() async {
    return _androidSdkInt;
  }

  // ignore: use_setters_to_change_properties
  void setAndroidSdkInt(int sdkInt) {
    _androidSdkInt = sdkInt;
  }

  @override
  Future<IosDeviceInformation> get iosInfo => throw UnimplementedError();

  @override
  DeviceInfoPlugin get _deviceInfoPlugin => throw UnimplementedError();
}
