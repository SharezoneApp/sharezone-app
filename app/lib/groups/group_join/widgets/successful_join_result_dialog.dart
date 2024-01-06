// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SuccessfulJoinResultDialog extends StatelessWidget {
  const SuccessfulJoinResultDialog({
    super.key,
    required this.result,
  });

  final SuccessfulJoinResult result;

  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: "Erfolgreich beigetreten 🎉",
      iconData: Icons.done,
      iconColor: Colors.green,
      description:
          "${result.groupInfo.name} wurde erfolgreich hinzugefügt. Du bist nun Mitglied.",
    );
  }
}
