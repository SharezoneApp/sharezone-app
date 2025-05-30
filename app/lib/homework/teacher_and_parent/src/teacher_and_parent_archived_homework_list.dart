// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:flutter/material.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';
import 'package:sharezone/homework/shared/shared.dart';

import 'teacher_and_parent_homework_tile.dart';

class TeacherAndParentArchivedHomeworkList extends StatelessWidget {
  final LazyLoadingHomeworkListView<TeacherAndParentHomeworkView> view;
  final TeacherAndParentHomeworkPageBloc bloc;

  const TeacherAndParentArchivedHomeworkList({
    super.key,
    required this.view,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return LazyLoadingHomeworkList(
      loadedAllHomeworks: view.loadedAllHomeworks,
      loadMoreHomeworksCallback: () => bloc.add(AdvanceArchivedHomeworks(10)),
      children: [
        for (final hw in view.orderedHomeworks)
          TeacherAndParentHomeworkTile(homework: hw),
      ],
    );
  }
}
