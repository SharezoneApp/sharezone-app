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

import 'teacher_homework_tile.dart';

class TeacherArchivedHomeworkList extends StatelessWidget {
  final TeacherArchivedHomeworkListView view;
  final TeacherHomeworkPageBloc bloc;

  const TeacherArchivedHomeworkList({
    Key key,
    @required this.view,
    @required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LazyLoadingHomeworkList(
      loadedAllHomeworks: view.loadedAllArchivedHomeworks,
      loadMoreHomeworksCallback: () => bloc.add(AdvanceArchivedHomeworks(10)),
      children: [
        for (final hw in view.orderedHomeworks)
          TeacherHomeworkTile(homework: hw)
      ],
    );
  }
}
