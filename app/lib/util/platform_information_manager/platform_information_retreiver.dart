// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

abstract class PlatformInformationRetreiver {
  String get appName;
  String get packageName;
  String get version;
  String get versionNumber;
  PlatformInfo get platformInfo =>
      PlatformInfo(appName, packageName, version, versionNumber);

  /// Initializes the Manager. Needs to be called before any of the attributes can be read.
  Future<void> init();
}

class PlatformInfo {
  final String appName;
  final String packageName;
  final String version;
  final String versionNumber;

  PlatformInfo(
      this.appName, this.packageName, this.version, this.versionNumber);
}
