// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:rxdart/rxdart.dart';
import 'package:sharezone/dashboard/tips/cache/dashboard_tip_cache.dart';
import 'package:sharezone/dashboard/tips/models/action.dart';
import 'package:sharezone/dashboard/tips/models/dashboard_tip.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_utils/platform.dart';

class RateOurAppTip implements DashboardTip {
  static const _showedDashboardRatingCardKey = "dashboard-showed-rating-card";

  final DashboardTipCache cache;

  RateOurAppTip(this.cache);

  @override
  Action get action =>
      Action(title: "App bewerten", onTap: () => launchURL(_getStoreLink()));

  String _getStoreLink() {
    const sharezoneLink = 'https://sharezone.net';
    if (PlatformCheck.isAndroid) return '$sharezoneLink/android';
    if (PlatformCheck.isIOS) return '$sharezoneLink/ios';
    if (PlatformCheck.isMacOS) return '$sharezoneLink/macos';
    return sharezoneLink;
  }

  @override
  String get text =>
      "Wir wären dir unglaublich dankbar, wenn du uns eine Bewertung im ${PlatformCheck.isMacOsOrIOS ? "App" : "Play"}Store hinterlassen könntest 🐵";

  @override
  String get title => "Gefällt dir Sharezone?";

  @override
  Stream<bool> shouldShown() {
    return CombineLatestStream([
      cache.showedTip(_showedDashboardRatingCardKey),
      cache.getDashboardCounter()
    ], (streamValues) {
      final showedDashboardCounterCard = streamValues[0] as bool? ?? false;
      final dashboardCounter = streamValues[1] as int? ?? 0;

      return !showedDashboardCounterCard && dashboardCounter >= 65;
    });
  }

  @override
  void markAsShown() => cache.markTipAsShown(_showedDashboardRatingCardKey);
}
