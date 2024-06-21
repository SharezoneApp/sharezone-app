// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/dashboard/tips/cache/dashboard_tip_cache.dart';
import 'package:sharezone/dashboard/tips/models/rate_our_app_tip.dart';
import 'package:sharezone/dashboard/tips/models/wrapped_tip.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/settings/src/bloc/user_tips_bloc.dart';

import 'models/dashboard_tip.dart';

class DashboardTipSystem extends BlocBase {
  final DashboardTipCache cache;
  final NavigationBloc navigationBloc;
  final Stream<DashboardTip?> dashboardTip;

  DashboardTipSystem({
    required this.cache,
    required this.navigationBloc,
    required UserTipsBloc userTipsBloc,
  }) : dashboardTip =
            initializeDashboardTipStream(cache, navigationBloc, userTipsBloc)
                .asBroadcastStream() {
    cache.increaseDashboardCounter();
  }

  static Stream<DashboardTip?> initializeDashboardTipStream(
    DashboardTipCache cache,
    NavigationBloc navigationBloc,
    UserTipsBloc userTipsBloc,
  ) {
    final rateOurAppTip = RateOurAppTip(cache);
    final wrappedTip =
        SharezoneWrappedTip(cache, userTipsBloc.streamAccountCreatedOn());

    final tips = [rateOurAppTip, wrappedTip];

    return CombineLatestStream(tips.map((tip) => tip.shouldShown()).toList(),
        (streamValues) {
      final showRateOurAppCard = streamValues[0];
      final showWrappedTip = streamValues[1];
      if (showWrappedTip) return wrappedTip;
      if (showRateOurAppCard) return rateOurAppTip;
      return null;
    });
  }

  @override
  void dispose() {}
}
