// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:analytics/analytics.dart';
import 'package:flutter/material.dart';

class DownloadAppTipAnalytics {
  final Analytics _analytics;

  DownloadAppTipAnalytics(this._analytics);

  void logOpenTip(TargetPlatform platform) {
    _analytics.log(_DownloadAppTipEvent(
      status: 'opened',
      targetPlatform: platform,
    ));
  }

  void logCloseTip(TargetPlatform platform) {
    _analytics.log(_DownloadAppTipEvent(
      status: 'closed',
      targetPlatform: platform,
    ));
  }
}

class _DownloadAppTipEvent extends AnalyticsEvent {
  _DownloadAppTipEvent({
    required String status,
    required this.targetPlatform,
  }) : super('download_app_tip_$status');

  final TargetPlatform targetPlatform;

  @override
  Map<String, dynamic> get data =>
      {"targetPlatform": targetPlatform.toString()};
}
