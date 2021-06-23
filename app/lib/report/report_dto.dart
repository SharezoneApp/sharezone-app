import 'package:meta/meta.dart';
import 'package:sharezone_common/helper_functions.dart';

import 'report.dart';
import 'report_reason.dart';

class ReportDto {
  final String creatorID;
  final DateTime createdOn;

  final String path;
  final ReportReason reason;
  final String description;

  const ReportDto._({
    @required this.creatorID,
    @required this.createdOn,
    @required this.path,
    @required this.reason,
    @required this.description,
  });

  factory ReportDto.fromReport(Report report) {
    return ReportDto._(
      creatorID: report.creatorID,
      createdOn: report.createdOn,
      reason: report.reason,
      description: report.description,
      path: report.item.path,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'creatorID': creatorID,
      'createdOn': createdOn.toIso8601String(),
      'path': path,
      'reason': enumToString(reason),
      'description': description,
    }..removeWhere((string, object) =>
        object == null || (object is String && object.isEmpty));
  }

  ReportDto copyWith({
    String creatorID,
    DateTime createdOn,
    String path,
    ReportReason reason,
    String description,
  }) {
    return ReportDto._(
      creatorID: creatorID ?? this.creatorID,
      createdOn: createdOn ?? this.createdOn,
      path: path ?? this.path,
      reason: reason ?? this.reason,
      description: description ?? this.description,
    );
  }
}
