// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/models/term_id.dart';
import 'package:sharezone/grades/pages/grades_details_page/grade_details_page.dart';
import 'package:sharezone/grades/pages/grades_view.dart';
import 'package:sharezone/grades/pages/shared/subject_avatar.dart';
import 'package:sharezone/grades/pages/shared/term_tile.dart';
import 'package:sharezone/grades/pages/term_details_page/term_details_page_controller_factory.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'term_details_page_controller.dart';

void openTermDetailsPage(BuildContext context, TermId id) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TermDetailsPage(id: id),
      settings: const RouteSettings(name: TermDetailsPage.tag),
    ),
  );
}

class TermDetailsPage extends StatelessWidget {
  const TermDetailsPage({
    super.key,
    required this.id,
  });

  final TermId id;
  static const tag = 'terms-details-page';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final factory = context.read<TermDetailsPageControllerFactory>();
        return factory.create(id);
      },
      builder: (context, widget) {
        final state = context.watch<TermDetailsPageController>().state;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Halbjahresdetails'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: MaxWidthConstraintBox(
                child: switch (state) {
                  TermDetailsPageLoading() => const _Loading(),
                  TermDetailsPageLoaded() => _Loaded(state),
                  TermDetailsPageError() => _Error(state),
                },
              ),
            ),
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
    const width = double.infinity;
    return const GrayShimmer(
      child: Column(
        children: [
          CustomCard(child: SizedBox(height: 200, width: width)),
          SizedBox(height: 12),
          CustomCard(child: SizedBox(height: 100, width: width)),
          SizedBox(height: 12),
          CustomCard(child: SizedBox(height: 150, width: width)),
        ],
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded(this.state);

  final TermDetailsPageLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TermInformationCard(
          termId: state.term.id,
          displayName: state.term.displayName,
          grade: state.term.avgGrade,
        ),
        const SizedBox(height: 12),
        for (final s in state.subjectsWithGrades)
          _SubjectCard(
            subject: s.subject,
            savedGrades: s.grades,
          )
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error(this.state);

  final TermDetailsPageError state;

  @override
  Widget build(BuildContext context) {
    return ErrorCard(
      message: Text(state.error),
      onContactSupportPressed: () => Navigator.pushNamed(
        context,
        SupportPage.tag,
      ),
    );
  }
}

class _TermInformationCard extends StatelessWidget {
  const _TermInformationCard({
    required this.termId,
    required this.displayName,
    required this.grade,
  });

  final TermId termId;
  final String displayName;
  final AvgGradeView grade;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TermTile(
            termId: termId,
            displayName: displayName,
            avgGrade: grade,
            title: 'Aktuelles Halbjahr',
          ),
        ],
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.subject,
    required this.savedGrades,
  });

  final SubjectView subject;
  final List<SavedGradeView> savedGrades;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              leading: SubjectAvatar(
                abbreviation: subject.abbreviation,
                design: subject.design,
              ),
              title: Text(subject.displayName),
              trailing: Text(
                subject.grade,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Berechnung der Fachnote'),
              onTap: () => snackbarSoon(context: context),
            ),
            if (savedGrades.isNotEmpty) const Divider(),
            for (final savedGrade in savedGrades) ...[
              _SavedGradeTile(savedGrade: savedGrade),
            ],
          ],
        ),
      ),
    );
  }
}

class _SavedGradeTile extends StatelessWidget {
  const _SavedGradeTile({
    required this.savedGrade,
  });

  final SavedGradeView savedGrade;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(savedGrade.title),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GradeDetailsPage(id: savedGrade.id),
        ),
      ),
      subtitle: Text(
        savedGrade.date.toDateString,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      leading: savedGrade.gradeTypeIcon,
      trailing: Text(
        savedGrade.grade,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
