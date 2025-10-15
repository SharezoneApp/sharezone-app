// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/blackboard/blackboard_item.dart';
import 'package:sharezone/filesharing/file_sharing_api.dart';
import 'package:sharezone/homework/shared/delete_homework.dart';

class BlackboardGateway {
  final String uID;
  final CollectionReference<Map<String, dynamic>> blackboardItemCollection;

  Stream<List<BlackboardItem>> get blackboardItemStream =>
      _blackboardItemsSubject.stream;
  final BehaviorSubject<List<BlackboardItem>> _blackboardItemsSubject =
      BehaviorSubject<List<BlackboardItem>>();
  StreamSubscription<List<BlackboardItem>>? _subscription;

  BlackboardGateway({
    required AuthUser authUser,
    required FirebaseFirestore firestore,
  }) : uID = authUser.uid,
       blackboardItemCollection = firestore.collection("Blackboard") {
    _subscription = firestore
        .collection("Blackboard")
        .where("forUsers.${authUser.uid}", isLessThanOrEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => BlackboardItem.fromData(doc.data(), id: doc.id))
                  .toList(),
        )
        .listen((event) {
          _blackboardItemsSubject.add(event);
        });
  }

  Stream<BlackboardItem> singleBlackboardItem(String itemID) {
    return blackboardItemCollection
        .doc(itemID)
        .snapshots()
        .map(
          (docSnap) => BlackboardItem.fromData(docSnap.data()!, id: docSnap.id),
        );
  }

  /// Sollte es keine Attachments geben, sollte an [attachmentsRemainOrDelete]
  /// null übergeben werden.
  void deleteBlackboardItemWithAttachments({
    required String id,
    required String courseID,
    required List<String> attachmentIDs,
    required AttachmentOperation attachmentsRemainOrDelete,
    required FileSharingGateway fileSharingGateway,
  }) {
    // Attachments
    if (attachmentsRemainOrDelete == AttachmentOperation.delete) {
      _deleteAllFiles(fileSharingGateway, courseID, attachmentIDs);
    } else if (attachmentsRemainOrDelete == AttachmentOperation.unlink) {
      _unlinkAllFiles(fileSharingGateway, id, attachmentIDs);
    }

    _deleteBlackboardItemDocument(id);
    return;
  }

  void deleteBlackboardItemWithoutAttachments(String id) {
    _deleteBlackboardItemDocument(id);
  }

  void _unlinkAllFiles(
    FileSharingGateway fileSharingGateway,
    String id,
    List<String> attachmentIDs,
  ) {
    for (final attachmentID in attachmentIDs) {
      fileSharingGateway.removeReferenceData(
        attachmentID,
        ReferenceData(type: ReferenceType.blackboard, id: id),
      );
    }
  }

  void _deleteAllFiles(
    FileSharingGateway fileSharingGateway,
    String courseID,
    List<String> attachmentIDs,
  ) {
    for (final attachmentID in attachmentIDs) {
      fileSharingGateway.cloudFilesGateway.deleteFile(courseID, attachmentID);
    }
  }

  Future<void> _deleteBlackboardItemDocument(String id) =>
      blackboardItemCollection.doc(id).delete();

  Future<DocumentReference> addBlackboardItemToCourse(
    BlackboardItem blackboardItem,
    List<String>? attachments,
    FileSharingGateway fileSharingGateway,
  ) async {
    final reference = blackboardItemCollection.doc();
    await reference.set(blackboardItem.toJson());

    final hasAttachments = attachments != null && attachments.isNotEmpty;
    if (hasAttachments) {
      for (int i = 0; i < attachments.length; i++) {
        await fileSharingGateway.addReferenceData(
          attachments[i],
          ReferenceData(type: ReferenceType.blackboard, id: reference.id),
        );
      }
    }

    return reference;
  }

  /// Adds a Bl4eackboardItem to the [blackboardItemCollection] or if [merge] is true updates the [Blackboard] at [blackboardItem.reference].
  Future<DocumentReference> add(
    BlackboardItem blackboardItem,
    bool merge, {
    List<String>? attachments,
    required FileSharingGateway fileSharingGateway,
    required String courseID,
  }) async {
    DocumentReference reference;
    if (!merge) {
      reference = await blackboardItemCollection.add(blackboardItem.toJson());
    } else {
      await blackboardItemCollection
          .doc(blackboardItem.id)
          .set(blackboardItem.toJson(), SetOptions(merge: true));
      reference = blackboardItemCollection.doc(blackboardItem.id);
    }

    if (attachments != null && attachments.isNotEmpty) {
      for (int i = 0; i < attachments.length; i++) {
        await fileSharingGateway.addReferenceData(
          attachments[i],
          ReferenceData(type: ReferenceType.blackboard, id: blackboardItem.id),
        );
      }
    }

    return reference;
  }

  static String parentOfPath(String documentRefPath) {
    final int lastIndex = documentRefPath.lastIndexOf("/");
    assert(
      lastIndex != -1,
      "documentReferencePath of DocumentReference should have a '/' in it. - documentReferencePath: $documentRefPath",
    );
    final String collectionRefPath = documentRefPath.substring(0, lastIndex);
    return collectionRefPath;
  }

  /// Changes the isDone Value of the [BlackboardItem] to [newDoneValue] for the user
  /// with [uID].
  void changeIsBlackboardDoneTo(
    String blackboardDocumentID,
    bool newDoneValue,
  ) {
    final documentReference = blackboardItemCollection.doc(
      blackboardDocumentID,
    );
    documentReference.update({"forUsers.$uID": newDoneValue});
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _blackboardItemsSubject.close();
  }
}
