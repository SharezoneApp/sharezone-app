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

/// The [TeacherOpenHomeworkList] shown in the open tab of the student
/// homework page.
///
/// Instead of [ArchivedHomeworkList] this list is not intended for lazy
/// loading.
class TeacherOpenHomeworkList extends StatelessWidget {
  final TeacherOpenHomeworkListView homeworkListView;
  final Color? overscrollColor;

  const TeacherOpenHomeworkList({
    Key? key,
    required this.homeworkListView,
    required this.overscrollColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_nullOrEmpty(homeworkListView.sections)) return Container();
    return GlowingOverscrollColorChanger(
        color: overscrollColor,
        child: AnimatedStaggeredScrollView(
          children: [
            for (final section in homeworkListView.sections)
              HomeworkListSection(
                title: section.title,
                children: [
                  for (final hw in section.homeworks)
                    TeacherHomeworkTile(
                      homework: hw,
                      key: Key('${hw.id}'),
                    )
                ],
              ),
          ],
        ));
  }

  bool _nullOrEmpty(List<TeacherHomeworkSectionView> homeworkSections) =>
      homeworkSections.isEmpty;
}
