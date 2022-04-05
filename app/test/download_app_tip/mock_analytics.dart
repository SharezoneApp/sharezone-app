// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/src/foundation/platform.dart';
import 'package:sharezone/download_app_tip/analytics/download_app_tip_analytics.dart';

class MockDownloadAppTipAnalytics implements DownloadAppTipAnalytics {
  MockDownloadAppTipAnalytics();

  bool closeTipLogged = false;
  @override
  void logCloseTip(TargetPlatform platform) {
    closeTipLogged = true;
  }

  bool openTipLogged = false;
  @override
  void logOpenTip(TargetPlatform platform) {
    openTipLogged = true;
  }
}
