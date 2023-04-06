// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/groups/group_join/bloc/group_join_bloc.dart';
import 'package:sharezone/groups/group_join/group_join_page.dart';
import 'package:sharezone/groups/group_join/widgets/group_join_help.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';

class GroupOnboardingGroupJoinPage extends StatefulWidget {
  static const tag = 'group-onboarding-group-join-page';

  @override
  _GroupOnboardingGroupJoinPageState createState() =>
      _GroupOnboardingGroupJoinPageState();
}

class _GroupOnboardingGroupJoinPageState
    extends State<GroupOnboardingGroupJoinPage> {
  GroupJoinBloc bloc;

  @override
  void initState() {
    super.initState();
    final api = BlocProvider.of<SharezoneContext>(context).api;
    bloc = GroupJoinBloc(api.connectionsGateway, getCrashAnalytics());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: const GroupJoinAppBar(withBackIcon: false),
            body:
                SafeArea(child: SingleChildScrollView(child: GroupJoinHelp())),
            bottomNavigationBar: OnboardingNavigationBar(
              action: _FinishButton(),
            ),
          );
        },
      ),
    );
  }
}

class _FinishButton extends StatelessWidget {
  const _FinishButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      child: Text("Fertig".toUpperCase(), style: TextStyle(fontSize: 20)),
      onPressed: () {
        final bloc = BlocProvider.of<GroupOnboardingBloc>(context);
        bloc.finsihOnboarding();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}
