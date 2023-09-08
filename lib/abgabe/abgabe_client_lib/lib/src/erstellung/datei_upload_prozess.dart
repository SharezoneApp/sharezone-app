// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:common_domain_models/common_domain_models.dart';

enum AbgabenStatus {
  /// Der Abgabenstart wird hochgeladen
  wirdGestartet,

  /// Der Abgabenstart wurde hochgeladen und das Erstellungszeitraum der
  /// Abgabe ist offen. Es können Dateien momentan im Upload sein, müssen aber
  /// nicht.
  inErstellung,

  /// Die Abgabe ist fehlgeschlagen, weil das Erstellungszeitraum für die Abgabe
  /// überschritten wurde.
  /// Das bedeutet, dass die alte Abgabe nichtig ist und eine neue Abgabe
  /// gemacht werden muss.
  ausgelaufen,

  /// Es wurde für die Abgabe mindestens eine Datei erfolgreich hochgeladen.
  /// Das heißt nicht, dass die Abgabe abgeschlossen sein muss, diese kann immer
  /// noch im Erstellungszeitraum liegen.
  erfolgreich,
}

// Erstellungszeitraum

enum UploadStatusEnum { erfolgreich, imGange, fehlgeschlagen }

class DateiUploadProzessFortschritt {
  final AbgabedateiId dateiId;
  double? fortschrittInProzent;
  final UploadStatusEnum status;

  DateiUploadProzessFortschritt.fehlgeschlagen(this.dateiId)
      : status = UploadStatusEnum.fehlgeschlagen;

  DateiUploadProzessFortschritt.erfolgreich(this.dateiId)
      : status = UploadStatusEnum.erfolgreich;

  /// Falls ein Upload im Gange ist muss ein gültiger fortschritt in Prozent sein.
  /// Null ist im diesem Falle nicht zulässig
  DateiUploadProzessFortschritt.imGange(
      this.dateiId, double fortschrittInProzent)
      : status = UploadStatusEnum.imGange,
        // ignore: prefer_initializing_formals
        fortschrittInProzent = fortschrittInProzent {
    if (fortschrittInProzent < 0 || fortschrittInProzent > 1) {
      throw ArgumentError('Ungültiger Fortschritt: $fortschrittInProzent');
    }
  }

  @override
  String toString() {
    return '$runtimeType(dateiId: $dateiId, status: $status, fortschritt: $fortschrittInProzent)';
  }
}
