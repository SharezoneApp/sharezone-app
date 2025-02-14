// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_analytics.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page_controller.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_icons.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class CreateTermPage extends StatelessWidget {
  const CreateTermPage({super.key});

  static const tag = 'create-term-page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final analytics = context.read<Analytics>();
        return CreateTermPageController(
          gradesService: Provider.of<GradesService>(context, listen: false),
          analytics: CreateTermAnalytics(analytics),
          crashAnalytics: context.read<CrashAnalytics>(),
        );
      },
      child: Scaffold(
        appBar: AppBar(actions: const [_SaveButton()]),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: SafeArea(
            child: MaxWidthConstraintBox(
              child: Column(
                children: [
                  _NameField(),
                  SizedBox(height: 8),
                  _GradingSystem(),
                  SizedBox(height: 8),
                  _ActiveTermSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  void showConfirmationSnackBar(BuildContext context) {
    showSnackSec(context: context, text: "Halbjahr gespeichert.");
  }

  void showErrorSnackBar(BuildContext context, TermException e) {
    showSnackSec(
      context: context,
      text: switch (e) {
        InvalidTermNameException() => 'Bitte gib einen gültigen Namen ein.',
        CouldNotSaveTermException() =>
          'Das Halbjahr konnte nicht gespeichert werden: $e',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateTermPageController>(
      context,
      listen: false,
    );
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilledButton(
        onPressed: () {
          try {
            controller.save();
            showConfirmationSnackBar(context);
            Navigator.of(context).pop();
          } on TermException catch (e) {
            if (!context.mounted) return;
            showErrorSnackBar(context, e);
          }
        },
        child: const Text("Speichern"),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreateTermPageController>();
    final view = controller.view;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: TextField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "z.B. 10/2",
              errorText: view.nameErrorText,
            ),
            onChanged: controller.setName,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 56, right: 12),
          child: Text(
            "Der Name beschreibt das Halbjahr, z.B. '10/2' für das zweite Halbjahr der 10. Klasse.",
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradingSystem extends StatelessWidget {
  const _GradingSystem();

  @override
  Widget build(BuildContext context) {
    final gradingSystem = context
        .select<CreateTermPageController, GradingSystem>(
          (controller) => controller.view.gradingSystem,
        );
    return GradingSystemBase(
      currentGradingSystemName: gradingSystem.displayName,
      onGradingSystemChanged: (res) {
        final controller = context.read<CreateTermPageController>();
        controller.setGradingSystem(res);
      },
    );
  }
}

class GradingSystemBase extends StatelessWidget {
  const GradingSystemBase({
    super.key,
    required this.currentGradingSystemName,
    required this.onGradingSystemChanged,
  });

  final String currentGradingSystemName;
  final ValueChanged<GradingSystem> onGradingSystemChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final res = await showDialog<GradingSystem?>(
          context: context,
          builder:
              (context) => SimpleDialog(
                title: const Text("Notensystem auswählen"),
                children: [
                  for (final gradingSystem in GradingSystem.values)
                    ListTile(
                      title: Text(gradingSystem.displayName),
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pop<GradingSystem?>(gradingSystem);
                      },
                    ),
                ],
              ),
        );

        if (res != null && context.mounted) {
          onGradingSystemChanged(res);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: SavedGradeIcons.gradingSystem,
            title: const Text("Notensystem"),
            subtitle: Text(currentGradingSystemName),
            mouseCursor: SystemMouseCursors.click,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 58, bottom: 12),
            child: Text(
              'Nur Noten von dem Notensystem, welches für das Halbjahr festlegt wurde, können für den Schnitt des Halbjahres berücksichtigt werden. Solltest du beispielsweise für das Halbjahr das Notensystem "1 - 6" festlegen und eine Note mit dem Notensystem "15 - 0" eintragen, kann diese Note für den Halbjahresschnitt nicht berücksichtigt werden.',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveTermSwitch extends StatelessWidget {
  const _ActiveTermSwitch();

  @override
  Widget build(BuildContext context) {
    final isActiveTerm = context.select<CreateTermPageController, bool>(
      (controller) => controller.view.isActiveTerm,
    );
    return ActiveTermSwitchBase(
      isActiveTerm: isActiveTerm,
      onActiveTermChanged: (res) {
        final controller = context.read<CreateTermPageController>();
        controller.setIsCurrentTerm(res);
      },
    );
  }
}

class ActiveTermSwitchBase extends StatelessWidget {
  const ActiveTermSwitchBase({
    super.key,
    required this.isActiveTerm,
    required this.onActiveTermChanged,
  });

  final bool isActiveTerm;
  final ValueChanged<bool> onActiveTermChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      onTap: () => onActiveTermChanged(!isActiveTerm),
      title: const Text("Aktuelles Halbjahr"),
      trailing: Switch(value: isActiveTerm, onChanged: onActiveTermChanged),
    );
  }
}
