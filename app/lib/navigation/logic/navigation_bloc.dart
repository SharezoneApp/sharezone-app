import 'package:bloc_base/bloc_base.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';

class NavigationBloc extends BlocBase {
  final scaffoldKey = GlobalKey();
  final drawerKey = GlobalKey();
  final controllerKey = GlobalKey();

  final _navigationItemsSubject =
      BehaviorSubject<NavigationItem>.seeded(NavigationItem.overview);
  Stream<NavigationItem> get navigationItems => _navigationItemsSubject;

  NavigationItem get currentItem => _navigationItemsSubject.value;

  Function(NavigationItem) get navigateTo => _navigationItemsSubject.sink.add;

  @override
  void dispose() {
    _navigationItemsSubject.close();
  }
}

Future<bool> popToOverview(BuildContext context) async {
  final navigationBloc = BlocProvider.of<NavigationBloc>(context);
  navigationBloc.navigateTo(NavigationItem.overview);
  return false;
}

Future<bool> popUntilOverview(BuildContext context) {
  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
  return null;
}
