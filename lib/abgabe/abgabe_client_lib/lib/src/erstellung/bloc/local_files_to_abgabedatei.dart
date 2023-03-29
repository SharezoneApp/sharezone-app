// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:abgabe_client_lib/src/erstellung/lokale_abgabedatei.dart';

import 'package:files_basics/local_file.dart';

import 'homework_user_submissions_bloc.dart';
import 'lokale_abgabedatei_factory.dart';

class LocalFileAbgabedateiKonvertierer {
  final ErrorRecorder _recordError;
  final LokaleAbgabedateiFactory _lokaleAbgabedateiFactory;

  LocalFileAbgabedateiKonvertierer(
    this._lokaleAbgabedateiFactory,
    this._recordError,
  );

  /// Versucht die [localFiles] in [LokaleAbgabedatei] umzuwandeln.
  LocalFilesConversionResult konvertiereLocalFiles(List<LocalFile> localFiles) {
    final convertedFiles = <LokaleAbgabedatei>[];
    final unconvertableFiles = <LocalFile>[];

    /// Versuche alle LocalFiles in Abgabedateien umzuwandeln
    for (final localFile in localFiles) {
      try {
        final datei = _lokaleAbgabedateiFactory.vonLocalFile(localFile);
        convertedFiles.add(datei);
      } catch (e, s) {
        unconvertableFiles.add(localFile);
        var msg =
            'LocalFile: $localFile konnte nicht zu einer LokaleAbgabedatei konvertiert werden: $e.';
        log(msg);
        _recordError(e, s);
      }
    }

    return LocalFilesConversionResult(convertedFiles, unconvertableFiles);
  }
}

class LocalFilesConversionResult {
  /// Jede [LokaleAbgabedatei], welche erfolgreich von einer [LocalFile] umgewandelt
  /// werden konnten.
  final List<LokaleAbgabedatei> konvertierteDateien;

  /// Jede [LocalFile], die nicht in eine [LokaleAbgabedatei] umgewandelt werden
  /// konnte.
  /// Das könnte möglicherweise passieren, falls ein im Dateisystem valider Name
  /// nicht ein gültiger [Dateiname] ist. Wir sind uns nicht sicher welche
  /// Garantien für Dateien bei welchem Gerät wie herrschen.
  final List<LocalFile> unkonvertierbareDateien;

  bool get hatUnkonvertierteDateien => unkonvertierbareDateien.isNotEmpty;

  LocalFilesConversionResult(
      this.konvertierteDateien, this.unkonvertierbareDateien);
}
