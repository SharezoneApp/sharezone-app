import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';

class BlackboardAnalytics extends BlocBase {
  final Analytics _analytics;

  BlackboardAnalytics(this._analytics);

  void logOpenUserReadPage() {
    _analytics.log(BlackboardEvent('open_user_read_page'));
  }

  @override
  void dispose() {}
}

class BlackboardEvent extends AnalyticsEvent {
  BlackboardEvent(String name) : super('blackboard_$name');
}
