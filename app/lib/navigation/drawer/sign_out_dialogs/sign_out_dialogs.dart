import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/navigation/logic/navigation_bloc.dart';
import 'package:sharezone/navigation/models/navigation_item.dart';
import 'package:sharezone_utils/platform.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';

import 'src/sign_out_and_delete_anonymous_user.dart';

Future<void> signOut(BuildContext context, bool isAnonymous) async {
  bool loggedOut;
  if (PlatformCheck.isWeb) {
    loggedOut = await _showSignOutWithNormalUserDialog(context);
  } else {
    loggedOut = isAnonymous
        ? await showSignOutAndDeleteAnonymousDialog(context)
        : await _showSignOutWithNormalUserDialog(context);
  }
  if (loggedOut != null && loggedOut) {
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
  if (confirmed) {
    final userGateway = BlocProvider.of<SharezoneContext>(context).api.user;
    userGateway.logOut();
  }
  return confirmed;
}
