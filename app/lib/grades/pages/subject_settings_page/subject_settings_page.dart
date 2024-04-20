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
import 'package:sharezone/grades/pages/shared/select_grade_type_dialog.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_controller.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_view.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SubjectSettingsPage extends StatelessWidget {
  const SubjectSettingsPage({
    super.key,
    required this.subjectId,
    required this.termId,
  });

  final SubjectId subjectId;
  final TermId termId;

  static const tag = 'subject-settings-page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final gradesService = context.read<GradesService>();
        return SubjectSettingsPageController(
          subjectId: subjectId,
          termId: termId,
          gradesService: gradesService,
        );
      },
      builder: (context, _) {
        final state = context.watch<SubjectSettingsPageController>().state;
        final subjectDisplayName = switch (state) {
          SubjectSettingsLoaded() => state.view.subjectName,
          _ => '?'
        };
        return Scaffold(
          appBar: AppBar(
            title: Text('Einstellungen: $subjectDisplayName'),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: switch (state) {
              SubjectSettingsLoading() => const _Loading(),
              SubjectSettingsError() => _Error(message: state.message),
              SubjectSettingsLoaded() => _Loaded(view: state.view),
            },
          ),
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return ErrorCard(
      message: Text(message),
      onContactSupportPressed: () =>
          Navigator.pushNamed(context, SupportPage.tag),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.view,
  });

  final SubjectSettingsPageView view;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: MaxWidthConstraintBox(
        child: SafeArea(
          child: Column(
            children: [
              _FinalGradeType(
                displayName: view.finalGradeTypeDisplayName,
                icon: view.finalGradeTypeIcon,
                selectableGradingTypes: view.selectableGradingTypes,
              ),
              const Divider(),
              SubjectWeights(
                selectableGradingTypes: view.selectableGradingTypes,
                weights: view.weights,
                onSetGradeWeight: (gradeTypeId, weight) {
                  final controller =
                      context.read<SubjectSettingsPageController>();
                  controller.setGradeWeight(
                    gradeTypeId: gradeTypeId,
                    weight: weight,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinalGradeType extends StatelessWidget {
  const _FinalGradeType({
    required this.icon,
    required this.displayName,
    required this.selectableGradingTypes,
  });

  final Icon icon;
  final String displayName;
  final IList<GradeType> selectableGradingTypes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Endnote',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Solange keine Endnote für einen Kurs feststeht, wird eine vorläufige Kursnote anhand der eingetragenen Noten berechnet. Wenn eine Endnote feststeht, kann die berechnete Kursnote überschrieben werden.',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: icon,
          title: Text(displayName),
          onTap: () async {
            final type = await SelectGradeTypeDialog.show(
              context: context,
              selectableGradingTypes: selectableGradingTypes.toList(),
            );

            if (type != null && context.mounted) {
              final controller = context.read<SubjectSettingsPageController>();
              controller.setFinalGradeType(type);
            }
          },
        ),
      ],
    );
  }
}

class SubjectWeights extends StatelessWidget {
  const SubjectWeights({
    super.key,
    required this.weights,
    required this.selectableGradingTypes,
    required this.onSetGradeWeight,
  });

  final IMap<GradeTypeId, Weight> weights;
  final IList<GradeType> selectableGradingTypes;
  final void Function(GradeTypeId gradeTypeId, Weight weight) onSetGradeWeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Berechnung der Fachnote', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          'Lege die Gewichtung der Notentypen für die Berechnung der Fachnote fest.',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
        const SizedBox(height: 8),
        for (final entry in weights.entries)
          _SubjectWeight(
            gradeTypeId: entry.key,
            weight: entry.value,
            onSetGradeWeight: onSetGradeWeight,
          ),
        _AddSubjectWeight(
          selectableGradingTypes: selectableGradingTypes,
          onSetGradeWeight: onSetGradeWeight,
        )
      ],
    );
  }
}

class _SubjectWeight extends StatelessWidget {
  const _SubjectWeight({
    required this.gradeTypeId,
    required this.weight,
    required this.onSetGradeWeight,
  });

  final GradeTypeId gradeTypeId;
  final Weight weight;
  final void Function(GradeTypeId gradeTypeId, Weight weight) onSetGradeWeight;

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
        onPressed: () {
          final controller = context.read<SubjectSettingsPageController>();
          controller.removeGradeType(gradeTypeId);
        },
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
