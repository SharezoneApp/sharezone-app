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
import 'package:sharezone/grades/pages/shared/final_grade_type_settings.dart';
import 'package:sharezone/grades/pages/shared/weight_settings.dart';
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
          subRef: gradesService.term(termId).subject(subjectId),
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
              _FinalGradeType(view: view),
              const Divider(),
              WeightSettings(
                selectableGradingTypes: view.selectableGradingTypes,
                weights: view.weights,
                onRemoveGradeType: (gradeTypeId) {
                  final controller =
                      context.read<SubjectSettingsPageController>();
                  controller.removeGradeType(gradeTypeId);
                },
                onSetGradeWeight: (gradeTypeId, weight) {
                  final controller =
                      context.read<SubjectSettingsPageController>();
                  controller.setGradeWeight(
                    gradeTypeId: gradeTypeId,
                    weight: weight,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinalGradeType extends StatelessWidget {
  const _FinalGradeType({
    required this.view,
  });

  final SubjectSettingsPageView view;

  @override
  Widget build(BuildContext context) {
    return FinalGradeTypeSettings(
      icon: view.finalGradeTypeIcon,
      displayName: view.finalGradeTypeDisplayName,
      selectableGradingTypes: view.selectableGradingTypes,
      onSetFinalGradeType: (type) {
        final controller = context.read<SubjectSettingsPageController>();
        controller.setFinalGradeType(type);
      },
    );
  }
}
