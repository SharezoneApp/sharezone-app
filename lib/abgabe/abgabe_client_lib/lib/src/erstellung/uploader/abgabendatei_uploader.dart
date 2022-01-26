// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:abgabe_client_lib/src/erstellung/datei_upload_prozess.dart';
import 'package:abgabe_client_lib/src/models/models.dart';

/// Eine Klasse, die den gesamten Upload (Dateiinhalt) und das Hinzufügen einer
/// Datei zu einer Abgabe regelt.
abstract class AbgabedateiUploader {
  /// Lädt eine Abgabedatei hoch und fügt diese zu einer Abgabe hinzu.
  Stream<DateiUploadProzessFortschritt> ladeAbgabedateiHoch(
      DateiHinzufuegenCommand befehl);
}
