// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/shared/grades_help_dialog.dart';
import 'package:sharezone/grades/pages/shared/select_grade_type_dialog.dart';

class FinalGradeTypeSettings extends StatelessWidget {
  const FinalGradeTypeSettings({
    super.key,
    required this.icon,
    required this.displayName,
    required this.selectableGradingTypes,
    required this.onSetFinalGradeType,
  });

  final Icon icon;
  final String displayName;
  final IList<GradeType> selectableGradingTypes;
  final ValueChanged<GradeType> onSetFinalGradeType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(context.l10n.gradesFinalGradeTypeTitle),
          subtitle: Text(
            context.l10n.gradesFinalGradeTypeSubtitle,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          trailing: IconButton(
            tooltip: context.l10n.gradesFinalGradeTypeHelpTooltip,
            icon: const Icon(Icons.help_outline),
            onPressed: () => _FinalGradeTypeHelpDialog.show(context),
          ),
        ),
        ListTile(
          leading: icon,
          title: Text(displayName),
          onTap: () async {
            final type = await SelectGradeTypeDialog.show(
              context: context,
              selectableGradingTypes: selectableGradingTypes.toList(),
            );

            if (type != null && context.mounted) {
              onSetFinalGradeType(type);
            }
          },
        ),
      ],
    );
  }
}

class _FinalGradeTypeHelpDialog extends StatelessWidget {
  const _FinalGradeTypeHelpDialog();

  static void show(BuildContext context) {
    GradesHelpDialog.show(context, _FinalGradeTypeHelpDialog());
  }

  @override
  Widget build(BuildContext context) {
    return GradesHelpDialog(
      title: Text(context.l10n.gradesFinalGradeTypeHelpDialogTitle),
      text: Text(context.l10n.gradesFinalGradeTypeHelpDialogText),
    );
  }
}
