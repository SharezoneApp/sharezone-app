// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
    return const SimpleData(
      title: "Erfolgreich",
      iconData: Icons.done,
      iconColor: Colors.green,
    );
  }

  factory SimpleData.failed() {
    return const SimpleData(
      title: "Fehlgeschlagen",
      iconData: Icons.error_outline,
      iconColor: Colors.red,
    );
  }

  factory SimpleData.unkonwnException() {
    return const SimpleData(
      title: 'Unbekannter Fehler',
      iconData: Icons.error_outline,
      iconColor: Colors.red,
      description: "Ein unbekannter Fehler ist aufgetreten! 😭",
    );
  }

  factory SimpleData.noInternet() {
    return const SimpleData(
      title: 'Fehler: Keine Internetverbindung',
      iconData: Icons.error_outline,
      iconColor: Colors.red,
      description: "Bitte überprüfen Sie die Internetverbindung.",
    );
  }
}
