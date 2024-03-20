// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'grades_dialog.dart';

class _RequiredFields extends StatelessWidget {
  const _RequiredFields({
    required this.view,
  });

  final GradesDialogView view;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: "Pflichtfelder",
      children: [
        const _GradeValue(),
        _GradingSystem(
          selectedGradingSystem: view.selectedGradingSystem,
        ),
        _Subject(selectedSubject: view.selectedSubject),
        _Date(selectedDate: view.selectedDate),
        _GradingType(selectedGradingType: view.selectedGradingType),
        _Term(selectedTerm: view.selectedTerm),
        _IntegrateGradeIntoSubjectGrade(
            value: view.integrateGradeIntoSubjectGrade),
      ],
    );
  }
}

class _GradeValue extends StatelessWidget {
  const _GradeValue();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.value,
      title: const Text("Note"),
      onTap: () => snackbarSoon(context: context),
    );
  }
}

class _GradingSystem extends StatelessWidget {
  const _GradingSystem({
    required this.selectedGradingSystem,
  });

  final String selectedGradingSystem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.gradingSystem,
      title: const Text("Notensystem"),
      subtitle: Text(selectedGradingSystem),
      onTap: () => snackbarSoon(context: context),
    );
  }
}

class _Subject extends StatelessWidget {
  const _Subject({
    required this.selectedSubject,
  });

  final String? selectedSubject;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.subject,
      title: const Text("Fach"),
      subtitle: Text(
          selectedSubject == null ? 'Kein Fach ausgewählt' : selectedSubject!),
      onTap: () => snackbarSoon(context: context),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date({
    required this.selectedDate,
  });

  final String selectedDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.date,
      title: Text(selectedDate),
      onTap: () => snackbarSoon(context: context),
    );
  }
}

class _GradingType extends StatelessWidget {
  const _GradingType({
    required this.selectedGradingType,
  });

  final String selectedGradingType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.gradingType,
      title: const Text("Notentyp"),
      subtitle: Text(selectedGradingType),
      onTap: () => snackbarSoon(context: context),
    );
  }
}

class _Term extends StatelessWidget {
  const _Term({
    required this.selectedTerm,
  });

  final String? selectedTerm;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.term,
      title: const Text("Halbjahr"),
      subtitle: selectedTerm == null ? null : Text(selectedTerm!),
      onTap: () => snackbarSoon(context: context),
    );
  }
}

class _IntegrateGradeIntoSubjectGrade extends StatelessWidget {
  const _IntegrateGradeIntoSubjectGrade({
    required this.value,
  });

  final bool value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.integrateGradeIntoSubjectGrade,
      title: const Text("Note in Fachnote einbringen"),
      onTap: () => snackbarSoon(context: context),
      trailing: Switch(
        value: value,
        onChanged: (value) => snackbarSoon(context: context),
      ),
    );
  }
}
