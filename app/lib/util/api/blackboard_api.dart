import 'dart:async';

import 'package:authentification_base/authentification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/filesharing/file_sharing_api.dart';
import 'package:sharezone/models/blackboard_item.dart';
import 'package:sharezone/widgets/homework/delete_homework.dart';

class BlackboardGateway {
  final String uID;
  final CollectionReference<Map<String, dynamic>> blackboardItemCollection;

  final Stream<List<BlackboardItem>> blackboardItemStream;

  final BehaviorSubject<List<BlackboardItem>> streamOfParsedBlackboardItem =
      BehaviorSubject<List<BlackboardItem>>();

  BlackboardGateway(
      {@required AuthUser authUser, @required FirebaseFirestore firestore})
      : uID = authUser.uid,
        blackboardItemCollection = firestore.collection("Blackboard"),
        blackboardItemStream = firestore
            .collection("Blackboard")
            .where("forUsers.${authUser.uid}", isLessThanOrEqualTo: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => BlackboardItem.fromData(doc.data(), id: doc.id))
                .toList())
            .asBroadcastStream();

  Stream<BlackboardItem> singleBlackboardItem(String itemID) {
    return blackboardItemCollection.doc(itemID).snapshots().map(
        (docSnap) => BlackboardItem.fromData(docSnap.data(), id: docSnap.id));
  }

  /// Sollte es keine Attachments geben, sollte an [attachmentsRemainOrDelete]
  /// null übergeben werden.
  void deleteBlackboardItemWithAttachments(
      {@required String id,
      @required String courseID,
      @required List<String> attachmentIDs,
      @required AttachmentOperation attachmentsRemainOrDelete,
      @required FileSharingGateway fileSharingGateway}) {
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

  void _unlinkAllFiles(FileSharingGateway fileSharingGateway, String id,
      List<String> attachmentIDs) {
    for (final attachmentID in attachmentIDs) {
      fileSharingGateway.removeReferenceData(
        attachmentID,
        ReferenceData(type: ReferenceType.blackboard, id: id),
      );
    }
  }

  void _deleteAllFiles(FileSharingGateway fileSharingGateway, String courseID,
      List<String> attachmentIDs) {
    for (final attachmentID in attachmentIDs) {
      fileSharingGateway.cloudFilesGateway.deleteFile(courseID, attachmentID);
    }
  }

  Future<void> _deleteBlackboardItemDocument(String id) =>
      blackboardItemCollection.doc(id).delete();

  Future<DocumentReference> addBlackboardItemToCourse(
      BlackboardItem blackboardItem,
      List<String> attachments,
      FileSharingGateway fileSharingGateway) async {
    final reference = blackboardItemCollection.doc();
    await reference.set(blackboardItem.toJson());

    final hasAttachments = attachments != null && attachments.isNotEmpty;
    if (hasAttachments) {
      for (int i = 0; i < attachments.length; i++) {
        await fileSharingGateway.addReferenceData(attachments[i],
            ReferenceData(type: ReferenceType.blackboard, id: reference.id));
      }
    }

    return reference;
  }

  /// Adds a Bl4eackboardItem to the [blackboardItemCollection] or if [merge] is true updates the [Blackboard] at [blackboardItem.reference].
  Future<DocumentReference> add(BlackboardItem blackboardItem, bool merge,
      {List<String> attachments,
      FileSharingGateway fileSharingGateway,
      String courseID}) async {
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
            ReferenceData(
                type: ReferenceType.blackboard, id: blackboardItem.id));
      }
    }

    return reference;
  }

  static String parentOfPath(String documentRefPath) {
    int lastIndex = documentRefPath.lastIndexOf("/");
    assert(lastIndex != -1,
        "documentReferencePath of DocumentReference should have a '/' in it. - documentReferencePath: $documentRefPath");
    String collectionRefPath = documentRefPath.substring(0, lastIndex);
    return collectionRefPath;
  }

  /// Changes the isDone Value of the [BlackboardItem] to [newDoneValue] for the user
  /// with [uID].
  void changeIsBlackboardDoneTo(
      String blackboardDocumentID, bool newDoneValue) {
    final documentReference =
        blackboardItemCollection.doc(blackboardDocumentID);
    documentReference.update({"forUsers.$uID": newDoneValue});
  }

  void dispose() {
    streamOfParsedBlackboardItem.close();
  }
}
