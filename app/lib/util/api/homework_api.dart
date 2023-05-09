// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filesharing_logic/filesharing_logic_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/filesharing/file_sharing_api.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:user/user.dart';

class HomeworkGateway {
  final String userId;
  final CollectionReference<Map<String, dynamic>> homeworkCollection;
  final Stream<TypeOfUser> typeOfUserStream;

  /// Stream that returns all homework which due date is today or in the future.
  /// For students this includes homeworks marked as completed.
  /// It is used by the Dashboard.
  Stream<List<HomeworkDto>> get homeworkForNowAndInFutureStream =>
      _homeworkNowAndInFutureStream;
  final _homeworkNowAndInFutureStream = BehaviorSubject<List<HomeworkDto>>();

  /// Return a [Stream] of a [List] of [HomeworkDto] from the [DocumentSnapshot] in the [homeworkCollection].
  /// If the deserialization from a [DocumentSnapshot] to [HomeworkDto] fails a list of [DeserializeFirestoreDocException],
  /// with one error per not parsed document, will be added into the stream.
  Stream<List<HomeworkDto>> get homeworkStream => _homeworkSubjectStream;

  final _homeworkSubjectStream = BehaviorSubject<List<HomeworkDto>>();

  HomeworkGateway({
    @required this.userId,
    @required FirebaseFirestore firestore,
    @required this.typeOfUserStream,
  }) : homeworkCollection = firestore.collection("Homework") {
    final now = DateTime.now();
    final startOfThisDay = DateTime(now.year, now.month, now.day);

    typeOfUserStream.firstWhere((e) => e != null).then((typeOfUser) {
      if (typeOfUser == TypeOfUser.student) {
        /// Der Homework-Stream wird hier nicht erstellt, weil dieser nur noch
        /// bei Eltern & Lehrern genutzt wird.
        ///
        /// Bei Schülern wurde die Hausaufgaben-Seite bereits überarbeitet,
        /// sodass diese nicht mehr auf das [HomeworkGateway] braucht, um
        /// Lazy-Loading zu ermöglichen, was mit dem Stream nicht möglich ist.
        ///
        /// Da [HomeworkGateway] aufgrund schlechten Designs während App-
        /// Starts immer direkt erstellt wird, benutzten wir erstmal diesen
        /// Workaround anstatt die Klasse bei Schülern einfach nicht bei
        /// Schülern nicht zu erstellen.
        ///
        /// In Zukunft sollten als richtiger Fix die Hausaufgabenseiten von
        /// Eltern & Lehrern auch überarbeitet werden, sodass dieser Stream
        /// nicht mehr benötigt wird.
        /// https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1098
        ///
        /// Der Stream hier kann geclosed werden, weil bei einem Account-Wechsel
        /// zu einem anderen Nutzertyp die Klasse (und damit der Stream) ganz
        /// neu erstellt wird.
        _homeworkSubjectStream.close();

        // Falls der Nutzer ein Schüler ist, dann muss der
        // [_homeworkNowAndInFutureStream] von Firestore geladen werden.
        // Für Eltern und Lehrer siehe weiter unten.
        homeworkCollection
            .where('assignedUserArrays.allAssignedUids', arrayContains: userId)
            .where('todoUntil', isGreaterThanOrEqualTo: startOfThisDay)
            .snapshots()
            .transform(_homeworkTransformer)
            .asBroadcastStream()
            .listen(_homeworkNowAndInFutureStream.add,
                onError: _homeworkNowAndInFutureStream.addError);

        return;
      }
      firestore
          .collection("Homework")
          .where('assignedUserArrays.allAssignedUids', arrayContains: userId)
          .snapshots()
          .transform(_homeworkTransformer)
          .asBroadcastStream()
          .listen(
            _homeworkSubjectStream.add,
            onError: _homeworkSubjectStream.addError,
          );

      // Falls der aktuelle Nutzer kein Schüler ist, dann laden wir schon alle
      // Hausaufgaben mit dem [_homeworkSubjectStream]. Hier kann der
      // [_homeworkNowAndInFutureStream] also einfach mit den gefilterten
      // Hausaufgaben aus dem [_homeworkSubjectStream] gefüllt werden.
      _homeworkSubjectStream
          .map((homeworks) => homeworks
              .where((hw) =>
                  hw.todoUntil.isAfter(startOfThisDay) ||
                  hw.todoUntil.isAtSameMomentAs(startOfThisDay))
              .toList())
          .listen(
            _homeworkNowAndInFutureStream.add,
            onError: _homeworkNowAndInFutureStream.addError,
          );
    });
  }

  Stream<HomeworkDto> singleHomeworkStream(String homeworkId) {
    return homeworkCollection
        .doc(homeworkId)
        .snapshots()
        .map((docSnap) => HomeworkDto.fromData(docSnap.data(), id: docSnap.id));
  }

  Future<HomeworkDto> singleHomework(String homeworkId, {Source source}) async {
    final doc = await homeworkCollection
        .doc(homeworkId)
        .get(GetOptions(source: source ?? Source.serverAndCache));
    return HomeworkDto.fromData(doc.data(), id: doc.id);
  }

  Future<void> deleteHomework(HomeworkDto homework,
      {FileSharingGateway fileSharingGateway}) async {
    if (homework.attachments != null &&
        homework.attachments.isNotEmpty &&
        fileSharingGateway != null) {
      for (final fileID in homework.attachments) {
        fileSharingGateway.removeReferenceData(fileID,
            ReferenceData(type: ReferenceType.blackboard, id: homework.id));
      }
    }
    _deleteHomeworkDocument(homework.id);
    return;
  }

  Future<void> _deleteHomeworkDocument(String id) =>
      homeworkCollection.doc(id).delete();

  void deleteHomeworkOnlyForCurrentUser(HomeworkDto homework) {
    if (homework.forUsers.length > 1) {
      final deleteCurrentUserOutOfUserMap = <String, Object>{
        "forUsers.$userId": FieldValue.delete()
      };
      homeworkCollection.doc(homework.id).update(deleteCurrentUserOutOfUserMap);
    } else {
      homeworkCollection.doc(homework.id).delete();
    }
    return;
  }

  /// Adds the given [HomeworkDto] to every user of the given [CourseSegment].
  ///
  /// Gets every user from the [CourseGateway.joinedUsersCollectionName] Collection
  /// and writes the userIDs to a Map, which is then inserted into the given
  /// [HomeworkDto].
  /// The [HomeworkDto] gets then added to the [homeworkCollection].
  Future<DocumentReference> addHomeworkToCourse(HomeworkDto homework,
      {List<String> attachments, FileSharingGateway fileSharingGateway}) async {
    final reference = homeworkCollection.doc();
    await reference.set(homework.toJson());

    final hasAttachments = attachments != null && attachments.isNotEmpty;
    if (hasAttachments) {
      for (int i = 0; i < attachments.length; i++) {
        await fileSharingGateway.addReferenceData(attachments[i],
            ReferenceData(type: ReferenceType.homework, id: reference.id));
      }
    }

    return reference;
  }

  /// Adds a Homework to the [homeworkCollection] or if [merge] is true updates the [HomeworkDto] at [homework.reference].
  Future<void> addPrivateHomework(HomeworkDto homework, bool merge,
      {List<String> attachments, FileSharingGateway fileSharingGateway}) async {
    final hasAttachments = attachments != null &&
        attachments.isNotEmpty &&
        fileSharingGateway != null;

    // Wenn eine Hausaufgabe erstellt wird (merge == false), wird
    // eine Hausaufgaben-ID automatisch von Firestore erstellt. Falls
    // eine Hausausgabe nur bearbeitet wird, wird die bestehende ID
    // verwendet.
    final reference =
        merge ? homeworkCollection.doc(homework.id) : homeworkCollection.doc();

    if (!merge) {
      if (hasAttachments) {
        await reference.set(homework.toJson());
      } else {
        reference.set(homework.toJson());
      }
    } else {
      if (hasAttachments) {
        await reference.set(homework.toJson(), SetOptions(merge: true));
      } else {
        reference.set(homework.toJson(), SetOptions(merge: true));
      }
    }

    if (hasAttachments) {
      for (int i = 0; i < attachments.length; i++) {
        await fileSharingGateway.addReferenceData(
          attachments[i],
          ReferenceData(
            type: ReferenceType.homework,
            id: reference.id,
          ),
        );
      }
    }
  }

  static String parentOfPath(String documentRefPath) {
    int lastIndex = documentRefPath.lastIndexOf("/");
    assert(lastIndex != -1,
        "documentReferencePath of DocumentReference should have a '/' in it. - documentReferencePath: $documentRefPath");
    String collectionRefPath = documentRefPath.substring(0, lastIndex);
    return collectionRefPath;
  }

  /// Changes the isDone Value of the [HomeworkDto] to [newDoneValue] for the user
  /// with [userId].
  void changeIsHomeworkDoneTo(String homeworkDocumentID, bool newDoneValue) {
    final documentReference = homeworkCollection.doc(homeworkDocumentID);
    documentReference.update({"forUsers.$userId": newDoneValue});
  }

  /// Takes a [QuerySnapshot] and tries to transform the [List] of [DocumentSnapshot] into a [List] of [HomeworkDto].
  /// Every error while deserializing will be added as an [List] of [DeserializeFirestoreDocException] with [sink.addError()] of the [Stream].
  static final _homeworkTransformer = StreamTransformer<
      QuerySnapshot<Map<String, dynamic>>,
      List<HomeworkDto>>.fromHandlers(handleData: (querySnapshot, sink) {
    List<HomeworkDto> parsedHomeworkList = [];
    List<DeserializeFirestoreDocException> errorList = [];

    // Adds each document either to parsedHomeworkList or errorList, depending if the deserializing/parsing succeeded.
    querySnapshot.docs.forEach((homeworkDocument) {
      try {
        parsedHomeworkList.add(HomeworkDto.fromData(homeworkDocument.data(),
            id: homeworkDocument.id));
      } catch (e, s) {
        errorList.add(DeserializeFirestoreDocException(
            homeworkDocument,
            "Error while trying to deserialize a FirestoreDocument into a Homework.",
            s));
      }
    });
    sink.add(parsedHomeworkList);
    if (errorList.isNotEmpty) sink.addError(errorList);
  });

  void dispose() {
    _homeworkSubjectStream.close();
    _homeworkNowAndInFutureStream.close();
  }
}
