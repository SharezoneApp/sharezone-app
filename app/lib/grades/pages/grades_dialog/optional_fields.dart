// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

part of 'grades_dialog.dart';

class _OptionalFields extends StatelessWidget {
  const _OptionalFields({
    required this.view,
  });

  final GradesDialogView view;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: "Optional",
      children: [
        _IntegrateGradeIntoSubjectGrade(
            value: view.integrateGradeIntoSubjectGrade),
        _Topic(topic: view.topic),
        _Notes(notes: view.topic),
      ],
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

class _Topic extends StatelessWidget {
  const _Topic({
    required this.topic,
  });

  final String? topic;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.topic,
      title: PrefilledTextField(
        prefilledText: topic,
        decoration: const InputDecoration(
          labelText: "Thema",
          hintText: "z.B. Lineare Funktionen",
          suffixIcon: _TopicHelpButton(),
        ),
      ),
    );
  }
}

class _TopicHelpButton extends StatelessWidget {
  const _TopicHelpButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      tooltip: 'Wozu dient das Thema?',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Wozu dient das Thema?"),
              content: const Text(
                  'Falls die Note beispielsweise zu einer Klausur gehört, kannst du das Thema der Klausur angeben, um die Note später besser zuordnen zu können.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Schließen"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Notes extends StatelessWidget {
  const _Notes({
    required this.notes,
  });

  final String? notes;

  @override
  Widget build(BuildContext context) {
    return MarkdownField(
      icon: SavedGradeIcons.notes,
      onChanged: (value) {},
      prefilledText: notes,
      inputDecoration: const InputDecoration(
        labelText: "Notizen",
      ),
    );
  }
}
