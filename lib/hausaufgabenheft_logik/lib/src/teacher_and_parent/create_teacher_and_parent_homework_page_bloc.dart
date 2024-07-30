// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort_and_subcategorizer.dart';
import 'package:hausaufgabenheft_logik/src/setup/config.dart';
import 'package:hausaufgabenheft_logik/src/setup/dependencies.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';

import '../../hausaufgabenheft_logik_lehrer.dart';
import '../models/date.dart';
import 'completed_homeworks/views/completed_homework_list_view_factory.dart';

TeacherAndParentHomeworkPageBloc createTeacherAndParentHomeworkPageBloc(
    HausaufgabenheftDependencies dependencies, HausaufgabenheftConfig config) {
  final getCurrentDateTime =
      dependencies.getCurrentDateTime ?? () => clock.now();
  getCurrentDate() => Date.fromDateTime(getCurrentDateTime());

  final viewFactory = TeacherAndParentHomeworkViewFactory(
      defaultColorValue: config.defaultCourseColorValue);
  final sortAndSubcategorizer =
      HomeworkSortAndSubcategorizer<TeacherHomeworkReadModel>(
          getCurrentDate: getCurrentDate);
  final openHomeworkListViewFactory =
      TeacherAndParentOpenHomeworkListViewFactory(
          sortAndSubcategorizer, viewFactory);

  final completedHomeworkListViewFactory =
      TeacherAndParentCompletedHomeworkListViewFactory(viewFactory);

  return TeacherAndParentHomeworkPageBloc(
    openHomeworkListViewFactory: openHomeworkListViewFactory,
    completedHomeworkListViewFactory: completedHomeworkListViewFactory,
    homeworkApi: dependencies.api.teachersAndParents,
    numberOfInitialCompletedHomeworksToLoad:
        config.nrOfInitialCompletedHomeworksToLoad,
    homeworkSortingCache: HomeworkSortingCache(dependencies.keyValueStore),
    getCurrentDateTime: dependencies.getCurrentDateTime ?? () => clock.now(),
  );
}
