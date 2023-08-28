// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/timetable/timetable_add_event/bloc/timetable_add_event_bloc.dart';
import 'package:sharezone/timetable/timetable_add_event/bloc/timetable_add_event_bloc_dependencies.dart';

class TimetableAddEventBlocFactory implements BlocBase {
  final TimetableAddEventBlocDependencies timetableAddBlocDependencies;

  TimetableAddEventBlocFactory(this.timetableAddBlocDependencies);

  TimetableAddEventBloc create() {
    return TimetableAddEventBloc.fromDependencies(timetableAddBlocDependencies);
  }

  @override
  void dispose() {} // Required by BlocProvider
}
