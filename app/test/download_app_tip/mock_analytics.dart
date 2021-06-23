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
