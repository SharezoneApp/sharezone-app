import 'package:sharezone/ical_export/shared/ical_export_sources.dart';
import 'package:sharezone/ical_export/shared/ical_export_status.dart';

class ICalExportView {
  final String id;
  final String name;
  final ICalExportStatus status;
  final List<ICalExportSource> sources;
  final Uri? url;
  final String? error;

  const ICalExportView({
    required this.id,
    required this.name,
    required this.sources,
    required this.status,
    required this.url,
    required this.error,
  });

  bool get hasUrl => url != null;
  bool get hasError => error != null;
}
