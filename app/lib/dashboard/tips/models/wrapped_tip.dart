// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart' hide Action;
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/dashboard/tips/cache/dashboard_tip_cache.dart';
import 'package:sharezone/dashboard/tips/models/action.dart';
import 'package:sharezone/dashboard/tips/models/dashboard_tip.dart';
import 'package:sharezone/sharezone_wrapped/sharezone_wrapped_page.dart';

class SharezoneWrappedTip implements DashboardTip {
  static const _showedDashboardRatingCardKey =
      "dashboard-showed-wrapped-23-24-tip";

  final DashboardTipCache cache;
  final Stream<DateTime?> accountCreatedOn;

  SharezoneWrappedTip(this.cache, this.accountCreatedOn);

  @override
  Action get action => Action(
      title: "Ansehen",
      onTap: (context) =>
          Navigator.pushNamed(context, SharezoneWrappedPage.tag));

  @override
  String get text =>
      "Das Schuljahr ist vorbei! Sieh dir dein Sharezone Wrapped 23/24 (dein Schuljahr in Zahlen) an 🎉";

  @override
  String get title => "Sharezone Wrapped 23/24";

  @override
  Stream<bool> shouldShown() {
    return CombineLatestStream([
      cache.showedTip(_showedDashboardRatingCardKey),
      accountCreatedOn,
    ], (streamValues) {
      final showedDashboardCounterCard = streamValues[0] as bool? ?? false;
      final createdOn = streamValues[1] as DateTime?;

      // New user shouldn't see the Sharezone Wrapped tip because their Wrapped
      // will be mostly empty.
      final isOldUser = createdOn?.isBefore(DateTime(2024, 5, 1)) == true;

      return !showedDashboardCounterCard && isOldUser;
    });
  }

  @override
  void markAsShown() => cache.markTipAsShown(_showedDashboardRatingCardKey);
}
