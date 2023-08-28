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
import 'package:sharezone/sharezone_plus/sharezone_plus_feature_guard.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'homework_completion_user_list_bloc.dart';
import 'homework_completion_user_list_bloc_factory.dart';
import 'user_has_completed_homework_view.dart';

class HomeworkCompletionUserListPage extends StatefulWidget {
  const HomeworkCompletionUserListPage({
    Key key,
    @required this.homeworkId,
  }) : super(key: key);

  final HomeworkId homeworkId;

  static const tag = 'homework-done-by-users-list-page';

  @override
  _HomeworkCompletionUserListPageState createState() =>
      _HomeworkCompletionUserListPageState();
}

class _HomeworkCompletionUserListPageState
    extends State<HomeworkCompletionUserListPage> {
  HomeworkCompletionUserListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<HomeworkCompletionUserListBlocFactory>(context)
        .create(widget.homeworkId);
    bloc.logOpenHomeworkDoneByUsersList();
  }

  @override
  Widget build(BuildContext context) {
    return SharezonePlusFeatureGuard(
      feature: SharezonePlusFeature.homeworkDonyByUsersList,
      child: BlocProvider(
        bloc: bloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Erledigt von"),
            centerTitle: true,
          ),
          body: StreamBuilder<List<UserHasCompletedHomeworkView>>(
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

  List<UserHasCompletedHomeworkView> _getMockViews() {
    return [
      _createMockView(1, 'Ironman'),
      _createMockView(2, 'Captain America'),
      _createMockView(3, 'Thor'),
      _createMockView(4, 'Black Widow'),
    ];
  }

  UserHasCompletedHomeworkView _createMockView(int number, String name) {
    return UserHasCompletedHomeworkView(
      uid: "user$number",
      hasDone: false,
      name: name,
    );
  }
}

class _List extends StatelessWidget {
  const _List(this.views, {Key key}) : super(key: key);

  final List<UserHasCompletedHomeworkView> views;

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
    return const Center(
      child: Text("Es befinden sich keine Teilnehmer in dieser Gruppe 😭"),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile(this.view, {Key key}) : super(key: key);

  final UserHasCompletedHomeworkView view;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListTile(
        key: ValueKey('${view.uid}${view.hasDone}'),
        title: Text(view.name),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(view.abbreviation, style: TextStyle(color: Colors.white)),
        ),
        trailing: _hasDoneIcon(),
      ),
    );
  }

  Widget _hasDoneIcon() {
    if (view.hasDone) return const Icon(Icons.check, color: Colors.green);
    return const Icon(Icons.close, color: Colors.red);
  }
}
