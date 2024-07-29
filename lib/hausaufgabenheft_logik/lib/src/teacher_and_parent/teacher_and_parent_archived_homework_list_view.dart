// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'teacher_and_parent_homework_view.dart';

class TeacherAndParentArchivedHomeworkListView {
  final bool loadedAllArchivedHomeworks;
  final IList<TeacherAndParentHomeworkView> orderedHomeworks;

  TeacherAndParentArchivedHomeworkListView(this.orderedHomeworks,
      {required this.loadedAllArchivedHomeworks});

  int get numberOfHomeworks => orderedHomeworks.length;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TeacherAndParentArchivedHomeworkListView &&
            other.orderedHomeworks == orderedHomeworks &&
            other.loadedAllArchivedHomeworks == loadedAllArchivedHomeworks;
  }

  @override
  int get hashCode =>
      orderedHomeworks.hashCode ^ loadedAllArchivedHomeworks.hashCode;
}
