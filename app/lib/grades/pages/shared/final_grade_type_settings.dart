// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
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
          title: const Text('Endnote eines Faches'),
          subtitle: Text(
            'Die berechnete Fachnote kann von einem Notentyp überschrieben werden.',
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5)),
          ),
          trailing: IconButton(
            tooltip: 'Was ist die Endnote?',
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
    GradesHelpDialog.show(context, const _FinalGradeTypeHelpDialog());
  }

  @override
  Widget build(BuildContext context) {
    return const GradesHelpDialog(
      title: Text('Was ist die Endnote eines Faches?'),
      text: Text(
        'Die Endnote ist die abschließende Note, die du in einem Fach bekommst, zum Beispiel die Note auf deinem Zeugnis. Manchmal berücksichtigt deine Lehrkraft zusätzliche Faktoren, die von der üblichen Berechnungsformel abweichen können – etwa 50% Prüfungen und 50% mündliche Beteiligung. In solchen Fällen kannst du die in Sharezone automatisch berechnete Note durch diese finale Note ersetzen.\n\nDiese Einstellung kann entweder für alle Fächer eines Halbjahres gleichzeitig festgelegt oder für jedes Fach individuell angepasst werden. So hast du die Flexibilität, je nach Bedarf spezifische Anpassungen vorzunehmen.',
      ),
    );
  }
}
