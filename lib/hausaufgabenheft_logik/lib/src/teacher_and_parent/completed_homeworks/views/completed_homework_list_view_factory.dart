// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';

class TeacherAndParentCompletedHomeworkListViewFactory {
  final TeacherAndParentHomeworkViewFactory _teacherHomeworkViewFactory;

  TeacherAndParentCompletedHomeworkListViewFactory(
      this._teacherHomeworkViewFactory);

  LazyLoadingHomeworkListView<TeacherAndParentHomeworkView> create(
      IList<TeacherHomeworkReadModel> completedHomeworks,
      bool loadedAllCompletedHomeworks) {
    final orderedHomeworks = IList([
      for (final completedHomework in completedHomeworks)
        _teacherHomeworkViewFactory.createFrom(completedHomework)
    ]);
    return LazyLoadingHomeworkListView(orderedHomeworks,
        loadedAllHomeworks: loadedAllCompletedHomeworks);
  }
}
