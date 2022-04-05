// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:meta/meta.dart';
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:collection/collection.dart' show DeepCollectionEquality;

abstract class HomeworkDataSource {
  Stream<List<HomeworkReadModel>> get openHomeworks;
  LazyLoadingController getLazyLoadingCompletedHomeworksController(
      int nrOfInitialHomeworkToLoad);
}

abstract class LazyLoadingController {
  Stream<LazyLoadingResult> get results;
  void advanceBy(int numberOfHomeworks);
}

class LazyLoadingResult {
  final List<HomeworkReadModel> homeworks;
  final bool moreHomeworkAvailable;

  LazyLoadingResult(this.homeworks, {@required this.moreHomeworkAvailable});

  LazyLoadingResult.empty({this.moreHomeworkAvailable = true}) : homeworks = [];

  @override
  String toString() {
    return 'LazyLoadingResult(homeworks: $homeworks, $moreHomeworkAvailable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is LazyLoadingResult &&
            DeepCollectionEquality().equals(other.homeworks, homeworks) &&
            other.moreHomeworkAvailable == moreHomeworkAvailable;
  }

  @override
  int get hashCode => homeworks.hashCode ^ moreHomeworkAvailable.hashCode;
}
