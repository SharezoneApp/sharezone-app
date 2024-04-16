// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'grades_dialog.dart';

class _GradeValue extends StatelessWidget {
  const _GradeValue();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;
    final gradingSystem = view.selectedGradingSystem;
    final selectableGrades = view.selectableGrades;
    final hasDistinctValues = selectableGrades.distinctGrades != null;
    return ListTile(
      leading: SavedGradeIcons.value,
      title: hasDistinctValues
          ? Text(
              view.selectedGrade ?? 'Keine Note ausgewählt',
              style: TextStyle(
                color: view.isGradeMissing
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
            )
          : TextField(
              decoration: InputDecoration(
                label: const Text('Note'),
                hintText: switch (gradingSystem) {
                  GradingSystem.oneToFiveWithDecimals => 'z.B. 1.3',
                  GradingSystem.oneToSixWithDecimals => 'z.B. 1.3',
                  GradingSystem.oneToSixWithPlusAndMinus => 'z.B. 1+',
                  GradingSystem.sixToOneWithDecimals => 'z.B. 6.0',
                  GradingSystem.zeroToFivteenPointsWithDecimals => 'z.B. 15.0',
                  GradingSystem.zeroToHundredPercentWithDecimals => 'z.B. 78.8',
                  _ => null,
                },
                errorText: view.selectedGradeErrorText,
              ),
              onChanged: controller.setGrade,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))
              ],
            ),
      onTap: hasDistinctValues
          ? () async {
              final res = await showDialog<String?>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text("Note auswählen"),
                  contentPadding: const EdgeInsets.all(12),
                  children: [
                    if (selectableGrades.distinctGrades != null)
                      for (final grade in selectableGrades.distinctGrades!)
                        ListTile(
                          title: Text(grade),
                          onTap: () {
                            Navigator.of(context).pop<String?>(grade);
                          },
                        ),
                  ],
                ),
              );

              if (res != null) {
                controller.setGrade(res);
              }
            }
          : null,
    );
  }
}

class _GradingSystem extends StatelessWidget {
  const _GradingSystem();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;
    return ListTile(
      leading: SavedGradeIcons.gradingSystem,
      title: const Text("Notensystem"),
      subtitle: Text(view.selectedGradingSystem.displayName),
      onTap: () async {
        final res = await showDialog<GradingSystem?>(
          context: context,
          builder: (context) => const _SelectGradeSystemDialog(),
        );

        if (res != null) {
          controller.setGradingSystem(res);
        }
      },
    );
  }
}

class _SelectGradeSystemDialog extends StatelessWidget {
  const _SelectGradeSystemDialog();

  @override
  Widget build(BuildContext context) {
    final greyColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
    return MaxWidthConstraintBox(
      maxWidth: 450,
      child: SimpleDialog(
        title: const Text("Notensystem auswählen"),
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              'Der erste Wert entspricht der besten Noten, z.B. bei dem Notensystem "1 - 6" ist "1" die beste Note.',
              style: TextStyle(
                fontSize: 12,
                color: greyColor,
              ),
            ),
          ),
          for (final gradingSystem in GradingSystem.values)
            ListTile(
              title: Text(gradingSystem.displayName),
              onTap: () {
                Navigator.of(context).pop<GradingSystem?>(gradingSystem);
              },
            ),
          const Divider(),
          ListTile(
            title: const Text("Weiteres Notensystem anfragen"),
            subtitle: Text(
              "Notensystem nicht dabei? Schreib uns, welches Notensystem du gerne hättest!",
              style: TextStyle(color: greyColor),
            ),
            onTap: () => Navigator.of(context).pushNamed(SupportPage.tag),
          ),
        ],
      ),
    );
  }
}

class _Subject extends StatelessWidget {
  const _Subject();

  @override
  Widget build(BuildContext context) {
    final view = context.watch<GradesDialogController>().view;
    return ListTile(
      leading: SavedGradeIcons.subject,
      title: const Text("Fach"),
      subtitle: Text(
        view.selectedSubject == null
            ? 'Kein Fach ausgewählt'
            : view.selectedSubject!.name,
        style: TextStyle(
          color: view.isSubjectMissing
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      ),
      onTap: () async {
        final res = await showDialog<SubjectId?>(
          context: context,
          builder: (context) => _SelectSubjectDialog(view.selectableSubjects),
        );

        if (res != null && context.mounted) {
          final controller = context.read<GradesDialogController>();
          controller.setSubject(res);
        }
      },
    );
  }
}

class _SelectSubjectDialog extends StatelessWidget {
  const _SelectSubjectDialog(this.subjects);

  final IList<SubjectView> subjects;

  @override
  Widget build(BuildContext context) {
    return MaxWidthConstraintBox(
      maxWidth: 450,
      child: SimpleDialog(
        title: const Text("Fach auswählen"),
        contentPadding: const EdgeInsets.all(12),
        children: [
          for (final subject in subjects)
            _SubjectTile(
              abbreviation: subject.abbreviation,
              name: subject.name,
              design: subject.design,
              onTap: () => Navigator.pop<SubjectId>(context, subject.id),
            ),
          const Divider(),
          const JoinCreateCourseFooter(),
        ],
      ),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({
    required this.name,
    required this.abbreviation,
    required this.design,
    required this.onTap,
  });

  final String name;
  final String abbreviation;
  final Design design;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: design.color.withOpacity(0.2),
        child: Text(
          abbreviation,
          style: TextStyle(color: design.color),
        ),
      ),
      title: Text(name),
      onTap: onTap,
    );
  }
}

class _Date extends StatelessWidget {
  const _Date();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;

    return ListTile(
      leading: SavedGradeIcons.date,
      title: Text(view.selectedDate.parser.toYMMMEd),
      onTap: () async {
        final res = await showDatePicker(
          context: context,
          firstDate: DateTime(2010),
          lastDate: DateTime(2100),
          initialDate: clock.now(),
        );

        if (res != null) {
          controller.setDate(Date.fromDateTime(res));
        }
      },
      trailing: const _DateHelpButton(),
    );
  }
}

class _DateHelpButton extends StatelessWidget {
  const _DateHelpButton();

  @override
  Widget build(BuildContext context) {
    return const _HelpDialogButton(
      title: 'Wozu dient das Datum?',
      text:
          'Das Datum stellt das Datum dar, an dem du die Note erhalten hast. Falls du das Datum nicht mehr genau weißt, kannst du einfach ein ungefähres Datum von dem Tag angeben, an dem du die Note erhalten hast.',
    );
  }
}

class _GradingType extends StatelessWidget {
  const _GradingType();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;
    final hasGradingTypeSelected = view.selectedGradingType != null;

    return ListTile(
      leading: SavedGradeIcons.gradingType,
      title: const Text("Notentyp"),
      subtitle: Text(
        hasGradingTypeSelected
            ? view.selectedGradingType?.predefinedType?.toUiString() ??
                'Benutzerdefinierter Notentyp'
            : 'Kein Notentyp ausgewählt',
        style: TextStyle(
          color: view.isGradeTypeMissing
              ? Theme.of(context).colorScheme.error
              : null,
        ),
      ),
      onTap: () async {
        final res = await showDialog<GradeType?>(
          context: context,
          builder: (context) => SimpleDialog(
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            title: const Text("Notentyp auswählen"),
            children: [
              for (final gradeType in view.selectableGradingTypes)
                ListTile(
                  leading: gradeType.predefinedType?.getIcon() ??
                      const Icon(Icons.help_outline),
                  title: Text(gradeType.predefinedType?.toUiString() ??
                      'Unbekannt/Eigener Notentyp'),
                  onTap: () {
                    Navigator.of(context).pop<GradeType?>(gradeType);
                  },
                ),
            ],
          ),
        );

        if (res != null) {
          controller.setGradeType(res);
        }
      },
    );
  }
}

class _Term extends StatelessWidget {
  const _Term();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;

    return ListTile(
      leading: SavedGradeIcons.term,
      title: const Text("Halbjahr"),
      subtitle: Text(
        view.selectedTerm?.name ?? 'Kein Halbjahr ausgewählt',
        style: TextStyle(
          color:
              view.isTermMissing ? Theme.of(context).colorScheme.error : null,
        ),
      ),
      onTap: () async {
        final res = await showDialog<TermId?>(
          context: context,
          builder: (context) => ChangeNotifierProvider.value(
            value: controller,
            child: const _SelectTermDialog(),
          ),
        );

        if (res != null) {
          controller.setTerm(res);
        }
      },
    );
  }
}

class _SelectTermDialog extends StatelessWidget {
  const _SelectTermDialog();

  @override
  Widget build(BuildContext context) {
    final terms = context.select<GradesDialogController,
        IList<({TermId id, String name})>>((c) => c.view.selectableTerms);
    return MaxWidthConstraintBox(
      maxWidth: 450,
      child: SimpleDialog(
        contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        title: const Text("Halbjahr auswählen"),
        children: [
          if (terms.isEmpty)
            const Padding(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Text(
                  "Bisher hast du keine Halbjahre erstellt. Bitte erstelle ein Halbjahr, um eine Note einzutragen."),
            ),
          for (final term in terms)
            ListTile(
              title: Text(term.name),
              onTap: () {
                Navigator.of(context).pop<TermId?>(term.id);
              },
            ),
          const _CreateTermTile(),
        ],
      ),
    );
  }
}

class _CreateTermTile extends StatelessWidget {
  const _CreateTermTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text("Halbjahr erstellen"),
      onTap: () => Navigator.of(context).pushNamed(CreateTermPage.tag),
    );
  }
}

class _TakeIntoAccountSwitch extends StatelessWidget {
  const _TakeIntoAccountSwitch();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;
    final isEnabled = view.isTakeIntoAccountEnabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          enabled: isEnabled,
          leading: SavedGradeIcons.integrateGradeIntoSubjectGrade,
          title: const Text("Note in Schnitt einbringen"),
          onTap: () {
            controller.setIntegrateGradeIntoSubjectGrade(!view.takeIntoAccount);
          },
          trailing: Switch(
            value: isEnabled ? view.takeIntoAccount : false,
            onChanged: isEnabled
                ? (newVal) =>
                    controller.setIntegrateGradeIntoSubjectGrade(newVal)
                : null,
          ),
        ),
        if (!isEnabled)
          Padding(
            padding: const EdgeInsets.only(left: 58, bottom: 12),
            child: Text(
              'Das Notensystem, welches du ausgewählt hast, ist nicht dasselbe wie das Notensystem deines Halbjahres. Du kannst die Note weiterhin eintragen, aber sie wird nicht in den Schnitt deines Halbjahres einfließen.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<GradesDialogController>();
    return ListTile(
      leading: SavedGradeIcons.title,
      title: TextField(
        controller: controller.view.titleController,
        onChanged: controller.setTitle,
        decoration: InputDecoration(
          labelText: "Titel",
          hintText: "z.B. Lineare Funktionen",
          suffixIcon: const _TitleHelpButton(),
          errorText: context.select<GradesDialogController, String?>(
              (controller) => controller.view.titleErrorText),
        ),
      ),
    );
  }
}

class _TitleHelpButton extends StatelessWidget {
  const _TitleHelpButton();

  @override
  Widget build(BuildContext context) {
    return const _HelpDialogButton(
      title: 'Wozu dient der Titel?',
      text:
          'Falls die Note beispielsweise zu einer Klausur gehört, kannst du das Thema / den Titel der Klausur angeben, um die Note später besser zuordnen zu können.',
    );
  }
}

class _HelpDialogButton extends StatelessWidget {
  const _HelpDialogButton({
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      tooltip: title,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return MaxWidthConstraintBox(
              maxWidth: 450,
              child: AlertDialog(
                title: Text(title),
                content: Text(text),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Schließen"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Details extends StatefulWidget {
  const _Details();

  @override
  State<_Details> createState() => _DetailsState();
}

class _DetailsState extends State<_Details> {
  String? prefilledDetails;

  @override
  void initState() {
    super.initState();
    prefilledDetails = context.read<GradesDialogController>().view.details;
  }

  @override
  Widget build(BuildContext context) {
    return MarkdownField(
      icon: SavedGradeIcons.details,
      onChanged: (value) {},
      prefilledText: prefilledDetails,
      inputDecoration: const InputDecoration(
        labelText: "Notizen",
      ),
    );
  }
}
