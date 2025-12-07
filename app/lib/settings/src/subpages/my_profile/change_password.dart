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
import 'package:sharezone/settings/src/subpages/my_profile/submit_method.dart';
import 'package:sharezone/settings/src/subpages/my_profile/change_data.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone_localizations/sharezone_localizations.dart';
import 'package:sharezone_widgets/sharezone_widgets.dart';

const changeType = ChangeType.password;

class ChangePasswordPage extends StatelessWidget {
  static const tag = "change-password-page";

  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final newPasswordNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.changePasswordTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ChangeDataPasswordField(
                labelText:
                    context.l10n.changePasswordCurrentPasswordTextfieldLabel,
                autofocus: true,
                onEditComplete:
                    () => FocusManager.instance.primaryFocus?.unfocus(),
              ),
              const SizedBox(height: 16),
              _NewPasswordField(newPasswordNode: newPasswordNode),
              const SizedBox(height: 16),
              _ResetPassword(),
            ],
          ),
        ),
      ),
      floatingActionButton: _ChangePasswordFAB(),
    );
  }
}

class _ChangePasswordFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FloatingActionButton(
        onPressed:
            () async => submit(
              context,
              context.l10n.changePasswordLoadingSnackbarText,
              changeType,
            ),
        tooltip: context.l10n.commonActionsSave,
        child: const Icon(Icons.check),
      ),
    );
  }
}

class _NewPasswordField extends StatefulWidget {
  const _NewPasswordField({required this.newPasswordNode});

  final FocusNode newPasswordNode;

  @override
  _NewPasswordFieldState createState() => _NewPasswordFieldState();
}

class _NewPasswordFieldState extends State<_NewPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangeDataBloc>(context);
    return StreamBuilder(
      stream: bloc.newPassword,
      builder: (context, snapshot) {
        return TextField(
          focusNode: widget.newPasswordNode,
          onChanged: bloc.changeNewPassword,
          onEditingComplete:
              () async => submit(
                context,
                context.l10n.changePasswordLoadingSnackbarText,
                changeType,
              ),
          autofocus: false,
          autofillHints: const [AutofillHints.newPassword],
          decoration: InputDecoration(
            labelText: context.l10n.changePasswordNewPasswordTextfieldLabel,
            //            icon: new Icon(Icons.vpn_key),
            errorText: snapshot.error?.toString(),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
            ),
          ),
          obscureText: _obscureText,
        );
      },
    );
  }
}

class _ResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangeDataBloc>(context);
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
        onPressed: () async {
          bool? reset = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  context.l10n.changePasswordResetCurrentPasswordDialogTitle,
                ),
                content: Text(
                  context.l10n.changePasswordResetCurrentPasswordDialogContent,
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(context.l10n.commonActionsCancel.toUpperCase()),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Text(context.l10n.commonActionsYes.toUpperCase()),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ],
              );
            },
          );
          if (!context.mounted) return;

          if (reset != null && reset) {
            showSnack(
              context: context,
              text: context.l10n.changePasswordResetCurrentPasswordLoading,
              withLoadingCircle: true,
              duration: const Duration(minutes: 5),
            );

            String? message;
            try {
              bloc.sendResetPasswordMail();
              message =
                  context
                      .l10n
                      .changePasswordResetCurrentPasswordEmailSentConfirmation;
            } on Exception catch (e, s) {
              message = handleErrorMessage(e.toString(), s);
            } finally {
              showSnackSec(context: context, text: message);
            }
          }
        },
        child: Text(context.l10n.changePasswordResetCurrentPasswordButton),
      ),
    );
  }
}
