// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

enum HomeworkSectionType { date, weekday, subject, custom }

enum HomeworkDateSection { overdue, today, tomorrow, dayAfterTomorrow, later }

class HomeworkSectionView<T> extends Equatable {
  final HomeworkSectionType type;
  final HomeworkDateSection? dateSection;
  final int? weekday;
  final String? title;
  final IList<T> homeworks;

  bool get isEmpty => homeworks.isEmpty;
  bool get isNotEmpty => homeworks.isNotEmpty;

  const HomeworkSectionView._({
    required this.type,
    required this.homeworks,
    this.title,
    this.dateSection,
    this.weekday,
  });

  factory HomeworkSectionView.date(
    HomeworkDateSection section,
    IList<T> homeworks,
  ) {
    return HomeworkSectionView._(
      type: HomeworkSectionType.date,
      dateSection: section,
      homeworks: homeworks,
    );
  }

  factory HomeworkSectionView.weekday(int weekday, IList<T> homeworks) {
    return HomeworkSectionView._(
      type: HomeworkSectionType.weekday,
      weekday: weekday,
      homeworks: homeworks,
    );
  }

  factory HomeworkSectionView.subject(String subject, IList<T> homeworks) {
    return HomeworkSectionView._(
      type: HomeworkSectionType.subject,
      title: subject,
      homeworks: homeworks,
    );
  }

  factory HomeworkSectionView.custom(String title, IList<T> homeworks) {
    return HomeworkSectionView._(
      type: HomeworkSectionType.custom,
      title: title,
      homeworks: homeworks,
    );
  }

  HomeworkSectionView<R> mapHomeworks<R>(IList<R> mappedHomeworks) {
    return HomeworkSectionView._(
      type: type,
      dateSection: dateSection,
      weekday: weekday,
      title: title,
      homeworks: mappedHomeworks,
    );
  }

  @override
  List<Object?> get props => [type, dateSection, weekday, title, homeworks];

  @override
  String toString() {
    return 'HomeworkSection(type: $type, dateSection: $dateSection, weekday: $weekday, title: $title, homeworks: $homeworks)';
  }
}
