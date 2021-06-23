import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';

class ImprintAnalytics extends BlocBase {
  final Analytics _analytics;

  ImprintAnalytics(this._analytics);

  void logOpenImprint() {
    _analytics.log(NamedAnalyticsEvent(name: 'open_imprint'));
  }

  @override
  void dispose() {}
}
