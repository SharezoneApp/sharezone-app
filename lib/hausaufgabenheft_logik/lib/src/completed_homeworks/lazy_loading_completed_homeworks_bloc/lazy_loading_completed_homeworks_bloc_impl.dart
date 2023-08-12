// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_base/bloc_base.dart';

import '../../data_source/homework_data_source.dart';
import '../../models/homework_list.dart';
import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

abstract class LazyLoadingCompletedHomeworksBloc
    implements
        Stream<LazyLoadingCompletedHomeworksBlocState>,
        Sink<LazyLoadingCompletedHomeworksEvent> {}

class LazyLoadingCompletedHomeworksBlocImpl extends Bloc<
        LazyLoadingCompletedHomeworksEvent,
        LazyLoadingCompletedHomeworksBlocState>
    implements LazyLoadingCompletedHomeworksBloc, BlocBase {
  final HomeworkDataSource _homeworkRepository;
  LazyLoadingController _lazyLoadingController;

  LazyLoadingCompletedHomeworksBlocImpl(this._homeworkRepository);

  @override
  LazyLoadingCompletedHomeworksBlocState get initialState => Loading();

  @override
  Stream<LazyLoadingCompletedHomeworksBlocState> mapEventToState(
      LazyLoadingCompletedHomeworksEvent event) async* {
    if (event is LoadCompletedHomeworks) {
      _lazyLoadingController =
          _homeworkRepository.getLazyLoadingCompletedHomeworksController(
              event.numberOfHomeworksToLoad);
      _lazyLoadingController.results.listen((res) => add(_Yield(Success(
          HomeworkList(res.homeworks),
          loadedAllHomeworks: !res.moreHomeworkAvailable))));
    } else if (event is AdvanceCompletedHomeworks) {
      assert(_lazyLoadingController != null);
      _lazyLoadingController.advanceBy(event.advanceBy);
    } else if (event is _Yield) {
      yield event.payload;
    } else {
      throw UnimplementedError('$event is not implemented');
    }
  }

  @override
  void dispose() {}
}

class _Yield extends LazyLoadingCompletedHomeworksEvent {
  final dynamic payload;
  _Yield(this.payload) : assert(payload != null);

  @override
  List<Object> get props => [payload];

  @override
  String toString() {
    return '_Yield(payload: $payload)';
  }
}
