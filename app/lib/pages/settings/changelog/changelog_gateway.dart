import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:sharezone/pages/settings/changelog/change_database_model.dart';

class ChangelogGateway {
  ChangelogGateway({@required FirebaseFirestore firestore})
      : changelogCollection = firestore.collection('Changelog');

  final CollectionReference<Map<String, dynamic>> changelogCollection;

  Future<List<ChangeDatabaseModel>> loadChange(
      {int from = 0, @required int to}) async {
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
