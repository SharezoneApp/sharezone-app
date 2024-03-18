import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/ical_export/shared/ical_export_dto.dart';
import 'package:sharezone/ical_export/shared/ical_export_sources.dart';
import 'package:sharezone/ical_export/shared/ical_export_status.dart';

class ICalExportView {
  final ICalExportId id;
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

  factory ICalExportView.fromDto(ICalExportDto dto) {
    return ICalExportView(
      id: dto.id,
      name: dto.name,
      sources: dto.sources,
      status: dto.status,
      url: null,
      error: null,
    );
  }

  bool get hasUrl => url != null;
  bool get hasError => error != null;

  ICalExportView copyWith({
    ICalExportId? id,
    String? name,
    ICalExportStatus? status,
    List<ICalExportSource>? sources,
    Uri? url,
    String? error,
  }) {
    return ICalExportView(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      sources: sources ?? this.sources,
      url: url ?? this.url,
      error: error ?? this.error,
    );
  }
}
