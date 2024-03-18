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
        _Title(title: view.title),
        _Details(details: view.details),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SavedGradeIcons.topic,
      title: PrefilledTextField(
        prefilledText: title,
        decoration: const InputDecoration(
          labelText: "Titel",
          hintText: "z.B. Lineare Funktionen",
          suffixIcon: _TitleHelpButton(),
        ),
      ),
    );
  }
}

class _TitleHelpButton extends StatelessWidget {
  const _TitleHelpButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      tooltip: 'Wozu dient der Titel?',
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Wozu dient der Titel?"),
              content: const Text(
                  'Falls die Note beispielsweise zu einer Klausur gehört, kannst du das Thema / den Titel der Klausur angeben, um die Note später besser zuordnen zu können.'),
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

class _Details extends StatelessWidget {
  const _Details({
    required this.details,
  });

  final String? details;

  @override
  Widget build(BuildContext context) {
    return MarkdownField(
      icon: SavedGradeIcons.notes,
      onChanged: (value) {},
      prefilledText: details,
      inputDecoration: const InputDecoration(
        labelText: "Notizen",
      ),
    );
  }
}
