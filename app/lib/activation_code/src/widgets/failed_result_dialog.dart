// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/activation_code/src/models/enter_activation_code_result.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class FailedEnterActivationCodeResultDialog extends StatelessWidget {
  final FailedEnterActivationCodeResult failedEnterActivationCodeResult;

  const FailedEnterActivationCodeResultDialog({
    Key? key,
    required this.failedEnterActivationCodeResult,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (failedEnterActivationCodeResult.enterActivationCodeException
        is NoInternetEnterActivationCodeException) return _NoInternet();
    if (failedEnterActivationCodeResult.enterActivationCodeException
        is NotAvailableEnterActivationCodeException) return _NotAvailable();
    if (failedEnterActivationCodeResult.enterActivationCodeException
        is NotFoundEnterActivationCodeException) return _NotFound();

    return _UnknownError();
  }
}

class _UnknownError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: "Ein unbekannter Fehler ist aufgetreten 😭",
      iconData: Icons.error,
      iconColor: Colors.red,
      description:
          "Dies könnte eventuell an deiner Internetverbindung liegen. Bitte überprüfe diese!",
    );
  }
}

class _NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: "Ein Fehler ist aufgetreten: Keine Internetverbindung ☠️",
      iconData: Icons.error,
      iconColor: Colors.red,
      description:
          "Wir konnten nicht versuchen, den Code einzulösen, da wir keine Internetverbindung herstellen konnten. Bitte überprüfe dein WLAN bzw. deine Mobilfunktdaten.",
    );
  }
}

class _NotAvailable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: "Ein Fehler ist aufgetreten: Dieser Code ist nicht gültig 🤨",
      iconData: Icons.error,
      iconColor: Colors.red,
      description:
          "Entweder wurde dieser Code schon aufgebracht oder er ist außerhalb des Gültigkeitszeitraumes.",
    );
  }
}

class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: "Ein Fehler ist aufgetreten: Aktivierungscode nicht gefunden ❌",
      iconData: Icons.error,
      iconColor: Colors.red,
      description:
          "Wir konnten den eigegeben Aktivierungscode nicht finden. Bitte überprüfe die Groß- und Kleinschreibung und ob dieser Aktivierungscode noch gültig ist.",
    );
  }
}
