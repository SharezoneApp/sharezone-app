// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:clock/clock.dart';
import 'package:hausaufgabenheft_logik/src/shared/sort_and_subcategorizer.dart';
import 'package:hausaufgabenheft_logik/src/shared/setup/config.dart';
import 'package:hausaufgabenheft_logik/src/shared/setup/dependencies.dart';
import 'package:hausaufgabenheft_logik/src/shared/homework_sorting_cache.dart';

import '../../hausaufgabenheft_logik_lehrer.dart';
import '../shared/models/date.dart';

TeacherAndParentHomeworkPageBloc createTeacherAndParentHomeworkPageBloc(
  HausaufgabenheftDependencies dependencies,
  HausaufgabenheftConfig config,
) {
  final getCurrentDateTime =
      dependencies.getCurrentDateTime ?? () => clock.now();
  getCurrentDate() => Date.fromDateTime(getCurrentDateTime());
  final l10n = dependencies.localizations;

  final viewFactory = TeacherAndParentHomeworkViewFactory(
    defaultColorValue: config.defaultCourseColorValue,
    l10n: l10n,
  );
  final sortAndSubcategorizer =
      HomeworkSortAndSubcategorizer<TeacherHomeworkReadModel>(
        getCurrentDate: getCurrentDate,
        l10n: l10n,
      );
  final openHomeworkListViewFactory =
      TeacherAndParentOpenHomeworkListViewFactory(
        sortAndSubcategorizer,
        viewFactory,
      );

  return TeacherAndParentHomeworkPageBloc(
    openHomeworkListViewFactory: openHomeworkListViewFactory,
    viewFactory: viewFactory,
    homeworkApi: dependencies.api.teachersAndParents,
    courseFilterStream: dependencies.courseFilterStream,
    numberOfInitialCompletedHomeworksToLoad:
        config.nrOfInitialCompletedHomeworksToLoad,
    homeworkSortingCache: HomeworkSortingCache(dependencies.keyValueStore),
    getCurrentDateTime: dependencies.getCurrentDateTime ?? () => clock.now(),
  );
}
