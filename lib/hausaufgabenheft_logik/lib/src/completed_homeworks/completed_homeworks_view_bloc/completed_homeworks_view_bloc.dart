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
import 'package:hausaufgabenheft_logik/hausaufgabenheft_logik.dart'
    show HomeworkDataSource, LazyLoadingController, LazyLoadingResult;
import 'package:hausaufgabenheft_logik/src/completed_homeworks/views/completed_homework_list_view_factory.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class CompletedHomeworksViewBloc extends Bloc<CompletedHomeworksViewBlocEvent,
    CompletedHomeworksViewBlocState> implements bloc_base.BlocBase {
  final HomeworkDataSource _homeworkRepository;
  LazyLoadingController? _lazyLoadingController;
  final CompletedHomeworkListViewFactory _completedHomeworkListViewFactory;
  final int nrOfInitialCompletedHomeworksToLoad;
  late StreamSubscription _streamSubscription;

  CompletedHomeworksViewBloc(
      this._homeworkRepository, this._completedHomeworkListViewFactory,
      {this.nrOfInitialCompletedHomeworksToLoad = 8})
      : super(Loading()) {
    on<StartTransformingHomeworks>((event, emit) {
      _lazyLoadingController =
          _homeworkRepository.getLazyLoadingCompletedHomeworksController(
              nrOfInitialCompletedHomeworksToLoad);

      _streamSubscription = _lazyLoadingController!.results.listen((state) {
        add(_Transform(state));
      });
    });
    on<AdvanceCompletedHomeworks>((event, emit) {
      _lazyLoadingController!.advanceBy(event.advanceBy);
    });
    on<_Transform>((event, emit) {
      final listView = _completedHomeworkListViewFactory.create(
          event.result.homeworks, !event.result.moreHomeworkAvailable);
      emit(Success(listView));
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
  }
}

class _Transform extends CompletedHomeworksViewBlocEvent {
  final LazyLoadingResult result;

  _Transform(this.result);

  @override
  List<Object> get props => [result];
}
