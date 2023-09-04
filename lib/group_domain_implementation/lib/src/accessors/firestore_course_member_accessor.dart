// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_domain_models/group_domain_accessors.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:sharezone_common/references.dart';
import 'package:user/user.dart';

class FirestoreCourseMemberAccessor extends CourseMemberAccessor {
  final FirebaseFirestore _firestore;

  FirestoreCourseMemberAccessor(this._firestore);

  DocumentReference _courseReference(String courseID) =>
      _firestore.collection(CollectionNames.courses).doc(courseID);

  CollectionReference _memberReference(String courseID) =>
      _courseReference(courseID).collection(CollectionNames.members);

  // Wegen der alten joinedUsers Architektur ist dieser Stream sehr komplex.
  // Wenn wir uns endlich davon verabschieden, können wir diese vereinfachen.
  @override
  Stream<List<MemberData>> streamAllMembers(String courseID) {
    // ignore:close_sinks
    final StreamController<List<MemberData>> streamController =
        StreamController();
    List<MemberData> joinedUsersData = [];
    List<MemberData> membersData = [];

    void update() {
      streamController.add(
        List.of(membersData)
          ..addAll(
            joinedUsersData.where(
              (joinedUser) =>
                  membersData.where((it) => it.id == joinedUser.id).isEmpty,
            ),
          ),
      );
    }

    final subscription2 = _firestore
        .collection(CollectionNames.courses)
        .doc(courseID)
        .collection("joinedUsers")
        .snapshots()
        .listen((querySnapshot) {
      try {
        if (querySnapshot.docs.isNotEmpty) {
          joinedUsersData = querySnapshot.docs.map((docSnapshot) {
            final data = docSnapshot.data();
            return MemberData.create(
              id: docSnapshot.id,
              role: data['powerLevel'] == 'owner'
                  ? MemberRole.owner
                  : MemberRole.creator,
              user: AppUser.create(id: docSnapshot.id).copyWith(
                name: data['name'],
                typeOfUser: TypeOfUser.values.byName(data['typeOfUser']),
              ),
            );
          }).toList();
          update();
        }
      } catch (e) {
        log('$e', error: e);
      }
    });
    final subscription = _memberReference(courseID)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
              (docSnap) => MemberData.fromData(
                docSnap.data() as Map<String, dynamic>,
                id: docSnap.id,
              ),
            )
            .toList())
        .listen((newData) {
      membersData = newData;
      update();
    });

    streamController.onCancel = () {
      subscription.cancel();
      subscription2.cancel();
    };
    return streamController.stream;
  }

  @override
  Stream<MemberData> streamSingleMember(String courseID, String memberID) {
    // ignore:close_sinks
    final StreamController<MemberData> streamController = StreamController();
    MemberData? joinedUsersData;
    MemberData? membersData;

    void update() {
      if (membersData != null) {
        streamController.add(membersData!);
      } else if (joinedUsersData != null) {
        streamController.add(joinedUsersData!);
      }
    }

    final subscription2 = _firestore
        .collection(CollectionNames.courses)
        .doc(courseID)
        .collection("joinedUsers")
        .doc(memberID)
        .snapshots()
        .listen((docSnapshot) {
      try {
        if (docSnapshot.exists) {
          final data = docSnapshot.data()!;
          joinedUsersData = MemberData.create(
            id: docSnapshot.id,
            role: data['powerLevel'] == 'owner'
                ? MemberRole.owner
                : MemberRole.creator,
            user: AppUser.create(id: docSnapshot.id).copyWith(
              name: data['name'],
              typeOfUser: TypeOfUser.values.byName(data['typeOfUser']),
            ),
          );
        } else {
          joinedUsersData = null;
        }
        update();
      } catch (e) {
        log('$e', error: e);
      }
    });
    final subscription = _memberReference(courseID)
        .doc(memberID)
        .snapshots()
        .map((docSnap) => MemberData.fromData(
            docSnap.data() as Map<String, dynamic>,
            id: docSnap.id))
        .listen((newData) {
      membersData = newData;
      update();
    });

    streamController.onCancel = () {
      subscription.cancel();
      subscription2.cancel();
    };
    return streamController.stream;
  }
}
