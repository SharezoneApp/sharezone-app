import 'package:analytics/analytics.dart';

class DashboardAnalytics {
  final Analytics _analytics;

  DashboardAnalytics(this._analytics);

  void logOpenFabSheet() {
    _analytics.log(AnalyticsEvent("dashboard_fab_sheet_open"));
  }

  void logBlackboardAdd() {
    _analytics.log(AnalyticsEvent("blackboard_add_via_overview_page"));
  }

  void logEventAdd() {
    _analytics.log(AnalyticsEvent("event_add_via_overview_page"));
  }

  void logExamAdd() {
    _analytics.log(AnalyticsEvent("exam_add_via_overview_page"));
  }

  void logLessonAdd() {
    _analytics.log(AnalyticsEvent("lesson_add_via_overview_page"));
  }

  void logHomeworkAdd() {
    _analytics.log(AnalyticsEvent("homework_add_via_overview_page"));
  }
}
