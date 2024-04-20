// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/create_term_page/create_term_page.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_controller.dart';
import 'package:sharezone/grades/pages/term_settings_page/term_settings_page_view.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class TermSettingsPage extends StatelessWidget {
  const TermSettingsPage({
    super.key,
    required this.termId,
  });

  static const tag = 'term-settings-page';

  final TermId termId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final gradesService = context.read<GradesService>();
        return TermSettingsPageController(
          gradesService: gradesService,
          termId: termId,
        );
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
  const _AppBarTitle({
    required this.name,
  });

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
  const _Error({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ErrorCard(
        message: Text(message),
        onContactSupportPressed: () =>
            Navigator.pushNamed(context, SupportPage.tag),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.view,
  });

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
  const _NameDialog({
    required this.name,
  });

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
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
  const _IsActiveTerm({
    required this.isActiveTerm,
  });

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

class _GradingSystem extends StatelessWidget {
  const _GradingSystem({
    required this.gradingSystem,
  });

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
