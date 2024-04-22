// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/shared/grades_help_dialog.dart';
import 'package:sharezone/grades/pages/shared/select_grade_type_dialog.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class WeightSettings extends StatelessWidget {
  const WeightSettings({
    super.key,
    required this.weights,
    required this.selectableGradingTypes,
    required this.onSetGradeWeight,
    required this.onRemoveGradeType,
  });

  final IMap<GradeTypeId, Weight> weights;
  final IList<GradeType> selectableGradingTypes;
  final void Function(GradeTypeId gradeTypeId, Weight weight) onSetGradeWeight;
  final void Function(GradeTypeId gradeTypeId) onRemoveGradeType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          title: const Text('Berechnung der Fachnote'),
          subtitle: Text(
            'Lege die Gewichtung der Notentypen für die Berechnung der Fachnote fest.',
            style: TextStyle(
                color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          ),
          trailing: IconButton(
            tooltip: 'Wie wird die Note berechnet?',
            onPressed: () => _HelpDialog.show(context),
            icon: const Icon(Icons.help_outline),
          ),
        ),
        const SizedBox(height: 8),
        for (final entry in weights.entries)
          _GradeTypeWeight(
            gradeTypeId: entry.key,
            weight: entry.value,
            onSetGradeWeight: onSetGradeWeight,
            onRemoveGradeType: onRemoveGradeType,
          ),
        _AddSubjectWeight(
          selectableGradingTypes: selectableGradingTypes,
          onSetGradeWeight: onSetGradeWeight,
        )
      ],
    );
  }
}

class _GradeTypeWeight extends StatelessWidget {
  const _GradeTypeWeight({
    required this.gradeTypeId,
    required this.weight,
    required this.onSetGradeWeight,
    required this.onRemoveGradeType,
  });

  final GradeTypeId gradeTypeId;
  final Weight weight;
  final void Function(GradeTypeId gradeTypeId, Weight weight) onSetGradeWeight;
  final void Function(GradeTypeId gradeTypeId) onRemoveGradeType;

  GradeType? getGradeType(BuildContext context) {
    final getPossibleGrades =
        context.read<GradesService>().getPossibleGradeTypes();
    return getPossibleGrades
        .firstWhereOrNull((element) => element.id == gradeTypeId);
  }

  @override
  Widget build(BuildContext context) {
    final gradeType = getGradeType(context);
    final name = gradeType?.predefinedType?.toUiString() ?? '?';
    return ListTile(
      title: Text(name),
      onTap: () async {
        final newValue = await showDialog<double>(
          context: context,
          builder: (context) => _WeightTextField(
            initialValue: weight.asPercentage,
          ),
        );

        if (newValue != null && context.mounted) {
          onSetGradeWeight(gradeTypeId, Weight.percent(newValue));
        }
      },
      leading: IconButton(
        tooltip: 'Entfernen',
        icon: const Icon(
          Icons.remove_circle_outline,
          color: Colors.red,
        ),
        onPressed: () => onRemoveGradeType(gradeTypeId),
      ),
      trailing: Text(
        '${weight.asPercentage}%',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class _WeightTextField extends StatefulWidget {
  const _WeightTextField({
    required this.initialValue,
  });

  final num initialValue;

  @override
  State<_WeightTextField> createState() => _WeightTextFieldState();
}

class _WeightTextFieldState extends State<_WeightTextField> {
  String? errorText;
  String? value;

  bool get isValid => errorText == null && value != null && value!.isNotEmpty;

  bool isChangeValid(String change) {
    final isEmpty = change.isEmpty;
    if (isEmpty) {
      return false;
    }

    final asDouble = double.tryParse(change);
    if (asDouble == null) {
      return false;
    }

    return asDouble >= 0;
  }

  void popWithValue(BuildContext context) {
    final asDouble = double.parse(value!);
    Navigator.of(context).pop(asDouble);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400,
          minWidth: 250,
        ),
        child: PrefilledTextField(
          autofocus: true,
          prefilledText: '${widget.initialValue}',
          onChanged: (v) {
            final isValid = isChangeValid(v);
            setState(() {
              value = v;
              errorText =
                  isValid ? null : 'Bitte gebe eine gültige Zahl (>= 0) ein.';
            });
          },
          onEditingComplete: () {
            if (isValid) {
              popWithValue(context);
            }
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Gewichtung in %',
            hintText: 'z.B. 56.5',
            errorText: errorText,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: FilledButton(
            key: ValueKey(isValid),
            onPressed: isValid ? () => popWithValue(context) : null,
            child: const Text('Speichern'),
          ),
        ),
      ],
    );
  }
}

class _AddSubjectWeight extends StatelessWidget {
  const _AddSubjectWeight({
    required this.selectableGradingTypes,
    required this.onSetGradeWeight,
  });

  final IList<GradeType> selectableGradingTypes;
  final void Function(GradeTypeId gradeTypeId, Weight weight) onSetGradeWeight;

  Future<void> onTap(BuildContext context) async {
    final type = await SelectGradeTypeDialog.show(
      context: context,
      selectableGradingTypes: selectableGradingTypes.toList(),
    );

    if (type != null && context.mounted) {
      onSetGradeWeight(type.id, const Weight.factor(0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        onPressed: () => onTap(context),
        color: Theme.of(context).colorScheme.primary,
      ),
      title: const Text('Neue Gewichtung hinzufügen'),
      onTap: () => onTap(context),
    );
  }
}

class _HelpDialog extends StatelessWidget {
  const _HelpDialog();

  static void show(BuildContext context) {
    GradesHelpDialog.show(context, const _HelpDialog());
  }

  @override
  Widget build(BuildContext context) {
    return const GradesHelpDialog(
      title: Text('Wie wird die Note eines Fachs berechnet?'),
      text: Text(
        'In Sharezone kannst du genau bestimmen, wie die Note für jedes Fach berechnet wird, indem du die Gewichtung der verschiedenen Notentypen festlegst. Zum Beispiel kannst du einstellen, dass die Gesamtnote aus 50% schriftlichen Prüfungen und 50% mündlicher Beteiligung zusammengesetzt wird.\n\nDiese Flexibilität ermöglicht es dir, die Bewertungskriterien deiner Schule genau abzubilden und sicherzustellen, dass jede Art von Leistung angemessen berücksichtigt wird.',
      ),
    );
  }
}
