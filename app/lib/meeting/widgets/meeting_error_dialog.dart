// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:sharezone_widgets/snackbars.dart';

import 'package:url_launcher_extended/url_launcher_extended.dart';

Future<void> showMeetingErrorDialog(
  BuildContext context,
  dynamic e,
  StackTrace s,
  String meetingId,
) async {
  final shouldContactSupport = await showLeftRightAdaptiveDialog<bool>(
    context: context,
    content: Text(
      "Oh! Es gab einen Fehler: $e 🙁\n\nBitte kontaktiere den Support mit diesem Fehler.",
      key: const ValueKey('meeting-error-dialog-text-widget-test'),
    ),
    defaultValue: false,
    title: 'Fehler 🤯',
    right: AdaptiveDialogAction<bool>(
      title: 'Support kontaktieren',
      popResult: true,
    ),
  );

  if (shouldContactSupport) {
    try {
      UrlLauncherExtended().tryLaunchMailOrThrow(
        "support@sharezone.net",
        subject: "Fehler beim Betreten der Videokonferenz",
        body:
            "Liebes Sharezone-Team,\n\nbeim Betreten einer Videokonferenz ist ein Fehler aufgetreten.\n\nMeeting-ID: $meetingId\n\nFehler: $e\n\nStackTrace: $s\n\nViele Grüße\n",
      );
    } catch (e) {
      print(e);
      showSnack(text: 'E-Mail-Adresse kopiert', context: context);
      _copySupportMail();
    }
  }
}

void _copySupportMail() {
  Clipboard.setData(ClipboardData(text: "support@sharezone.net"));
}
