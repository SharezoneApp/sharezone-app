import 'package:abgabe_client_lib/src/erstellung/datei_upload_prozess.dart';
import 'package:abgabe_client_lib/src/models/models.dart';

/// Eine Klasse, die den gesamten Upload (Dateiinhalt) und das Hinzufügen einer
/// Datei zu einer Abgabe regelt.
abstract class AbgabedateiUploader {
  /// Lädt eine Abgabedatei hoch und fügt diese zu einer Abgabe hinzu.
  Stream<DateiUploadProzessFortschritt> ladeAbgabedateiHoch(
      DateiHinzufuegenCommand befehl);
}
