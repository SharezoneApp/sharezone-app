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
import 'package:flutter/services.dart';
import 'package:helper_functions/helper_functions.dart';
import 'package:provider/provider.dart' as pv;
import 'package:sharezone/account/account_page.dart';
import 'package:sharezone/account/change_data_bloc.dart';
import 'package:sharezone/account/profile/user_edit/user_edit_page.dart';
import 'package:sharezone/account/select_state_dialog.dart';
import 'package:sharezone/activation_code/activation_code_page.dart';
import 'package:sharezone/groups/src/widgets/danger_section.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/navigation/drawer/sign_out_dialogs/sign_out_dialogs.dart';
import 'package:sharezone/navigation/drawer/sign_out_dialogs/src/sign_out_and_delete_anonymous_user.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_email.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_password.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_type_of_user/change_type_of_user_page.dart';
import 'package:sharezone/settings/src/subpages/my_profile/my_profile_bloc.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'user_view.dart';

/// SharezoneContext sollte von dieser Seite entfernt werden, damit richtige
/// Widget-Tests geschrieben werden können.\
/// Ticket: https://gitlab.com/codingbrain/sharezone/sharezone-app/-/issues/1209
class MyProfilePage extends StatelessWidget {
  static const tag = "my-profile-page";

  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final bloc = MyProfileBloc(api.user);
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.myProfileTitle),
          centerTitle: true,
        ),
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
                      _UserId(user.id),
                      _EnterActivationTile(),
                      _PrivacyOptOut(),
                      const Divider(height: 32),
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
  const _NameTile({required this.user});

  final UserView user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(context.l10n.myProfileNameTile),
      subtitle: Text(user.name),
      onTap: () => openUserEditPageIfUserIsLoaded(context, user.user),
    );
  }
}

class _EnterActivationTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(context.l10n.myProfileActivationCodeTile),
      leading: const Icon(Icons.vpn_key),
      onTap: () {
        openEnterActivationCodePage(context);
      },
    );
  }
}

class _EmailTile extends StatelessWidget {
  const _EmailTile({required this.user});

  final UserView user;

  @override
  Widget build(BuildContext context) {
    if (user.isAnonymous || user.provider == Provider.apple) return Container();
    return ListTile(
      leading: const Icon(Icons.email),
      title: Text(context.l10n.myProfileEmailTile),
      subtitle: Text(user.email ?? '-'),
      onTap: () {
        if (user.provider == Provider.google) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  content: Text(context.l10n.myProfileEmailNotChangeable),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        context.l10n.commonActionsAlright.toUpperCase(),
                      ),
                    ),
                  ],
                ),
          );
        } else {
          openChangeEmailPage(context, user.email!);
        }
      },
    );
  }
}

class _TypeOfUserTile extends StatelessWidget {
  const _TypeOfUserTile({this.user});

  final UserView? user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(context.l10n.myProfileEmailAccountTypeTitle),
      subtitle: Text(user!.typeOfUser),
      leading: const Icon(Icons.accessibility),
      onTap: () => Navigator.pushNamed(context, ChangeTypeOfUserPage.tag),
    );
  }
}

class _PasswordTile extends StatelessWidget {
  const _PasswordTile({required this.provider});

  final Provider provider;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangeDataBloc>(context);
    if (provider != Provider.email) return Container();
    return ListTile(
      leading: const Icon(Icons.vpn_key),
      title: Text(context.l10n.myProfileChangePasswordTile),
      onTap: () async {
        bloc.changePassword(null);
        bloc.changeNewPassword(null);
        final successful =
            await Navigator.pushNamed(context, ChangePasswordPage.tag) as bool?;
        if (successful == true) {
          await waitingForPopAnimation();
          if (!context.mounted) return;

          showSnackSec(
            seconds: 3,
            context: context,
            text: context.l10n.myProfileChangedPasswordConfirmation,
          );
        }
      },
    );
  }
}

class _StateTile extends StatelessWidget {
  const _StateTile({required this.state});

  final String? state;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(context.l10n.myProfileStateTile),
      subtitle: Text(state!),
      onTap: () => showStateSelectionDialog(context),
    );
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({required this.provider});

  final Provider provider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lock),
      title: Text(context.l10n.myProfileSignInMethodTile),
      subtitle: Text(providerToUiString(provider, context.l10n)),
      onTap: () {
        if (provider == Provider.anonymous) {
          Navigator.pushNamed(context, AccountPage.tag);
        } else {
          showLeftRightAdaptiveDialog(
            context: context,
            title:
                context.l10n.myProfileSignInMethodChangeNotPossibleDialogTitle,
            content: Text(
              context.l10n.myProfileSignInMethodChangeNotPossibleDialogContent,
            ),
            left: AdaptiveDialogAction(
              isDefaultAction: true,
              title: context.l10n.commonActionsOk,
            ),
          );
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
    final crashAnalytics = pv.Provider.of<CrashAnalytics>(
      context,
      listen: false,
    );
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
          title: Text(context.l10n.myProfileSupportTeamTile),
          leading: const Icon(Icons.security),
          onTap: () => setCollectionEnabled(!hasUserOptOut),
          trailing: Switch.adaptive(
            value: hasUserOptOut,
            onChanged: (isEnabled) => setCollectionEnabled(isEnabled),
          ),
          description: Padding(
            padding: const EdgeInsets.only(left: 41, right: 20),
            child: Text(
              context.l10n.myProfileSupportTeamDescription,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}

class _UserId extends StatelessWidget {
  const _UserId(this.userID);

  final String userID;

  void copyUserId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: userID));
    showSnack(
      context: context,
      text: context.l10n.myProfileCopyUserIdConfirmation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.tag),
      title: Text(context.l10n.myProfileCopyUserIdTile),
      subtitle: Text(userID),
      onTap: () => copyUserId(context),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key, required this.isAnonymous});

  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DangerButtonOutlined(
        key: const ValueKey('sign-out-button-E2E'),
        icon: const Icon(Icons.exit_to_app),
        onPressed: () => signOut(context, isAnonymous),
        label: Text(context.l10n.myProfileSignOutButton.toUpperCase()),
      ),
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DangerButtonFilled(
        icon: const Icon(Icons.delete),
        label: Text(context.l10n.myProfileDeleteAccountButton.toUpperCase()),
        onPressed:
            () => showDialog(
              context: context,
              builder: (context) => _DeleteAccountDialogContent(),
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
  bool? signOut = false;
  bool isLoading = false;
  String? error;
  String? password;
  bool _obscureText = true;

  bool isStringNullOrEmpty(String? string) {
    return string == null || string.isEmpty;
  }

  List<Widget> actions(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final provider = api.user.authUser!.provider;
    return [
      const CancelButton(),
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        onPressed:
            provider != Provider.email
                ? signOut!
                    ? () => tryToDeleteUser(context)
                    : null
                : !isStringNullOrEmpty(password)
                ? () => tryToDeleteUser(context)
                : null,
        child: Text(context.l10n.commonActionsDelete.toUpperCase()),
      ),
    ];
  }

  static const List<Widget> loadingCircle = [
    Padding(
      padding: EdgeInsets.only(right: 16, bottom: 16),
      child: SizedBox(
        width: 25,
        height: 25,
        child: AccentColorCircularProgressIndicator(),
      ),
    ),
  ];

  Future<void> tryToDeleteUser(BuildContext context) async {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final authUser = api.user.authUser!;
    final fbUser = authUser.firebaseUser;
    final provider = authUser.provider;
    if (provider == Provider.email) {
      if (isEmptyOrNull(password)) {
        return;
      }
    }

    final analytics = BlocProvider.of<SharezoneContext>(context).analytics;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      if (provider != Provider.anonymous) {
        if (provider == Provider.google) {
          final googleSignInLogic = GoogleSignInLogic();
          await googleSignInLogic.reauthenticateWithGoogle();
        } else if (provider == Provider.apple) {
          final appleSignInLogic = AppleSignInLogic();
          await appleSignInLogic.reauthenticateWithApple();
        } else {
          final credential = EmailAuthProvider.credential(
            email: fbUser.email!,
            password: password!,
          );
          await fbUser.reauthenticateWithCredential(credential);
        }
      }
      await api.user.deleteUser(api);
      api.references.firebaseAuth!.signOut();
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
    final provider = api.user.authUser!.provider;
    const text = "Ja, ich möchte mein Konto löschen.";

    if (ThemePlatform.isCupertino) {
      return CupertinoAlertDialog(
        title: const _DeleteAccountDialogTitle(),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const _DeleteAccountDialogText(),
              if (provider == Provider.email)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    const Text(
                      "Bitte gib dein Passwort ein, um deinen Account zu löschen.",
                    ),
                    Material(
                      color: Colors.transparent,
                      child: TextField(
                        onChanged: (s) => setState(() => password = s),
                        onEditingComplete: () async => tryToDeleteUser(context),
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Passwort',
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
                  confirm: signOut!,
                  text: text,
                ),
              if (isNotEmptyOrNull(error))
                DeleteAccountDialogErrorText(text: error!),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(context.l10n.commonActionsCancel),
            onPressed: () => Navigator.pop(context),
          ),
          if (isLoading)
            const Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: LoadingCircle(),
                ),
              ],
            ),
          if ((provider == Provider.email
                  ? isNotEmptyOrNull(password)
                  : signOut!) &&
              !isLoading)
            CupertinoDialogAction(
              isDefaultAction: true,
              isDestructiveAction: true,
              onPressed: () => tryToDeleteUser(context),
              child: Text(context.l10n.commonActionsDelete),
            ),
        ],
      );
    }

    return MaxWidthConstraintBox(
      maxWidth: 400,
      child: AlertDialog(
        title: const _DeleteAccountDialogTitle(),
        contentPadding: const EdgeInsets.only(top: 24),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
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
                        Text(
                          context
                              .l10n
                              .myProfileDeleteAccountDialogPleaseEnterYourPassword,
                        ),
                        TextField(
                          onChanged: (s) => setState(() => password = s),
                          onEditingComplete:
                              () async => tryToDeleteUser(context),
                          autofocus: false,
                          decoration: InputDecoration(
                            labelText:
                                context
                                    .l10n
                                    .myProfileDeleteAccountDialogPasswordTextfieldLabel,
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
                              ),
                            ),
                          ),
                          obscureText: _obscureText,
                        ),
                      ],
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 4,
                    ),
                    child: DeleteConfirmationCheckbox(
                      confirm: signOut!,
                      onChanged: (value) => setState(() => signOut = value),
                      text: text,
                    ),
                  ),
              if (isNotEmptyOrNull(error))
                DeleteAccountDialogErrorText(text: error!),
            ],
          ),
        ),
        actions: isLoading ? loadingCircle : actions(context),
      ),
    );
  }
}

class _DeleteAccountDialogText extends StatelessWidget {
  const _DeleteAccountDialogText();

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.myProfileDeleteAccountDialogContent);
  }
}

class _DeleteAccountDialogTitle extends StatelessWidget {
  const _DeleteAccountDialogTitle();

  @override
  Widget build(BuildContext context) =>
      Text(context.l10n.myProfileDeleteAccountDialogTitle);
}
