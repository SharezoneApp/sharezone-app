// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification.dart';
import 'package:authentification_base/authentification_apple.dart';
import 'package:authentification_base/authentification_google.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:crash_analytics/crash_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pv;
import 'package:sharezone/account/account_page.dart';
import 'package:sharezone/activation_code/activation_code_page.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/blocs/settings/change_data_bloc.dart';
import 'package:sharezone/navigation/drawer/sign_out_dialogs/sign_out_dialogs.dart';
import 'package:sharezone/navigation/drawer/sign_out_dialogs/src/sign_out_and_delete_anonymous_user.dart';
import 'package:sharezone/pages/profile/user_edit/user_edit_page.dart';
import 'package:sharezone/pages/settings/my_profile/change_email.dart';
import 'package:sharezone/pages/settings/my_profile/change_password.dart';
import 'package:sharezone/pages/settings/my_profile/change_state.dart';
import 'package:sharezone/pages/settings/my_profile/my_profile_bloc.dart';
import 'package:sharezone/widgets/material/list_tile_with_description.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:sharezone_widgets/wrapper.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:url_launcher_extended/url_launcher_extended.dart';

import 'user_view.dart';

/// SharezoneContext sollte von dieser Seite entfernt werden, damit richtige
/// Widget-Tests geschrieben werden können.\
/// Ticket: https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1209
class MyProfilePage extends StatelessWidget {
  static const tag = "my-profile-page";

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = MyProfileBloc(api.user);
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Mein Konto"), centerTitle: true),
        body: SingleChildScrollView(
          child: SafeArea(
            child: MaxWidthConstraintBox(
              child: StreamBuilder<UserView>(
                stream: bloc.userViewStream,
                builder: (context, snapshot) {
                  final user = snapshot.data ?? UserView.empty();
                  return Column(
                    children: <Widget>[
                      _NameTile(user: user),
                      _EmailTile(user: user),
                      _TypeOfUserTile(user: user),
                      _PasswordTile(provider: user.provider),
                      _StateTile(state: user.state),
                      _ProviderTile(provider: user.provider),
                      _EnterActivationTile(),
                      _PrivacyOptOut(),
                      const Divider(),
                      SignOutButton(isAnonymous: user.isAnonymous),
                      _DeleteAccountButton(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NameTile extends StatelessWidget {
  const _NameTile({Key key, @required this.user}) : super(key: key);

  final UserView user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text("Name"),
      subtitle: Text(user.name),
      onTap: () => openUserEditPageIfUserIsLoaded(context, user.user),
    );
  }
}

class _EnterActivationTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Aktivierungscode eingeben"),
      leading: Icon(Icons.vpn_key),
      onTap: () {
        openEnterActivationCodePage(context);
      },
    );
  }
}

class _EmailTile extends StatelessWidget {
  const _EmailTile({Key key, @required this.user}) : super(key: key);

  final UserView user;

  @override
  Widget build(BuildContext context) {
    if (user.isAnonymous || user.provider == Provider.apple) return Container();
    return ListTile(
      leading: Icon(Icons.email),
      title: const Text("E-Mail"),
      subtitle: Text(user.email ?? '-'),
      onTap: () {
        if (user.provider == Provider.google) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: const Text(
                  "Dein Account ist mit einem Google-Konto verbunden. Aus diesem Grund kannst du deine E-Mail nicht ändern."),
              actions: <Widget>[
                TextButton(
                  child: const Text("ALLES KLAR"),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        } else {
          openChangeEmailPage(context, user.email);
        }
      },
    );
  }
}

class _TypeOfUserTile extends StatelessWidget {
  const _TypeOfUserTile({Key key, this.user}) : super(key: key);

  final UserView user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Account-Typ"),
      subtitle: Text(user.typeOfUser),
      leading: const Icon(Icons.accessibility),
      onTap: () async {
        final confirmed = await showLeftRightAdaptiveDialog<bool>(
          context: context,
          defaultValue: false,
          title: 'Account-Typ',
          content: Text(
              "Der Typ des Accounts kann nur vom Support geändert werden."),
          right: AdaptiveDialogAction(
            isDefaultAction: true,
            popResult: true,
            title: "Support kontaktieren",
          ),
        );

        if (confirmed) {
          UrlLauncherExtended().tryLaunchMailOrThrow("support@sharezone.net",
              subject: "Typ des Accounts ändern [${user.id}]");
        }
      },
    );
  }
}

class _PasswordTile extends StatelessWidget {
  const _PasswordTile({Key key, @required this.provider}) : super(key: key);

  final Provider provider;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangeDataBloc>(context);
    if (provider != Provider.email) return Container();
    return ListTile(
      leading: const Icon(Icons.vpn_key),
      title: const Text("Passwort ändern"),
      onTap: () async {
        bloc.changePassword(null);
        bloc.changeNewPassword(null);
        final successful =
            await Navigator.pushNamed(context, ChangePasswordPage.tag) as bool;
        if (successful != null && successful) {
          await waitingForPopAnimation();
          showSnackSec(
              seconds: 3,
              context: context,
              text: "Das Passwort wurde erfolgreich geändert.");
        }
      },
    );
  }
}

class _StateTile extends StatelessWidget {
  const _StateTile({Key key, @required this.state}) : super(key: key);

  final String state;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text("Bundesland"),
      subtitle: Text(state),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChangeStatePage(),
          settings: RouteSettings(name: ChangeStatePage.tag),
        ),
      ),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({Key key, @required this.provider}) : super(key: key);

  final Provider provider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock),
      title: const Text("Anmeldemethode"),
      subtitle: Text(providerToUiString(provider)),
      onTap: () {
        if (provider == Provider.anonymous) {
          Navigator.pushNamed(context, AccountPage.tag);
        } else {
          showLeftRightAdaptiveDialog(
              context: context,
              title: 'Anmeldemethode ändern nicht möglich',
              content: const Text(
                "Die Anmeldemethode kann aktuell nur bei der Registrierung gesetzt werden. Später kann diese nicht mehr geändert werden.",
              ),
              left: AdaptiveDialogAction(
                isDefaultAction: true,
                title: 'Ok',
              ));
        }
      },
    );
  }
}

class _PrivacyOptOut extends StatelessWidget {
  static const preferenceKey = 'opt-out';

  @override
  Widget build(BuildContext context) {
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    final crashAnalytics =
        pv.Provider.of<CrashAnalytics>(context, listen: false);
    final preferences =
        BlocProvider.of<SharezoneContext>(context).streamingSharedPreferences;

    void setCollectionEnabled(bool enabled) {
      analytics.setAnalyticsCollectionEnabled(enabled);
      preferences.setBool(preferenceKey, enabled);
      crashAnalytics.setCrashAnalyticsEnabled(enabled);
    }

    return PreferenceBuilder<bool>(
      preference: preferences.getBool(preferenceKey, defaultValue: true),
      builder: (context, snapshot) {
        final hasUserOptOut = snapshot;
        return ListTileWithDescription(
          title: Text("Entwickler unterstützen"),
          leading: const Icon(Icons.security),
          onTap: () => setCollectionEnabled(!hasUserOptOut),
          trailing: Switch.adaptive(
            value: hasUserOptOut,
            onChanged: (isEnabled) => setCollectionEnabled(isEnabled),
          ),
          description: Padding(
            padding: const EdgeInsets.only(left: 56, right: 20),
            child: Text(
              "Durch das Teilen von anonymen Nutzerdaten hilfst du uns, die App noch einfacher und benutzerfreundlicher zu machen.",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key key, @required this.isAnonymous}) : super(key: key);

  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        key: const ValueKey('sign-out-button-E2E'),
        child: Text("Abmelden".toUpperCase()),
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
        ),
        onPressed: () => signOut(context, isAnonymous),
      ),
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _DangerButton(
        icon: const Icon(Icons.delete),
        title: "Konto löschen",
        onTap: () => showDialog(
          context: context,
          builder: (context) => _DeleteAccountDialogContent(),
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  const _DangerButton({Key key, this.onTap, this.title, this.icon})
      : super(key: key);

  final VoidCallback onTap;
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: ButtonTheme(
        minWidth: getScreenSize(context).width,
        child: ElevatedButton.icon(
          icon: icon,
          label: Text(title.toUpperCase()),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.redAccent,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}

class _DeleteAccountDialogContent extends StatefulWidget {
  @override
  _DeleteAccountDialogContentState createState() =>
      _DeleteAccountDialogContentState();
}

class _DeleteAccountDialogContentState
    extends State<_DeleteAccountDialogContent> {
  bool signOut = false;
  bool isLoading = false;
  String error;
  String password;
  bool _obscureText = true;

  bool isStringNullOrEmpty(String string) {
    return string == null || string.isEmpty;
  }

  List<Widget> actions(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final provider = api.user.authUser.provider;
    return [
      CancelButton(),
      TextButton(
        child: const Text("LÖSCHEN"),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        onPressed: provider != Provider.email
            ? signOut
                ? () => tryToDeleteUser(context)
                : null
            : !isStringNullOrEmpty(password)
                ? () => tryToDeleteUser(context)
                : null,
      ),
    ];
  }

  static const List<Widget> loadingCircle = [
    Padding(
      padding: EdgeInsets.only(right: 16, bottom: 16),
      child: SizedBox(
          width: 25, height: 25, child: AccentColorCircularProgressIndicator()),
    ),
  ];

  Future<void> tryToDeleteUser(BuildContext context) async {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;
    final authUser = api.user.authUser;
    final fbUser = authUser.firebaseUser;
    final provider = authUser.provider;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      if (provider != Provider.anonymous) {
        AuthCredential credential;
        if (provider == Provider.google) {
          final googleSignInLogic = GoogleSignInLogic();
          final googleSignInCredential = await googleSignInLogic.signIn();
          credential = googleSignInCredential;
        } else if (provider == Provider.apple) {
          final appleSignInLogic = AppleSignInLogic();
          await appleSignInLogic.signIn();
        } else {
          credential = EmailAuthProvider.credential(
              email: fbUser.email, password: password);
        }
        if (credential != null) {
          await fbUser.reauthenticateWithCredential(credential);
        }
      }
      await api.user.deleteUser(api);
      api.references.firebaseAuth.signOut();
      analytics.log(NamedAnalyticsEvent(name: "user_deleted"));
    } on Exception catch (e, s) {
      setState(() {
        isLoading = false;
        error = handleErrorMessage(e.toString(), s);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final provider = api.user.authUser.provider;
    const text = "Ja, ich möchte mein Konto löschen.";

    if (ThemePlatform.isCupertino) {
      return CupertinoAlertDialog(
        title: _DeleteAccountDialogTitle(),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _DeleteAccountDialogText(),
              if (provider == Provider.email)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    const Text(
                        "Bitte gib dein Passwort ein, um deinen Account zu löschen."),
                    Material(
                      color: Colors.transparent,
                      child: TextField(
                        onChanged: (s) => setState(() => password = s),
                        onEditingComplete: () async => tryToDeleteUser(context),
                        autofocus: false,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Passwort',
                          labelStyle: TextStyle(color: Colors.black),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        obscureText: _obscureText,
                      ),
                    ),
                  ],
                )
              else
                DeleteConfirmationCheckbox(
                  onChanged: (value) => setState(() => signOut = value),
                  confirm: signOut,
                  text: text,
                ),
              if (isNotEmptyOrNull(error))
                DeleteAccountDialogErrorText(text: error)
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: const Text("Abbrechen"),
            onPressed: () => Navigator.pop(context),
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
          if ((provider == Provider.email
                  ? isNotEmptyOrNull(password)
                  : signOut) &&
              !isLoading)
            CupertinoActionSheetAction(
              child: const Text("Löschen"),
              isDefaultAction: true,
              isDestructiveAction: true,
              onPressed: () => tryToDeleteUser(context),
            ),
        ],
      );
    }

    return AlertDialog(
      title: _DeleteAccountDialogTitle(),
      contentPadding: const EdgeInsets.only(top: 24),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _DeleteAccountDialogText(),
            ),
            provider == Provider.email
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 16),
                        const Text(
                            "Bitte gib dein Passwort ein, um deinen Account zu löschen."),
                        TextField(
                          onChanged: (s) => setState(() => password = s),
                          onEditingComplete: () async =>
                              tryToDeleteUser(context),
                          autofocus: false,
                          decoration: InputDecoration(
                            labelText: 'Passwort',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          obscureText: _obscureText,
                        ),
                      ],
                    ),
                  )
                : DeleteConfirmationCheckbox(
                    confirm: signOut,
                    onChanged: (value) => setState(() => signOut = value),
                    text: text,
                  ),
            if (isNotEmptyOrNull(error))
              DeleteAccountDialogErrorText(text: error)
          ],
        ),
      ),
      actions: isLoading ? loadingCircle : actions(context),
    );
  }
}

class _DeleteAccountDialogText extends StatelessWidget {
  const _DeleteAccountDialogText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
        "Sollte dein Account gelöscht werden, werden alle deine Daten gelöscht. Dieser Vorgang lässt sich nicht wieder rückgängig machen.");
  }
}

class _DeleteAccountDialogTitle extends StatelessWidget {
  const _DeleteAccountDialogTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const Text("Möchtest du deinen Account wirklich löschen?");
}
