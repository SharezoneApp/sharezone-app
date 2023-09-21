// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/calendrical_events/analytics/calendrical_events_page_analytics.dart';
import 'package:sharezone/calendrical_events/bloc/calendrical_events_page_cache.dart';
import 'package:sharezone/util/api/course_gateway.dart';
import 'package:sharezone/util/api/school_class_gateway.dart';
import 'package:sharezone/util/api/timetable_gateway.dart';

import 'calendrical_events_page_bloc.dart';

class CalendricalEventsPageBlocFactory extends BlocBase {
  final TimetableGateway _timetableGateway;
  final CourseGateway _courseGateway;
  final SchoolClassGateway _schoolClassGateway;
  final CalendricalEventsPageCache _cache;
  final CalendricalEventsPageAnalytics _analytics;

  CalendricalEventsPageBlocFactory(
    this._timetableGateway,
    this._courseGateway,
    this._schoolClassGateway,
    this._cache,
    this._analytics,
  );

  CalendricalEventsPageBloc create() {
    return CalendricalEventsPageBloc(
      _timetableGateway,
      _courseGateway,
      _schoolClassGateway,
      _cache,
      _analytics,
    );
  }

  @override
  void dispose() {}
}
