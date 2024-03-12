import 'package:flutter/material.dart';
import 'package:sharezone/grades/grade_views.dart';
import 'package:sharezone/grades/term_id.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'terms_details_page_controller.dart';

class TermsDetailsPage extends StatelessWidget {
  const TermsDetailsPage({super.key, required this.id});

  final TermId id;

  @override
  Widget build(BuildContext context) {
    final controller = TermsDetailsPageController(termId: id);
    final state = controller.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halbjahresdetails'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthConstraintBox(
          child: switch (state) {
            TermDetailsPageLoading() => const _Loading(),
            TermDetailsPageLoaded() => _Loaded(state),
            TermDetailsPageError() => _Error(state),
          },
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: LoadingCircle());
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
          displayName: state.term.displayName,
          grade: state.term.avgGrade,
        ),
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
      message: Text('todo'),
      onContactSupportPressed: () => Navigator.pushNamed(
        context,
        SupportPage.tag,
      ),
    );
  }
}

class _TermInformationCard extends StatelessWidget {
  const _TermInformationCard({
    required this.displayName,
    required this.grade,
  });

  final String displayName;
  final AvgGradeView grade;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Aktuelles Halbjahr',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(displayName,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Text(
                grade.$1,
                style: TextStyle(
                  color: grade.$2.toColor(),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Berechnung des Schnitts'),
            onTap: () => snackbarSoon(context: context),
          )
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
    return CustomCard(
      child: Column(
        children: [
          ListTile(
            title: Text(subject.displayName),
            trailing: Text(subject.grade),
          ),
          const ListTile(
            leading: Icon(Icons.edit),
            title: Text('Berechnung der Fachnote'),
          ),
          if (savedGrades.isNotEmpty) const Divider(),
          for (final savedGrade in savedGrades) ...[
            ListTile(
              title: Text(savedGrade.gradeTypeName),
              subtitle: Text(savedGrade.date.toDateString),
              leading: savedGrade.gradeTypeIcon,
              trailing: Text(savedGrade.grade),
            ),
          ],
        ],
      ),
    );
  }
}
