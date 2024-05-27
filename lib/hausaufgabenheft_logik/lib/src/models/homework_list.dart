// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:collection';
import 'package:hausaufgabenheft_logik/src/models/homework/homework_completion_status.dart';

import 'homework/homework.dart';
import 'date.dart';
import 'subject.dart';
import '../open_homeworks/sort_and_subcategorization/sort/src/sort.dart';

class HomeworkList extends ListBase<HomeworkReadModel> {
  final List<HomeworkReadModel> _homeworks;

  HomeworkList(List<HomeworkReadModel> homeworks)
      : _homeworks = List.from(homeworks);
  @override
  int get length => _homeworks.length;

  @override
  set length(int newLength) => _homeworks.length = newLength;

  @override
  HomeworkReadModel operator [](int index) => _homeworks[index];

  @override
  void operator []=(int index, value) => _homeworks[index] = value;

  @override // Overwritten for performance reasons as stated in ListBase
  void add(HomeworkReadModel element) => _homeworks.add(element);

  @override // Overwritten for performance reasons as stated in ListBase
  void addAll(Iterable<HomeworkReadModel> iterable) =>
      _homeworks.addAll(iterable);

  @override
  String toString() {
    var s = 'HomeworkList([\n';
    for (final homework in _homeworks) {
      s += '$homework\n';
    }
    s += '])';
    return s;
  }
}

extension SortWith<T> on List<T> {
  void sortWith(Sort<T> sort) {
    sort.sort(this);
  }
}

extension HomeworkListExtension on List<HomeworkReadModel> {
  @deprecated
  HomeworkList get completedHl => HomeworkList(
      where((homework) => homework.status == CompletionStatus.completed)
          .toList());
  List<HomeworkReadModel> get completed =>
      where((homework) => homework.status == CompletionStatus.completed)
          .toList();
  @deprecated
  HomeworkList get openHl => HomeworkList(
      where((homework) => homework.status == CompletionStatus.open).toList());
  List<HomeworkReadModel> get open =>
      where((homework) => homework.status == CompletionStatus.open).toList();

  List<Subject> getDistinctOrderedSubjects() {
    final subjects = <Subject>{};
    for (final homework in this) {
      subjects.add(homework.subject);
    }
    return subjects.toList();
  }

  @deprecated
  HomeworkList getOverdueHl([Date? now]) {
    now = now ?? Date.now();
    return HomeworkList(
        where((homeworks) => homeworks.isOverdueRelativeTo(now!)).toList());
  }

  List<HomeworkReadModel> getOverdue([Date? now]) {
    now = now ?? Date.now();
    return where((homeworks) => homeworks.isOverdueRelativeTo(now!)).toList();
  }
}
