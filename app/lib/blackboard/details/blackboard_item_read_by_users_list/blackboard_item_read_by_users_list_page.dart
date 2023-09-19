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
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/sharezone_plus/page/sharezone_plus_page.dart';
import 'package:sharezone/sharezone_plus/subscription_service/subscription_service.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'blackboard_item_read_by_users_list_bloc.dart';
import 'user_view.dart';

class BlackboardItemReadByUsersListPage extends StatefulWidget {
  const BlackboardItemReadByUsersListPage({
    Key? key,
    required this.itemId,
    required this.courseId,
  }) : super(key: key);

  final String itemId;
  final CourseId courseId;

  static const tag = 'blackboard-item-read-by-users-list-page';

  @override
  State createState() => _BlackboardItemReadByUsersListPageState();
}

class _BlackboardItemReadByUsersListPageState
    extends State<BlackboardItemReadByUsersListPage> {
  late BlackboardItemReadByUsersListBloc bloc;

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
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Gelesen von"),
          centerTitle: true,
        ),
        body: const BlackboardItemReadByUsersListPageBody(),
      ),
    );
  }

  void logOpenUserReadPage() {
    final analytics = BlocProvider.of<BlackboardAnalytics>(context);
    analytics.logOpenUserReadPage();
  }
}

@visibleForTesting
class BlackboardItemReadByUsersListPageBody extends StatelessWidget {
  const BlackboardItemReadByUsersListPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isUnlocked = context
        .read<SubscriptionService>()
        .hasFeatureUnlocked(SharezonePlusFeature.infoSheetReadByUsersList);
    if (!isUnlocked) {
      return const _FreeUsersLockScreen();
    }

    final bloc = BlocProvider.of<BlackboardItemReadByUsersListBloc>(context);
    return StreamBuilder<List<UserView>>(
      stream: bloc.userViews,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: snapshot.hasData ? _List(snapshot.data!) : _Loading(),
        );
      },
    );
  }
}

UserView _createMockView(int number, String name, {bool hasRead = false}) {
  return UserView(
    uid: "user$number",
    hasRead: hasRead,
    typeOfUser: TypeOfUser.student.toReadableString(),
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
      _createMockView(3, 'Pünktchen Schmunzler', hasRead: true),
      _createMockView(4, 'Kicher Karla'),
      _createMockView(5, 'Hoppla Heidi'),
      _createMockView(6, 'Fussel Frieda', hasRead: true),
      _createMockView(7, 'Wuschel Waltraud'),
      _createMockView(8, 'Pumpernickel Peter'),
      _createMockView(9, 'Tapsi Töne'),
      _createMockView(10, 'Knuddel Kuno', hasRead: true),
      _createMockView(11, 'Wunder Willi'),
      _createMockView(12, 'Muffel Maxim'),
      _createMockView(13, 'Schnuffel Sina', hasRead: true),
      _createMockView(14, 'Gurken Greta'),
      _createMockView(15, 'Träumchen Tino', hasRead: true),
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
                    'Erwerbe Sharezone Plus, um nachzuvollziehen, wer den Infozettel bereits gelesen hat.'),
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

  List<UserView> _getMockViews() {
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
    return const Center(
      child: Text("Es befinden sich keine Teilnehmer in dieser Gruppe 😭"),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile(this.view, {Key? key}) : super(key: key);

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
          child: Text(view.abbreviation,
              style: const TextStyle(color: Colors.white)),
        ),
        trailing: hasReadIcon(),
      ),
    );
  }

  Widget hasReadIcon() {
    if (view.hasRead) return const Icon(Icons.check, color: Colors.green);
    return const Icon(Icons.close, color: Colors.red);
  }
}
