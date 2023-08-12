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
import 'package:hausaufgabenheft_logik/src/completed_homeworks/lazy_loading_completed_homeworks_bloc/lazy_loading_completed_homeworks_bloc_impl.dart'
    as lazy_loading;
import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homework_list_view_factory.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

abstract class CompletedHomeworksViewBloc
    implements
        Stream<CompletedHomeworksViewBlocState>,
        Sink<CompletedHomeworksViewBlocEvent> {}

class CompletedHomeworksViewBlocImpl extends Bloc<
        CompletedHomeworksViewBlocEvent, CompletedHomeworksViewBlocState>
    implements CompletedHomeworksViewBloc, BlocBase {
  final lazy_loading.LazyLoadingCompletedHomeworksBloc
      _lazyLoadingCompletedHomeworksBloc;
  final CompletedHomeworkListViewFactory _completedHomeworkListViewFactory;
  final int nrOfInitialCompletedHomeworksToLoad;
  StreamSubscription _streamSubscription;
  Stream<lazy_loading.Success> _lazyLoadingSuccessStates;

  CompletedHomeworksViewBlocImpl(this._lazyLoadingCompletedHomeworksBloc,
      this._completedHomeworkListViewFactory,
      {this.nrOfInitialCompletedHomeworksToLoad = 8}) {
    _lazyLoadingSuccessStates =
        _lazyLoadingCompletedHomeworksBloc.whereType<lazy_loading.Success>();
  }

  @override
  CompletedHomeworksViewBlocState get initialState => Loading();

  @override
  Stream<CompletedHomeworksViewBlocState> mapEventToState(
      CompletedHomeworksViewBlocEvent event) async* {
    if (event is StartTransformingHomeworks) {
      _lazyLoadingCompletedHomeworksBloc.add(
          lazy_loading.LoadCompletedHomeworks(
              nrOfInitialCompletedHomeworksToLoad));

      _streamSubscription = _lazyLoadingSuccessStates.listen((state) {
        add(_Transform(state));
      });
    } else if (event is AdvanceCompletedHomeworks) {
      _lazyLoadingCompletedHomeworksBloc
          .add(lazy_loading.AdvanceCompletedHomeworks(event.advanceBy));
    } else if (event is _Transform) {
      final success = event.successState;
      final listView = _completedHomeworkListViewFactory.create(
          success.homeworks, success.loadedAllHomeworks);
      yield Success(listView);
    } else {
      throw UnimplementedError('$event is not implemented');
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
  }
}

class _Transform extends CompletedHomeworksViewBlocEvent {
  final lazy_loading.Success successState;

  _Transform(this.successState);

  @override
  List<Object> get props => [successState];
}
