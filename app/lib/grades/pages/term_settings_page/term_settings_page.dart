// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart'
    hide SubjectView;
import 'package:sharezone/grades/pages/shared/final_grade_type_settings.dart';
import 'package:sharezone/grades/pages/shared/subject_avatar.dart';
import 'package:sharezone/grades/pages/shared/weight_settings.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller_factory.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_view.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class TermSettingsPage extends StatelessWidget {
  const TermSettingsPage({super.key, required this.termId});

  static const tag = 'term-settings-page';

  final TermId termId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final factory = context.read<TermSettingsPageControllerFactory>();
        return factory.create(termId);
      },
      builder: (context, _) {
        final state = context.watch<TermSettingsPageController>().state;
        return Scaffold(
          appBar: AppBar(
            title: _AppBarTitle(
              name: switch (state) {
                TermSettingsLoaded() => state.view.name,
                _ => '?',
              },
            ),
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: switch (state) {
                TermSettingsLoading() => const _Loading(),
                TermSettingsLoaded() => _Loaded(view: state.view),
                TermSettingsError() => _Error(message: state.message),
              },
            ),
          ),
        );
      },
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text('Einstellung: $name');
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ErrorCard(
        message: Text(message),
        onContactSupportPressed:
            () => Navigator.pushNamed(context, SupportPage.tag),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.view});

  final TermSettingsPageView view;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: MaxWidthConstraintBox(
        child: Column(
          children: [
            _Name(name: view.name),
            const SizedBox(height: 8),
            _GradingSystem(gradingSystem: view.gradingSystem),
            const SizedBox(height: 8),
            _IsActiveTerm(isActiveTerm: view.isActiveTerm),
            const Divider(),
            const SizedBox(height: 8),
            _SubjectWeights(
              subjects: view.subjects,
              weightDisplayType: view.weightDisplayType,
            ),
            const Divider(),
            const SizedBox(height: 8),
            _GradingTypeWeights(
              weights: view.weights,
              selectableGradingTypes: view.selectableGradingTypes,
            ),
            const Divider(),
            const SizedBox(height: 8),
            _FinalGradeType(view: view),
          ],
        ),
      ),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_month),
      title: const Text('Name'),
      subtitle: Text(name),
      onTap: () async {
        final res = await showDialog<String>(
          context: context,
          builder: (context) => _NameDialog(name: name),
        );

        if (res != null && context.mounted) {
          final controller = context.read<TermSettingsPageController>();
          controller.setName(res);
        }
      },
    );
  }
}

class _NameDialog extends StatefulWidget {
  const _NameDialog({required this.name});

  final String name;

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late String initialValue;
  String? errorText;
  String? value;

  @override
  void initState() {
    super.initState();
    initialValue = widget.name;
    value = widget.name;
  }

  bool get isValid =>
      errorText == null && value != null && value != initialValue;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text('Name ändern'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Der Name beschreibt das Halbjahr, z.B. '10/2' für das zweite Halbjahr der 10. Klasse.",
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 20),
              PrefilledTextField(
                prefilledText: widget.name,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "z.B. 10/2",
                  errorText: errorText,
                ),
                onEditingComplete: () {
                  if (isValid) {
                    Navigator.of(context).pop(value);
                  }
                },
                onChanged: (value) {
                  setState(() {
                    this.value = value;

                    final isValid = value.isNotEmpty;
                    errorText = isValid ? null : 'Bitte gib einen Namen ein.';
                  });
                },
              ),
            ],
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
              onPressed:
                  isValid ? () => Navigator.of(context).pop(value) : null,
              child: const Text('Speichern'),
            ),
          ),
        ],
      ),
    );
  }
}

class _IsActiveTerm extends StatelessWidget {
  const _IsActiveTerm({required this.isActiveTerm});

  final bool isActiveTerm;

  @override
  Widget build(BuildContext context) {
    return ActiveTermSwitchBase(
      isActiveTerm: isActiveTerm,
      onActiveTermChanged: (value) {
        final controller = context.read<TermSettingsPageController>();
        controller.setIsActiveTerm(value);
      },
    );
  }
}

class _SubjectWeights extends StatelessWidget {
  const _SubjectWeights({
    required this.subjects,
    required this.weightDisplayType,
  });

  final WeightDisplayType weightDisplayType;
  final IList<SubjectView> subjects;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gewichtung der Kurse für Notenschnitt vom Halbjahr',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        _WeightDisplaySetting(
          weightDisplayType: weightDisplayType,
          onWeightDisplayTypeChanged: (newDisplayType) {
            final controller = context.read<TermSettingsPageController>();
            controller.setWeightDisplayType(newDisplayType);
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Solltest du Kurse haben, die doppelt gewichtet werden, kannst du bei diesen eine 2.0 eintragen.',
          style: TextStyle(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 8),
        if (subjects.isEmpty)
          Text(
            'Du hast bisher noch keine Fächer erstellt.',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        for (final subject in subjects)
          _SubjectTile(subject, weightDisplayType),
      ],
    );
  }
}

class _WeightDisplaySetting extends StatelessWidget {
  const _WeightDisplaySetting({
    required this.weightDisplayType,
    required this.onWeightDisplayTypeChanged,
  });

  final WeightDisplayType weightDisplayType;
  final void Function(WeightDisplayType) onWeightDisplayTypeChanged;

  String get weightDisplayTypeString => switch (weightDisplayType) {
    WeightDisplayType.factor => 'Faktor',
    WeightDisplayType.percent => 'Prozent',
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Symbols.weight, fill: 1),
      title: const Text('Gewichtungssystem'),
      subtitle: Text(weightDisplayTypeString),
      onTap: () async {
        final result = await showDialog<WeightDisplayType?>(
          context: context,
          builder:
              (context) => SimpleDialog(
                title: const Text('Gewichtungssystem'),
                children: [
                  ListTile(
                    title: const Text('Faktor'),
                    onTap: () {
                      Navigator.pop(context, WeightDisplayType.factor);
                    },
                  ),
                  ListTile(
                    title: const Text('Prozent'),
                    onTap: () {
                      Navigator.pop(context, WeightDisplayType.percent);
                    },
                  ),
                ],
              ),
        );
        if (result != null) {
          onWeightDisplayTypeChanged(result);
        }
      },
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile(this.subject, this.weightDisplayType);

  final SubjectView subject;
  final WeightDisplayType weightDisplayType;

  @override
  Widget build(BuildContext context) {
    final factor = switch (weightDisplayType) {
      WeightDisplayType.factor => subject.weight.asFactor.toStringAsPrecision(
        2,
      ),
      WeightDisplayType.percent =>
        '${subject.weight.asPercentage.toStringAsPrecision(3)}%',
    };
    return ListTile(
      leading: SubjectAvatar(
        abbreviation: subject.abbreviation,
        design: subject.design,
      ),
      title: Text(subject.displayName),
      onTap: () async {
        final weight = await showDialog<Weight>(
          context: context,
          builder:
              (context) => _FactorDialog(
                weight: subject.weight,
                weightDisplayType: weightDisplayType,
              ),
        );

        if (weight != null && context.mounted) {
          final controller = context.read<TermSettingsPageController>();
          controller.setSubjectWeight(subject.id, weight);
        }
      },
      trailing: Text(
        factor,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
    );
  }
}

class _FactorDialog extends StatefulWidget {
  const _FactorDialog({required this.weight, required this.weightDisplayType});

  final Weight weight;
  final WeightDisplayType weightDisplayType;

  @override
  State<_FactorDialog> createState() => _FactorDialogState();
}

class _FactorDialogState extends State<_FactorDialog> {
  String? errorText;
  num? value;

  num get initialValue => switch (widget.weightDisplayType) {
    WeightDisplayType.factor => widget.weight.asFactor,
    WeightDisplayType.percent => widget.weight.asPercentage,
  };

  String get formatted => switch (widget.weightDisplayType) {
    WeightDisplayType.factor =>
      value == null
          ? ''
          // If there are no decimals, we want to show the "1" as "1.0", so
          // that the user knows that he can write a decimal number and what
          // the seperator is ("." instead of ",").
          : value!.hasDecimals
          ? value.toString()
          : value!.toStringAsPrecision(2),
    WeightDisplayType.percent => value?.toString() ?? '',
  };

  Weight? get valueAsWeight => switch (widget.weightDisplayType) {
    WeightDisplayType.factor => value != null ? Weight.factor(value!) : null,
    WeightDisplayType.percent => value != null ? Weight.percent(value!) : null,
  };

  @override
  void initState() {
    super.initState();
    value = initialValue;
  }

  bool isValid() => errorText == null && value != null && initialValue != value;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const Text('Gewichtung ändern'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Die Gewichtung beschreibt, wie stark die Note des Kurses in den Halbjahresschnitt einfließt.',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 20),
              PrefilledTextField(
                prefilledText: formatted,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Gewichtung',
                  hintText: 'z.B. 1.0',
                  errorText: errorText,
                  suffixText: switch (widget.weightDisplayType) {
                    WeightDisplayType.factor => null,
                    WeightDisplayType.percent => '%',
                  },
                ),
                onEditingComplete: () {
                  if (isValid()) {
                    Navigator.of(context).pop(valueAsWeight);
                  }
                },
                onChanged: (value) {
                  setState(() {
                    this.value = num.tryParse(value);

                    final isValid = this.value != null;
                    errorText = isValid ? null : 'Bitte gib eine Zahl ein.';
                  });
                },
              ),
            ],
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
              onPressed:
                  isValid()
                      ? () => Navigator.of(context).pop(valueAsWeight)
                      : null,
              child: const Text('Speichern'),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradingTypeWeights extends StatelessWidget {
  const _GradingTypeWeights({
    required this.weights,
    required this.selectableGradingTypes,
  });

  final IMap<GradeTypeId, Weight> weights;
  final IList<GradeType> selectableGradingTypes;

  @override
  Widget build(BuildContext context) {
    return WeightSettings(
      weights: weights,
      selectableGradingTypes: selectableGradingTypes,
      onRemoveGradeType: (gradeTypeId) {
        final controller = context.read<TermSettingsPageController>();
        controller.removeGradeType(gradeTypeId);
      },
      onSetGradeWeight: (gradeTypeId, weight) {
        final controller = context.read<TermSettingsPageController>();
        controller.setGradeWeight(gradeTypeId, weight);
      },
    );
  }
}

class _GradingSystem extends StatelessWidget {
  const _GradingSystem({required this.gradingSystem});

  final GradingSystem gradingSystem;

  @override
  Widget build(BuildContext context) {
    return GradingSystemBase(
      currentGradingSystemName: gradingSystem.displayName,
      onGradingSystemChanged: (res) {
        final controller = context.read<TermSettingsPageController>();
        controller.setGradingSystem(res);
      },
    );
  }
}

class _FinalGradeType extends StatelessWidget {
  const _FinalGradeType({required this.view});

  final TermSettingsPageView view;

  @override
  Widget build(BuildContext context) {
    return FinalGradeTypeSettings(
      icon:
          view.finalGradeType.predefinedType?.getIcon() ??
          const Icon(Icons.help),
      displayName: view.finalGradeType.predefinedType?.toUiString() ?? '?',
      selectableGradingTypes: view.selectableGradingTypes,
      onSetFinalGradeType: (type) {
        final controller = context.read<TermSettingsPageController>();
        controller.setFinalGradeType(type);
      },
    );
  }
}
