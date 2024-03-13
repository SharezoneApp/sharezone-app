import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/grades/models/term_id.dart';
import 'package:sharezone/grades/pages/grades_page/grades_page_controller.dart';
import 'package:sharezone/grades/pages/grades_view.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  static const tag = "grades-page";

  @override
  Widget build(BuildContext context) {
    return const SharezoneMainScaffold(
      navigationItem: NavigationItem.grades,
      body: _Body(),
      floatingActionButton: _FAB(),
    );
  }
}

class _FAB extends StatelessWidget {
  const _FAB();

  @override
  Widget build(BuildContext context) {
    return ModalFloatingActionButton(
      onPressed: () => snackbarSoon(context: context),
      icon: const Icon(Icons.add),
      tooltip: 'Neue Note',
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GradesPageController>();
    final state = controller.state;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (state) {
        GradesPageLoading() => const _Loading(),
        GradesPageLoaded() => _Loaded(state: state),
        GradesPageError() => _Error(state: state),
      },
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.state});

  final GradesPageLoaded state;

  @override
  Widget build(BuildContext context) {
    if (!state.hasGrades()) {
      return const _Empty();
    }

    final currentTerm = state.currentTerm;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: SafeArea(
        child: MaxWidthConstraintBox(
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 250),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 20,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  if (currentTerm != null)
                    _CurrentTerm(
                      id: currentTerm.id,
                      displayName: currentTerm.displayName,
                      avgGrade: currentTerm.avgGrade,
                      subjects: currentTerm.subjects,
                    ),
                  for (final pastTerm in state.pastTerms)
                    _PastTerm(
                      id: pastTerm.id,
                      displayName: pastTerm.displayName,
                      avgGrade: pastTerm.avgGrade,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: SafeArea(
        child: MaxWidthConstraintBox(
          child: ErrorCard(
            message: Text(state.error),
            onContactSupportPressed: () => Navigator.pushNamed(
              context,
              SupportPage.tag,
            ),
          ),
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomCard(
        onTap: () => _navigateToTerm(context, id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TermTile(
              title: 'Aktuelles Halbjahr',
              displayName: displayName,
              avgGrade: avgGrade,
            ),
            const Divider(height: 0),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'Aktuelle Noten',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            for (final subject in subjects)
              ListTile(
                mouseCursor: SystemMouseCursors.click,
                leading: CircleAvatar(
                  backgroundColor: subject.design.color.withOpacity(0.2),
                  child: Text(
                    subject.abbreviation,
                    style: TextStyle(color: subject.design.color),
                  ),
                ),
                title: Text(subject.displayName),
                trailing: Text(subject.grade,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )),
              )
          ],
        ),
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
  final DisplayName displayName;
  final AvgGradeView avgGrade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: CustomCard(
          onTap: () => _navigateToTerm(context, id),
          child: _TermTile(
            title: 'Vergangenes Halbjahr',
            displayName: displayName,
            avgGrade: avgGrade,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: grade.$2.toColor().withOpacity(0.1),
      ),
      child: Text(
        '⌀ ${grade.$1}',
        style: TextStyle(
          color: grade.$2.toColor(),
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _TermTile extends StatelessWidget {
  const _TermTile({
    required this.displayName,
    required this.avgGrade,
    required this.title,
  });

  final String title;
  final DisplayName displayName;
  final AvgGradeView avgGrade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _TermGrade(grade: avgGrade)
        ],
      ),
    );
  }
}

void _navigateToTerm(BuildContext context, TermId termId) {
  snackbarSoon(context: context);
}
