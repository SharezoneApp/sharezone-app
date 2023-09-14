// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sharezone/account/account_page_bloc.dart';
import 'package:sharezone/account/register_account_section.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone/navigation/scaffold/app_bar_configuration.dart';
import 'package:sharezone/navigation/scaffold/sharezone_main_scaffold.dart';
import 'package:sharezone/overview/views/user_view.dart';
import 'package:sharezone/pages/settings/my_profile/change_state.dart';
import 'package:sharezone/pages/settings/my_profile/my_profile_page.dart';
import 'package:sharezone/pages/settings/web_app.dart';
import 'package:sharezone/widgets/avatar_card.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'account_page_bloc_factory.dart';

class AccountPage extends StatefulWidget {
  static const tag = 'profil-page';

  const AccountPage({super.key});

  @override
  State createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late AccountPageBloc bloc;

  @override
  void initState() {
    super.initState();
    final blocFactory = BlocProvider.of<AccountPageBlocFactory>(context);
    bloc = blocFactory.create(scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popToOverview(context),
      child: StreamBuilder<UserView>(
        stream: bloc.userViewStream,
        builder: (context, snapshot) {
          final user = snapshot.data ?? UserView.empty();
          return BlocProvider(
            bloc: bloc,
            child: SharezoneMainScaffold(
              navigationItem: NavigationItem.accountPage,
              scaffoldKey: scaffoldKey,
              appBarConfiguration: AppBarConfiguration(
                title: "Profil",
                actions: <Widget>[
                  if (!PlatformCheck.isDesktopOrWeb) _WebIcon(),
                ],
              ),
              body: AccountPageBody(user: user),
            ),
          );
        },
      ),
    );
  }
}

@visibleForTesting
class AccountPageBody extends StatelessWidget {
  const AccountPageBody({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserView user;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: MaxWidthConstraintBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _MainAccountInformationCard(user: user),
              _SecondaryInformationCard(user: user),
              SignOutButton(isAnonymous: user.isAnonymous)
            ],
          ),
        ),
      ),
    );
  }
}

class _WebIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'QR-Code Login für die Web-App',
      icon: const Icon(Icons.desktop_mac),
      onPressed: () => Navigator.pushNamed(context, WebAppSettingsPage.tag),
    );
  }
}

class _SecondaryInformationCard extends StatelessWidget {
  const _SecondaryInformationCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserView user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: CustomCard(
        child: Column(
          children: <Widget>[
            ListTile(
              title: const Text("Bundesland"),
              subtitle: Text(user.state!),
              onTap: () => Navigator.pushNamed(context, ChangeStatePage.tag),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainAccountInformationCard extends StatelessWidget {
  const _MainAccountInformationCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserView user;

  @override
  Widget build(BuildContext context) {
    final isAnonymous = user.isAnonymous;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Stack(
        children: [
          AvatarCard(
            crossAxisAlignment: CrossAxisAlignment.center,
            kuerzel: user.abbreviation,
            children: <Widget>[
              _Name(userView: user),
              if (user.provider?.hasEmailAddress == true) _EmailText(user),
              _TypeOfUserText(userType: user.userType, uid: user.id),
              if (isAnonymous) const RegistierAccountSection(),
              if (kDebugMode) _UserId(user: user),
            ],
          ),
          const _EditProfilButton(),
        ],
      ),
    );
  }
}

class _EditProfilButton extends StatelessWidget {
  const _EditProfilButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 65,
      right: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            tooltip: 'Profil bearbeiten',
            icon: const Icon(Icons.edit),
            color: Colors.grey,
            onPressed: () => Navigator.pushNamed(context, MyProfilePage.tag),
          ),
        ),
      ),
    );
  }
}

class _UserId extends StatelessWidget {
  const _UserId({Key? key, required this.user}) : super(key: key);

  final UserView user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: InkWell(
        onTap: () => _copyUidAndShowConfirmationSnackBar(context),
        onLongPress: () => _copyUidAndShowConfirmationSnackBar(context),
        child: Text(user.id),
      ),
    );
  }

  void _copyUidAndShowConfirmationSnackBar(BuildContext context) {
    _copyUidToClipboard();
    _showConfirmationSnackBar(context);
  }

  void _copyUidToClipboard() {
    Clipboard.setData(ClipboardData(text: user.id));
  }

  void _showConfirmationSnackBar(BuildContext context) {
    showSnack(context: context, text: 'UID wurde kopiert');
  }
}

class _Name extends StatelessWidget {
  const _Name({Key? key, required this.userView}) : super(key: key);

  final UserView userView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SelectableText(
        userView.name,
        style: const TextStyle(fontSize: 26),
      ),
    );
  }
}

class _EmailText extends StatelessWidget {
  const _EmailText(this.user, {Key? key}) : super(key: key);

  final UserView user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: SelectableText(
          user.email ?? '',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}

class _TypeOfUserText extends StatelessWidget {
  const _TypeOfUserText({
    Key? key,
    required this.uid,
    required this.userType,
  }) : super(key: key);

  final String userType;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      userType,
      style: const TextStyle(fontSize: 14, color: Colors.grey),
    );
  }
}
