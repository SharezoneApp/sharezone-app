import 'package:analytics/analytics.dart';
import 'package:bloc_base/bloc_base.dart';

class FeedbackAnalytics extends BlocBase {
  final Analytics _analytics;

  FeedbackAnalytics(this._analytics);

  void logSendFeedback() {
    _analytics.log(NamedAnalyticsEvent(name: 'send_feedback'));
  }

  void logOpenRatingOfThankYouSheet() {
    _analytics
        .log(NamedAnalyticsEvent(name: 'feedback_thank_you_sheet_open_rating'));
  }

  @override
  void dispose() {}
}
