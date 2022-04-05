// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/dialog_wrapper.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:sharezone_widgets/widgets.dart';

Future<bool> showSignOutAndDeleteAnonymousDialog(BuildContext context) {
  if (ThemePlatform.isCupertino) {
    return showCupertinoDialog(
        context: context,
        builder: (context) => SignOutAndDeleteAnonymousUserAlert());
  } else {
    return showDialog(
        context: context,
        builder: (context) => SignOutAndDeleteAnonymousUserAlert());
  }
}

class SignOutAndDeleteAnonymousUserAlert extends StatefulWidget {
  @override
  _SignOutAndDeleteAnonymousUserAlertState createState() =>
      _SignOutAndDeleteAnonymousUserAlertState();
}

class _SignOutAndDeleteAnonymousUserAlertState
    extends State<SignOutAndDeleteAnonymousUserAlert> {
  static const userDeletionNotice = """
Du bist anonym angemeldet. Solltest du dich abmelden, wirst du nie wieder auf deinen Account zugreifen können. Deswegen wird dein Konto dann gelöscht.
    
Bitte stell dabei sicher, dass dein Gerät eine Verbindung zum Internet hat.
  """;
  bool confirmedToDeleteAccount = false;
  bool isLoading = false;
  String errorTextForUser;

  Future<void> tryToSignOutAndDeleteUser(BuildContext context) async {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    setState(() {
      isLoading = true;
      errorTextForUser = null;
    });

    try {
      _logAnonymousUserSignedOutEvent(analytics);
      await api.user.deleteUser(api);
    } on NoInternetAccess catch (_) {
      print("User has no internet access!");
      setState(() {
        isLoading = false;
        errorTextForUser =
            "Dein Gerät hat leider keinen Zugang zum Internet...";
      });
    } on Exception catch (e, s) {
      print("$e $s");
      setState(() {
        isLoading = false;
        errorTextForUser = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const text = "Ja, ich möchte mein Konto löschen.";
    if (ThemePlatform.isCupertino) {
      return CupertinoAlertDialog(
        title: const _SignOutAndDeleteAnonymousDialogTitle(),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userDeletionNotice),
              DeleteConfirmationCheckbox(
                onChanged: (value) =>
                    setState(() => confirmedToDeleteAccount = value),
                confirm: confirmedToDeleteAccount,
                text: text,
              ),
              if (isValidError(errorTextForUser))
                DeleteAccountDialogErrorText(text: errorTextForUser)
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text("Abbrechen"),
            onPressed: () => Navigator.pop(context, false),
          ),
          if (isLoading)
            Column(
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: LoadingCircle(),
                ),
              ],
            ),
          if (confirmedToDeleteAccount && !isLoading)
            CupertinoActionSheetAction(
                child: const Text("Löschen"),
                isDefaultAction: true,
                isDestructiveAction: true,
                onPressed: () => tryToSignOutAndDeleteUser(context)),
        ],
      );
    }

    return AlertDialog(
        title: const _SignOutAndDeleteAnonymousDialogTitle(),
        contentPadding: const EdgeInsets.only(top: 24),
        content: DialogWrapper(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(userDeletionNotice),
                ),
                DeleteConfirmationCheckbox(
                  onChanged: (bool value) =>
                      setState(() => confirmedToDeleteAccount = value),
                  confirm: confirmedToDeleteAccount,
                  text: text,
                ),
                if (isValidError(errorTextForUser))
                  DeleteAccountDialogErrorText(text: errorTextForUser)
              ],
            ),
          ),
        ),
        actions: [
          if (isLoading)
            LoadingCircle()
          else
            Row(
              children: <Widget>[
                CancleButton(),
                TextButton(
                  child: const Text("LÖSCHEN"),
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).errorColor,
                  ),
                  onPressed: confirmedToDeleteAccount
                      ? () => tryToSignOutAndDeleteUser(context)
                      : null,
                ),
              ],
            )
        ]);
  }

  bool isValidError(String error) => error != null && error.isNotEmpty;

  void _logAnonymousUserSignedOutEvent(Analytics analytics) {
    analytics.log(NamedAnalyticsEvent(name: "anonymous_user_signed_out"));
  }
}

class _SignOutAndDeleteAnonymousDialogTitle extends StatelessWidget {
  const _SignOutAndDeleteAnonymousDialogTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const Text("Möchtest du dich wirklich abmelden?");
}

class DeleteAccountDialogErrorText extends StatelessWidget {
  const DeleteAccountDialogErrorText({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(ThemePlatform.isCupertino ? 0 : 24, 16,
          ThemePlatform.isCupertino ? 0 : 24, 0),
      child: Text(text,
          style: TextStyle(color: Theme.of(context).errorColor, fontSize: 14)),
    );
  }
}

class DeleteConfirmationCheckbox extends StatelessWidget {
  const DeleteConfirmationCheckbox(
      {Key key, this.confirm, this.onChanged, @required this.text})
      : super(key: key);

  final bool confirm;
  final ValueChanged<bool> onChanged;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (ThemePlatform.isCupertino)
      return GestureDetector(
        onTap: () => onChanged(!confirm),
        child: child(context),
      );
    return InkWell(
      onTap: () => onChanged(!confirm),
      child: child(context),
    );
  }

  Widget child(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          ThemePlatform.isCupertino ? 0 : 24,
          12,
          ThemePlatform.isCupertino ? 0 : 24,
          ThemePlatform.isCupertino ? 0 : 12),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(text, textAlign: TextAlign.start),
          ),
          if (!ThemePlatform.isCupertino) SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: Theme(
              data: darkTheme,
              child: Checkbox(
                value: confirm,
                onChanged: onChanged,
              ),
            ),
          )
        ],
      ),
    );
  }
}
