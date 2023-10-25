// Copyright (c) 2022 Sharezone UG (haftungsbeschränkt)
// Licensed under the EUPL-1.2-or-later.
//
// You may obtain a copy of the Licence at:
// https://joinup.ec.europa.eu/software/page/eupl
//
// SPDX-License-Identifier: EUPL-1.2

import 'package:authentification_base/authentification.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:sharezone/account/account_page_bloc.dart';
import 'package:sharezone/account/register_account_section.dart';
import 'package:sharezone/main/application_bloc.dart';
import 'package:sharezone/auth/email_and_password_link_bloc.dart';
import 'package:sharezone/account/profile/user_edit/user_edit_bloc.dart';
import 'package:sharezone/widgets/auth.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';
import 'package:user/user.dart';

import 'login_page.dart';

Future<void> handleEmailAndPasswordLinkSubmit(BuildContext context) async {
  sendLoginDataEncryptedSnackBar(context);

  final bloc = BlocProvider.of<EmailAndPasswordLinkBloc>(context);
  final result = await bloc.linkWithEmailAndPasswordAndHandleExceptions();
  if (result == LinkAction.finished && context.mounted) {
    // Hides the loading snackbar, see
    // https://github.com/SharezoneApp/sharezone-app/issues/814.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pop(context, true);
  } else if (result == LinkAction.credentialAlreadyInUse && context.mounted) {
    showCredentialAlreadyInUseDialog(context);
  }
}

TextStyle _hintTextStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).isDarkTheme
        ? Colors.grey
        : Colors.grey[600]!.withOpacity(0.75),
    fontSize: 11.5);

class EmailAndPasswordLinkPage extends StatefulWidget {
  const EmailAndPasswordLinkPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  static const tag = "email-and-password-link-page";
  final AppUser user;

  @override
  State createState() => _EmailAndPasswordLinkPageState();
}

class _EmailAndPasswordLinkPageState extends State<EmailAndPasswordLinkPage> {
  late EmailAndPasswordLinkBloc bloc;

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    final api = BlocProvider.of<SharezoneContext>(context).api;
    bloc = EmailAndPasswordLinkBloc(
      LinkProviderGateway(api.user),
      UserEditBlocGateway(api.user, widget.user),
      widget.user.name,
      scaffoldKey,
    );
    delayKeyboard(context: context, focusNode: emailFocusNode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SafeArea(
                  child: MaxWidthConstraintBox(
                    child: Column(
                      children: <Widget>[
                        const SharezoneLogo(
                          height: 60,
                          width: 200,
                          logoColor: LogoColor.blueLong,
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: <Widget>[
                              NameField(
                                focusNode: nameFocusNode,
                                onEditingComplete: () => FocusManager
                                    .instance.primaryFocus
                                    ?.unfocus(),
                                initialName: widget.user.name,
                                nameStream: bloc.name,
                                onChanged: bloc.changeName,
                              ),
                              const SizedBox(height: 16),
                              _EmailField(
                                focusNode: emailFocusNode,
                                nextFocusNode: passwordFocusNode,
                              ),
                              const SizedBox(height: 16),
                              _PasswordField(
                                  passwordFocusNode: passwordFocusNode),
                            ],
                          ),
                        ),
                        const SizedBox(height: 38),
                        _SubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const BackIcon(),
          ],
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key? key,
    required this.passwordFocusNode,
  }) : super(key: key);

  final FocusNode passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EmailAndPasswordLinkBloc>(context);
    return PasswordField(
      focusNode: passwordFocusNode,
      onChanged: bloc.changePassword,
      passwordStream: bloc.password,
      isNewPassword: true,
      onEditingComplete: () => handleEmailAndPasswordLinkSubmit(context),
    );
  }
}

class BackIcon extends StatelessWidget {
  const BackIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 5,
      left: 5,
      child: SafeArea(
        child: IconButton(
          color: Theme.of(context).isDarkTheme
              ? Colors.grey
              : darkBlueColor.withOpacity(0.4),
          icon: Icon(themeIconData(Icons.arrow_back,
              cupertinoIcon: Icons.arrow_back_ios)),
          tooltip: 'Zurück',
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class NameField extends StatelessWidget {
  const NameField({
    Key? key,
    required this.onEditingComplete,
    this.focusNode,
    this.initialName,
    required this.nameStream,
    required this.onChanged,
    this.withIcon = true,
    this.textInputAction = TextInputAction.next,
    this.autofocus = false,
    this.selectText = false,
  }) : super(key: key);

  final FocusNode? focusNode;
  final VoidCallback onEditingComplete;
  final String? initialName;
  final bool withIcon;
  final TextInputAction textInputAction;
  final bool autofocus;

  final Stream<String> nameStream;
  final ValueChanged<String> onChanged;

  /// If [selectText] is true, all characters in the TextField will be selected.
  /// Default value is false;
  final bool selectText;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: nameStream,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PrefilledTextField(
              prefilledText: initialName,
              onChanged: onChanged,
              autofocus: autofocus,
              onEditingComplete: onEditingComplete,
              textInputAction: textInputAction,
              autofillHints: const [AutofillHints.name],
              autoSelectAllCharactersOnFirstBuild: selectText,
              decoration: InputDecoration(
                labelText: 'Nickname',
                icon: withIcon ? const Icon(Icons.person) : null,
                errorText: snapshot.error?.toString(),
                border: const OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: withIcon ? 38 : 0),
              child: Text(
                "Dieser Nickname ist nur für deine Gruppenmitglieder sichtbar und sollte ein Pseudonym sein.",
                style: _hintTextStyle(context),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    Key? key,
    required this.focusNode,
    required this.nextFocusNode,
  }) : super(key: key);

  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<EmailAndPasswordLinkBloc>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        EmailLoginField(
          emailStream: bloc.email,
          onChanged: bloc.changeEmail,
          emailFocusNode: focusNode,
          passwordFocusNode: nextFocusNode,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 38),
          child: Text(
              "Die E-Mail ist für niemanden sichtbar und dient nur zur Anmeldung.",
              style: _hintTextStyle(context)),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SubmitButton(
      onPressed: () => handleEmailAndPasswordLinkSubmit(context),
      titel: "Verknüpfen",
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }
}
