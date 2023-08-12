// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc/bloc.dart';
import 'package:hausaufgabenheft_logik/src/data_source/homework_data_source.dart';
import 'package:hausaufgabenheft_logik/src/models/homework_list.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class OpenHomeworkListBloc
    extends Bloc<OpenHomeworkListBlocEvent, OpenHomeworkListBlocState> {
  final HomeworkDataSource _repository;

  OpenHomeworkListBloc(this._repository) : super(Uninitialized());

  @override
  Stream<OpenHomeworkListBlocState> mapEventToState(
      OpenHomeworkListBlocEvent event) async* {
    if (event is LoadHomeworks) {
      _repository.openHomeworks
          .listen((hws) => add(_Yield(Success(HomeworkList(hws)))));
    } else if (event is _Yield) {
      yield event.payload;
    } else {
      throw UnimplementedError('$event is not implemented');
    }
  }
}

class _Yield extends OpenHomeworkListBlocEvent {
  final dynamic payload;
  _Yield(this.payload) : assert(payload != null);

  @override
  List<Object> get props => [payload];
}
