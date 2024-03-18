import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:sharezone/ical_export/shared/ical_export_sources.dart';
import 'package:sharezone/ical_export/shared/ical_export_status.dart';

class ICalExportDto extends Equatable {
  final ICalExportId id;
  final List<ICalExportSource> sources;
  final String name;
  final ICalExportStatus status;
  final UserId? userId;

  const ICalExportDto({
    required this.id,
    required this.sources,
    required this.name,
    required this.status,
    required this.userId,
  });

  Map<String, dynamic> toCreateJson() {
    return {
      'sources': sources.map((e) => e.name).toList(),
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
      'status': status.name,
      'userId': '$userId',
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'sources': sources.map((x) => x.name).toList(),
      'name': name,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory ICalExportDto.fromJson(String id, Map<String, dynamic> map) {
    return ICalExportDto(
      id: ICalExportId(id),
      sources: decodeList(map['sources'], (dynamic decodedMapValue) {
        return ICalExportSource.values.byName(decodedMapValue);
      }),
      name: map['name'],
      status: ICalExportStatus.values.byName(map['status']),
      userId: UserId(map['userId']),
    );
  }

  ICalExportDto copyWith({
    ICalExportId? id,
    List<ICalExportSource>? sources,
    String? name,
    ICalExportStatus? status,
    UserId? userId,
  }) {
    return ICalExportDto(
      id: id ?? this.id,
      sources: sources ?? this.sources,
      name: name ?? this.name,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, sources, name, status];
}
