// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'report.dart';
import 'report_item.dart' as ui;
import 'report_reason.dart';

class ReportFactory extends BlocBase {
  final String uid;
  final FirebaseFirestore firestore;

  ReportFactory({@required this.uid, @required this.firestore});

  Report create(
      String description, ReportReason reason, ui.ReportItemReference item) {
    validatePath(item.path);
    return Report(
      createdOn: DateTime.now(),
      creatorID: uid,
      description: description,
      reason: reason,
      item: ReportItem(item.path),
    );
  }

  void validatePath(String path) => firestore.doc(path);

  @override
  void dispose() {}
}
