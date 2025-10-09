// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/change_data_bloc.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_data.dart';
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
      appBar: AppBar(title: const Text("E-Mail ändern"), centerTitle: true),
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
      tooltip: "Speichern",
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
                focusNode: passwordNode,
                onEditComplete:
                    () async => await submit(context, snackBarText, changeType),
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
    return const InfoMessage(
      title: "Wozu brauchen wir deine E-Mail?",
      message:
          "Die E-Mail benötigst du um dich anzumelden. Solltest du zufällig mal dein Passwort vergessen haben, "
          "können wir dir an diese E-Mail-Adresse einen Link zum Zurücksetzen des Passworts schicken. Deine E-Mail Adresse "
          "ist nur für dich sichtbar, und sonst niemanden.",
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
      decoration: const InputDecoration(labelText: "Aktuell"),
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
            labelText: "Neu",
            errorText: snapshot.error?.toString(),
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
      builder: (context) => VerifyEmailAddressDialog(),
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
      title: "Neue E-Mail Adresse bestätigen",
      content: Text.rich(
        TextSpan(
          text:
              'Wir haben dir einen Link geschickt. Bitte klicke darauf, um deine E-Mail zu bestätigen. Prüfe auch deinen Spam-Ordner.\n\n',
          children: [
            TextSpan(
              text: "Nachdem",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text:
                  " du die neue E-Mail-Adresse bestätigt hast, klicke auf \"Weiter\".",
            ),
          ],
        ),
      ),
      left: AdaptiveDialogAction.cancel,
      right: AdaptiveDialogAction.continue_,
    );
  }
}

class _ReAuthenticationDialog extends StatelessWidget {
  const _ReAuthenticationDialog();

  static Future<void> show(BuildContext context) async {
    final clickedLogout = await showDialog<bool>(
      context: context,
      builder: (context) => _ReAuthenticationDialog(),
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
      title: "Re-Authentifizierung",
      content: const Text(
        '''Nach der Änderung der E-Mail-Adresse musst du abgemeldet und wieder angemeldet werden. Danach kannst du die App wie gewohnt weiter nutzen.

Klicke auf "Weiter" um eine Abmeldung und eine Anmeldung von Sharezone durchzuführen.

Es kann sein, dass die Anmeldung nicht funktioniert (z.B. weil die E-Mail-Adresse noch nicht bestätigt wurde). Führe in diesem Fall die Anmeldung selbständig durch.''',
      ),
      left: AdaptiveDialogAction.cancel,
      right: AdaptiveDialogAction.continue_,
    );
  }
}
