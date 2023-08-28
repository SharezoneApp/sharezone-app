// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:async';
import 'dart:developer';

import 'package:authentification_base/authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:sharezone_common/helper_functions.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'email_and_password_link_page.dart';
import 'login_button.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({
    Key? key,
    required this.loginMail,
  }) : super(key: key);

  static const String tag = "reset-password-page";
  final String? loginMail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _ResetPasswordPage(loginMail: loginMail),
          BackIcon(),
        ],
      ),
    );
  }
}

class _ResetPasswordPage extends StatefulWidget {
  const _ResetPasswordPage({
    Key? key,
    required this.loginMail,
  }) : super(key: key);

  static const String erfolg =
      "E-Mail zum Passwort zurücksetzen wurde gesendet. Wehe du vergisst dein Passwort nochmal ;)";
  static const String error =
      "E-Mail konnte nicht gesendet werden. Überprüfe deine eingegebene E-Mail-Adresse!";

  final String? loginMail;

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<_ResetPasswordPage> {
  late _ResetPasswordBloc bloc;
  final FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    bloc = _ResetPasswordBloc();
    if (isNotEmptyOrNull(widget.loginMail)) {
      bloc.changeEmail(widget.loginMail!);
    }

    delayKeyboard(
      context: context,
      focusNode: emailFocusNode,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: MaxWidthConstraintBox(
            maxWidth: 700,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  const _Logo(),
                  const SizedBox(height: 48),
                  _EmailField(
                    bloc: bloc,
                    focusNode: emailFocusNode,
                    label: widget.loginMail,
                  ),
                  const SizedBox(height: 12),
                  _SubmitButton(bloc: bloc),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SharezoneLogo(
      logoColor: LogoColor.blueShort,
      height: 50,
      width: 50,
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    Key? key,
    required this.bloc,
    required this.focusNode,
    required this.label,
  }) : super(key: key);

  final _ResetPasswordBloc bloc;
  final FocusNode focusNode;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: bloc.email,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: PrefilledTextField(
            prefilledText: label,
            focusNode: focusNode,
            autofocus: true,
            autofillHints: const [AutofillHints.email],
            keyboardType: TextInputType.emailAddress,
            onChanged: bloc.changeEmail,
            decoration: InputDecoration(
              labelText: "E-Mail Adresse deines Kontos",
              icon: const Icon(Icons.mail),
              errorText: snapshot.error?.toString(),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onEditingComplete: () async {
              final isValid = await bloc.submitValid.first;
              if (isValid) {
                bloc
                    .submit()
                    .then((_) => showSnack(
                        text: _ResetPasswordPage.erfolg,
                        duration: const Duration(seconds: 5),
                        context: context))
                    .catchError((e, StackTrace s) {
                  log('$e', error: e, stackTrace: s);
                  showSnack(
                      text: _ResetPasswordPage.error,
                      duration: const Duration(seconds: 5),
                      context: context);
                });
              }
            },
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  final _ResetPasswordBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: bloc.submitValid,
      builder: (context, snapshot) => Align(
        alignment: Alignment.centerRight,
        child: ContinueRoundButton(
          tooltip: 'Passwort zurücksetzen',
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            sendDataToFrankfurtSnackBar(context);
            snapshot.hasData && snapshot.data == true
                ? bloc
                    .submit()
                    .then((_) => showConfirmationDialog(context))
                    .catchError((e, StackTrace s) {
                    log('$e', error: e, stackTrace: s);
                    showSnack(
                        text: _ResetPasswordPage.error,
                        duration: const Duration(seconds: 5),
                        context: context);
                  })
                : log("Can't submit.");
          },
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    showLeftRightAdaptiveDialog(
      context: context,
      title: "E-Mail wurde verschickt",
      content: Text(_ResetPasswordPage.erfolg),
      left: AdaptiveDialogAction(
        isDefaultAction: true,
        title: 'Ok',
      ),
    );
  }
}

class _ResetPasswordBloc extends Object with AuthentificationValidators {
  final _emailSubject = BehaviorSubject<String>();

  Stream<String> get email => _emailSubject.stream.transform(validateEmail);

  Stream<bool> get submitValid => _emailSubject.valueOrNull != ""
      ? Stream.value(true)
      : Stream.value(false);

  Function(String) get changeEmail => _emailSubject.sink.add;

  Future<void> submit() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailSubject.valueOrNull!);
    return;
  }

  void dispose() {
    _emailSubject.close();
  }
}
