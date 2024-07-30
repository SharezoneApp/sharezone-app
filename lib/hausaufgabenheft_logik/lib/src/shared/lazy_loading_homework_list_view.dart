// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

class LazyLoadingHomeworkListView<T> {
  final bool loadedAllHomeworks;
  final IList<T> orderedHomeworks;

  LazyLoadingHomeworkListView(this.orderedHomeworks,
      {required this.loadedAllHomeworks});

  int get numberOfHomeworks => orderedHomeworks.length;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LazyLoadingHomeworkListView &&
            other.orderedHomeworks == orderedHomeworks &&
            other.loadedAllHomeworks == loadedAllHomeworks;
  }

  @override
  int get hashCode => orderedHomeworks.hashCode ^ loadedAllHomeworks.hashCode;
}
