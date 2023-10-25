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
import 'package:sharezone/account/change_data_bloc.dart';
import 'package:sharezone/settings/src/subpages/my_profile/submit_method.dart';
import 'package:sharezone/widgets/settings/my_profile/change_data.dart';
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
                  currentEmail: currentEmail, passwordNode: passwordNode),
              const SizedBox(height: 8),
              ChangeDataPasswordField(
                  focusNode: passwordNode,
                  onEditComplete: () async =>
                      await submit(context, snackBarText, changeType)),
              const SizedBox(height: 16),
              const Text(
                "Hinweis: Wenn deine E-Mail geändert wurde, wirst du automatisch kurz ab- und sofort wieder angemeldet - also nicht wundern 😉",
                style: TextStyle(color: Colors.grey, fontSize: 11),
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
  const _WhyWeNeedTheEmail({Key? key}) : super(key: key);

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
  const _CurrentEmailField({Key? key, required this.currentEmail})
      : super(key: key);

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
    Key? key,
    required this.currentEmail,
    required this.passwordNode,
  }) : super(key: key);

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
          onEditingComplete: () =>
              FocusManager.instance.primaryFocus?.unfocus(),
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
