// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/src/shared/homework_sorting_cache.dart';

import '../shared/sort_and_subcategorizer.dart';
import 'views/student_open_homework_list_view_factory.dart';
import 'views/student_homework_view_factory.dart';
import '../shared/setup/config.dart';
import '../shared/setup/dependencies.dart';

StudentHomeworkPageBloc createStudentHomeworkPageBloc(
    HausaufgabenheftDependencies dependencies, HausaufgabenheftConfig config) {
  final getCurrentDateTime =
      dependencies.getCurrentDateTime ?? () => clock.now();
  getCurrentDate() => Date.fromDateTime(getCurrentDateTime());

  final viewFactory = StudentHomeworkViewFactory(
      defaultColorValue: config.defaultCourseColorValue);
  final sortAndSubcategorizer =
      HomeworkSortAndSubcategorizer<StudentHomeworkReadModel>(
    getCurrentDate: getCurrentDate,
  );
  final openHomeworkListViewFactory = StudentOpenHomeworkListViewFactory(
      sortAndSubcategorizer, viewFactory, getCurrentDate);

  return StudentHomeworkPageBloc(
    openHomeworkListViewFactory: openHomeworkListViewFactory,
    viewFactory: viewFactory,
    homeworkApi: dependencies.api.students,
    numberOfInitialCompletedHomeworksToLoad:
        config.nrOfInitialCompletedHomeworksToLoad,
    homeworkSortingCache: HomeworkSortingCache(dependencies.keyValueStore),
    getCurrentDateTime: dependencies.getCurrentDateTime ?? () => clock.now(),
  );
}
