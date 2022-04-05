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
import 'package:hausaufgabenheft_logik/src/models/homework/homework.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/sort_and_subcategorization/sort/src/sort.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_list_bloc/open_homework_list_bloc.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/views/open_homework_list_view_factory.dart';
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_list_bloc/events.dart'
    as hws_bloc;
import 'package:hausaufgabenheft_logik/src/open_homeworks/open_homework_list_bloc/states.dart'
    as hws_bloc;

import 'events.dart';
import 'states.dart';

class OpenHomeworksViewBloc
    extends Bloc<OpenHomeworkViewEvent, OpenHomeworksViewBlocState>
    implements BlocBase {
  final OpenHomeworkListViewFactory _listViewFactory;
  final OpenHomeworkListBloc _openHomeworksBloc;

  Stream<HomeworkList> _openHomeworks;
  StreamSubscription _streamSubscription;
  HomeworkList _latestHomeworks;
  Sort<HomeworkReadModel> _currentSort;

  OpenHomeworksViewBloc(this._openHomeworksBloc, this._listViewFactory) {
    _latestHomeworks = HomeworkList([]);
    _openHomeworks = _openHomeworksBloc.transform(_toHomeworkList);
  }

  @override
  OpenHomeworksViewBlocState get initialState => Uninitialized();

  @override
  void dispose() {
    _streamSubscription.cancel();
  }

  @override
  Stream<OpenHomeworksViewBlocState> mapEventToState(
      OpenHomeworkViewEvent event) async* {
    if (event is LoadHomeworks) {
      _currentSort = event.sort;
      _openHomeworksBloc.add(hws_bloc.LoadHomeworks());
      _streamSubscription = _openHomeworks.listen((hws) {
        assert(hws != null);
        _latestHomeworks = hws;
        add(_CreateListView(hws, _currentSort));
      });
    } else if (event is SortingChanged) {
      _currentSort = event.sort;
      add(_CreateListView(_latestHomeworks, _currentSort));
    } else if (event is _CreateListView) {
      final view = _listViewFactory.create(event.homeworks, event.sort);
      var success = Success(view);
      yield success;
    } else {
      throw UnimplementedError('$event is not implemented');
    }
  }
}

class _CreateListView extends OpenHomeworkViewEvent {
  final HomeworkList homeworks;
  final Sort<HomeworkReadModel> sort;

  _CreateListView(this.homeworks, this.sort);

  @override
  List<Object> get props => [homeworks, sort];
}

final _toHomeworkList = StreamTransformer<hws_bloc.OpenHomeworkListBlocState,
    HomeworkList>.fromHandlers(handleData: (state, sink) {
  if (state is hws_bloc.Success) {
    sink.add(state.homeworks);
  }
});
