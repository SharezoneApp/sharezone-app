// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart';
import 'package:meta/meta.dart';
import 'realtime_completed_homework_loader.dart';

class RealtimeUpdatingLazyLoadingController extends LazyLoadingController {
  /// The number of homeworks that will be initially loaded on construction.
  /// If it is 0 then an empty LazyLoading result will be given back without
  /// calling the [FirebaseRealtimeCompletedHomeworkLoader].
  final int initialNumberOfHomeworksToLoad;
  final RealtimeCompletedHomeworkLoader _homeworkLoader;

  final StreamController<LazyLoadingResult> _controller =
      StreamController<LazyLoadingResult>();
  int _numberOfHomeworksToAdvance = 0;

  /// The latest stream of lazy loading results.
  /// It is used so only the latest results from the
  /// [RealtimeUpdatingLazyLoadingController] are considered and that
  /// there are no duplicate homeworks from the results of
  /// [RealtimeUpdatingLazyLoadingController] from before.
  StreamSubscription _currentLazyLoadingStreamSubscription;

  RealtimeUpdatingLazyLoadingController(this._homeworkLoader,
      {@required this.initialNumberOfHomeworksToLoad}) {
    _validateArguments();

    if (initialNumberOfHomeworksToLoad > 0) {
      _numberOfHomeworksToAdvance += initialNumberOfHomeworksToLoad;
      _emitResultsAndCancelLastSubscription(initialNumberOfHomeworksToLoad);
    } else {
      _controller.add(LazyLoadingResult.empty());
    }
  }

  @override
  Stream<LazyLoadingResult> get results => _controller.stream;

  /// Advances the current number of loaded homeworks by [numberOfHomeworks].
  ///
  /// E.g. If this [FirebaseRealtimeCompletedHomeworkLoader] was constructed to load
  /// 3 homeworks initially [advanceBy](3) will result in loading 6 homeworks.
  @override
  Future<void> advanceBy(int numberOfHomeworks) async {
    _numberOfHomeworksToAdvance += numberOfHomeworks;
    _emitResultsAndCancelLastSubscription(_numberOfHomeworksToAdvance);
  }

  void _emitResultsAndCancelLastSubscription(int numberOfHomeworksToLoad) {
    _currentLazyLoadingStreamSubscription?.cancel();
    _currentLazyLoadingStreamSubscription =
        _getLazyLoadingResultStream(numberOfHomeworksToLoad).listen((data) {
      _controller.add(data);
    });
  }

  Stream<LazyLoadingResult> _getLazyLoadingResultStream(
      int nrOfHomeworksToLoad) {
    final homeworksStream =
        _homeworkLoader.loadMostRecentHomeworks(nrOfHomeworksToLoad);

    final results = homeworksStream.map((homeworks) {
      final loadedAll = homeworks.length < nrOfHomeworksToLoad;
      return LazyLoadingResult(homeworks, moreHomeworkAvailable: !loadedAll);
    });

    return results;
  }

  void _validateArguments() {
    ArgumentError.checkNotNull(_homeworkLoader, "_homeworkLoader");
    _validateInitialNumberOfHomeworksToLoad();
  }

  void _validateInitialNumberOfHomeworksToLoad() {
    ArgumentError.checkNotNull(
        initialNumberOfHomeworksToLoad, "initialNumberOfHomeworksToLoad");
    if (initialNumberOfHomeworksToLoad.isNegative) {
      throw ArgumentError.value(initialNumberOfHomeworksToLoad,
          "initialNumberOfHomeworksToLoad", "can't be negative");
    }
  }
}
