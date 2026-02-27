// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:rxdart/rxdart.dart';
import 'package:sharezone/dashboard/tips/cache/dashboard_tip_cache.dart';
import 'package:sharezone/dashboard/tips/models/action.dart';
import 'package:sharezone/dashboard/tips/models/dashboard_tip.dart';
import 'package:sharezone_utils/launch_link.dart';
import 'package:platform_check/platform_check.dart';

class RateOurAppTip implements DashboardTip {
  static const _showedDashboardRatingCardKey = "dashboard-showed-rating-card";
  static const _fallbackActionTitle = "Rate app";

  final DashboardTipCache cache;

  RateOurAppTip(this.cache);

  @override
  Action get action => Action(
    title: _fallbackActionTitle,
    onTap: (_) => launchURL(_getStoreLink()),
  );

  String _getStoreLink() {
    const sharezoneLink = 'https://sharezone.net';
    if (PlatformCheck.isAndroid) return '$sharezoneLink/android';
    if (PlatformCheck.isIOS) return '$sharezoneLink/ios';
    if (PlatformCheck.isMacOS) return '$sharezoneLink/macos';
    return sharezoneLink;
  }

  @override
  String get text =>
      "We'd really appreciate it if you leave us a rating in the ${PlatformCheck.isMacOsOrIOS ? "App" : "Play"} Store 🐵";

  @override
  String get title => "Do you like Sharezone?";

  @override
  Stream<bool> shouldShown() {
    return CombineLatestStream(
      [
        cache.showedTip(_showedDashboardRatingCardKey),
        cache.getDashboardCounter(),
      ],
      (streamValues) {
        final showedDashboardCounterCard = streamValues[0] as bool? ?? false;
        final dashboardCounter = streamValues[1] as int? ?? 0;

        return !showedDashboardCounterCard && dashboardCounter >= 65;
      },
    );
  }

  @override
  void markAsShown() => cache.markTipAsShown(_showedDashboardRatingCardKey);
}
