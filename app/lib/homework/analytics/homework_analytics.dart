import 'package:analytics/analytics.dart';

class HomeworkAnalytics {
  final Analytics _analytics;

  HomeworkAnalytics(this._analytics);

  void logOpenHomeworkDoneByUsersList() {
    _analytics.log(HomeworkEvent('open_done_by_users_list'));
  }
}

class HomeworkEvent extends AnalyticsEvent {
  HomeworkEvent(String name) : super('homework_$name');
}