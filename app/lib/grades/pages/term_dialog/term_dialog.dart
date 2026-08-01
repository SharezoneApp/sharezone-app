// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
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
                  decoration: InputDecoration(
                    labelText: context.l10n.gradesTermDialogNameLabel,
                  ),
                  prefilledText: controller.termName,
                  onChanged: (value) {
                    controller.setTermName(value);
                  },
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: SavedGradeIcons.gradingSystem,
                  title: Text(context.l10n.gradesDialogGradingSystemLabel),
                  subtitle: Text(
                    controller.gradingSystem.toLocalizedString(context),
                  ),
                  onTap: () async {
                    final res = await showDialog<GradingSystem?>(
                      context: context,
                      builder:
                          (context) => SimpleDialog(
                            title: Text(context.l10n.gradesDialogSelectGrade),
                            children: [
                              for (final gradingSystem in GradingSystem.values)
                                ListTile(
                                  title: Text(
                                    gradingSystem.toLocalizedString(context),
                                  ),
                                  onTap: () {
                                    Navigator.of(
                                      context,
                                    ).pop<GradingSystem?>(gradingSystem);
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
                    await controller.addTerm();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(context.l10n.gradesDialogCreateTerm),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  key: const ValueKey('cancel-button'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(context.l10n.commonActionsCancel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
