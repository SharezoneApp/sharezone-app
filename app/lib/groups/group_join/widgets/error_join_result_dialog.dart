// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/groups/group_join/models/group_join_exception.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class ErrorJoinResultDialog extends StatelessWidget {
  final ErrorJoinResult errorJoinResult;

  const ErrorJoinResultDialog({
    Key? key,
    required this.errorJoinResult,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (errorJoinResult.groupJoinException is NoInternetGroupJoinException) {
      return _NoInternet();
    }
    if (errorJoinResult.groupJoinException is AlreadyMemberGroupJoinException) {
      return _AlreadyMember();
    }
    if (errorJoinResult.groupJoinException
        is GroupNotPublicGroupJoinException) {
      return _NotPublic();
    }
    if (errorJoinResult.groupJoinException
        is SharecodeNotFoundGroupJoinException) return _NotFound();

    return _UnknownError();
  }
}

class _UnknownError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const StateSheetSimpleBody(
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
    return const StateSheetSimpleBody(
      title: "Ein Fehler ist aufgetreten: Keine Internetverbindung ☠️",
      iconData: Icons.error,
      iconColor: Colors.red,
      description:
          "Wir konnten nicht versuchen, der Gruppe beizutreten, da wir keine Internetverbindung herstellen konnten. Bitte überprüfe dein WLAN bzw. deine Mobilfunktdaten.",
    );
  }
}

class _AlreadyMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const StateSheetSimpleBody(
      title: "Ein Fehler ist aufgetreten: Bereits Mitglied 🤨",
      iconData: Icons.error,
      iconColor: Colors.red,
      description:
          "Du bist bereits Mitglied in dieser Gruppe, daher musst du dieser nicht mehr beitreten.",
    );
  }
}

class _NotPublic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const StateSheetSimpleBody(
      title: "Ein Fehler ist aufgetreten: Beitreten verboten ⛔️",
      iconData: Icons.error,
      iconColor: Colors.red,
      description:
          "Die Gruppe erlaubt aktuell kein Beitreten. Dies ist in den Gruppeneinstellungen deaktiviert. Bitte wende dich an einen Admin dieser Gruppe.",
    );
  }
}

class _NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const StateSheetSimpleBody(
      title: "Ein Fehler ist aufgetreten: Sharecode nicht gefunden ❌",
      iconData: Icons.error,
      iconColor: Colors.red,
      description:
          "Wir konnten den eingegeben Sharecode nicht finden. Bitte überprüfe die Groß- und Kleinschreibung und ob dieser Sharecode noch gültig ist.",
    );
  }
}
