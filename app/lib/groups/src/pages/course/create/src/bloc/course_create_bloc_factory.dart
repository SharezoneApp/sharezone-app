// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

//@dart=2.12

import 'package:bloc_base/bloc_base.dart';
import 'package:sharezone/groups/src/pages/course/create/src/analytics/course_create_analytics.dart';

import '../gateway/course_create_gateway.dart';
import 'course_create_bloc.dart';

class CourseCreateBlocFactory implements BlocBase {
  final CourseCreateGateway _api;
  final CourseCreateAnalytics _analytics;

  CourseCreateBlocFactory(this._api, this._analytics);

  CourseCreateBloc create({String? schoolClassId}) {
    return CourseCreateBloc(_api, _analytics, schoolClassId: schoolClassId);
  }

  @override
  void dispose() {}
}
