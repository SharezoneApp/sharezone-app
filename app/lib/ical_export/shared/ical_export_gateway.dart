import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/ical_export/shared/ical_export_dto.dart';

class ICalExportGateway {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  final CollectionReference _iCalExports;

  ICalExportGateway({
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _functions = functions,
        _iCalExports = firestore.collection('ICalExports');

  ICalExportId generateId() => ICalExportId(_iCalExports.doc().id);

  void createIcalExport(ICalExportDto iCalExport) async {
    _iCalExports.doc('${iCalExport.id}').set(iCalExport.toCreateJson());
  }

  Future<void> updateIcalExport(ICalExportDto iCalExport) async {
    await _firestore.runTransaction((transaction) async {
      transaction.update(
        _iCalExports.doc('${iCalExport.id}'),
        iCalExport.toUpdateJson(),
      );
    });
  }

  Future<String> getFancyUrl(ICalExportId id) async {
    final callable = _functions.httpsCallable('getFancyIcalUrl');
    final result = await callable.call<Map<String, dynamic>>({
      'calendarId': '$id',
    });
    return result.data['url'];
  }

  Stream<List<ICalExportDto>> getIcalExportsStream(UserId userId) {
    return _iCalExports
        .where('userId', isEqualTo: '$userId')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ICalExportDto.fromJson(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  void deleteIcalExport(ICalExportId id) async {
    _iCalExports.doc('$id').delete();
  }
}
