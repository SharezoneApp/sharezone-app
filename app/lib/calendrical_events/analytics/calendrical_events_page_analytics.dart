import 'package:analytics/analytics.dart';
import 'package:sharezone/calendrical_events/models/calendrical_events_layout.dart';

class CalendricalEventsPageAnalytics {
  final Analytics analytics;

  const CalendricalEventsPageAnalytics(this.analytics);

  void logChangeLayout(CalendricalEventsPageLayout layout) {
    analytics.log(
      CalendricalEventsPageAnalyticsEvent(
        'changed_layout',
        data: {'layout': layout.name},
      ),
    );
  }
}

class CalendricalEventsPageAnalyticsEvent extends AnalyticsEvent {
  const CalendricalEventsPageAnalyticsEvent(
    String name, {
    Map<String, dynamic>? data,
  }) : super('events_page_$name', data: data);
}
