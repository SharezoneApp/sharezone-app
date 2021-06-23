import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharezone/report/report.dart';
import 'package:sharezone_common/references.dart';

import 'report_dto.dart';

class ReportGateway extends BlocBase {
  final CollectionReference _reportsCollection;

  ReportGateway(FirebaseFirestore firestore)
      : _reportsCollection = firestore.collection(CollectionNames.reports);

  void sendReport(Report report) {
    final dto = ReportDto.fromReport(report);
    _reportsCollection.add(dto.toJson());
  }

  @override
  void dispose() {}
}
