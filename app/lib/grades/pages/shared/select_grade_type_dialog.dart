// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';

class SelectGradeTypeDialog extends StatelessWidget {
  const SelectGradeTypeDialog({
    super.key,
    required this.selectableGradingTypes,
  });

  final List<GradeType> selectableGradingTypes;

  static Future<GradeType?> show({
    required BuildContext context,
    required List<GradeType> selectableGradingTypes,
  }) async {
    return showDialog<GradeType?>(
      context: context,
      builder:
          (context) => SelectGradeTypeDialog(
            selectableGradingTypes: selectableGradingTypes,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      title: Text(context.l10n.gradesDialogSelectGradeType),
      children: [
        for (final gradeType in selectableGradingTypes)
          ListTile(
            leading:
                gradeType.predefinedType?.getIcon() ??
                const Icon(Icons.help_outline),
            title: Text(
              gradeType.predefinedType?.toLocalizedString(context) ??
                  context.l10n.gradesDialogUnknownCustomGradeType,
            ),
            onTap: () {
              Navigator.of(context).pop<GradeType?>(gradeType);
            },
          ),
      ],
    );
  }
}
