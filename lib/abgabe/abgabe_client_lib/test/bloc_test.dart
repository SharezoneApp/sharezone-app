// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:abgabe_client_lib/src/erstellung/bloc/homework_user_submissions_bloc.dart';
import 'package:abgabe_client_lib/src/erstellung/datei_upload_prozess.dart';
import 'package:abgabe_client_lib/src/erstellung/local_file_saver.dart';
import 'package:abgabe_client_lib/src/erstellung/uploader/abgabedatei_uploader.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/abgabe_veroeffentlicher.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/datei_loescher.dart';
import 'package:abgabe_client_lib/src/erstellung/use_cases/datei_umbenenner.dart';
import 'package:abgabe_client_lib/src/erstellung/views.dart';
import 'package:abgabe_client_lib/src/models/models.dart';
import 'package:async/async.dart';
import 'package:clock/clock.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:files_basics/files_models.dart';
import 'package:files_basics/local_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';
import 'package:test_randomness/test_randomness.dart';

void main() {
  group(
    'HomeworkUserCreateSubmissionsBloc',
    () {
      group('Tests Zeitirrelevant', () {
        late AbgabeId abgabeId;
        late HomeworkUserCreateSubmissionsBloc bloc;
        late MockAbgabendateiUseCases useCases;
        late MockAbgabedateiIdGenerator abgabedateiIdGenerator;
        SingletonLocalFileSaver fileSaver;

        setUp(() {
          useCases = MockAbgabendateiUseCases();
          abgabedateiIdGenerator = MockAbgabedateiIdGenerator();
          abgabeId = AbgabeId(
              AbgabezielId.homework(const HomeworkId('ValidHomeworkId')),
              const UserId('ValidUserId'));
          fileSaver = SingletonLocalFileSaver();
          bloc = HomeworkUserCreateSubmissionsBloc(
            abgabeId,
            useCases.recordError,
            fileSaver,
            useCases,
            useCases.abgabe,
            useCases,
            useCases,
            useCases,
            Stream.value(DateTime(2020, 10, 02)),
            () => DateTime(2020, 04, 30, 11, 30),
            generiereAbgabedateiId:
                abgabedateiIdGenerator.generiereAbgabedateiId,
            abgabefristUeberwachungsfrequenz: const Duration(milliseconds: 10),
          );
        });

        Future<void> testeDateiumbenennung({
          required String vorher,
          required String neuerBasename,
          required String nachher,
        }) async {
          var abgabedateiId = const AbgabedateiId('abgabedateiId');
          useCases.abgabe.add(
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            hochgeladeneAbgabedatei(
              id: abgabedateiId,
              name: vorher,
            ),
          ]));

          // Darauf warten, dass das Event oben ausgegeben wurde
          await pumpEventQueue();

          await bloc.renameFile('$abgabedateiId', neuerBasename);

          final name = useCases.dateiUmbenennenAufrufFuer(abgabedateiId);
          expect(
            name!.mitExtension,
            nachher,
            reason:
                'Wenn der "Basename" (Name ohne Extension) der Datei "$vorher" zu "$neuerBasename" umgeändert wird, dann sollte der neue Dateiname (mit Extension) "$nachher" sein.',
          );
        }

        void fuegeLokaleDateiHinzuUndSetzeId({
          required AbgabedateiId id,
          required String name,
        }) {
          final file = MockLocalFile(name: name);
          abgabedateiIdGenerator.gebeAbgabedateiIdZurueckFuerDateiMitNamen(
              id, name);
          bloc.addSubmissionFiles([file]);
        }

        test('Übernimmt abgegeben Status aus dem Abgabe Ersteller-Modell',
            () async {
          useCases.abgabe.add(erstelleAbgabenModelSnapshot(
              abgegeben: false, abgabedateien: []));

          useCases.abgabe.add(
              erstelleAbgabenModelSnapshot(abgegeben: true, abgabedateien: []));

          expect(bloc.pageView.map((pageView) => pageView.submitted),
              emitsInOrder([false, true]));
        });

        test(
            'Recorded einen Error, falls eine lokale Datei nicht zu einer Abgabedatei konvertiert werden kann',
            () async {
          final localFile = BrokenLocalFile();

          try {
            await bloc.addSubmissionFiles([localFile]);
            // ignore: empty_catches
          } catch (e) {}

          // Sichergehen, dass das hinzufügen fertig ist.
          await pumpEventQueue();

          expect(useCases.recordedError, true);
        });

        /// Momentan erlauben wir den Nutzer nur bei bereits hochgeladenen Dateien den Namen zu ändern.
        test('Dateinamen-Änderung hochladene Datei', () async {
          await testeDateiumbenennung(
            vorher: 'Meine-Datei.jpg',
            neuerBasename: 'Seite 1',
            nachher: 'Seite 1.jpg',
          );
        });

        test(
            'Beim Umbenennen des Dateinamens mit mehreren Extensions sollte sich alles bis auf die letzte Extension ändern',
            () async {
          await testeDateiumbenennung(
            vorher:
                'Screenshot_20200316_114301_com.android.chrome.android.chrome.jpg',
            neuerBasename: 'Seite 1',
            nachher: 'Seite 1.jpg',
          );
        });
        test(
            'Wenn beim Umbenennen ein Dateiname mit Extension eingegeben wird, dann wird die alte Extension einfach angehangen',
            () async {
          await testeDateiumbenennung(
            vorher: 'Meine-Datei.jpg',
            neuerBasename: 'NameMitExtension.pdf',
            nachher: 'NameMitExtension.pdf.jpg',
          );
        });

        test(
            'Eine Abgabe ist abgebar, wenn mindestens eine Datei erfolgreich hochgeladen wurde und vom Server wieder beim Client ankommt',
            () async {
          useCases.abgabe.add(erstelleAbgabenModelSnapshot(
              abgegeben: false, abgabedateien: []));

          var dateiname = 'gustav.pdf';
          var abgabedateiId = const AbgabedateiId('id1');
          useCases.abgabeprozessFortschrittFuerDateiMitName(
              Stream.value(
                  DateiUploadProzessFortschritt.erfolgreich(abgabedateiId)),
              dateiname);
          fuegeLokaleDateiHinzuUndSetzeId(id: abgabedateiId, name: dateiname);

          await bloc.pageView.firstWhere((view) => view.files
              .where(
                  (file) => file.status == FileViewStatus.successfullyUploaded)
              .isNotEmpty);

          /// Wir wollen sichergehen, dass die Abgabe vom Server wieder ankommt
          expect(bloc.submittable, emits(false));

          var abgabe =
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            hochgeladeneAbgabedatei(id: abgabedateiId, name: dateiname),
          ]);
          useCases.abgabe.add(abgabe);

          expect(bloc.pageView.map((view) => view.submittable),
              emitsThrough(true));
        });
        test(
            'Eine Abgabe ist nicht abgebar, wenn noch eine Datei am hochladen ist',
            () async {
          final abgabe =
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            hochgeladeneAbgabedatei(
              name: 'gustav.pdf',
              id: const AbgabedateiId('idH'),
            ),
          ]);
          useCases.abgabe.add(abgabe);

          var dateiname = 'bernd.pdf';
          var abgabedateiId = const AbgabedateiId('id');
          useCases.abgabeprozessFortschrittFuerDateiMitName(
              Stream.value(
                  DateiUploadProzessFortschritt.imGange(abgabedateiId, 0.22)),
              dateiname);
          fuegeLokaleDateiHinzuUndSetzeId(name: dateiname, id: abgabedateiId);

          await bloc.files.firstWhere((files) => files.length == 2);

          expect(bloc.submittable, emits(false));
        });

        test(
            'Eine Abgabe ist nicht abgebbar, falls diese schon abgegeben wurde',
            () {
          useCases.abgabe.add(
              erstelleAbgabenModelSnapshot(abgegeben: true, abgabedateien: []));

          expect(bloc.submittable, emits(false));
        });

        test(
            'Wenn eine Abgabe abgegeben wird, dann wird vom Bloc der AbgabeAbgeber mit der richtigen Id aufgerufen',
            () {
          var abgabe =
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            hochgeladeneAbgabedatei(),
          ]);
          useCases.abgabe.add(abgabe);

          bloc.veroeffentlicheAbgabe();

          expect(useCases.wurdeGebeAbMitIdAufgerufen(abgabeId), true);
        });

        /// Falls eine Datei aus der Datenbank entfernt wird, war es bisher so, dass
        /// der Nutzer die Datei immer noch als erfolgreich hochgeladen sah.
        /// So konnte es manchmal dazu kommen, dass man dachte, dass man eine Datei
        /// agibt, obwohl gar nicht mehr auf dem Server existiert.
        test(
            'Lokal hochgeladene Datei nicht mehr anzeigen, falls diese vom Backend einmal ankam aber dann von außen entfernt wurde.',
            () async {
          var dateiname1 = 'gustav.pdf';
          var dateiname2 = 'meier.mp3';
          var abgabedateiId1 = const AbgabedateiId('id1');
          var abgabedateiId2 = const AbgabedateiId('id2');

          fuegeLokaleDateiHinzuUndSetzeId(id: abgabedateiId1, name: dateiname1);
          fuegeLokaleDateiHinzuUndSetzeId(id: abgabedateiId2, name: dateiname2);

          var snapshot =
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            hochgeladeneAbgabedatei(id: abgabedateiId1, name: dateiname1),
            hochgeladeneAbgabedatei(id: abgabedateiId2, name: dateiname2),
          ]);
          useCases.abgabe.add(snapshot);

          // Bevor eine Datei hinzugefügt wird, wird schon eine leere View erstellt
          bloc.files.where((event) =>
              event.length == 2 &&
              event.every((element) =>
                  element.status == FileViewStatus.successfullyUploaded));

          final abgabeMitEntfernterDatei =
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            snapshot.abgabe!.abgabedateien.first,
          ]);
          useCases.abgabe.add(abgabeMitEntfernterDatei);

          expect(bloc.files.map((event) => event.length), emitsThrough(1));
        });
      });

      group('Datei-Tests', () {
        late HomeworkUserCreateSubmissionsBloc bloc;
        late MockAbgabendateiUseCases useCases;
        late MockAbgabedateiIdGenerator abgabedateiIdGenerator;
        late SingletonLocalFileSaver fileSaver;
        late DateTime Function() kriegeAktuelleZeit;

        setUp(() {
          useCases = MockAbgabendateiUseCases();
          abgabedateiIdGenerator = MockAbgabedateiIdGenerator();
          final abgabeId = AbgabeId(
              AbgabezielId.homework(const HomeworkId('ValidHomeworkId')),
              const UserId('ValidUserId'));
          fileSaver = SingletonLocalFileSaver();
          bloc = HomeworkUserCreateSubmissionsBloc(
            abgabeId,
            (_, __, {context}) async {},
            fileSaver,
            useCases,
            useCases.abgabe,
            useCases,
            useCases,
            useCases,
            Stream.value(DateTime(2020, 10, 02)),
            () => kriegeAktuelleZeit(),
            generiereAbgabedateiId:
                abgabedateiIdGenerator.generiereAbgabedateiId,
            abgabefristUeberwachungsfrequenz: const Duration(milliseconds: 10),
          );
          kriegeAktuelleZeit = () => DateTime(2020, 04, 30, 11, 30);
          useCases.abgabe.add(ErstellerAbgabeModelSnapshot.nichtExistent());
        });

        void fuegeLokaleDateiHinzuUndSetzeId({
          required AbgabedateiId id,
          required String name,
        }) {
          final file = MockLocalFile(name: name);
          abgabedateiIdGenerator.gebeAbgabedateiIdZurueckFuerDateiMitNamen(
              id, name);
          bloc.addSubmissionFiles([file]);
        }

        Future<FileView> getFirstFileView() async {
          final pageView = await bloc.pageView
              .firstWhere((element) => element.files.isNotEmpty);
          return pageView.files.first;
        }

        test('Datei-View-Attribute - Lokale Datei', () async {
          final files = MockLocalFile(
              name: 'datei.pdf',
              path: '/eine/datei.pdf',
              sizeInBytes: 1234,
              mimeType: MimeType.any);
          var abgabedateiId = const AbgabedateiId('testId');
          abgabedateiIdGenerator.gebeAbgabedateiIdZurueckFuerDateiMitNamen(
              abgabedateiId, 'datei.pdf');

          bloc.addSubmissionFiles([files]);

          final fileView = await getFirstFileView();

          expect(fileView.name, 'datei.pdf');
          expect(fileView.id, '$abgabedateiId');
          expect(fileView.basename, 'datei');
          expect(fileView.extentionName, 'pdf');
          expect(fileView.fileFormat, FileFormat.pdf);
          expect(fileView.path, '/eine/datei.pdf');
          expect(fileView.status, FileViewStatus.unitiated);
          expect(fileView.uploadProgress, null);
          expect(fileView.downloadUrl, null);
        });

        test('Datei-View-Attribute - Hochgeladene Datei', () async {
          useCases.abgabe.add(
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            HochgeladeneAbgabedatei(
              id: const AbgabedateiId('abgabedateiId'),
              name: Dateiname('file.pdf'),
              groesse: Dateigroesse(12345),
              downloadUrl: DateiDownloadUrl('https://some-url.com'),
              erstellungsdatum: DateTime(2020, 02, 02),
            )
          ]));

          final fileView = await getFirstFileView();

          expect(fileView.name, 'file.pdf');
          expect(fileView.basename, 'file');
          expect(fileView.extentionName, 'pdf');
          expect(fileView.fileFormat, FileFormat.pdf);
          expect(fileView.path, null);
          expect(fileView.status, FileViewStatus.successfullyUploaded);
          expect(fileView.uploadProgress, null);
          expect(fileView.downloadUrl, 'https://some-url.com');
        });

        test('File-Format - mp3', () async {
          final files = MockLocalFile(
              name: 'datei.mp3',
              path: '/eine/datei.mp3',
              sizeInBytes: 1234,
              mimeType: MimeType.any);
          bloc.addSubmissionFiles([files]);

          final fileView = await getFirstFileView();

          expect(fileView.fileFormat, FileFormat.audio);
        });

        test('File-Format - unknown', () async {
          final files = MockLocalFile(
              name: 'datei.gibsNicht',
              path: '/eine/datei.gibsNicht',
              sizeInBytes: 1234,
              mimeType: MimeType.any);
          bloc.addSubmissionFiles([files]);

          final fileView = await getFirstFileView();

          expect(fileView.fileFormat, FileFormat.unknown);
        });

        test(
            'Gibt Datei-Uploadstatus zurück, wenn eine lokale Datei hochgeladen wird',
            () async {
          // ARRANGE
          var dateiname = 'gustav.pdf';
          final uploadProzess =
              BehaviorSubject<DateiUploadProzessFortschritt>();
          useCases.abgabeprozessFortschrittFuerDateiMitName(
            uploadProzess,
            dateiname,
          );

          final fileStream = bloc.pageView
              .map((event) => event.files.isEmpty ? null : event.files.single);
          final queue = StreamQueue(fileStream);
          // Bevor eine Datei hinzugefügt wird, wird schon eine leere View erstellt
          await queue.skip(1);

          // ACT

          bloc.addSubmissionFiles([MockLocalFile(name: dateiname)]);

          // ASSERT

          var fileView = (await queue.next)!;
          expect(fileView.status, FileViewStatus.unitiated);

          uploadProzess.add(
            DateiUploadProzessFortschritt.imGange(
                const AbgabedateiId('dad'), 0.2),
          );

          fileView = (await queue.next)!;
          expect(fileView.status, FileViewStatus.uploading);
          expect(fileView.uploadProgress, 0.2);

          uploadProzess.add(DateiUploadProzessFortschritt.erfolgreich(
              const AbgabedateiId('dad')));
          fileView = (await queue.next)!;
          expect(fileView.status, FileViewStatus.successfullyUploaded);
          expect(fileView.uploadProgress, null);

          uploadProzess.add(DateiUploadProzessFortschritt.fehlgeschlagen(
              const AbgabedateiId('dad')));
          fileView = (await queue.next)!;
          expect(fileView.uploadProgress, null);
        });

        test(
            'Gibt die LocalFiles unter der jeweiligen Id an den Speicher weiter',
            () async {
          var abgabedateiId1 = const AbgabedateiId('id1');
          var abgabedateiId2 = const AbgabedateiId('id2');
          var name1 = 'Datei1.pdf';
          var name2 = 'Datei2.pdf';
          fuegeLokaleDateiHinzuUndSetzeId(id: abgabedateiId1, name: name1);
          fuegeLokaleDateiHinzuUndSetzeId(id: abgabedateiId2, name: name2);

          /// Weil in der Methode async Sachen ausgeführt werden müssen wir warten,
          /// bis die Dateien komplett "verarbeitet" wurden.
          await bloc.files.firstWhere((files) => files.length == 2);

          expect(fileSaver.getFile('$abgabedateiId1'), isNotNull);
          expect(fileSaver.getFile('$abgabedateiId2'), isNotNull);
        });

        test(
            'Regressions-Test: Wenn eine Datei bereits hochgeladen wurde, dann sollte bei den anderen nur lokalen, noch am hochladenen Dateien noch der richtige Upload-Fortschritt angezeigt werden',
            () async {
          useCases.abgabe.add(
            erstelleAbgabenModelSnapshot(
                abgegeben: false,
                abgabedateien: [hochgeladeneAbgabedatei(name: 'name.pdf')]),
          );

          var hochladeneDateiName = 'abc.mp3';
          var abgabedateiId = const AbgabedateiId('id2');
          useCases.abgabeprozessFortschrittFuerDateiMitName(
            Stream.value(
                DateiUploadProzessFortschritt.imGange(abgabedateiId, 0.2)),
            hochladeneDateiName,
          );
          fuegeLokaleDateiHinzuUndSetzeId(
            name: hochladeneDateiName,
            id: abgabedateiId,
          );

          expect(
              bloc.files.where((files) => files.length == 2).map(
                    (files) => files
                        .singleWhere((file) => file.name == 'abc.mp3')
                        .status,
                  ),
              emitsInOrder(
                  [FileViewStatus.unitiated, FileViewStatus.uploading]));
        });

        test(
            'Schreibt hinter den Dateinamen einer Datei "(1)", "(2)" etc, wenn bereits eine lokale oder hochgeladene Datei mit dem selben Namen hinzugefügt wurde',
            () async {
          var abgabedateiId = const AbgabedateiId('id');
          var name = 'hallo.pdf';
          useCases.abgabe.add(
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            hochgeladeneAbgabedatei(id: abgabedateiId, name: name),
          ]));
          // Warten bis die Abgabe oben ankommt
          await pumpEventQueue();

          final f1 = MockLocalFile(name: 'hallo.pdf');
          final f2 = MockLocalFile(name: 'hallo.pdf');

          bloc.addSubmissionFiles([f1]);

          /// Ohne kleinen Delay funktioniert das ganze noch nicht,
          /// was aber nicht schlimm sein sollte, da es kein Nutzer schafft eine
          /// neue einzelne Datei so schnell hinzuzufügen.
          await pumpEventQueue(times: 100);
          bloc.addSubmissionFiles([f2]);

          final namesStream = bloc.files
              .map((files) => files.map((e) => e.name))
              .where((names) => names.length == 3);

          await expectLater(
              namesStream,
              emits(unorderedEquals(
                [
                  'hallo.pdf',
                  'hallo (1).pdf',
                  'hallo (2).pdf',
                ],
              )));

          expect(useCases.wurdeAbgabedateiHochladenMitNamen('hallo (1).pdf'),
              true);
          expect(useCases.wurdeAbgabedateiHochladenMitNamen('hallo (2).pdf'),
              true);
        });
        test(
            'Schreibt hinter den Dateinamen einer Datei "(1)", "(2)" etc, wenn mehrere Dateien mit dem selben Namen hinzugefügt werden',
            () {
          final f1 = MockLocalFile(name: 'selberDateiname.pdf');
          final f2 = MockLocalFile(name: 'selberDateiname.pdf');
          final f3 = MockLocalFile(name: 'selberDateiname.pdf');
          final f4 = MockLocalFile(name: 'nochmal.mp3');
          final f5 = MockLocalFile(name: 'nochmal.mp3');

          var files = [f1, f2, f3, f4, f5];
          bloc.addSubmissionFiles(files);

          final names = bloc.files
              .map((files) => files.map((e) => e.name))
              .where((event) => event.length == files.length);

          expect(
              names,
              emits([
                'selberDateiname.pdf',
                'selberDateiname (1).pdf',
                'selberDateiname (2).pdf',
                'nochmal.mp3',
                'nochmal (1).mp3',
              ]));
        });

        test(
            'Wenn eine lokale Datei hochgeladen wurde und diese nun auch im Abgabe-Stream vorkommt, dann werden die Informationen aus Firestore den lokalen vorgezogen.',
            () async {
          var dateiname = 'gustav.pdf';
          const id = AbgabedateiId('gustav.pdf');
          useCases.abgabeprozessFortschrittFuerDateiMitName(
            Stream.value(DateiUploadProzessFortschritt.erfolgreich(id)),
            dateiname,
          );

          fuegeLokaleDateiHinzuUndSetzeId(id: id, name: dateiname);

          useCases.abgabe.add(
            erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
              hochgeladeneAbgabedatei(
                id: id,
                name: dateiname,
              ),
            ]),
          );

          final firstFileView = bloc.files
              .where((files) => files.isNotEmpty)
              .map((event) => event.first);

          final view = await firstFileView
              .firstWhere((file) => file.downloadUrl != null);

          expect(view.downloadUrl, 'https://some-url.com');
          expect(view.status, FileViewStatus.successfullyUploaded);

          expect(
            bloc.files.map((event) => event.length),
            neverEmits(
              greaterThan(1),
            ),
          );
          bloc.dispose();
        });

        test(
            'Bloc wirft FileConversionException-Error, wenn ein LocalFile nicht in eine Abgabedatei konvertiert werden kann.',
            () {
          final broken = BrokenLocalFile();

          expect(() => bloc.addSubmissionFiles([broken]),
              throwsA(isA<FileConversionException>()));
        });

        /// Hier geht es darum, dass die App nicht für eine Datei, die nur lokal ist,
        /// den Server bittet diese (für den Server unbekannte) Datei zu löschen.
        test(
            'Wenn eine Datei gelöscht werden soll, die nicht erfolgreich hochgeladen werden konnte, dann wird das nur lokal gemacht',
            () async {
          var abgabedateiId = const AbgabedateiId('id');
          var name = 'file.pdf';
          useCases.abgabeprozessFortschrittFuerDateiMitName(
              Stream.value(
                  DateiUploadProzessFortschritt.fehlgeschlagen(abgabedateiId)),
              name);
          fuegeLokaleDateiHinzuUndSetzeId(name: name, id: abgabedateiId);

          await bloc.files
              .where((files) =>
                  files.isNotEmpty &&
                  files.first.status == FileViewStatus.failed)
              .first;

          bloc.removeSubmissionFile('$abgabedateiId');

          expect(bloc.pageView.map((view) => view.files), emitsThrough([]));
          expect(useCases.wurdeLoescheDateiAufgerufen, false);
        });

        test('Löschen hochgeladene Datei', () async {
          var abgabedateiId = const AbgabedateiId('fileId');
          useCases.abgabe.add(
            erstelleAbgabenModelSnapshot(
              abgegeben: false,
              abgabedateien: [hochgeladeneAbgabedatei(id: abgabedateiId)],
            ),
          );

          await bloc.files.firstWhere((files) => files.isNotEmpty);

          bloc.removeSubmissionFile('$abgabedateiId');

          // Das Löschen von einer Datei auf dem Server kann dauern
          await expectLater(
            bloc.files.map((files) => files.isEmpty),
            emitsThrough(true),
          );
          expect(useCases.wurdeLoescheDateiAufgerufenMit(abgabedateiId), true);
        });

        test(
            'zeigt Abgabe als abgegeben, wenn das Abgaben-Model aus Firestore das sagt',
            () async {
          final abgabe =
              erstelleAbgabenModelSnapshot(abgegeben: true, abgabedateien: []);
          useCases.abgabe.add(abgabe);
          final abgabe2 =
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: []);
          useCases.abgabe.add(abgabe2);

          expect(
            /// Das erste Event wird geskippt, weil es das "Standard-Event" ist,
            /// solange die Daten aus Firestore noch nicht angekommen sind.
            bloc.pageView.skip(1).map((event) => event.submitted),
            emitsInOrder([
              true,
              false,
            ]),
          );
        });

        test(
            'Löschen lokale Datei die hochgeladen wurde lokal und auf dem Server',
            () async {
          var abgabedateiId = const AbgabedateiId('id');
          var name = 'file.pdf';
          useCases.abgabeprozessFortschrittFuerDateiMitName(
            Stream.value(
                DateiUploadProzessFortschritt.erfolgreich(abgabedateiId)),
            name,
          );
          fuegeLokaleDateiHinzuUndSetzeId(id: abgabedateiId, name: name);

          useCases.abgabe.add(
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            hochgeladeneAbgabedatei(
              id: abgabedateiId,
              name: name,
            ),
          ]));

          await bloc.pageView.firstWhere((pageView) =>
              pageView.files.isNotEmpty &&
              pageView.files.first.status ==
                  FileViewStatus.successfullyUploaded);

          bloc.removeSubmissionFile('$abgabedateiId');

          await expectLater(
              bloc.files.map((files) => files.isEmpty), emitsThrough(true));
          expect(useCases.wurdeLoescheDateiAufgerufenMit(abgabedateiId), true);
        });
      });

      group('Abgabzeitpunkt-Status', () {
        late HomeworkUserCreateSubmissionsBloc bloc;
        late BehaviorSubject<DateTime> abgabezeitpunktStream;
        late DateTime Function() kriegeAktuelleZeit;
        late MockAbgabendateiUseCases useCases;
        AbgabeId abgabeId;

        setUp(() {
          abgabezeitpunktStream = BehaviorSubject<DateTime>();
          useCases = MockAbgabendateiUseCases();
          abgabeId = AbgabeId(
            AbgabezielId.homework(const HomeworkId('ValidHomeworkId')),
            const UserId('ValidUserId'),
          );
          final localFileSaver = SingletonLocalFileSaver();
          bloc = HomeworkUserCreateSubmissionsBloc(
            abgabeId,
            (_, __, {context}) async {},
            localFileSaver,
            useCases,
            useCases.abgabe,
            useCases,
            useCases,
            useCases,
            abgabezeitpunktStream,
            () => kriegeAktuelleZeit(),
            abgabefristUeberwachungsfrequenz: const Duration(milliseconds: 10),
          );

          useCases.abgabe.add(
            erstelleAbgabenModelSnapshot(abgegeben: true, abgabedateien: []),
          );
        });

        tearDown(() async {
          await abgabezeitpunktStream.close();
        });

        test('Die Dateien werden nach hinzufuegedatum sortiert.', () async {
          final now = clock.now();
          abgabezeitpunktStream.add(now.add(const Duration(days: 20)));
          kriegeAktuelleZeit = () => clock.now();

          useCases.abgabe.add(
              erstelleAbgabenModelSnapshot(abgegeben: false, abgabedateien: [
            hochgeladeneAbgabedatei(
              name: 'first.pdf',
              erstellungsdatum: now.subtract(const Duration(days: 3)),
            ),
            hochgeladeneAbgabedatei(
              name: 'fourth.pdf',
              erstellungsdatum: now.add(const Duration(hours: 3)),
            ),
          ]));

          final second = MockLocalFile(name: 'second.mp4');
          final third = MockLocalFile(name: 'third.lol');

          bloc.addSubmissionFiles([second, third]);

          await bloc.pageView
              .firstWhere((pageView) => pageView.files.length == 4);

          final names = bloc.pageView.map(
              (pageView) => pageView.files.map((file) => file.name).toList());

          expect(
            names,
            emits(orderedEquals(
              ['first.pdf', 'second.mp4', 'third.lol', 'fourth.pdf'],
            )),
          );
        });

        test(
            'Falls der Abgabezeitpunkt nach der aktuellen Zeit ist, sollte die View ein "vor Abgabezeitpunk"-State haben',
            () {
          abgabezeitpunktStream.add(DateTime(2020, 02, 02));
          kriegeAktuelleZeit = () => DateTime(2020, 01, 01);

          expect(bloc.deadlineState,
              emitsInOrder([SubmissionDeadlineState.beforeDeadline]));
        });
        test(
            'Falls der Abgabezeitpunkt vor der aktuellen Zeit ist, sollte die View ein "nach Abgabezeitpunk"-State haben',
            () {
          abgabezeitpunktStream.add(DateTime(2020, 01, 12));
          kriegeAktuelleZeit = () => DateTime(2020, 05, 10);

          expect(bloc.deadlineState,
              emitsInOrder([SubmissionDeadlineState.afterDeadline]));
        });
        test(
            'Falls der Abgabezeitpunkt gleich der aktuellen Zeit ist, sollte eine leere PageView mit "gleich Abgabezeitpunkt"-State kommen',
            () {
          final dateTime = DateTime(2020, 04, 30);
          abgabezeitpunktStream.add(dateTime);
          kriegeAktuelleZeit = () => dateTime;

          expect(bloc.deadlineState,
              emitsInOrder([SubmissionDeadlineState.onDeadline]));
        });
        test(
            'Wechselt Abgabezeitpunkt-State, wenn der Abgabezeitpunkt sich ändert',
            () async {
          abgabezeitpunktStream.add(DateTime(2020, 04, 30, 12, 30));
          kriegeAktuelleZeit = () => DateTime(2020, 04, 30, 11, 30);
          abgabezeitpunktStream.add(DateTime(2020, 04, 30, 10, 30));

          expect(
              bloc.deadlineState,
              emitsInOrder([
                SubmissionDeadlineState.beforeDeadline,
                SubmissionDeadlineState.afterDeadline
              ]));
        });
      });
    },
  );
}

extension on HomeworkUserCreateSubmissionsBloc {
  Stream<SubmissionDeadlineState> get deadlineState =>
      pageView.map((event) => event.deadlineState);
  Stream<List<FileView>> get files => pageView.map((event) => event.files);
  Stream<bool> get submittable => pageView.map((view) => view.submittable);
}

HochgeladeneAbgabedatei hochgeladeneAbgabedatei({
  AbgabedateiId? id,
  String? name,
  DateTime? erstellungsdatum,
}) {
  return HochgeladeneAbgabedatei(
    id: id ?? AbgabedateiId(randomAlpha(10)),
    name: Dateiname(name ?? 'meine-datei-${randomAlpha(5)}.pdf'),
    groesse: Dateigroesse(12345),
    downloadUrl: DateiDownloadUrl('https://some-url.com'),
    // Sollte letzte sein (auch wenn es eigentlich nicht sein)
    erstellungsdatum: erstellungsdatum ?? clock.now(),
  );
}

ErstellerAbgabeModelSnapshot erstelleAbgabenModelSnapshot(
    {required bool abgegeben,
    required List<HochgeladeneAbgabedatei> abgabedateien}) {
  return ErstellerAbgabeModel(
          abgabeId: AbgabeId(
              AbgabezielId.homework(const HomeworkId('ValidHomeworkId')),
              const UserId('ValidUserId')),
          abgegebenUm: abgegeben ? clock.now() : null,
          abgabedateien: abgabedateien)
      .toSnapshot();
}

class MockAbgabedateiIdGenerator {
  final _namenIdsMap = <String, AbgabedateiId>{};
  void gebeAbgabedateiIdZurueckFuerDateiMitNamen(
      AbgabedateiId id, String name) {
    _namenIdsMap[name] = id;
  }

  AbgabedateiId generiereAbgabedateiId(LocalFile datei) {
    return _namenIdsMap[datei.getName()] ??
        AbgabedateiId(AutoIdGenerator.autoId());
  }
}

class MockAbgabendateiUseCases
    implements
        AbgabedateiUploader,
        AbgabendateiLoescher,
        AbgabendateiUmbenenner,
        AbgabeVeroeffentlicher {
  final abgabe = BehaviorSubject<ErstellerAbgabeModelSnapshot>();

  final _mockFortschritt = <String, Stream<DateiUploadProzessFortschritt>>{};

  void abgabeprozessFortschrittFuerDateiMitName(
      Stream<DateiUploadProzessFortschritt> fortschritt, String name) {
    _mockFortschritt[name] = fortschritt;
  }

  final _ladeAbgabedateiHochAufrufe = <Dateiname>{};

  bool wurdeAbgabedateiHochladenMitNamen(String name) {
    return _ladeAbgabedateiHochAufrufe.contains(Dateiname(name));
  }

  @override
  Stream<DateiUploadProzessFortschritt> ladeAbgabedateiHoch(
      DateiHinzufuegenCommand befehl) {
    _ladeAbgabedateiHochAufrufe.add(befehl.dateiname);
    return _mockFortschritt[befehl.dateiname.mitExtension] ??
        const Stream.empty();
  }

  bool get wurdeLoescheDateiAufgerufen => _aufrufe.isNotEmpty;
  final _aufrufe = <AbgabedateiId>{};
  bool wurdeLoescheDateiAufgerufenMit(AbgabedateiId id) {
    return _aufrufe.contains(id);
  }

  @override
  Future<void> loescheDatei(AbgabedateiId id) async {
    _aufrufe.add(id);
    final snap = abgabe.value;
    // ignore: no_leading_underscores_for_local_identifiers
    final _abgabe = snap.abgabe!;
    _abgabe.abgabedateien.removeWhere((datei) => datei.id == id);
    abgabe.add(_abgabe.toSnapshot());
  }

  bool recordedError = false;
  Future<void> recordError(dynamic exception, StackTrace stack,
      {dynamic context}) async {
    recordedError = true;
    return;
  }

  Dateiname? dateiUmbenennenAufrufFuer(AbgabedateiId id) {
    return _nenneDateiUmAufrufe[id];
  }

  final _nenneDateiUmAufrufe = <AbgabedateiId, Dateiname>{};
  @override
  Future<void> nenneDateiUm(AbgabedateiId id, Dateiname neuerName) async {
    _nenneDateiUmAufrufe[id] = neuerName;
  }

  bool wurdeGebeAbMitIdAufgerufen(AbgabeId abgabeId) {
    return _veroeffentlichenSet.contains(abgabeId);
  }

  final _veroeffentlichenSet = <AbgabeId>{};

  @override
  Future<void> veroeffentlicheAbgabe(AbgabeId abgabeId) async {
    _veroeffentlichenSet.add(abgabeId);
  }
}

int _counter = 0;

class BrokenLocalFile implements MockLocalFile {
  @override
  MimeType get mimeType => throw Exception('A dummy exception for testing');

  @override
  String get name => throw Exception('A dummy exception for testing');

  @override
  String get path => throw Exception('A dummy exception for testing');

  @override
  int get sizeInBytes => throw Exception('A dummy exception for testing');

  @override
  Uint8List getData() {
    throw Exception('A dummy exception for testing');
  }

  @override
  File getFile() {
    throw Exception('A dummy exception for testing');
  }

  @override
  String getName() {
    throw Exception('A dummy exception for testing');
  }

  @override
  String getPath() {
    throw Exception('A dummy exception for testing');
  }

  @override
  int getSizeBytes() {
    throw Exception('A dummy exception for testing');
  }

  @override
  MimeType getType() {
    throw Exception('A dummy exception for testing');
  }

  @override
  set mimeType(MimeType mimeType) {}

  @override
  set name(String name) {}

  @override
  set path(String path) {}

  @override
  set sizeInBytes(int sizeInBytes) {}
}

class MockLocalFile extends LocalFile {
  late String name;
  late String path;
  late int sizeInBytes;
  late MimeType mimeType;

  MockLocalFile({
    String? name,
    String? path,
    int? sizeInBytes,
    MimeType? mimeType,
  }) {
    this.name = name ?? 'MockFileName${_counter++}';
    this.path = path ?? '/ABc/aw${_counter++}dw/file.pdf';
    this.sizeInBytes = sizeInBytes ?? 241421;
    this.mimeType = mimeType ?? MimeType.any;
  }

  @override
  Uint8List getData() {
    throw UnimplementedError();
  }

  @override
  File getFile() {
    throw UnimplementedError();
  }

  @override
  String getName() {
    return name;
  }

  @override
  String getPath() {
    return path;
  }

  @override
  int getSizeBytes() {
    return sizeInBytes;
  }

  @override
  MimeType getType() {
    return mimeType;
  }
}
