// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:date/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_controller.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog_view.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_icons.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

part 'optional_fields.dart';
part 'required_fields.dart';

class GradesDialog extends StatelessWidget {
  const GradesDialog({super.key});

  static const tag = 'grades-dialog';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GradesDialogController>(
      create: (context) => GradesDialogController(
        gradesService: Provider.of<GradesService>(
          context,
          listen: false,
        ),
      ),
      builder: (context, _) {
        final view = context.watch<GradesDialogController>().view;
        return Scaffold(
          appBar: AppBar(
            actions: const [_SaveButton()],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              child: MaxWidthConstraintBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    const _RequiredFields(),
                    const Divider(),
                    const SizedBox(height: 4),
                    _OptionalFields(view: view),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final controller =
        Provider.of<GradesDialogController>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilledButton(
        onPressed: () {
          controller.save();
          Navigator.of(context).pop();
        },
        child: const Text("Speichern"),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      data: Theme.of(context).listTileTheme.copyWith(
            subtitleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(title: title),
          const SizedBox(height: 8),
          for (final child in children)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: child,
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }
}
