// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/pages/shared/subject_avatar.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page_controller.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page_controller_factory.dart';
import 'package:sharezone/grades/pages/subjects_page/subjects_page_view.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class SubjectsPage extends StatelessWidget {
  const SubjectsPage({super.key});

  static const tag = 'subjects-page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final factory = context.read<SubjectsPageControllerFactory>();
        return factory.create();
      },
      builder: (context, _) {
        final state = context.watch<SubjectsPageController>().state;
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.gradesSettingsSubjectsTitle)),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: switch (state) {
              SubjectsPageLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              SubjectsPageError(:final message) => _Error(message: message),
              SubjectsPageLoaded(:final view) => _Loaded(view: view),
            },
          ),
        );
      },
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: MaxWidthConstraintBox(
        child: ErrorCard(
          message: Text(message),
          onContactSupportPressed:
              () => Navigator.pushNamed(context, SupportPage.tag),
        ),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.view});

  final SubjectsPageView view;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: SafeArea(
        child: MaxWidthConstraintBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _CourseVsSubjectsInfo(),
              const SizedBox(height: 12),
              if (view.hasGradeSubjects) ...[
                _SectionHeader(
                  title: context.l10n.gradesSubjectsPageGradeSubjects,
                ),
                const SizedBox(height: 12),
                for (final subject in view.gradeSubjects) ...[
                  _SubjectTile(subject: subject),
                  const SizedBox(height: 12),
                ],
              ],
              if (view.hasCoursesWithoutSubject) ...[
                _SectionHeader(
                  title: context.l10n.gradesSubjectsPageCoursesWithoutSubject,
                ),
                const SizedBox(height: 12),
                for (final subject in view.coursesWithoutSubject) ...[
                  _CourseTile(subject: subject),
                  const SizedBox(height: 12),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}

class _CourseVsSubjectsInfo extends StatelessWidget {
  const _CourseVsSubjectsInfo();

  @override
  Widget build(BuildContext context) {
    return ExpansionCard(
      header: Text(context.l10n.gradesSubjectsPageInfoHeader),
      body: Text(context.l10n.gradesSubjectsPageInfoBody),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.1),
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({required this.subject});

  final SubjectListItemView subject;

  @override
  Widget build(BuildContext context) {
    Future<void> handleDelete() async {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => _DeleteSubjectDialog(subject: subject),
      );

      if (shouldDelete != true || !context.mounted) return;

      final controller = context.read<SubjectsPageController>();
      try {
        await controller.deleteSubject(subject.id);
        if (!context.mounted) return;
        showSnackSec(
          context: context,
          text: context.l10n.gradesSubjectsPageDeleteSuccess,
        );
      } catch (error) {
        if (!context.mounted) return;
        showSnackSec(
          context: context,
          text: context.l10n.gradesSubjectsPageDeleteFailure(error),
        );
      }
    }

    final subtitle = _buildSubtitle(context);
    final theme = Theme.of(context).textTheme;
    return CardListTile(
      leading: SubjectAvatar(
        abbreviation: subject.abbreviation,
        design: subject.design,
      ),
      title: Text(subject.name, style: theme.titleMedium),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: IconButton(
        tooltip: context.l10n.gradesSubjectsPageDeleteTooltip,
        icon: const Icon(Icons.delete_outline),
        onPressed: handleDelete,
      ),
    );
  }

  String? _buildSubtitle(BuildContext context) {
    final parts = <String>[];

    if (subject.hasGrades) {
      final gradeCount = subject.grades.length;
      final gradeLabel =
          gradeCount == 1
              ? context.l10n.gradesSubjectsPageSingleGrade
              : context.l10n.gradesSubjectsPageMultipleGrades(gradeCount);
      parts.add(gradeLabel);
    } else {
      parts.add(context.l10n.gradesSubjectsPageNoGrades);
    }

    if (subject.connectedCourses.isNotEmpty) {
      final names = subject.connectedCourses.map((c) => c.name).join(', ');
      parts.add(context.l10n.gradesSubjectsPageCoursesLabel(names));
    }

    return parts.isEmpty ? null : parts.join(' · ');
  }
}

class _CourseTile extends StatelessWidget {
  const _CourseTile({required this.subject});

  final SubjectListItemView subject;

  @override
  Widget build(BuildContext context) {
    final courseNames = subject.connectedCourses.map((c) => c.name).join(', ');
    final subtitle =
        courseNames.isEmpty
            ? context.l10n.gradesSubjectsPageCourseNotAssigned
            : context.l10n.gradesSubjectsPageCoursesLabel(courseNames);
    return CardListTile(
      leading: SubjectAvatar(
        abbreviation: subject.abbreviation,
        design: subject.design,
      ),
      title: Text(subject.name, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle),
    );
  }
}

class _DeleteSubjectDialog extends StatelessWidget {
  const _DeleteSubjectDialog({required this.subject});

  final SubjectListItemView subject;

  @override
  Widget build(BuildContext context) {
    final grades = subject.grades;
    return MaxWidthConstraintBox(
      maxWidth: 420,
      child: AlertDialog(
        title: Text(context.l10n.gradesSubjectsPageDeleteTitle(subject.name)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.gradesSubjectsPageDeleteDescription),
              const SizedBox(height: 12),
              if (grades.isEmpty)
                Text(context.l10n.gradesSubjectsPageNoGradesRecorded)
              else
                _GradesList(grades: grades),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonActionsCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.commonActionsDelete),
          ),
        ],
      ),
    );
  }
}

class _GradesList extends StatelessWidget {
  const _GradesList({required this.grades});

  final IList<SubjectGradeView> grades;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMd();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < grades.length; i++) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(grades[i].title),
            subtitle: Text(
              '${grades[i].termName} · ${grades[i].gradeTypeName} · ${formatter.format(grades[i].date.toDateTime)}',
            ),
            trailing: Text(grades[i].displayValue),
          ),
          if (i < grades.length - 1) const Divider(height: 12),
        ],
      ],
    );
  }
}
