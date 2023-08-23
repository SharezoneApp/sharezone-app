// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_base/bloc_base.dart' as bloc_base;
import 'package:hausaufgabenheft_logik/src/completed_homeworks/lazy_loading_completed_homeworks_bloc/lazy_loading_completed_homeworks_bloc.dart'
    as lazy_loading;
import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homework_list_view_factory.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class CompletedHomeworksViewBloc extends Bloc<CompletedHomeworksViewBlocEvent,
    CompletedHomeworksViewBlocState> implements bloc_base.BlocBase {
  final lazy_loading.LazyLoadingCompletedHomeworksBloc
      _lazyLoadingCompletedHomeworksBloc;
  final CompletedHomeworkListViewFactory _completedHomeworkListViewFactory;
  final int nrOfInitialCompletedHomeworksToLoad;
  late StreamSubscription _streamSubscription;
  late Stream<lazy_loading.Success> _lazyLoadingSuccessStates;

  CompletedHomeworksViewBloc(this._lazyLoadingCompletedHomeworksBloc,
      this._completedHomeworkListViewFactory,
      {this.nrOfInitialCompletedHomeworksToLoad = 8})
      : super(Loading()) {
    _lazyLoadingSuccessStates = _lazyLoadingCompletedHomeworksBloc.stream
        .whereType<lazy_loading.Success>();

    on<StartTransformingHomeworks>((event, emit) {
      _lazyLoadingCompletedHomeworksBloc.add(
          lazy_loading.LoadCompletedHomeworks(
              nrOfInitialCompletedHomeworksToLoad));

      _streamSubscription = _lazyLoadingSuccessStates.listen((state) {
        add(_Transform(state));
      });
    });
    on<AdvanceCompletedHomeworks>((event, emit) {
      _lazyLoadingCompletedHomeworksBloc
          .add(lazy_loading.AdvanceCompletedHomeworks(event.advanceBy));
    });
    on<_Transform>((event, emit) {
      final success = event.successState;
      final listView = _completedHomeworkListViewFactory.create(
          success.homeworks, success.loadedAllHomeworks);
      emit(Success(listView));
    });
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
