import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:sharezone/blocs/settings/change_data_bloc.dart';
import 'package:sharezone/util/launch_link.dart';
import 'package:sharezone_utils/platform.dart';

/// Soll unter den TextFeldern anzeigt werden, bei denen man seinen Namen, E-Mail Adresse, etc. ändern kann
/// Informatiert den Nutzer, wie wir mit seinen Daten umgehen.
/// [title] ist der Titel, wie z.B. "Wozu brauchen wir deinen Namen?"
/// [message] ist die Nachricht an den Nutzer, wie z.B. "Dein Namen brauchen wir für..."
class InfoMessage extends StatelessWidget {
  const InfoMessage({this.title, this.message, this.withPrivacyStatement});

  final String title;
  final String message;
  final bool withPrivacyStatement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 16.0),
        ),
        Text(
          message,
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 12.0),
        withPrivacyStatement != null && withPrivacyStatement
            ? privacyStatement(context)
            : Container(),
      ],
    );
  }

  Widget privacyStatement(BuildContext context) {
    return Text.rich(
      TextSpan(children: <TextSpan>[
        TextSpan(
            style: TextStyle(color: Colors.grey),
            text: "Mehr Informationen erhältst du in unserer "),
        TextSpan(
            text: "Datenschutzerklärung",
            style: TextStyle(color: Theme.of(context).primaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchURL("https://www.codingbrain.de/imprint#privacy-app");
              }),
        TextSpan(
          style: TextStyle(color: Colors.grey),
          text: ".",
        ),
      ]),
    );
  }
}

class ChangeDataPasswordField extends StatefulWidget {
  const ChangeDataPasswordField({
    @required this.onEditComplete,
    this.focusNode,
    this.labelText = "Passwort",
    this.autofocus = false,
  });

  final VoidCallback onEditComplete;
  final FocusNode focusNode;
  final String labelText;
  final bool autofocus;

  @override
  _ChangeDataPasswordFieldState createState() =>
      _ChangeDataPasswordFieldState();
}

class _ChangeDataPasswordFieldState extends State<ChangeDataPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ChangeDataBloc>(context);
    return StreamBuilder(
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          focusNode: widget.focusNode,
          onChanged: bloc.changePassword,
          onEditingComplete: () => widget.onEditComplete(),
          autofocus: widget.autofocus,
          // Autofill sollte im Web mit der Kombination eines StreamBuilders /
          // FutureBuilders nicht verwendet werden, weil es ansonsten zu
          // Problemen mit den TextFeldern kommt, wenn ein Error-Text angezeigt
          // wird.
          //
          // Ticket: https://github.com/flutter/flutter/issues/63596
          //
          // Sobald dieser Bug behoben ist, kann Autofill fürs Web wieder
          // verwendet werden.
          autofillHints: [if (!PlatformCheck.isWeb) AutofillHints.password],
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: snapshot.error?.toString(),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscureText = !_obscureText),
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
