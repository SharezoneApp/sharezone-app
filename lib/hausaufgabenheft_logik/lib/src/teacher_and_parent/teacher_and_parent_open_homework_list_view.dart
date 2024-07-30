// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik_lehrer.dart';

class TeacherAndParentOpenHomeworkListView {
  final IList<HomeworkSectionView<TeacherAndParentHomeworkView>> sections;
  final HomeworkSort sorting;

  TeacherAndParentOpenHomeworkListView(
    this.sections, {
    required this.sorting,
  }) : super();

  int get numberOfHomeworks {
    final listLengths = sections.map((s) => s.homeworks.length).toList();
    if (listLengths.isEmpty) {
      return 0;
    }
    return listLengths.reduce((i, i2) => i + i2);
  }

  @override
  String toString() =>
      'OpenHomeworkListView(sorting: $sorting, sections: $sections)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final bool Function(Object, Object) listEquals =
        const DeepCollectionEquality().equals;

    return other is TeacherAndParentOpenHomeworkListView &&
        listEquals(other.sections, sections) &&
        other.sorting == sorting;
  }

  @override
  int get hashCode => sections.hashCode ^ sorting.hashCode;
}
