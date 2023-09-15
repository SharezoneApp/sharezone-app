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
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/onboarding/group_onboarding/logic/group_onboarding_bloc.dart';
import 'package:sharezone/support/support_page.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'bloc/group_join_bloc.dart';
import 'widgets/group_join_help.dart';
import 'widgets/group_join_text_field.dart';

/// Auf dieser Seite kann der Nutzer einen Sharecode eingeben oder QrCode scannen und
/// dadurch einer Gruppe beitreten.
Future<dynamic> openGroupJoinPage(BuildContext context) {
  final api = BlocProvider.of<SharezoneContext>(context).api;
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        bloc: GroupJoinBloc(api.connectionsGateway, getCrashAnalytics()),
        child: const _GroupJoinPage(),
      ),
      settings: const RouteSettings(name: _GroupJoinPage.tag),
    ),
  );
}

void _navigateToSharezonePlusPage(BuildContext context) {
  final navigationBloc = BlocProvider.of<NavigationBloc>(context);
  Navigator.pop(context);
  navigationBloc.navigateTo(NavigationItem.sharezonePlus);
}

Future<bool> _isInOnboarding(BuildContext context) async {
  final groupOnboardingBloc = BlocProvider.of<GroupOnboardingBloc>(context);
  return groupOnboardingBloc.isGroupOnboardingActive;
}

Future<void> _openSupportPage(BuildContext context) async {
  openSupportPage(
    context: context,
    // When the user is in the group onboarding, we don't want to show
    // the Sharezone Plus ad because the user is new to the app and we
    // don't want to overwhelm them.
    navigateToPlusPageOrHidePlusAd: await _isInOnboarding(context)
        ? null
        : () => _navigateToSharezonePlusPage(context),
  );
}

class _GroupJoinPage extends StatelessWidget {
  const _GroupJoinPage({Key? key}) : super(key: key);

  static const tag = "group-join-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GroupJoinAppBar(),
      body:
          const SafeArea(child: SingleChildScrollView(child: GroupJoinHelp())),
      bottomNavigationBar: FutureBuilder<bool>(
        future: _isInOnboarding(context),
        builder: (context, future) {
          final isInOnboarding = future.data ?? false;
          return ContactSupport(
            // See [_openSupportPage] for comment.
            navigateToPlusPageOrHidePlusAd: isInOnboarding
                ? null
                : () => _navigateToSharezonePlusPage(context),
          );
        },
      ),
    );
  }
}

class GroupJoinAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GroupJoinAppBar({Key? key, this.withBackIcon = true}) : super(key: key);

  final bool withBackIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("Beitreten", style: TextStyle(color: Colors.white)),
      automaticallyImplyLeading: withBackIcon,
      centerTitle: true,
      backgroundColor:
          isDarkThemeEnabled(context) ? null : Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: const [_SupportIcon()],
      bottom: const GroupJoinTextField(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(190);
}

class _SupportIcon extends StatelessWidget {
  const _SupportIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.question_answer),
      onPressed: () => _openSupportPage(context),
      tooltip: "Support",
    );
  }
}
