import 'package:intl/intl.dart';

/// File for the [intl.message()] messages, as otherwise one would have to specify
/// every .dart file where intl.message() is used.
///
/// The class name will be the name of the .dart file used, without underscores "_",
/// with CamelCase lettering and with "Messages" at the end.
/// Example:
/// The Strings of "homework_page.dart" would be in the class "HomeworkPageMessages"

class HomeworkPageMessages {
  static String appbarTitle() =>
      Intl.message("Hausaufgabenheft", desc: "Beschreibt den Titel der Seite");
  static String offeneHausaufgaben() => Intl.message("Offen",
      desc:
          "Erklärt, dass die zu sehenden Hausaufgaben in der Liste noch zu machen sind.");
  static String gemachteHausaufgaben() => Intl.message("Erledigt",
      desc:
          "Erklärt, dass die zu sehenden Hausaufgaben in der Liste gemacht sind.");
  static String hausaufgabeBearbeiten() => Intl.message("Bearbeiten",
      desc:
          "Erklärt, dass der aktuelle Dialog der Hausaufgabe zum Bearbeiten dieser da ist");
}

class FirebaseAuthErrorTranslations {
  static String emailWirdBereitsBenutzt() => Intl.message(
      "Die Email wird bereits von einem anderen Account benutzt.",
      desc:
          "Erklärt, dass die Email, die von dem Benutzer angegeben wurde, schon von einem anderen Account benutzt wird.");
  static String emailFalschFormatiert() => Intl.message(
      "Die Email ist ungültig.",
      desc:
          "Erklärt, dass die Email die angegeben wurde nicht gültig ist bzw eine ungültige Formatierung besitzt.");
  static String passwortSchwach() =>
      Intl.message("Das Passwort ist unzureichend.",
          desc: "Erklärt, dass das Passwort zu schwach/unzureichend ist.");
  static String netzwerkError() =>
      Intl.message("Ein Netzwerkproblem ist aufgetreten.");
}
