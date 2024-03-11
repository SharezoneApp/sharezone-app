import 'package:analytics/analytics.dart';
import 'package:sharezone/ical_export/shared/ical_export_sources.dart';

class ICalExportAnalytics {
  final Analytics analytics;

  const ICalExportAnalytics(this.analytics);

  void logCreate(List<ICalExportSource> sources) {
    analytics.log(
      ICalExportEvent(
        'create',
        data: {
          'sources': sources.map((e) => e.name).toList(),
        },
      ),
    );
  }

  void logUpdateSources(List<ICalExportSource> sources) {
    analytics.log(
      ICalExportEvent(
        'update_sources',
        data: {
          'sources': sources.map((e) => e.name).toList(),
        },
      ),
    );
  }

  void logUpdateName() {
    analytics.log(const ICalExportEvent('update_name'));
  }

  void logDelete() {
    analytics.log(const ICalExportEvent('delete'));
  }
}

class ICalExportEvent extends AnalyticsEvent {
  const ICalExportEvent(String name, {Map<String, dynamic>? data})
      : super('ical_export_$name', data: data);
}
