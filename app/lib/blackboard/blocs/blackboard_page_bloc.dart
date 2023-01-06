// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/blackboard/blackboard_item.dart';
import 'package:sharezone/blackboard/blackboard_view.dart';
import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone/util/api/courseGateway.dart';

class BlackboardPageBloc extends BlocBase {
  final _viewsSubject = BehaviorSubject<List<BlackboardView>>();

  BlackboardPageBloc(
      {BlackboardGateway gateway, CourseGateway courseGateway, String uid}) {
    final views = gateway.blackboardItemStream.map((items) =>
        _mapBlackboardItemsIntoBlackboardView(items, courseGateway, uid)
            .toList());
    _viewsSubject.sink.addStream(views);
  }

  Stream<List<BlackboardView>> get views => _viewsSubject;

  List<BlackboardView> _mapBlackboardItemsIntoBlackboardView(
      List<BlackboardItem> items, CourseGateway courseGateway, String uid) {
    _sortItemsByDate(items);
    return items
        .map((item) =>
            BlackboardView.fromBlackboardItem(item, uid, courseGateway))
        .toList();
  }

  void _sortItemsByDate(List<BlackboardItem> items) {
    items.sort((a, b) => b.createdOn.compareTo(a.createdOn));
  }

  @override
  Future<void> dispose() async {
    await _viewsSubject.drain();
    _viewsSubject.close();
  }
}
