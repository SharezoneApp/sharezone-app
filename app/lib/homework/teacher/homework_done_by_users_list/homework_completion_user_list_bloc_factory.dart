// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:firebase_hausaufgabenheft_logik/firebase_hausaufgabenheft_logik.dart';
import 'package:sharezone/homework/analytics/homework_analytics.dart';
import 'package:sharezone/util/api/homework_api.dart';

import 'homework_completion_user_list_bloc.dart';

class HomeworkCompletionUserListBlocFactory extends BlocBase {
  final HomeworkGateway _gateway;
  final CollectionReference _userCollectionReference;
  final HomeworkAnalytics _analyitcs;

  HomeworkCompletionUserListBlocFactory(
    this._gateway,
    this._userCollectionReference,
    this._analyitcs,
  );

  HomeworkCompletionUserListBloc create(HomeworkId id) {
    return HomeworkCompletionUserListBloc(
      id,
      _gateway,
      _userCollectionReference,
      _analyitcs,
      // We pass a Future because the bloc is needed synchronously by the UI.
      // A better fix is proposed in the documentation of the bloc.
      _getCourseId(id),
    );
  }

  Future<CourseId> _getCourseId(HomeworkId id) async {
    final hw = await _getHomework(id);
    return CourseId(hw.courseID);
  }

  // Homework should be in the cache as the only way to get to this screen is
  // via the homework list.
  // Nontheless this method will load the homework from the server in release
  // mode is not in cache for whatever reason.
  Future<HomeworkDto> _getHomework(HomeworkId id) async {
    HomeworkDto hw;
    try {
      hw = await _gateway.singleHomework('$id', source: Source.cache);
    } catch (e) {
      if (_isDebug()) {
        throw StateError(
            'Homework $id is not in Firestore cache. This is unexpected as we assume it is always in the cache. This code needs to be fixed.');
      }
      hw = await _gateway.singleHomework('$id', source: Source.server);
    }
    return hw;
  }

  bool _isDebug() {
    bool isDebug = false;
    // Gets removed if we're not in debug.
    assert(() {
      isDebug = true;
    }());
    return isDebug;
  }

  @override
  void dispose() {}
}
