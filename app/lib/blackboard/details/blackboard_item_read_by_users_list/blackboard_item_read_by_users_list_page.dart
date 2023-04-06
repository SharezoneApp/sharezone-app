// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blackboard/analytics/blackboard_analytics.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/sharezone_plus/sharezone_plus_feature_guard.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'blackboard_item_read_by_users_list_bloc.dart';
import 'user_view.dart';

class BlackboardItemReadByUsersListPage extends StatefulWidget {
  const BlackboardItemReadByUsersListPage({
    Key key,
    @required this.itemId,
    @required this.courseId,
  }) : super(key: key);

  final String itemId;
  final CourseId courseId;

  static const tag = 'blackboard-item-read-by-users-list-page';

  @override
  _BlackboardItemReadByUsersListPageState createState() =>
      _BlackboardItemReadByUsersListPageState();
}

class _BlackboardItemReadByUsersListPageState
    extends State<BlackboardItemReadByUsersListPage> {
  BlackboardItemReadByUsersListBloc bloc;

  @override
  void initState() {
    super.initState();
    final api = BlocProvider.of<SharezoneContext>(context).api;
    bloc = BlackboardItemReadByUsersListBloc(
      widget.itemId,
      api.blackboard,
      api.references.courses,
      widget.courseId,
    );
    logOpenUserReadPage();
  }

  @override
  Widget build(BuildContext context) {
    return SharezonePlusFeatureGuard(
      feature: SharezonePlusFeature.infoSheetReadByUsersList,
      child: BlocProvider(
        bloc: bloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Gelesen von"),
            centerTitle: true,
          ),
          body: StreamBuilder<List<UserView>>(
            stream: bloc.userViews,
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: snapshot.hasData ? _List(snapshot.data) : _Loading(),
              );
            },
          ),
        ),
      ),
    );
  }

  void logOpenUserReadPage() {
    final analytics = BlocProvider.of<BlackboardAnalytics>(context);
    analytics.logOpenUserReadPage();
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GrayShimmer(child: _List(_getMockViews()));
  }

  List<UserView> _getMockViews() {
    return [
      _createMockView(1, 'Ironman'),
      _createMockView(2, 'Captain America'),
      _createMockView(3, 'Thor'),
      _createMockView(4, 'Black Widow'),
    ];
  }

  UserView _createMockView(int number, String name) {
    return UserView(
      uid: "user$number",
      hasRead: false,
      typeOfUser: TypeOfUser.student.toReadableString(),
      name: name,
    );
  }
}

class _List extends StatelessWidget {
  const _List(this.views, {Key key}) : super(key: key);

  final List<UserView> views;

  @override
  Widget build(BuildContext context) {
    if (views.isEmpty) return _EmptyList();
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: MaxWidthConstraintBox(
          child: SafeArea(
            child: Column(
              children: [for (final view in views) _UserTile(view)],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Es befinden sich keine Teilnehmer in dieser Gruppe 😭"),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile(this.view, {Key key}) : super(key: key);

  final UserView view;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListTile(
        key: ValueKey('${view.uid}${view.hasRead}'),
        title: Text(view.name),
        subtitle: Text(view.typeOfUser),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(view.abbrevation, style: TextStyle(color: Colors.white)),
        ),
        trailing: hasReadIcon(),
      ),
    );
  }

  Widget hasReadIcon() {
    if (view.hasRead) return Icon(Icons.check, color: Colors.green);
    return Icon(Icons.close, color: Colors.red);
  }
}
