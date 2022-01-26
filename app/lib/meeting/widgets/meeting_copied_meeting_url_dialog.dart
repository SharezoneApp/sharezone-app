// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/cupertino.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';

void showCopiedMeetingUrlDialog(BuildContext context) {
  showLeftRightAdaptiveDialog(
    context: context,
    content: const Text(
      "Es konnte nicht automatisch der Videokonferenz beigetreten werden. Deswegen wurde die URL für das Meeting in deine Zwischenablage kopiert. Bitte öffne selbstständig einen Browser und füge die URL ein.\n\nDen Link zur Videokonferenz solltest du niemals an andere Personen schicken!",
      key: ValueKey('copied-meeting-url-dialog-text-widget-test'),
    ),
    left: AdaptiveDialogAction.ok,
  );
}
