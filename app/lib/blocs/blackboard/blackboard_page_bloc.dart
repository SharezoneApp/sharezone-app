import 'dart:async';

import 'package:bloc_base/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sharezone/models/blackboard_item.dart';
import 'package:sharezone/util/api/blackboard_api.dart';
import 'package:sharezone/util/api/courseGateway.dart';
import 'package:sharezone/widgets/blackboard/blackboard_view.dart';

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
  void dispose() {
    _viewsSubject.close();
  }
}
