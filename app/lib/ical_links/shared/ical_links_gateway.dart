// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:sharezone/ical_links/shared/ical_link_dto.dart';

class ICalLinksGateway {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  final CollectionReference _iCalLinks;

  ICalLinksGateway({
    required FirebaseFirestore firestore,
    required FirebaseFunctions functions,
  })  : _firestore = firestore,
        _functions = functions,
        _iCalLinks = firestore.collection('iCalLinks');

  ICalLinkId generateId() => ICalLinkId(_iCalLinks.doc().id);

  void createICalLink(ICalLinkDto dto) async {
    _iCalLinks.doc('${dto.id}').set(dto.toCreateJson());
  }

  Future<void> updateICalLink(ICalLinkDto dto) async {
    await _firestore.runTransaction((transaction) async {
      transaction.update(
        _iCalLinks.doc('${dto.id}'),
        dto.toUpdateJson(),
      );
    });
  }

  Future<String> getFancyUrl(ICalLinkId id) async {
    final callable = _functions.httpsCallable('getFancyIcalUrl');
    final result = await callable.call<Map<String, dynamic>>({
      'linkId': '$id',
    });
    return result.data['url'];
  }

  Stream<List<ICalLinkDto>> getICalLinksStream(UserId userId) {
    return _iCalLinks
        .where('userId', isEqualTo: '$userId')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ICalLinkDto.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  void deleteICalLink(ICalLinkId id) async {
    _iCalLinks.doc('$id').delete();
  }
}
