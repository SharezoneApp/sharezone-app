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

class TeacherAndParentOpenHomeworkList extends StatelessWidget {
  final TeacherAndParentOpenHomeworkListView homeworkListView;
  final Color? overscrollColor;

  const TeacherAndParentOpenHomeworkList({
    super.key,
    required this.homeworkListView,
    required this.overscrollColor,
  });

  @override
  Widget build(BuildContext context) {
    if (homeworkListView.sections.isEmpty) return Container();
    return GlowingOverscrollColorChanger(
        color: overscrollColor,
        child: AnimatedStaggeredScrollView(
          children: [
            for (final section in homeworkListView.sections)
              HomeworkListSection(
                title: section.title,
                children: [
                  for (final hw in section.homeworks)
                    TeacherAndParentHomeworkTile(
                      homework: hw,
                      key: Key('${hw.id}'),
                    )
                ],
              ),
          ],
        ));
  }
}
