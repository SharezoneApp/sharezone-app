// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';

/// Zeigt dem Nutzer einen Hinweis, dass die Videokonferenz über Jitsi
/// läuft und wir auf Fehler in der Videokonferenz keinen Einfluss haben.
Future<bool> showMeetingWarning(BuildContext context) async {
  return showLeftRightAdaptiveDialog<bool>(
    context: context,
    title: 'Hinweis',
    content: SingleChildScrollView(
      key: const ValueKey("meeting-warning-widget-test"),
      child: Text(
        'Die Videokonferenz läuft mit der Open Source Software Jitsi. Sollten Fehler in der Videokonferenz auftreten, hat Sharezone darauf keinen Einfluss.\n\nSollte es zu Performance-Problemen kommen, kann es helfen, wenn möglichst wenige Teilnehmer die Video-Funktion eingeschaltet haben.\n\nDas Hosting der Jitsi-Software läuft über Sharezone (Serverstandort: Belgien).',
      ),
    ),
    left: AdaptiveDialogAction<bool>(
      isDefaultAction: true,
      popResult: true,
      title: 'Alles klar',
      key: const ValueKey('meeting-warning-okay-button-widget-test'),
    ),
  );
}
