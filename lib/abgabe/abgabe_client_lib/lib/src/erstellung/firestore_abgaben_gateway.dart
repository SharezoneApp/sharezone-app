// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:abgabe_client_lib/src/abnahme/abgaben_abnahme_gateway.dart';
import 'package:abgabe_client_lib/src/abnahme/view_submissions_page_bloc.dart';
import 'package:abgabe_client_lib/src/erstellung/abnahme_erstellung_gateway.dart';
import 'package:abgabe_client_lib/src/erstellung/string_to_datetime_extension.dart';
import 'package:abgabe_client_lib/src/models/models.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreAbgabeGateway
    implements AbgabenAbnahmeGateway, AbnahmeErstellungGateway {
  final FirebaseFirestore firestore;
  final CollectionReference submissionReviewCollection;
  final CollectionReference submissionCreationCollection;
  final CollectionReference homeworkCollection;
  final CollectionReference courseCollection;
  final UserId userId;

  FirestoreAbgabeGateway({
    required this.firestore,
    required this.submissionReviewCollection,
    required this.submissionCreationCollection,
    required this.homeworkCollection,
    required this.userId,
    required this.courseCollection,
  });

  @override
  Stream<ErstellerAbgabeModelSnapshot> streamAbgabe(
      final HomeworkId homeworkId) async* {
    final abgabeId = AbgabeId(AbgabezielId.homework(homeworkId), userId);

    final reference = submissionCreationCollection.doc('$abgabeId');
    final docSnaps = reference.snapshots();

    await for (var snapshot in docSnaps) {
      yield _toAbgabe(snapshot);
    }
  }

  @override
  Stream<DateTime> streamAbgabezeitpunktFuerHausaufgabe(HomeworkId homeworkId) {
    return homeworkCollection
        .doc('$homeworkId')
        .snapshots()
        .asyncMap((event) => tryToConvertToHomework(event, '$userId'))
        .whereNotNull()
        .map((event) => event.todoDate);
  }

  @override
  Stream<List<AbgegebeneAbgabe>> streamAbgabenFuerHausaufgabe(
      final HomeworkId homeworkId) {
    final querySnapshots = submissionReviewCollection
        .where('submittedForReference.type', isEqualTo: 'hw')
        .where('submittedForReference.id', isEqualTo: homeworkId.toString())
        .snapshots();

    return querySnapshots.map(_toAbgegebeneAbgaben);
  }

  ErstellerAbgabeModelSnapshot _toAbgabe(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      final dto = ErstellerAbgabenModelDto.fromMap(
        snapshot.data() as Map<String, dynamic>,
      );
      var abgabe = dto.toAbgabe();
      return ErstellerAbgabeModelSnapshot(abgabe);
    } else {
      return ErstellerAbgabeModelSnapshot.nichtExistent();
    }
  }

  List<AbgegebeneAbgabe> _toAbgegebeneAbgaben(QuerySnapshot snapshot) {
    return snapshot.docs.map(_toDto).map(_toAbgegebeneAbgabe).toList();
  }

  AbgegebeneAbgabeDto _toDto(DocumentSnapshot snapshot) {
    return AbgegebeneAbgabeDto.fromData(
        snapshot.id, snapshot.data() as Map<String, dynamic>);
  }

  AbgegebeneAbgabe _toAbgegebeneAbgabe(AbgegebeneAbgabeDto dto) {
    final dateien = dto.submittedFiles
        .map(
          (f) => HochgeladeneAbgabedatei(
            id: AbgabedateiId(f.id),
            erstellungsdatum: DateTime.parse(f.createdOnIsoString),
            name: Dateiname(f.fileNameWithExtension),
            downloadUrl: DateiDownloadUrl(f.downloadUrl),
            groesse: Dateigroesse(f.sizeInBytes),
            zuletztBearbeitet: f.lastEditedIsoString?.toDateTime(),
          ),
        )
        .toList();

    final authorName = Nutzername(dto.author.name, dto.author.abbreviation);
    return AbgegebeneAbgabe(
      id: AbgabeId.fromOrThrow(dto.id),
      author: Author(UserId(dto.author.uid), authorName),
      abgegebeneDateien: dateien,
      abgabezeitpunkt: DateTime.parse(dto.submittedOnIsoString),
      zuletztBearbeitet: dto.lastEditedIsoString.toDateTime(),
    );
  }

  @override
  Stream<List<Nutzer>> vonAbgabeBetroffendeNutzer(AbgabeId abgabeId) async* {
    if (abgabeId.abgabenzielId.zielTyp != AbgabenzielTyp.hausaufgabe) {
      throw UnimplementedError(
          '${abgabeId.abgabenzielId.zielTyp} nicht implementiert');
    }
    final homeworkId = abgabeId.abgabenzielId.zielId.toString();
    final docSnaps = homeworkCollection.doc(homeworkId).snapshots();

    await for (final snapshot in docSnaps) {
      final homework = HomeworkDto.fromData(
          snapshot.data() as Map<String, dynamic>,
          id: snapshot.id);
      final allStudentUids = _getAllNonEmptyStudentIds(homework);

      final schueler = <Nutzer>[];
      for (var studentId in allStudentUids) {
        final membersDoc = await courseCollection
            .doc(homework.courseID)
            .collection("Members")
            .doc(studentId)
            .get();
        if (membersDoc.get('typeOfUser') == 'student') {
          try {
            final nutzer = Nutzer(
              id: UserId(membersDoc.id),
              name: Nutzername.generiereAbkuerzung(
                membersDoc.get('name'),
              ),
            );
            schueler.add(nutzer);
          } catch (e) {
            log('Konnte kein Nutzer aus ${membersDoc.reference.path} generieren: $e',
                error: e);
          }
        }
      }

      yield schueler;
    }
  }

  Iterable<String> _getAllNonEmptyStudentIds(HomeworkDto homework) {
    final studentsCompleted = homework.assignedUserArrays.completedStudentUids;
    final studentsOpen = homework.assignedUserArrays.openStudentUids;
    Iterable<String> allStudentUids = studentsCompleted
      ..addAll(studentsOpen)
      ..toSet();
    allStudentUids = allStudentUids.where((id) => id.isNotEmpty);
    return allStudentUids;
  }
}

// TODO: Use enum methods
T? enumFromString<T>(List<T?> values, dynamic json, {T? orElse}) => json != null
    ? values.firstWhere(
        (it) =>
            '$it'.split('.')[1].toString().toLowerCase() ==
            json.toString().toLowerCase(),
        orElse: () => orElse)
    : orElse;
