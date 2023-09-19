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

class _GroupJoinPage extends StatelessWidget {
  const _GroupJoinPage({Key? key}) : super(key: key);

  static const tag = "group-join-page";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GroupJoinAppBar(),
      body: SafeArea(child: SingleChildScrollView(child: GroupJoinHelp())),
      bottomNavigationBar: ContactSupport(),
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
          Theme.of(context).isDarkTheme ? null : Theme.of(context).primaryColor,
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
      onPressed: () => Navigator.pushNamed(context, SupportPage.tag),
      tooltip: "Support",
    );
  }
}
