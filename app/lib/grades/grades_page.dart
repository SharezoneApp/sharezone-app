import 'package:flutter/material.dart';
import 'package:sharezone/grades/grade_views.dart';
import 'package:sharezone/grades/grades_page_controller.dart';
import 'package:sharezone/grades/term_id.dart';
import 'package:sharezone/grades/terms_details_page.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  static const tag = "grades-page";

  @override
  Widget build(BuildContext context) {
    final controller = GradesPageController();
    final state = controller.state;
    return SharezoneMainScaffold(
      navigationItem: NavigationItem.grades,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: MaxWidthConstraintBox(
          child: switch (state) {
            GradesPageLoading() => const _Loading(),
            GradesPageLoaded() => _Loaded(state: state),
            GradesPageError() => _Error(state: state),
          },
        ),
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final GradesPageLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CurrentTerm(
          id: state.currentTerm.id,
          displayName: state.currentTerm.displayName,
          avgGrade: state.currentTerm.avgGrade,
          subjects: state.currentTerm.subjects,
        ),
        for (final pastTerm in state.pastTerms)
          _PastTerm(
            id: pastTerm.id,
            displayName: pastTerm.displayName,
            avgGrade: pastTerm.avgGrade,
          ),
      ],
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

class _Error extends StatelessWidget {
  const _Error({required this.state});

  final GradesPageError state;

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

class _CurrentTerm extends StatelessWidget {
  const _CurrentTerm({
    required this.displayName,
    required this.avgGrade,
    required this.subjects,
    required this.id,
  });

  final TermId id;
  final String displayName;
  final AvgGradeView avgGrade;
  final List<SubjectView> subjects;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: () => navigateToTerm(context, id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vergangene Halbjahr'),
                    Text(displayName),
                  ],
                ),
              ),
              _TermGrade(grade: avgGrade)
            ],
          ),
          const Divider(),
          for (final subject in subjects)
            ListTile(
              leading: IconButton.filled(
                color: subject.design.color.withOpacity(0.2),
                onPressed: () {},
                icon: Text(
                  subject.abbreviation,
                  style: TextStyle(color: subject.design.color),
                ),
              ),
              title: Text(subject.displayName),
              trailing: Text(subject.grade),
            )
        ],
      ),
    );
  }
}

class _PastTerm extends StatelessWidget {
  const _PastTerm({
    required this.id,
    required this.displayName,
    required this.avgGrade,
  });

  final TermId id;
  final String displayName;
  final AvgGradeView avgGrade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: CustomCard(
          onTap: () => navigateToTerm(context, id),
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vergangene Halbjahr'),
                    Text(displayName),
                  ],
                ),
              ),
              _TermGrade(grade: avgGrade)
            ],
          ),
        ),
      ),
    );
  }
}

class _TermGrade extends StatelessWidget {
  const _TermGrade({required this.grade});

  final AvgGradeView grade;

  @override
  Widget build(BuildContext context) {
    return Text(
      grade.$1,
      style: TextStyle(
        color: grade.$2.toColor(),
      ),
    );
  }
}

void navigateToTerm(BuildContext context, TermId termId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TermsDetailsPage(
        id: termId,
      ),
    ),
  );
}
