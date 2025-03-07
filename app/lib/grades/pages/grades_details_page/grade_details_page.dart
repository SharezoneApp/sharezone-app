// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/models/grade_id.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page_controller_factory.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_view.dart';
import 'package:sharezone/grades/pages/grades_dialog/grades_dialog.dart';
import 'package:sharezone/grades/pages/shared/saved_grade_icons.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class GradeDetailsPage extends StatelessWidget {
  const GradeDetailsPage({super.key, required this.id});

  final GradeId id;
  static const tag = 'grade-details-page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final factory = context.read<GradeDetailsPageControllerFactory>();
        return factory.create(id);
      },
      child: Scaffold(
        appBar: AppBar(actions: const [_DeleteIconButton(), _EditIconButton()]),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: SafeArea(child: MaxWidthConstraintBox(child: _Body())),
        ),
      ),
    );
  }
}

class _DeleteIconButton extends StatelessWidget {
  const _DeleteIconButton();

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const _DeleteConfirmationDialog(),
    );
  }

  void showGradeDeletedSnackBar(BuildContext context) {
    showSnackSec(context: context, text: 'Note gelöscht.');
  }

  void deleteGrade(BuildContext context) {
    final controller = context.read<GradeDetailsPageController>();
    controller.deleteGrade();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('delete-grade-icon-button'),
      tooltip: 'Note löschen',
      onPressed: () async {
        final shouldDelete = await _showDeleteConfirmationDialog(context);
        if (shouldDelete != true || !context.mounted) return;

        deleteGrade(context);
        showGradeDeletedSnackBar(context);
        Navigator.pop(context);
      },
      icon: const Icon(Icons.delete),
    );
  }
}

class _DeleteConfirmationDialog extends StatelessWidget {
  const _DeleteConfirmationDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('delete-grade-confirmation-dialog'),
      title: const Text('Note löschen'),
      content: const Text('Möchtest du diese Note wirklich löschen?'),
      actions: [
        TextButton(
          key: const Key('delete-grade-confirmation-dialog-cancel-button'),
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          key: const Key('delete-grade-confirmation-dialog-delete-button'),
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Löschen'),
        ),
      ],
    );
  }
}

class _EditIconButton extends StatelessWidget {
  const _EditIconButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('edit-grade-icon-button'),
      tooltip: 'Note bearbeiten',
      onPressed: () async {
        await Navigator.pushNamed(context, GradesDialog.tag);
      },
      icon: const Icon(Icons.edit),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GradeDetailsPageController>();
    final state = controller.state;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (state) {
        GradeDetailsPageLoading() => const _Loading(),
        GradeDetailsPageError() => _Error(state: state),
        GradeDetailsPageLoaded(view: final view) => _Items(view: view),
      },
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.state});

  final GradeDetailsPageError state;

  @override
  Widget build(BuildContext context) {
    return ErrorCard(
      message: Text(state.message),
      onContactSupportPressed:
          () => Navigator.pushNamed(context, SupportPage.tag),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    const dummyView = GradeDetailsView(
      gradeValue: '5',
      gradingSystem: '5-Point',
      subjectDisplayName: 'Math',
      date: '2021-09-01',
      gradeType: 'Test',
      termDisplayName: '1st Term',
      integrateGradeIntoSubjectGrade: true,
      title: 'Algebra',
      details: 'This is a test grade for algebra.',
    );
    return const _Items(view: dummyView, isLoading: true);
  }
}

class _Items extends StatelessWidget {
  const _Items({required this.view, this.isLoading = false});

  final GradeDetailsView view;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Provider<_IsLoading>.value(
      value: isLoading,
      child: GrayShimmer(
        enabled: isLoading,
        child: Column(
          children: [
            _GradeValue(value: view.gradeValue),
            _GradingSystem(gradingSystemDisplayName: view.gradingSystem),
            _Subject(subjectDisplayName: view.subjectDisplayName),
            _Date(date: view.date),
            _GradingType(gradeType: view.gradeType),
            _Term(termDisplayName: view.termDisplayName),
            _IntegrateGradeIntoSubjectGrade(
              value: view.integrateGradeIntoSubjectGrade,
            ),
            _Topic(topic: view.title),
            _Details(details: view.details),
          ],
        ),
      ),
    );
  }
}

class _GradeValue extends StatelessWidget {
  const _GradeValue({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return _GradeDetailsTile(
      leading: SavedGradeIcons.value,
      title: Text(value),
    );
  }
}

class _GradingSystem extends StatelessWidget {
  const _GradingSystem({required this.gradingSystemDisplayName});

  final String gradingSystemDisplayName;

  @override
  Widget build(BuildContext context) {
    return _GradeDetailsTile(
      leading: SavedGradeIcons.gradingSystem,
      title: const Text("Notensystem"),
      subtitle: Text(gradingSystemDisplayName),
    );
  }
}

class _Subject extends StatelessWidget {
  const _Subject({required this.subjectDisplayName});

  final String subjectDisplayName;

  @override
  Widget build(BuildContext context) {
    return _GradeDetailsTile(
      leading: SavedGradeIcons.subject,
      title: const Text("Fach"),
      subtitle: Text(subjectDisplayName),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return _GradeDetailsTile(leading: SavedGradeIcons.date, title: Text(date));
  }
}

class _GradingType extends StatelessWidget {
  const _GradingType({required this.gradeType});

  final String gradeType;

  @override
  Widget build(BuildContext context) {
    return _GradeDetailsTile(
      leading: SavedGradeIcons.gradingType,
      title: const Text("Notentyp"),
      subtitle: Text(gradeType),
    );
  }
}

class _Term extends StatelessWidget {
  const _Term({required this.termDisplayName});

  final String termDisplayName;

  @override
  Widget build(BuildContext context) {
    return _GradeDetailsTile(
      leading: SavedGradeIcons.term,
      title: const Text("Halbjahr"),
      subtitle: Text(termDisplayName),
    );
  }
}

class _IntegrateGradeIntoSubjectGrade extends StatelessWidget {
  const _IntegrateGradeIntoSubjectGrade({required this.value});

  final bool? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) return const SizedBox();
    return _GradeDetailsTile(
      leading: SavedGradeIcons.integrateGradeIntoSubjectGrade,
      title: const Text("In Schnitt einbringen"),
      trailing: Icon(value! ? Icons.check : Icons.close),
    );
  }
}

class _Topic extends StatelessWidget {
  const _Topic({required this.topic});

  final String? topic;

  @override
  Widget build(BuildContext context) {
    if (topic == null) return const SizedBox();
    return _GradeDetailsTile(
      leading: SavedGradeIcons.title,
      title: Text(topic!),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.details});

  final String? details;

  @override
  Widget build(BuildContext context) {
    if (details == null) return const SizedBox();
    return _GradeDetailsTile(
      leading: SavedGradeIcons.details,
      title: Text(details!),
    );
  }
}

typedef _IsLoading = bool;

class _GradeDetailsTile extends StatelessWidget {
  const _GradeDetailsTile({
    this.leading,
    this.title,
    this.trailing,
    this.subtitle,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<_IsLoading>();
    final boxDecoration = BoxDecoration(
      color: isLoading ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(5),
    );
    return ListTile(
      leading: leading,
      title:
          isLoading
              ? Container(
                height: 20,
                width: double.infinity,
                decoration: boxDecoration,
              )
              : title,
      subtitle: () {
        if (subtitle == null) return null;
        if (isLoading) {
          return Container(
            height: 15,
            width: double.infinity,
            decoration: boxDecoration,
          );
        }
        return subtitle;
      }(),
      trailing: trailing,
    );
  }
}
