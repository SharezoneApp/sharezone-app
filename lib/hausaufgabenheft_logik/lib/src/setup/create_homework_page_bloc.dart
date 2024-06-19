// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:hausaufgabenheft_logik/color.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';

import '../completed_homeworks/views/completed_homework_list_view_factory.dart';
import '../models/models.dart';
import '../open_homeworks/sort_and_subcategorization/sort_and_subcategorizer.dart';
import '../open_homeworks/views/open_homework_list_view_factory.dart';
import '../student_homework_page_bloc/student_homework_page_bloc.dart';
import '../views/student_homework_view_factory.dart';
import 'config.dart';
import 'dependencies.dart';

HomeworkPageBloc createHomeworkPageBloc(
    HausaufgabenheftDependencies dependencies, HausaufgabenheftConfig config) {
  final getCurrentDateTime =
      dependencies.getCurrentDateTime ?? () => clock.now();
  getCurrentDate() => Date.fromDateTime(getCurrentDateTime());

  final viewFactory = StudentHomeworkViewFactory(
      defaultColorValue: config.defaultCourseColorValue);
  final sortAndSubcategorizer = HomeworkSortAndSubcategorizer(
    viewFactory: viewFactory,
    getCurrentDate: getCurrentDate,
  );
  final openHomeworkListViewFactory =
      OpenHomeworkListViewFactory(sortAndSubcategorizer, getCurrentDate);

  final completedHomeworkListViewFactory =
      CompletedHomeworkListViewFactory(viewFactory);

  return HomeworkPageBloc(
    openHomeworkListViewFactory: openHomeworkListViewFactory,
    completedHomeworkListViewFactory: completedHomeworkListViewFactory,
    homeworkApi: dependencies.api.students,
    numberOfInitialCompletedHomeworksToLoad:
        config.nrOfInitialCompletedHomeworksToLoad,
    homeworkSortingCache: HomeworkSortingCache(dependencies.keyValueStore),
    getCurrentDateTime: dependencies.getCurrentDateTime ?? () => clock.now(),
  );
}
