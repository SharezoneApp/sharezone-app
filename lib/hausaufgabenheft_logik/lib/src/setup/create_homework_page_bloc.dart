// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/homework_completion/homework_page_completion_dispatcher.dart';
import 'package:hausaufgabenheft_logik/src/student_homework_page_bloc/homework_sorting_cache.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_list_bloc/open_homework_list_bloc.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_view_bloc/open_homework_view_bloc.dart';

import '../completed_homeworks/completed_homeworks_view_bloc/completed_homeworks_view_bloc_impl.dart';
import '../completed_homeworks/lazy_loading_completed_homeworks_bloc/lazy_loading_completed_homeworks_bloc_impl.dart';
import '../completed_homeworks/views/completed_homework_list_view_factory.dart';
import '../student_homework_page_bloc/student_homework_page_bloc.dart';
import '../models/homework/models_used_by_homework.dart';
import '../open_homeworks/sort_and_subcategorization/sort_and_subcategorizer.dart';
import '../open_homeworks/sort_and_subcategorization/subcategorizer_factory.dart';
import '../open_homeworks/views/open_homework_list_view_factory.dart';
import '../views/student_homework_view_factory.dart';
import 'config.dart';
import 'dependencies.dart';

HomeworkPageBloc createHomeworkPageBloc(
    HausaufgabenheftDependencies dependencies, HausaufgabenheftConfig config) {
  final viewFactory = StudentHomeworkViewFactory(
      defaultColorValue: config.defaultCourseColorValue);
  final subcategorizerFactory = SubcategorizerFactory(viewFactory);
  final sortAndSubcategorizer = HomeworkSortAndSubcategorizer(
      subcategorizerFactory.getMatchingSubcategorizer);
  final openHomeworkListViewFactory =
      OpenHomeworkListViewFactory(sortAndSubcategorizer, () => Date.now());
  final openHomeworkListBloc = OpenHomeworkListBloc(dependencies.dataSource);
  final openHomeworksViewBloc = OpenHomeworksViewBloc(
      openHomeworkListBloc, openHomeworkListViewFactory);

  final completedHomeworkListViewFactory =
      CompletedHomeworkListViewFactory(viewFactory);
  final lazyLoadingCompletedHomeworksBloc =
      LazyLoadingCompletedHomeworksBlocImpl(dependencies.dataSource);
  final completedHomeworksViewBloc = CompletedHomeworksViewBlocImpl(
      lazyLoadingCompletedHomeworksBloc, completedHomeworkListViewFactory,
      nrOfInitialCompletedHomeworksToLoad:
          config.nrOfInitialCompletedHomeworksToLoad);

  final homeworkPageCompletionReceiver = HomeworkPageCompletionDispatcher(
      dependencies.completionDispatcher,
      getCurrentOverdueHomeworkIds: dependencies.getOpenOverdueHomeworkIds);

  return HomeworkPageBloc(
    openHomeworksViewBloc: openHomeworksViewBloc,
    completedHomeworksViewBloc: completedHomeworksViewBloc,
    homeworkCompletionReceiver: homeworkPageCompletionReceiver,
    homeworkSortingCache: HomeworkSortingCache(dependencies.keyValueStore),
    getCurrentDateTime: dependencies.getCurrentDateTime ?? () => DateTime.now(),
  );
}
