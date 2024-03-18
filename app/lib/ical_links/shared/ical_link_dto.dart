import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_helper/cloud_firestore_helper.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:sharezone/ical_links/shared/ical_link_source.dart';
import 'package:sharezone/ical_links/shared/ical_link_status.dart';

class ICalLinkDto extends Equatable {
  final ICalLinkId id;
  final List<ICalLinkSource> sources;
  final String name;
  final ICalLinkStatus status;
  final UserId? userId;

  const ICalLinkDto({
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

  factory ICalLinkDto.fromJson(String id, Map<String, dynamic> map) {
    return ICalLinkDto(
      id: ICalLinkId(id),
      sources: decodeList(map['sources'], (dynamic decodedMapValue) {
        return ICalLinkSource.values.byName(decodedMapValue);
      }),
      name: map['name'],
      status: ICalLinkStatus.values.byName(map['status']),
      userId: UserId(map['userId']),
    );
  }

  ICalLinkDto copyWith({
    ICalLinkId? id,
    List<ICalLinkSource>? sources,
    String? name,
    ICalLinkStatus? status,
    UserId? userId,
  }) {
    return ICalLinkDto(
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
