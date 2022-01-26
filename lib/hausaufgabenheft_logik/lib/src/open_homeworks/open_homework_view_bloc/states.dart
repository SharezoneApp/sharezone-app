// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:hausaufgabenheft_logik/src/open_homeworks/views/open_homework_list_view.dart';

abstract class OpenHomeworksViewBlocState {}

class Uninitialized extends OpenHomeworksViewBlocState {}

class Success extends OpenHomeworksViewBlocState {
  final OpenHomeworkListView openHomeworkListView;

  Success(this.openHomeworkListView) : assert(openHomeworkListView != null);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is Success && other.openHomeworkListView == openHomeworkListView;
  }

  @override
  int get hashCode => openHomeworkListView.hashCode;

  @override
  String toString() {
    return 'Success(openHomeworkListView: $openHomeworkListView)';
  }
}
