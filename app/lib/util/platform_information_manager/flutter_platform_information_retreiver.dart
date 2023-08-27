// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:package_info_plus/package_info_plus.dart';
import 'package:sharezone/util/platform_information_manager/platform_information_retreiver.dart';

class FlutterPlatformInformationRetriever extends PlatformInformationRetriever {
  late PackageInfo _packageInfo;

  @override
  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  String get appName {
    return _packageInfo.appName;
  }

  @override
  String get packageName {
    return _packageInfo.packageName;
  }

  @override
  String get version {
    return _packageInfo.version;
  }

  @override
  String get versionNumber {
    return _packageInfo.buildNumber;
  }
}
