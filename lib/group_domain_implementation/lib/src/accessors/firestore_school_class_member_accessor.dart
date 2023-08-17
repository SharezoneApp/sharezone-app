// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_domain_models/group_domain_accessors.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone_common/references.dart';

class FirestoreSchoolClassMemberAccessor extends SchoolClassMemberAccessor {
  final FirebaseFirestore _firestore;

  FirestoreSchoolClassMemberAccessor(this._firestore);

  DocumentReference _schoolClassReference(String schoolClassID) =>
      _firestore.collection(CollectionNames.schoolClasses).doc(schoolClassID);

  CollectionReference _memberReference(String schoolClassID) =>
      _schoolClassReference(schoolClassID).collection(CollectionNames.members);

  @override
  Stream<List<MemberData>> streamAllMembers(String schoolClassID) {
    return _memberReference(schoolClassID).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (docSnap) => MemberData.fromData(
                  docSnap.data() as Map<String, dynamic>,
                  id: docSnap.id,
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<MemberData> streamSingleMember(String schoolClassID, String memberID) {
    return _memberReference(schoolClassID).doc(memberID).snapshots().map(
          (snapshot) => MemberData.fromData(
            snapshot.data() as Map<String, dynamic>,
            id: snapshot.id,
          ),
        );
  }
}
