// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:collection/collection.dart' show DeepCollectionEquality;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

abstract class HomeworkDataSource<T> {
  Stream<IList<T>> get openHomeworks;
  LazyLoadingController<T> getLazyLoadingCompletedHomeworksController(
      int nrOfInitialHomeworkToLoad);
}

abstract class LazyLoadingController<T> {
  Stream<LazyLoadingResult<T>> get results;
  void advanceBy(int numberOfHomeworks);
}

class LazyLoadingResult<T> {
  final IList<T> homeworks;
  final bool moreHomeworkAvailable;

  LazyLoadingResult(this.homeworks, {required this.moreHomeworkAvailable});

  LazyLoadingResult.empty({this.moreHomeworkAvailable = true})
      : homeworks = const IListConst([]);

  @override
  String toString() {
    return 'LazyLoadingResult(homeworks: $homeworks, $moreHomeworkAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LazyLoadingResult &&
            const DeepCollectionEquality().equals(other.homeworks, homeworks) &&
            other.moreHomeworkAvailable == moreHomeworkAvailable;
  }

  @override
  int get hashCode => homeworks.hashCode ^ moreHomeworkAvailable.hashCode;
}
