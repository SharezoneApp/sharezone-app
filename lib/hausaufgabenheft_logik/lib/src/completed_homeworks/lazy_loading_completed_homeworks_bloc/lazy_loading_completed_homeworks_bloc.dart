// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc/bloc.dart';
import 'package:bloc_base/bloc_base.dart' as bloc_base;

import '../../data_source/homework_data_source.dart';
import '../../models/homework_list.dart';
import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class LazyLoadingCompletedHomeworksBloc extends Bloc<
    LazyLoadingCompletedHomeworksEvent,
    LazyLoadingCompletedHomeworksBlocState> implements bloc_base.BlocBase {
  final HomeworkDataSource _homeworkRepository;
  LazyLoadingController? _lazyLoadingController;

  LazyLoadingCompletedHomeworksBloc(this._homeworkRepository)
      : super(Loading()) {
    on<LoadCompletedHomeworks>(
      (event, emit) {
        _lazyLoadingController =
            _homeworkRepository.getLazyLoadingCompletedHomeworksController(
                event.numberOfHomeworksToLoad);
        _lazyLoadingController!.results.listen((res) => add(
              _Yield(Success(
                HomeworkList(res.homeworks),
                loadedAllHomeworks: !res.moreHomeworkAvailable,
              )),
            ));
      },
    );
    on<AdvanceCompletedHomeworks>(
      (event, emit) {
        assert(_lazyLoadingController != null);
        _lazyLoadingController!.advanceBy(event.advanceBy);
      },
    );
    on<_Yield>(
      (event, emit) => emit(event.payload),
    );
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
