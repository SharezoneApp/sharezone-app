// Copyright (c) 2024 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

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
      body: GradesPageBody(),
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

class GradesPageBody extends StatelessWidget {
  const GradesPageBody({super.key});

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
                duration: const Duration(milliseconds: 350),
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
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: 400,
            child: AnimationLimiter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: AnimationConfiguration.toStaggeredList(
                  delay: const Duration(milliseconds: 750),
                  duration: const Duration(milliseconds: 750),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 20,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    AnimationLimiter(
                      child: Stack(
                        alignment: Alignment.center,
                        children: AnimationConfiguration.toStaggeredList(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 750),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 20,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                radius: 150,
                              ),
                            ),
                            const _EmptyTerm3(),
                            const _EmptyTerm2(),
                            const _EmptyTerm1(),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: CardListTile(
                        leading: const Icon(Icons.add_circle_outline),
                        centerTitle: true,
                        title: const Text("Note eintragen"),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyTerm3 extends StatelessWidget {
  const _EmptyTerm3();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Transform.scale(
        scale: 0.8,
        child: Transform(
          transform: Matrix4.translationValues(0, -110, 0),
          child: const CustomCard(
            child: _TermTile(
              displayName: 'Vergangenes Halbjahr',
              avgGrade: ("3,8", GradePerformance.bad),
              title: '8/2',
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyTerm2 extends StatelessWidget {
  const _EmptyTerm2();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Transform.scale(
        scale: 0.9,
        child: Transform(
          transform: Matrix4.translationValues(0, -55, 0),
          child: const CustomCard(
            child: _TermTile(
              displayName: 'Vergangenes Halbjahr',
              avgGrade: ("2,6", GradePerformance.satisfactory),
              title: '9/1',
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyTerm1 extends StatelessWidget {
  const _EmptyTerm1();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 70),
      child: CustomCard(
        child: _TermTile(
          displayName: 'Aktuelles Halbjahr',
          avgGrade: ("1,3", GradePerformance.good),
          title: '9/2',
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
              mainAxisSize: MainAxisSize.min,
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
