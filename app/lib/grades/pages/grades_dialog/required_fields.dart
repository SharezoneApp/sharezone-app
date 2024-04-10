// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'grades_dialog.dart';

class _RequiredFields extends StatelessWidget {
  const _RequiredFields();

  @override
  Widget build(BuildContext context) {
    return const _Section(
      title: "Pflichtfelder",
      children: [
        _GradeValue(),
        _GradingSystem(),
        _Subject(),
        _Date(),
        _GradingType(),
        _Term(),
        _IntegrateGradeIntoSubjectGrade(),
      ],
    );
  }
}

class _GradeValue extends StatelessWidget {
  const _GradeValue();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;
    final selectableGrades = view.selectableGrades;
    return ListTile(
      leading: SavedGradeIcons.value,
      title: Text(view.selectedGrade ?? 'Keine Note ausgewählt'),
      onTap: () async {
        final res = await showDialog<String?>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text("Note auswählen"),
            children: [
              if (selectableGrades.distinctGrades != null)
                for (final grade in selectableGrades.distinctGrades!)
                  ListTile(
                    title: Text(grade),
                    onTap: () {
                      Navigator.of(context).pop<String?>(grade);
                    },
                  ),
              if (selectableGrades.nonDistinctGrades != null)
                StatefulBuilder(builder: (context, setState) {
                  String input = "";

                  return PrefilledTextField(
                    decoration: const InputDecoration(label: Text('Note')),
                    prefilledText: input,
                    onChanged: (val) => input = val,
                    onEditingComplete: () =>
                        Navigator.of(context).pop<String?>(input),
                  );
                })
            ],
          ),
        );

        if (res != null) {
          controller.setGrade(res);
        }
      },
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
          builder: (context) => SimpleDialog(
            title: const Text("Note auswählen"),
            children: [
              for (final gradingSystem in GradingSystem.values)
                ListTile(
                  title: Text(gradingSystem.displayName),
                  onTap: () {
                    Navigator.of(context).pop<GradingSystem?>(gradingSystem);
                  },
                ),
            ],
          ),
        );

        if (res != null) {
          controller.setGradingSystem(res);
        }
      },
    );
  }
}

class _Subject extends StatelessWidget {
  const _Subject();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;

    return ListTile(
      leading: SavedGradeIcons.subject,
      title: const Text("Fach"),
      subtitle: Text(view.selectedSubject == null
          ? 'Kein Fach ausgewählt'
          : view.selectedSubject!.name),
      onTap: () async {
        final res = await showDialog<SubjectId?>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text("Fach auswählen"),
            children: [
              for (final subject in view.selectableSubjects)
                ListTile(
                  title: Text(subject.name),
                  onTap: () {
                    Navigator.of(context).pop<SubjectId?>(subject.id);
                  },
                ),
            ],
          ),
        );

        if (res != null) {
          controller.setSubject(res);
        }
      },
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
    );
  }
}

class _GradingType extends StatelessWidget {
  const _GradingType();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;

    return ListTile(
      leading: SavedGradeIcons.gradingType,
      title: const Text("Notentyp"),
      subtitle: Text(view.selectedGradingType.predefinedType?.toString() ??
          'Kein Notentyp ausgewählt / Benutzerdefinierter Notentyp'),
      onTap: () async {
        final res = await showDialog<GradeType?>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text("Note auswählen"),
            children: [
              for (final gradeType in view.selectableGradingTypes)
                ListTile(
                  title: Text(gradeType.predefinedType?.toString() ??
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
      subtitle: Text(view.selectedTerm?.name ?? 'Kein Halbjahr ausgewählt'),
      onTap: () async {
        final res = await showDialog<TermId?>(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text("Note auswählen"),
            children: [
              for (final term in view.selectableTerms)
                ListTile(
                  title: Text(term.name),
                  onTap: () {
                    Navigator.of(context).pop<TermId?>(term.id);
                  },
                ),
            ],
          ),
        );

        if (res != null) {
          controller.setTerm(res);
        }
      },
    );
  }
}

class _IntegrateGradeIntoSubjectGrade extends StatelessWidget {
  const _IntegrateGradeIntoSubjectGrade();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradesDialogController>(context);
    final view = controller.view;
    return ListTile(
      leading: SavedGradeIcons.integrateGradeIntoSubjectGrade,
      title: const Text("Note in Fachnote einbringen"),
      onTap: () => snackbarSoon(context: context),
      trailing: Switch(
        value: view.integrateGradeIntoSubjectGrade,
        onChanged: (newVal) =>
            controller.setIntegrateGradeIntoSubjectGrade(newVal),
      ),
    );
  }
}
