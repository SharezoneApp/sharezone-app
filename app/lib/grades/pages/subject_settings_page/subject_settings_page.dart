// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/grades_service/grades_service.dart';
import 'package:sharezone/grades/pages/shared/select_grade_type_dialog.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_controller.dart';
import 'package:sharezone/grades/pages/subject_settings_page/subject_settings_page_view.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SubjectSettingsPage extends StatelessWidget {
  const SubjectSettingsPage({
    super.key,
    required this.subjectId,
    required this.termId,
  });

  final SubjectId subjectId;
  final TermId termId;

  static const tag = 'subject-settings-page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final gradesService = context.read<GradesService>();
        return SubjectSettingsPageController(
          subjectId: subjectId,
          termId: termId,
          gradesService: gradesService,
        );
      },
      builder: (context, _) {
        final state = context.watch<SubjectSettingsPageController>().state;
        final subjectDisplayName = switch (state) {
          SubjectSettingsLoaded() => state.view.subjectName,
          _ => '?'
        };
        return Scaffold(
          appBar: AppBar(
            title: Text('Einstellungen: $subjectDisplayName'),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: switch (state) {
              SubjectSettingsLoading() => const _Loading(),
              SubjectSettingsError() => _Error(message: state.message),
              SubjectSettingsLoaded() => _Loaded(view: state.view),
            },
          ),
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return ErrorCard(
      message: Text(message),
      onContactSupportPressed: () =>
          Navigator.pushNamed(context, SupportPage.tag),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({
    required this.view,
  });

  final SubjectSettingsPageView view;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: MaxWidthConstraintBox(
        child: SafeArea(
          child: Column(
            children: [
              _FinalGradeType(
                displayName: view.finalGradeTypeDisplayName,
                icon: view.finalGradeTypeIcon,
                selectableGradingTypes: view.selectableGradingTypes,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _FinalGradeType extends StatelessWidget {
  const _FinalGradeType({
    required this.icon,
    required this.displayName,
    required this.selectableGradingTypes,
  });

  final Icon icon;
  final String displayName;
  final IList<GradeType> selectableGradingTypes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Endnote',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Solange keine Endnote für einen Kurs feststeht, wird eine vorläufige Kursnote anhand der eingetragenen Noten berechnet. Wenn eine Endnote feststeht, kann die berechnete Kursnote überschrieben werden.',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
        const SizedBox(height: 8),
        ListTile(
          leading: icon,
          title: Text(displayName),
          onTap: () async {
            final type = await SelectGradeTypeDialog.show(
              context: context,
              selectableGradingTypes: selectableGradingTypes.toList(),
            );

            if (type != null && context.mounted) {
              final controller = context.read<SubjectSettingsPageController>();
              controller.setFinalGradeType(type);
            }
          },
        ),
      ],
    );
  }
}
