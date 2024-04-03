// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_icons.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'term_dialog_controller.dart';

class TermDialog extends StatelessWidget {
  const TermDialog({super.key, required this.gradesService});

  final GradesService gradesService;

  static const tag = 'term-dialog';

  @override
  Widget build(BuildContext context) {
    final controller = TermDialogController(gradesService);
    return MaxWidthConstraintBox(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PrefilledTextField(
                  key: const ValueKey('term-name-field'),
                  decoration:
                      const InputDecoration(labelText: 'Name des Halbjahres'),
                  prefilledText: controller.termName,
                  onChanged: (value) {
                    controller.setTermName(value);
                  },
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: SavedGradeIcons.gradingSystem,
                  title: const Text("Notensystem"),
                  subtitle: Text(controller.gradingSystem.displayName),
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
                                Navigator.of(context)
                                    .pop<GradingSystem?>(gradingSystem);
                              },
                            ),
                        ],
                      ),
                    );

                    if (res != null) {
                      controller.setGradingSystem(res);
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  key: const ValueKey('save-button'),
                  onPressed: () async {
                    await controller.createTerm();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Halbjahr erstellen'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  key: const ValueKey('cancel-button'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Abbrechen'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
