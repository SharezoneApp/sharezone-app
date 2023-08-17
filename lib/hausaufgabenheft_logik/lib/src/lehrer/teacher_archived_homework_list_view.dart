// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2


import 'teacher_homework_view.dart';

class TeacherArchivedHomeworkListView {
  final bool loadedAllArchivedHomeworks;
  final List<TeacherHomeworkView> orderedHomeworks;

  TeacherArchivedHomeworkListView(this.orderedHomeworks,
      {required this.loadedAllArchivedHomeworks});

  int get numberOfHomeworks => orderedHomeworks.length;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is TeacherArchivedHomeworkListView &&
            other.orderedHomeworks == orderedHomeworks &&
            other.loadedAllArchivedHomeworks == loadedAllArchivedHomeworks;
  }

  @override
  int get hashCode =>
      orderedHomeworks.hashCode ^ loadedAllArchivedHomeworks.hashCode;
}
