// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:package_info_plus/package_info_plus.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_receiver.dart';

class FlutterPlatformInformationReceiver extends PlatformInformationReceiver {
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
