// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/src/shared/models/homework.dart';

import 'student_homework_view.dart';
import 'student_homework_view_factory.dart';

class StudentHomeworkSectionView extends Equatable {
  final String title;
  final IList<StudentHomeworkView> homeworks;

  bool get isEmpty => homeworks.isEmpty;
  bool get isNotEmpty => homeworks.isNotEmpty;

  const StudentHomeworkSectionView(this.title, this.homeworks);

  @override
  List<Object> get props => [title, homeworks];

  factory StudentHomeworkSectionView.fromModels(
    String title,
    IList<StudentHomeworkReadModel> homeworks,
    StudentHomeworkViewFactory viewFactory,
  ) {
    return StudentHomeworkSectionView(
      title,
      IList([for (final h in homeworks) viewFactory.createFrom(h)]),
    );
  }

  @override
  String toString() => 'HomeworkSection(title: $title, homeworks: $homeworks)';
}
