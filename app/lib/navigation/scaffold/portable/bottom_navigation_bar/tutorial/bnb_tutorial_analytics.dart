import 'package:analytics/analytics.dart';

class BnbTutorialAnalytics {
  final Analytics _analytics;

  BnbTutorialAnalytics(this._analytics);

  void logCompletedBnbTutorial() {
    _analytics.log(BnbTutorialEvent('completed'));
  }

  void logSkippedBnbTutorial() {
    _analytics.log(BnbTutorialEvent('skipped'));
  }
}

class BnbTutorialEvent extends AnalyticsEvent {
  BnbTutorialEvent(String name) : super('bnb_tutorial_$name');
}
