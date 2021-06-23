import 'package:bloc_base/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/dashboard/tips/cache/dashboard_tip_cache.dart';
import 'package:sharezone/dashboard/tips/models/rate_our_app_tip.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/settings/src/bloc/user_tips_bloc.dart';

import 'models/dashboard_tip.dart';

class DashboardTipSystem extends BlocBase {
  final DashboardTipCache cache;
  final NavigationBloc navigationBloc;
  final Stream<DashboardTip> dashboardTip;

  DashboardTipSystem({
    @required this.cache,
    @required this.navigationBloc,
    @required UserTipsBloc userTipsBloc,
  }) : dashboardTip = initialiseDashboardTipStream(
                cache, navigationBloc, userTipsBloc)
            .asBroadcastStream() {
    cache.increaseDashboardCounter();
  }

  static Stream<DashboardTip> initialiseDashboardTipStream(
    DashboardTipCache cache,
    NavigationBloc navigationBloc,
    UserTipsBloc userTipsBloc,
  ) {
    final rateOurAppTip = RateOurAppTip(cache);

    final tips = [rateOurAppTip];

    return CombineLatestStream(tips.map((tip) => tip.shouldShown()).toList(),
        (streamValues) {
      final showRateOurAppCard = streamValues[0] ?? false;

      if (showRateOurAppCard) return rateOurAppTip;
      return null;
    });
  }

  @override
  void dispose() {}
}
