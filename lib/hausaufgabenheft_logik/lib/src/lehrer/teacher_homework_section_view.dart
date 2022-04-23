// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';

import 'teacher_homework_view.dart';
import 'teacher_homework_view_factory.dart';

class TeacherHomeworkSectionView extends Equatable {
  final String title;
  final List<TeacherHomeworkView> homeworks;

  bool get isEmpty => homeworks.isEmpty;
  bool get isNotEmpty => homeworks.isNotEmpty;

  const TeacherHomeworkSectionView(this.title, this.homeworks);

  @override
  List<Object> get props => [title, homeworks];

  factory TeacherHomeworkSectionView.fromModels(
    String title,
    List<TeacherHomeworkReadModel> homeworks,
    TeacherHomeworkViewFactory viewFactory,
  ) {
    return TeacherHomeworkSectionView(title, [
      for (final h in homeworks) viewFactory.createFrom(h),
    ]);
  }

  @override
  String toString() => 'HomeworkSection(title: $title, homeworks: $homeworks)';
}
