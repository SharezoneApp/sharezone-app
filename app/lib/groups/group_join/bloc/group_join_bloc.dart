// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_base/bloc_base.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/services.dart';
import 'package:group_domain_models/group_domain_models.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_function.dart';
import 'package:sharezone/groups/group_join/models/group_join_result.dart';
import 'package:sharezone/util/api/connections_gateway.dart';

class GroupJoinBloc extends BlocBase {
  final ConnectionsGateway _connectionsGateway;
  final CrashAnalytics _crashAnalytics;

  final _joinResultSubject = BehaviorSubject<GroupJoinResult>();
  String _lastEnteredValue;

  GroupJoinFunction get groupJoinFunction =>
      GroupJoinFunction(_connectionsGateway, _crashAnalytics);

  GroupJoinBloc(this._connectionsGateway, this._crashAnalytics) {
    _changeJoinResult(NoDataResult());
  }

  Stream<GroupJoinResult> get joinResult => _joinResultSubject;

  Function(GroupJoinResult) get _changeJoinResult =>
      _joinResultSubject.sink.add;

  /// Hier wird ein Join Versuch ohne zusätzliche Angaben gemacht.
  /// Dies erfolgt von der GroupJoinPage
  Future<void> enterValue(String enteredValue) async {
    if (enteredValue == null) return;
    if (enteredValue == "") return;
    _lastEnteredValue = enteredValue;
    _changeJoinResult(LoadingJoinResult());

    final groupJoinResult = await _join(
      joinValue: enteredValue,
      courseList: null,
    );
    _changeJoinResult(groupJoinResult);
  }

  /// Hier wird ein Join Versuch mit einer KursListe als zusätzlicher Parameter
  /// erldigt. Dies ist erforderlich beim Beitritt einer Schulklasse. Diese Funktion
  /// wird vom GroupJoinSelectCoursesBloc aufgerufen.
  Future<void> enterValueWithCourseList(List<GroupKey> courseList) async {
    _changeJoinResult(LoadingJoinResult());
    final groupJoinResult = await _join(
      joinValue: _lastEnteredValue,
      courseList: courseList,
    );
    _changeJoinResult(groupJoinResult);
  }

  /// Checks if the user has a sharecode in the clipboard and returns
  /// the sharecode.
  Future<Sharecode> getSharecodeFromClipboard() async {
    final clipboardData = await Clipboard.getData("text/plain");
    if (Sharecode.isValid(clipboardData?.text))
      return Sharecode(clipboardData.text);
    return null;
  }

  Future<void> retry() async {
    if (_lastEnteredValue != null) {
      return enterValue(_lastEnteredValue);
    } else {}
  }

  Future<void> clear() async {
    _lastEnteredValue = null;
    _changeJoinResult(NoDataResult());
  }

  Future<GroupJoinResult> _join({
    @required String joinValue,
    List<GroupKey> courseList,
  }) {
    return groupJoinFunction.runGroupJoinFunction(
      enteredValue: joinValue,
      coursesForSchoolClass:
          courseList?.map((groupKey) => groupKey.id)?.toList(),
    );
  }

  @override
  Future<void> dispose() async {
    await _joinResultSubject.drain();
    _joinResultSubject.close();
  }
}
