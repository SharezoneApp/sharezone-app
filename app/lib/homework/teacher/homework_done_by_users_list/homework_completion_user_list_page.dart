// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:ui';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:common_domain_models/common_domain_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/blackboard/analytics/blackboard_analytics.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'homework_completion_user_list_bloc.dart';
import 'homework_completion_user_list_bloc_factory.dart';
import 'user_has_completed_homework_view.dart';

class HomeworkCompletionUserListPage extends StatefulWidget {
  const HomeworkCompletionUserListPage({
    Key? key,
    required this.homeworkId,
  }) : super(key: key);

  final HomeworkId homeworkId;

  static const tag = 'homework-done-by-users-list-page';

  @override
  State createState() => _HomeworkCompletionUserListPageState();
}

class _HomeworkCompletionUserListPageState
    extends State<HomeworkCompletionUserListPage> {
  late HomeworkCompletionUserListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<HomeworkCompletionUserListBlocFactory>(context)
        .create(widget.homeworkId);
    bloc.logOpenHomeworkDoneByUsersList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Erledigt von"),
          centerTitle: true,
        ),
        body: const HomeworkCompletionUserListPageBody(),
      ),
    );
  }

  void logOpenUserReadPage() {
    final analytics = BlocProvider.of<BlackboardAnalytics>(context);
    analytics.logOpenUserReadPage();
  }
}

@visibleForTesting
class HomeworkCompletionUserListPageBody extends StatelessWidget {
  const HomeworkCompletionUserListPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = context
        .read<SubscriptionService>()
        .hasFeatureUnlocked(SharezonePlusFeature.homeworkDoneByUsersList);
    if (!isUnlocked) {
      return const _FreeUsersLockScreen();
    }

    final bloc = BlocProvider.of<HomeworkCompletionUserListBloc>(context);
    return StreamBuilder<List<UserHasCompletedHomeworkView>>(
      stream: bloc.userViews,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: snapshot.hasData ? _List(snapshot.data) : _Loading(),
        );
      },
    );
  }
}

UserHasCompletedHomeworkView _createMockView(
  int number,
  String name, {
  bool hasDone = false,
}) {
  return UserHasCompletedHomeworkView(
    uid: "user$number",
    hasDone: hasDone,
    name: name,
  );
}

class _FreeUsersLockScreen extends StatelessWidget {
  const _FreeUsersLockScreen();

  @override
  Widget build(BuildContext context) {
    final dummyUsers = [
      _createMockView(1, 'Zottel Zappelfritz'),
      _createMockView(2, 'Quassel Trudel'),
      _createMockView(3, 'Pünktchen Schmunzler', hasDone: true),
      _createMockView(4, 'Kicher Karla'),
      _createMockView(5, 'Hoppla Heidi'),
      _createMockView(6, 'Fussel Frieda', hasDone: true),
      _createMockView(7, 'Wuschel Waltraud'),
      _createMockView(8, 'Pumpernickel Peter'),
      _createMockView(9, 'Tapsi Töne'),
      _createMockView(10, 'Knuddel Kuno', hasDone: true),
      _createMockView(11, 'Wunder Willi'),
      _createMockView(12, 'Muffel Maxim'),
      _createMockView(13, 'Schnuffel Sina', hasDone: true),
      _createMockView(14, 'Gurken Greta'),
      _createMockView(15, 'Träumchen Tino', hasDone: true),
      _createMockView(16, 'Rübchen Rudi'),
    ];

    return Stack(
      children: [
        IgnorePointer(
          // We ignore the pointer to avoid that the user can scroll in blurred
          // the list.
          ignoring: true,
          child: _List(dummyUsers),
        ),
        BackdropFilter(
          // We should use a blur that is not too strong so that a user can
          // identify that the users in the list are no real users. Otherwise
          // the user might think that some of the users have already read the
          // info sheet.
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: const SizedBox.expand(),
        ),
        Positioned.fill(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SharezonePlusFeatureInfoCard(
                withLearnMoreButton: true,
                onLearnMorePressed: () => navigateToSharezonePlusPage(context),
                underlayColor: Theme.of(context).scaffoldBackgroundColor,
                child: const Text(
                    'Erwerbe Sharezone Plus, um nachzuvollziehen, wer bereits die Hausaufgabe als erledigt markiert hat.'),
              ),
            ),
          ),
        ),
      ],
    );
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
}

class _List extends StatelessWidget {
  const _List(this.views, {Key? key}) : super(key: key);

  final List<UserHasCompletedHomeworkView>? views;

  @override
  Widget build(BuildContext context) {
    if (views!.isEmpty) return _EmptyList();
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: MaxWidthConstraintBox(
          child: SafeArea(
            child: Column(
              children: [for (final view in views!) _UserTile(view)],
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
  const _UserTile(this.view, {Key? key}) : super(key: key);

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
          child: Text(view.abbreviation,
              style: const TextStyle(color: Colors.white)),
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
