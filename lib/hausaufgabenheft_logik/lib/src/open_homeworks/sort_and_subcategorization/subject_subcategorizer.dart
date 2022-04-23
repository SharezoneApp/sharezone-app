// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/homework_section_view.dart';
import 'package:hausaufgabenheft_logik/src/views/student_homework_view_factory.dart';

import 'subcategorizer.dart';

class SubjectSubcategeorizer extends Subcategorizer {
  final StudentHomeworkViewFactory _viewFactory;

  SubjectSubcategeorizer(this._viewFactory);

  @override
  List<HomeworkSectionView> subcategorize(HomeworkList homeworks) {
    final subjects = homeworks.getDistinctOrderedSubjects();
    final homeworkSections = <HomeworkSectionView>[];
    for (final subject in subjects) {
      final homeworksWithSubject =
          homeworks.where((h) => h.subject == subject).toList();

      final homeworkViewsWithSubject =
          homeworksWithSubject.map((h) => _viewFactory.createFrom(h)).toList();

      homeworkSections
          .add(HomeworkSectionView(subject.name, homeworkViewsWithSubject));
    }
    return homeworkSections;
  }
}
