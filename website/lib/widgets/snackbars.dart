import 'package:flutter/material.dart';

/// [behavior] ist hier standardmäßig fixed, da die [showDataArrivalConfirmedSnackbar]
/// ob aufgerufen wird, wenn es einen FAB gib. Gibt einen FAB, sehen die floating
/// Snackbars absolut kacke aus ._. Deswegen wird dann für diesen Fall das
/// [behavior] auf fixed gewechselt.
void showDataArrivalConfirmedSnackbar(
    {GlobalKey<ScaffoldState> key,
    BuildContext context,
    SnackBarBehavior behavior = SnackBarBehavior.fixed}) {
  showSnack(
    context: context,
    key: key,
    text: "Ankunft der Daten bestätigt",
    duration: const Duration(milliseconds: 1500),
    behavior: behavior,
  );
}

void sendDataToFrankfurtSnackBar(BuildContext context, {SnackBarBehavior behavior}) {
  showSnackSec(
    context: context,
    seconds: 3600,
    withLoadingCircle: true,
    behavior: behavior,
    text: "Daten werden nach Frankfurt transportiert...",
  );
}

void sendLoginDataEncryptedSnackBar(BuildContext context) {
  showSnackSec(
    context: context,
    text: "Anmeldedaten werden verschlüsselt übertragen...",
    seconds: 120,
    withLoadingCircle: true,
  );
}

void savedChangesSnackBar(BuildContext context,
    {Duration duration = const Duration(milliseconds: 1750)}) {
  showSnack(
    context: context,
    text: 'Änderung wurde erfolgreich gespeichert',
    duration: duration,
  );
}

void patienceSnackBar(BuildContext context) {
  showSnackSec(
    context: context,
    seconds: 2,
    text: "Geduld! Daten werden noch geladen...",
  );
}

void showSnackSec({
  String text,
  int seconds = 3,
  BuildContext context,
  GlobalKey<ScaffoldState> key,
  bool withLoadingCircle = false,
  SnackBarAction action,
  bool hideCurrentSnackBar = true,
  SnackBarBehavior behavior,
}) {
  showSnack(
    key: key,
    duration: Duration(seconds: seconds),
    context: context,
    text: text,
    withLoadingCircle: withLoadingCircle,
    action: action,
    hideCurrentSnackBar: hideCurrentSnackBar,
    behavior: behavior,
  );
}

void showSnack({
  String text,
  Duration duration,
  BuildContext context,
  GlobalKey<ScaffoldState> key,
  bool withLoadingCircle = false,
  SnackBarAction action,
  bool hideCurrentSnackBar = true,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
}) {
  final snackBar = SnackBar(
    content: withLoadingCircle == false
        ? Text(text)
        : Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 20, left: 4),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(),
                  ),
                ),
                Flexible(child: Text(text)),
              ],
            ),
          ),
    duration: duration,
    action: action,
    behavior: behavior,
  );

  if (key != null) {
    try {
      if (hideCurrentSnackBar) key.currentState.hideCurrentSnackBar();
      key.currentState.showSnackBar(snackBar);
    } catch (e) {
      print("Fehler beim anzeigen der SnackBar über den Key: ${e.toString()}");
    }
  } else if (context != null) {
    try {
      if (hideCurrentSnackBar) Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(snackBar);
    } catch (e) {
      print(
          "Fehler beim anzeigen der SnackBar über den Kontext: ${e.toString()}");
    }
  } else {
    debugPrint("Fehler! Die SnackBar hat keinen Key und keinen Context!");
  }
}
