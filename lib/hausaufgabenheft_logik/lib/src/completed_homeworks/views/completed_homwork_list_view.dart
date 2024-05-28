// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../views/homework_view.dart';

class CompletedHomeworkListView {
  final bool loadedAllCompletedHomeworks;
  final IList<StudentHomeworkView> orderedHomeworks;

  CompletedHomeworkListView(this.orderedHomeworks,
      {required this.loadedAllCompletedHomeworks});

  int get numberOfHomeworks => orderedHomeworks.length;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CompletedHomeworkListView &&
            other.orderedHomeworks == orderedHomeworks &&
            other.loadedAllCompletedHomeworks == loadedAllCompletedHomeworks;
  }

  @override
  int get hashCode =>
      orderedHomeworks.hashCode ^ loadedAllCompletedHomeworks.hashCode;
}
