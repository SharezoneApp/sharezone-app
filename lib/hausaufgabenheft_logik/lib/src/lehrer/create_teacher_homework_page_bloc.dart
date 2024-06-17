// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/src/setup/config.dart';
import 'package:hausaufgabenheft_logik/src/setup/dependencies.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';

import '../../hausaufgabenheft_logik_lehrer.dart';
import '../models/date.dart';
import 'completed_homeworks/views/completed_homework_list_view_factory.dart';

TeacherHomeworkPageBloc createTeacherHomeworkPageBloc(
    HausaufgabenheftDependencies dependencies, HausaufgabenheftConfig config) {
  final getCurrentDateTime =
      dependencies.getCurrentDateTime ?? () => clock.now();
  getCurrentDate() => Date.fromDateTime(getCurrentDateTime());

  final viewFactory = TeacherHomeworkViewFactory(
      defaultColorValue: config.defaultCourseColorValue);
  final sortAndSubcategorizer = TeacherHomeworkSortAndSubcategorizer(
    defaultColor: Color(config.defaultCourseColorValue),
    getCurrentDate: getCurrentDate,
  );
  final openHomeworkListViewFactory =
      TeacherOpenHomeworkListViewFactory(sortAndSubcategorizer, getCurrentDate);

  final completedHomeworkListViewFactory =
      TeacherCompletedHomeworkListViewFactory(viewFactory);

  return TeacherHomeworkPageBloc(
    openHomeworkListViewFactory: openHomeworkListViewFactory,
    completedHomeworkListViewFactory: completedHomeworkListViewFactory,
    homeworkDataSource: dependencies.teacherHomeworkDataSource,
    numberOfInitialCompletedHomeworksToLoad:
        config.nrOfInitialCompletedHomeworksToLoad,
    homeworkSortingCache: HomeworkSortingCache(dependencies.keyValueStore),
    getCurrentDateTime: dependencies.getCurrentDateTime ?? () => clock.now(),
  );
}
