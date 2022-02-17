// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:sharezone/util/platform_information_manager/platform_information_receiver.dart';

class MockPlatformInformationRetreiver extends PlatformInformationReceiver {
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
