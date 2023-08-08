// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'dart:developer';

import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sharezone/download_app_tip/widgets/download_app_tip_card.dart';
import 'package:sharezone/groups/src/widgets/contact_support.dart';
import 'package:sharezone/onboarding/sign_up/sign_up_page.dart';
import 'package:sharezone/util/flavor.dart';
import 'package:sharezone/widgets/apple_sign_in_button.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

import 'email_and_password_link_page.dart';
import 'login_button.dart';
import 'reset_pw_page.dart';
import 'sign_in_with_qr_code_page.dart';

Future<void> handleGoogleSignInSubmit(BuildContext context) async {
  final bloc = BlocProvider.of<LoginBloc>(context);
  try {
    await bloc.loginWithGoogle();
  } on Exception catch (e, s) {
    log("Couldn't sign in with Google: $e", error: e);
    showSnackSec(
      context: context,
      seconds: 4,
      text: handleErrorMessage(e.toString(), s),
    );
  }
}

Future<void> handleAppleSignInSubmit(BuildContext context) async {
  final bloc = BlocProvider.of<LoginBloc>(context);
  try {
    await bloc.loginWithApple();
  } on Exception catch (e, s) {
    log("Couldn't sign in with Apple: $e", error: e);
    showSnackSec(
      context: context,
      seconds: 4,
      text: handleErrorMessage(e.toString(), s),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
    this.withBackIcon = true,
    this.withQrCodeLogin = false,
    this.withRegistrationButton = false,
  }) : super(key: key);

  const LoginPage.desktop({Key key})
      : withBackIcon = false,
        withQrCodeLogin = true,
        withRegistrationButton = true,
        super(key: key);

  const LoginPage.mobile({Key key})
      : withBackIcon = true,
        withQrCodeLogin = false,
        withRegistrationButton = false,
        super(key: key);

  static const tag = "login-page";

  final bool withBackIcon;
  final bool withRegistrationButton;
  final bool withQrCodeLogin;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc bloc;
  bool isLoading = false;

  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    final analytics = LoginAnalytics(Analytics(getBackend()));
    bloc = LoginBloc(analytics);
    super.initState();
    showTipCardIfIsAvailable(context);
  }

  @override
  Widget build(BuildContext context) {
    final flavor = context.read<Flavor>();
    final showDebugLogins = kDebugMode && flavor == Flavor.dev;
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        body: Builder(
          builder: (context) => Stack(
            children: <Widget>[
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 20),
                          const _Logo(),
                          const SizedBox(height: 32),
                          _EmailPassword(
                            passwordFocusNode: passwordFocusNode,
                            onEditingComplete: () => handleLoginSubmit(context),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _ResetPasswordButton(),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: isLoading
                                    ? _LoadingCircle()
                                    : ContinueRoundButton(
                                        tooltip: 'Einloggen',
                                        onTap: () => handleLoginSubmit(context),
                                        key: const ValueKey('login-button-E2E'),
                                      ),
                              ),
                            ],
                          ),
                          _LoginWithAppleButton(
                            onLogin: () {
                              startLoading();
                              handleAppleSignInSubmit(context);
                            },
                          ),
                          _LoginWithGoogleButton(
                            onLogin: () {
                              startLoading();
                              handleGoogleSignInSubmit(context);
                            },
                          ),
                          _LoginWithQrCodeButton(),
                          const SizedBox(height: 12),
                          if (widget.withRegistrationButton)
                            _RegistrationSection(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.withBackIcon) BackIcon(),
              if (showDebugLogins) _DebugLoginButtons(),
            ],
          ),
        ),
        bottomNavigationBar: ContactSupport(),
      ),
    );
  }

  void startLoading() => setState(() => isLoading = true);

  Future<void> handleLoginSubmit(BuildContext context) async {
    startLoading();
    final bloc = BlocProvider.of<LoginBloc>(context);

    try {
      await bloc.submit();
    } on Exception catch (e, s) {
      setState(() => isLoading = false);
      showSnackSec(text: handleErrorMessage(e.toString(), s), context: context);
    }
  }
}

class _DebugLoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0.0,
      child: SafeArea(
        child: Row(
          children: [
            TextButton(
              onPressed: () => _loginStudent(context),
              child: const Text("Student"),
            ),
            TextButton(
              onPressed: () => _loginTeacher(context),
              child: const Text("Teacher"),
            ),
            TextButton(
              onPressed: () => _loginParent(context),
              child: const Text("Parent"),
            ),
          ],
        ),
      ),
    );
  }

  // Login funktionieren nur für das Debug-Firebase-Projekt
  void _loginStudent(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    bloc.changeEmail("student@sharezone.net");
    bloc.changePassword("12345678");
    bloc.submit();
  }

  // Login funktionieren nur für das Debug-Firebase-Projekt
  void _loginTeacher(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    bloc.changeEmail("teacher@sharezone.net");
    bloc.changePassword("12345678");
    bloc.submit();
  }

  // Login funktionieren nur für das Debug-Firebase-Projekt
  void _loginParent(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    bloc.changeEmail("parent@sharezone.net");
    bloc.changePassword("12345678");
    bloc.submit();
  }
}

class _EmailPassword extends StatelessWidget {
  const _EmailPassword({
    Key key,
    @required this.passwordFocusNode,
    @required this.onEditingComplete,
  }) : super(key: key);

  final FocusNode passwordFocusNode;
  final VoidCallback onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AutofillGroup(
        child: Column(
          children: <Widget>[
            EmailLoginField(
              passwordFocusNode: passwordFocusNode,
              emailStream: bloc.email,
              onChanged: bloc.changeEmail,
            ),
            const SizedBox(height: 12),
            _PasswordField(
              passwordFocusNode: passwordFocusNode,
              onEditingComplete: onEditingComplete,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCircle extends StatelessWidget {
  const _LoadingCircle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, top: 6, right: 2),
        child: LoadingCircle(),
      ),
    );
  }
}

class _RegistrationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Divider(),
        _SignWithOAuthButton(
          icon: Icon(
            Icons.add_circle,
            color: Theme.of(context).primaryColor,
            size: 25,
          ),
          text: 'Neues Konto erstellen',
          onTap: () => _openSignUpPage(context),
        ),
      ],
    );
  }

  void _openSignUpPage(BuildContext context) {
    Navigator.push(
      context,
      FadeRoute(
        child: SignUpPage(
          withBackButton: true,
          withLogin: false,
        ),
        tag: ChooseTypeOfUser.tag,
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key key,
    @required this.passwordFocusNode,
    @required this.onEditingComplete,
  }) : super(key: key);

  final FocusNode passwordFocusNode;
  final VoidCallback onEditingComplete;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return PasswordField(
      focusNode: passwordFocusNode,
      onChanged: bloc.changePassword,
      passwordStream: bloc.password,
      onEditingComplete: onEditingComplete,
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SharezoneLogo(
      height: 60,
      width: 200,
      logoColor: LogoColor.blueShort,
    );
  }
}

class EmailLoginField extends StatelessWidget {
  const EmailLoginField({
    Key key,
    @required this.emailStream,
    @required this.onChanged,
    this.passwordFocusNode,
    this.autofocus,
    this.emailFocusNode,
  }) : super(key: key);

  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final Stream<String> emailStream;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: emailStream,
      builder: (context, snapshot) {
        return TextField(
          key: const ValueKey('email-text-field-E2E'),
          focusNode: emailFocusNode,
          onChanged: (email) => onChanged(email.trim()),
          onEditingComplete: () =>
              FocusManager.instance.primaryFocus?.unfocus(),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofocus: autofocus ?? false,
          autofillHints: const [AutofillHints.email],
          decoration: InputDecoration(
            labelText: 'E-Mail',
            icon: const Icon(Icons.email),
            errorText: snapshot.error?.toString(),
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key key,
    @required this.focusNode,
    @required this.passwordStream,
    @required this.onChanged,
    @required this.onEditingComplete,
    this.isNewPassword = false,
  }) : super(key: key);

  final FocusNode focusNode;
  final Stream<String> passwordStream;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final bool isNewPassword;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.passwordStream,
      builder: (context, snapshot) {
        return Semantics(
          textField: true,
          label: 'Passwortfeld',
          enabled: true,
          child: TextField(
            key: const ValueKey('password-text-field-E2E'),
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            enableInteractiveSelection: true,
            autofillHints: [
              widget.isNewPassword
                  ? AutofillHints.newPassword
                  : AutofillHints.password
            ],
            decoration: InputDecoration(
              labelText: 'Passwort',
              icon: const Icon(Icons.vpn_key),
              errorText: snapshot.error?.toString(),
              border: const OutlineInputBorder(),
              suffixIcon: GestureDetector(
                onTap: () => setState(() => obscureText = !obscureText),
                child:
                    Icon(obscureText ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            obscureText: obscureText,
          ),
        );
      },
    );
  }
}

class _ResetPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return StreamBuilder<String>(
      stream: bloc.email,
      builder: (context, snapshot) {
        final email = snapshot.data;
        return TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(loginMail: email),
              settings: RouteSettings(name: ResetPasswordPage.tag),
            ),
          ),
          child: Text(
            'Passwort zurücksetzen',
            style: TextStyle(
              color: isDarkThemeEnabled(context) ? Colors.grey : Colors.black54,
            ),
          ),
        );
      },
    );
  }
}

class _LoginWithGoogleButton extends StatelessWidget {
  const _LoginWithGoogleButton({Key key, @required this.onLogin})
      : super(key: key);

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return _SignWithOAuthButton(
      icon: Image.asset(
        "assets/logo/google-favicon.png",
        width: 24,
        height: 24,
      ),
      text: "Über Google einloggen",
      onTap: onLogin,
    );
  }
}

class _LoginWithQrCodeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SignWithOAuthButton(
      icon: PlatformSvg.asset(
        "assets/icons/qr-code.svg",
        width: 24,
        height: 24,
        color: isDarkThemeEnabled(context) ? Colors.white : Colors.black,
      ),
      text: "Über einen Qr-Code einloggen",
      onTap: () => Navigator.pushNamed(context, SignInWithQrCodePage.tag),
    );
  }
}

class _LoginWithAppleButton extends StatelessWidget {
  const _LoginWithAppleButton({
    Key key,
    @required this.onLogin,
  }) : super(key: key);

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 32, 12, 0),
      child: SignInWithAppleButton(
        onPressed: onLogin,
        text: 'Mit Apple anmelden',
        height: 45,
        iconAlignment: IconAlignment.left,
      ),
    );
  }
}

class _SignWithOAuthButton extends StatelessWidget {
  const _SignWithOAuthButton({Key key, this.icon, this.text, this.onTap})
      : super(key: key);

  final Widget icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 10, 12, 0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 52,
        child: Semantics(
          button: true,
          label: text,
          onTap: onTap,
          child: CustomCard(
            onTap: onTap,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 12),
                icon,
                const SizedBox(width: 12),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                        color: isDarkThemeEnabled(context)
                            ? Colors.white
                            : Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
