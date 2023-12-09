// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'src/sign_out_and_delete_anonymous_user.dart';

Future<void> signOut(BuildContext context, bool isAnonymous) async {
  bool? loggedOut;
  if (PlatformCheck.isWeb) {
    loggedOut = await _showSignOutWithNormalUserDialog(context);
  } else {
    loggedOut = isAnonymous
        ? await showSignOutAndDeleteAnonymousDialog(context)
        : await _showSignOutWithNormalUserDialog(context);
  }
  if (loggedOut == true && context.mounted) {
    final bloc = BlocProvider.of<NavigationBloc>(context);
    bloc.navigateTo(NavigationItem.overview);
  }
}

Future<bool> _showSignOutWithNormalUserDialog(BuildContext context) async {
  final confirmed = await showLeftRightAdaptiveDialog<bool>(
      context: context,
      title: ThemePlatform.isCupertino
          ? "Möchtest du dich wirklich abmelden?"
          : null,
      content: !ThemePlatform.isCupertino
          ? const Text("Möchtest du dich wirklich abmelden?")
          : null,
      defaultValue: false,
      right: const AdaptiveDialogAction(
        key: ValueKey('sign-out-dialog-action-E2E'),
        title: "Abmelden",
        popResult: true,
        isDestructiveAction: true,
        isDefaultAction: true,
      ));
  if (confirmed == true && context.mounted) {
    final userGateway = BlocProvider.of<SharezoneContext>(context).api.user;
    userGateway.logOut();
  }
  return confirmed!;
}
