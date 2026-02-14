// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class RequireCourseSelectionsJoinResultDialog extends StatelessWidget {
  final RequireCourseSelectionsJoinResult result;

  const RequireCourseSelectionsJoinResultDialog({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return StateSheetSimpleBody(
      title: context.l10n.groupJoinRequireCourseSelectionTitle(
        result.groupInfo.name ?? '',
      ),
      iconData: Icons.notifications,
      iconColor: Colors.deepOrange,
      description: context.l10n.groupJoinRequireCourseSelectionDescription,
    );
  }
}
