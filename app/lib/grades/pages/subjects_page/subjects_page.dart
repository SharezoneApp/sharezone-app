// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
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
          appBar: AppBar(title: const Text('Fächer')),
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
                const _SectionHeader(title: 'Notenfächer'),
                const SizedBox(height: 12),
                for (final subject in view.gradeSubjects) ...[
                  _SubjectTile(subject: subject),
                  const SizedBox(height: 12),
                ],
              ],
              if (view.hasCoursesWithoutSubject) ...[
                const _SectionHeader(title: 'Kurse ohne Notenfach'),
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
      header: const Text('Notenfächer vs Kurse'),
      body: const Text(
        '''In Sharezone werden alle Inhalte (wie Hausaufgaben oder Prüfungen) einem Kurs zugeordnet. Deine Noten werden jedoch in Notenfächern gespeichert - nicht in Kursen. So bleiben sie erhalten, auch wenn du einen Kurs verlässt.

Das hat noch einen Vorteil: Du kannst deine Noten nach Fächern sortieren und später deine Entwicklung in einem Fach über mehrere Jahre hinweg verfolgen (diese Funktion ist bald verfügbar).

Sharezone legt automatisch ein Notenfach an, sobald du eine Note in einem Kurs erstellst.
''',
      ),
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
          text: 'Fach und zugehörige Noten gelöscht.',
        );
      } catch (error) {
        if (!context.mounted) return;
        showSnackSec(
          context: context,
          text: 'Fach konnte nicht gelöscht werden: $error',
        );
      }
    }

    final subtitle = _buildSubtitle();
    final theme = Theme.of(context).textTheme;
    return CardListTile(
      leading: SubjectAvatar(
        abbreviation: subject.abbreviation,
        design: subject.design,
      ),
      title: Text(subject.name, style: theme.titleMedium),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: IconButton(
        tooltip: 'Fach löschen',
        icon: const Icon(Icons.delete_outline),
        onPressed: handleDelete,
      ),
    );
  }

  String? _buildSubtitle() {
    final parts = <String>[];

    if (subject.hasGrades) {
      final gradeCount = subject.grades.length;
      final gradeLabel = gradeCount == 1 ? '1 Note' : '$gradeCount Noten';
      parts.add(gradeLabel);
    } else {
      parts.add('Keine Noten');
    }

    if (subject.connectedCourses.isNotEmpty) {
      final names = subject.connectedCourses.map((c) => c.name).join(', ');
      parts.add('Kurse: $names');
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
            ? 'Dieser Kurs ist noch keinem Notenfach zugeordnet.'
            : 'Kurse: $courseNames';
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
        title: Text('${subject.name} löschen'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Beim Löschen werden alle zugehörigen Noten dauerhaft entfernt.',
              ),
              const SizedBox(height: 12),
              if (grades.isEmpty)
                const Text('Für dieses Fach wurden noch keine Noten erfasst.')
              else
                _GradesList(grades: grades),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
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
