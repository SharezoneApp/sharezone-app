// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/auth/authentification_localization_mapper.dart';
import 'package:sharezone/account/change_data_bloc.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_data.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone/settings/src/subpages/my_profile/submit_method.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

const snackBarText = 'Neue E-Mail Adresse wird an die Zentrale geschickt...';
const changeType = ChangeType.email;

void openChangeEmailPage(BuildContext context, String email) {
  final bloc = BlocProvider.of<ChangeDataBloc>(context);
  bloc.changeEmail(email);
  bloc.changePassword(null);
  Navigator.pushNamed(context, ChangeEmailPage.tag);
}

class ChangeEmailPage extends StatelessWidget {
  static const String tag = "change-email-page";

  const ChangeEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.changeEmailAddressTitle),
        centerTitle: true,
      ),
      body: ChangeEmailPageBody(),
      floatingActionButton: const ChangeEmailFab(),
    );
  }
}

class ChangeEmailFab extends StatelessWidget {
  const ChangeEmailFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => submit(context, snackBarText, changeType),
      tooltip: context.l10n.commonActionsSave,
      child: const Icon(Icons.check),
    );
  }
}

class ChangeEmailPageBody extends StatelessWidget {
  final passwordNode = FocusNode();

  ChangeEmailPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    final currentEmail = api.user.authUser!.email;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: MaxWidthConstraintBox(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _CurrentEmailField(currentEmail: currentEmail),
              const SizedBox(height: 16),
              _NewEmailField(
                currentEmail: currentEmail,
                passwordNode: passwordNode,
              ),
              const SizedBox(height: 8),
              ChangeDataPasswordField(
                labelText:
                    context.l10n.changeEmailAddressPasswordTextfieldLabel,
                focusNode: passwordNode,
                onEditComplete:
                    () async => await submit(context, snackBarText, changeType),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.changeEmailAddressNoteOnAutomaticSignOutSignIn,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const Divider(height: 42),
              const _WhyWeNeedTheEmail(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhyWeNeedTheEmail extends StatelessWidget {
  const _WhyWeNeedTheEmail();

  @override
  Widget build(BuildContext context) {
    return InfoMessage(
      title: context.l10n.changeEmailAddressWhyWeNeedTheEmailInfoTitle,
      message: context.l10n.changeEmailAddressWhyWeNeedTheEmailInfoContent,
      withPrivacyStatement: true,
    );
  }
}

class _CurrentEmailField extends StatelessWidget {
  const _CurrentEmailField({required this.currentEmail});

  final String? currentEmail;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: currentEmail),
      decoration: InputDecoration(
        labelText: context.l10n.changeEmailAddressCurrentEmailTextfieldLabel,
      ),
      enabled: false,
      style: const TextStyle(color: Colors.grey, fontSize: 16),
    );
  }
}

class _NewEmailField extends StatefulWidget {
  const _NewEmailField({
    required this.currentEmail,
    required this.passwordNode,
  });

  final String? currentEmail;
  final FocusNode passwordNode;

  @override
  __NewEmailFieldState createState() => __NewEmailFieldState();
}

class __NewEmailFieldState extends State<_NewEmailField> {
  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.currentEmail);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangeDataBloc>(context);
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          controller: controller,
          autofocus: true,
          autofillHints: const [AutofillHints.email],
          onEditingComplete:
              () => FocusManager.instance.primaryFocus?.unfocus(),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: context.l10n.changeEmailAddressNewEmailTextfieldLabel,
            errorText: mapAuthentificationValidationErrorMessage(
              context,
              snapshot.error,
            ),
          ),
          onChanged: (newEmail) => bloc.changeEmail(newEmail.trim()),
        );
      },
    );
  }
}

class VerifyEmailAddressDialog extends StatelessWidget {
  const VerifyEmailAddressDialog({super.key});

  static Future<void> show(BuildContext context) async {
    final clickedContinue = await showDialog<bool>(
      context: context,
      builder: (context) => const VerifyEmailAddressDialog(),
      // We disallow dismissing the dialog by clicking outside of it
      // because we want to guide the user through the process of verifying
      // the new email address.
      barrierDismissible: false,
    );
    if (!context.mounted || clickedContinue != true) return;

    await _ReAuthenticationDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    return LeftAndRightAdaptiveDialog(
      title: context.l10n.changeEmailVerifyDialogTitle,
      content: Text.rich(
        TextSpan(
          text: context.l10n.changeEmailVerifyDialogBodyPrefix,
          children: [
            TextSpan(
              text: context.l10n.changeEmailVerifyDialogAfterWord,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: context.l10n.changeEmailVerifyDialogBodySuffix),
          ],
        ),
      ),
      left: AdaptiveDialogAction.cancel(context),
      right: AdaptiveDialogAction.continue_(context),
    );
  }
}

class _ReAuthenticationDialog extends StatelessWidget {
  const _ReAuthenticationDialog();

  static Future<void> show(BuildContext context) async {
    final clickedLogout = await showDialog<bool>(
      context: context,
      builder: (context) => const _ReAuthenticationDialog(),
      barrierDismissible: false,
    );

    if (!context.mounted || clickedLogout != true) return;

    await _reauthenticate(context);
  }

  static Future<void> _reauthenticate(BuildContext context) async {
    final bloc = BlocProvider.of<ChangeDataBloc>(context);
    await bloc.signOutAndSignInWithNewCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return LeftAndRightAdaptiveDialog(
      title: context.l10n.changeEmailReauthenticationDialogTitle,
      content: Text(context.l10n.changeEmailReauthenticationDialogBody),
      left: AdaptiveDialogAction.cancel(context),
      right: AdaptiveDialogAction.continue_(context),
    );
  }
}
