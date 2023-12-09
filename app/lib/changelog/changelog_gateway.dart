// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharezone/changelog/change_database_model.dart';

class ChangelogGateway {
  ChangelogGateway({required FirebaseFirestore firestore})
      : changelogCollection = firestore.collection('Changelog');

  final CollectionReference<Map<String, dynamic>> changelogCollection;

  Future<List<ChangeDatabaseModel>> loadChange({
    int from = 0,
    required int to,
  }) async {
    final querySnapshot = await changelogCollection
        .orderBy("version", descending: true)
        .limit(to)
        .get();
    final models = querySnapshot.docs
        .map((changelogDoc) => ChangeDatabaseModel.fromData(changelogDoc.data(),
            id: changelogDoc.id))
        .toList();
    return models;
  }
}
