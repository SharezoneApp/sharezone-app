import 'package:flutter/material.dart';

/// Ein Datenobjekt für Widgets wie zum Beispiel [StateDialogSimpleBody] oder [StateSheetSimpleBody].
class SimpleData {
  final String title;
  final String description;
  final IconData iconData;
  final Color iconColor;

  const SimpleData({
    @required this.title,
    this.description,
    @required this.iconData,
    this.iconColor,
  }) : assert(iconData != null);

  factory SimpleData.successful() {
    return SimpleData(
      title: "Erfolgreich",
      iconData: Icons.done,
      iconColor: Colors.green,
    );
  }

  factory SimpleData.failed() {
    return SimpleData(
      title: "Fehlgeschlagen",
      iconData: Icons.error_outline,
      iconColor: Colors.red,
    );
  }

  factory SimpleData.unkonwnException() {
    return SimpleData(
      title: 'Unbekannter Fehler',
      iconData: Icons.error_outline,
      iconColor: Colors.red,
      description: "Ein unbekannter Fehler ist aufgetreten! 😭",
    );
  }

  factory SimpleData.noInternet() {
    return SimpleData(
      title: 'Fehler: Keine Internetverbindung',
      iconData: Icons.error_outline,
      iconColor: Colors.red,
      description: "Bitte überprüfen Sie die Internetverbindung.",
    );
  }
}
