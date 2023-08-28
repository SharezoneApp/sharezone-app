// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
