import 'dart:async';

import 'package:sharezone/main/run_app.dart';

/// Zeigt, ob die App momentan von einem Flutter-Driver Test ausgeführt wird.
///
/// Wird genutzt um Verhalten, wodurch die App durch den Driver-Test nicht (gut)
/// testbar wäre, zu ändern. Beispielsweise kann somit eingestellt werden, dass
/// im Driver-Test der Benachrichtigungs-Bestätigungsdialog beim ersten Start
/// der App nicht angezeigt wird, weil dieser nativ erstellt wird und der
/// Driver-Test diesen nicht bestätigen kann (zumindest ohne unschöne
/// workarounds).
///
/// Im Bestfall sollte diese globale Variable *nicht* vom Code direkt genutzt
/// werden. Im Beispiel oben sollte möglicherweise im Dialog-Code per Parameter
/// einstellbar sein, ob der Bestätigungsdialog angzeigt wird. Anhand
/// [kIsDriverTest] sollte nur am Anfang dann diese Einstellung dann geändert
/// werden.
/// Heißt: Am besten nicht direkt diese globale Variable überall im Code
/// benutzen, sondern den Code konfigurierbar machen und die Konfiguration
/// anhand dieser Variablen ändern.
bool kIsDriverTest = false;

/// Startet die Sharezone-App.
/// [isDriverTest] setzt die globale Variable [kIsDriverTest], um Verhalten für
/// einfachere Driver-Tests zu ändern. Für mehr Infos siehe Dokumentation von
/// [kIsDriverTest].
Future main({bool isDriverTest = false}) async {
  kIsDriverTest = isDriverTest;
  return runFlutterApp();
}
