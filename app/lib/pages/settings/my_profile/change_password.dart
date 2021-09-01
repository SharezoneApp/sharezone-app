import 'package:flutter/material.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:sharezone/blocs/settings/change_data_bloc.dart';
import 'package:sharezone/pages/settings/my_profile/submit_method.dart';
import 'package:sharezone_common/api_errors.dart';
import 'package:sharezone/widgets/settings/my_profile/change_data.dart';
import 'package:sharezone_widgets/snackbars.dart';

const snackBarText = "Neues Password wird an die Zentrale geschickt...";
const changeType = ChangeType.password;

class ChangePasswordPage extends StatelessWidget {
  static const tag = "change-password-page";

  @override
  Widget build(BuildContext context) {
    final newPasswordNode = FocusNode();
    return Scaffold(
      appBar: AppBar(title: const Text("Passwort ändern"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ChangeDataPasswordField(
                  labelText: "Aktuelles Passwort",
                  autofocus: true,
                  onEditComplete: () =>
                      FocusScope.of(context).requestFocus(newPasswordNode)),
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
        onPressed: () async => submit(context, snackBarText, changeType),
        child: const Icon(Icons.check),
        tooltip: "Speichern",
      ),
    );
  }
}

class _NewPasswordField extends StatefulWidget {
  const _NewPasswordField({@required this.newPasswordNode});

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
          onEditingComplete: () async =>
              submit(context, snackBarText, changeType),
          autofocus: false,
          autofillHints: const [AutofillHints.newPassword],
          decoration: InputDecoration(
            labelText: 'Neues Passwort',
//            icon: new Icon(Icons.vpn_key),
            errorText: snapshot.error?.toString(),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
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
        child: const Text("Aktuelles Passwort vergessen?"),
        style: TextButton.styleFrom(
          primary: Colors.grey[400],
        ),
        onPressed: () async {
          bool reset = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Passwort zurücksetzen"),
                  content: const Text(
                      "Sollen wir dir eine E-Mail schicken, mit der du dein Passwort zurücksetzen kannst?"),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      child: const Text("ABBRECHEN"),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      child: const Text("JA"),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                );
              });
          if (reset != null && reset) {
            showSnack(
              context: context,
              text: "Verschicken der E-Mail wird vorbereitet...",
              withLoadingCircle: true,
              duration: Duration(minutes: 5),
            );

            String message;
            try {
              bloc.sendResetPasswordMail();
              message =
                  "Wir haben eine E-Mail zum Zurücksetzen deines Passworts verschickt.";
            } on Exception catch (e, s) {
              message = handleErrorMessage(e.toString(), s);
            } finally {
              showSnackSec(
                context: context,
                text: message,
              );
            }
          }
        },
      ),
    );
  }
}
