// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:abgabe_client_lib/src/erstellung/datei_upload_prozess.dart';
import 'package:abgabe_client_lib/src/erstellung/local_file_saver.dart';
import 'package:abgabe_client_lib/src/models/models.dart';
import 'package:abgabe_http_api/api/abgabedatei_api.dart';

import 'package:crash_analytics/crash_analytics.dart';
import 'package:files_basics/local_file.dart';
import 'package:filesharing_logic/file_uploader.dart';

import 'uploader/abgabedatei_uploader.dart';
import 'use_cases/abgabedatei_hinzufueger.dart';

DateTime _lastUploaded = DateTime.now();

class CloudStorageAbgabedateiUploader extends AbgabedateiUploader {
  final FileUploader fileUploader;
  final SingletonLocalFileSaver localFileSaver = SingletonLocalFileSaver();
  final AbgabedateiApi abgabedateiApi;
  final CrashAnalytics crashAnalytics;
  final CloudStorageBucket bucket;
  final AbgabedateiHinzufueger abgabedateiHinzufueger;

  CloudStorageAbgabedateiUploader(this.fileUploader, this.abgabedateiApi,
      this.crashAnalytics, this.bucket, this.abgabedateiHinzufueger);

  /// Lädt den Dateiinhalt der hinzuzufügenden Datei in Cloud Storage hoch und
  /// fügt nach erfolgreichem Upload die Datei-Referenz zu der Abgabe hinzu.
  ///
  /// Der [DateiUploadProzessFortschritt] wird erst als "erfolgreich" makiert,
  /// falls nach erfolgerichem Upload die Dateireferenz auch erfolgreich zur
  /// Abgabe hinzugefügt wird.
  /// Hierbei kann es passieren, dass der Fortschritt des Uploads zwar schon bei
  /// 100% ist, aber der Status noch nicht erfolgreich ist, weil das hinzufügen
  /// der Referenz noch nicht fertig ist.
  @override
  Stream<DateiUploadProzessFortschritt> ladeAbgabedateiHoch(
      DateiHinzufuegenCommand befehl) async* {
    await for (final upload in _ladeDateiZuCloudStorageHoch(befehl)) {
      if (upload.status == UploadStatusEnum.erfolgreich) {
        /// Der "Datei hinzufügen"-Prozess ist erst wirklich fertig, wenn wir
        /// auch die Datei(referenz) zu Firestore hinzugefügt haben.
        try {
          /// Hier wird geguckt, dass zwischen dem Hinzufügen der Datei zu der
          /// Abgabe immer ein gewisser Zeit-Abstand liegt.
          /// Das liegt daran, dass im Backend Transaktionen momentan noch nicht
          /// ganz implementiert sind und es bei zu vielen schnellen Abfragen
          /// passieren kann, dass das hinzufügen einer Datei "überschrieben"
          /// also sozusagen rückgängig gemacht wird, wenn die Anfragen parallel
          /// verarbeitet werden.
          while (DateTime.now().difference(_lastUploaded).abs() <
              const Duration(milliseconds: 900)) {
            await Future.delayed(const Duration(milliseconds: 300));
          }
          _lastUploaded = DateTime.now();
          await _fuegeAbgabedateireferenzZuAbgabeHinzu(befehl);
        } catch (e, s) {
          await _logAbgabedateireferenzHinzufuegeError(e, s);
          yield DateiUploadProzessFortschritt.fehlgeschlagen(befehl.dateiId);
          continue;
        }
        yield upload;
      } else {
        yield upload;
      }
    }
  }

  Future _logAbgabedateireferenzHinzufuegeError(e, StackTrace s) async {
    const msg =
        'Konnte nicht die Datei-Referenz zu dem Abgabe-Dokument hinzufügen.';
    log('$msg $e', error: e, stackTrace: s);
    crashAnalytics.log(msg);
    await crashAnalytics.recordError(e, s);
  }

  Future _fuegeAbgabedateireferenzZuAbgabeHinzu(
      DateiHinzufuegenCommand befehl) async {
    await abgabedateiHinzufueger.fuegeAbgabedateiHinzu(befehl);
  }

  Stream<DateiUploadProzessFortschritt> _ladeDateiZuCloudStorageHoch(
      DateiHinzufuegenCommand befehl) async* {
    final dateiId = befehl.dateiId;
    final localFile = localFileSaver.getFile(dateiId.toString()).value;
    // Der Name wird bei den Abgaben z.B. bei einer bereits vorhandenen Datei
    // mit dem selben Namen ungeändert.
    final nameCorrectedLocalFile =
        NameChangingLocalFileWrapper(localFile, '${befehl.dateiname}');
    // Sollte das hier gemacht werden?
    final abgabenzielId = befehl.abgabeId.abgabenzielId;
    final nutzerId = befehl.abgabeId.nutzerId;
    final pfad =
        bucket.lokalerPfad('submissions/$abgabenzielId/$nutzerId/$dateiId');
    log('cloudStoragePath: $pfad');

    final task = await fileUploader.uploadFileToStorage(
      pfad,
      befehl.abgeberId.toString(),
      nameCorrectedLocalFile,

      /// 31536000 - ein Jahr, Eine Datei kann sich momentan nicht ändern.
      /// Falls vom Client die gleiche Datei mit selben Namne hochgeladen werden
      /// würde, dann hätte diese immer noch eine andere Id, wäre also nicht
      /// die gleiche Datei.
      /// Cache-Control: private - Nur der Konsument darf die Antwort cachen,
      /// kein Mittelmann (z.B. Server) dazwischen. Unsicher ob das die beste
      /// Vorgehensweise ist, wir spielen aber lieber erstmal save ;)
      cacheControl: 'Cache-Control: private, max-age=31536000',
    );

    await for (var uploadEvent in task.events) {
      final totalBytes = uploadEvent.snapshot.totalByteCount;
      final uploadedBytes = uploadEvent.snapshot.bytesTransferred;
      final prozentHochgeladen = uploadedBytes / totalBytes;
      final prozentHochgeladenClamp = prozentHochgeladen.clamp(0, 1).toDouble();

      switch (uploadEvent.type) {
        case UploadTaskEventType.error:
          yield DateiUploadProzessFortschritt.fehlgeschlagen(dateiId);
          continue;
        // Momentan kann man noch nicht pausieren
        case UploadTaskEventType.paused:
        case UploadTaskEventType.running:
          yield DateiUploadProzessFortschritt.imGange(
            dateiId,
            prozentHochgeladenClamp,
          );
          continue;
        case UploadTaskEventType.success:
          yield DateiUploadProzessFortschritt.erfolgreich(dateiId);
          continue;
        case UploadTaskEventType.canceled:
          throw UnimplementedError(
              'Cancel an upload has not been implemented yet.');
      }

      throw UnimplementedError('Type: ${uploadEvent.type} unimplementiert.');
    }
  }
}

class NameChangingLocalFileWrapper extends LocalFile {
  final LocalFile _localFile;
  final String _name;

  NameChangingLocalFileWrapper(this._localFile, this._name);

  @override
  dynamic getData() {
    return _localFile.getData();
  }

  @override
  dynamic getFile() {
    return _localFile.getFile();
  }

  @override
  String getName() {
    return _name;
  }

  @override
  String getPath() {
    return _localFile.getPath();
  }

  @override
  int getSizeBytes() {
    return _localFile.getSizeBytes();
  }

  @override
  MimeType getType() {
    return _localFile.getType();
  }
}
