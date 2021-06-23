import 'package:analytics/analytics.dart';
import 'package:authentification_base/authentification_analytics.dart';
import 'package:authentification_base/authentification_apple.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sharezone/account/use_account_on_multiple_devices_instruction.dart';
import 'package:sharezone/auth/email_and_password_link_page.dart';
import 'package:sharezone/blocs/application_bloc.dart';
import 'package:sharezone/util/navigation_service.dart';
import 'package:sharezone_widgets/adaptive_dialog.dart';
import 'package:sharezone_widgets/snackbars.dart';
import 'package:sharezone_widgets/theme.dart';
import 'package:user/user.dart';

import 'account_page_bloc.dart';

class RegistierAccountSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Column(
        children: <Widget>[
          const Divider(height: 32),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Du bist nur anonym angemeldet!",
                style: TextStyle(color: Colors.orange, fontSize: 18)),
          ),
          const SizedBox(height: 12),
          const Text(
            "Übertrage jetzt deinen Account auf ein richtiges Konto, um von folgenden Vorteilen zu profitieren:",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 12),
            leading: Icon(Icons.check, color: Color(0xFF41d876)),
            title: Text("Automatisches Backup"),
            subtitle: Text(
                "Weiterhin Zugriff auf die Daten bei Verlust des Smartphones"),
          ),
          const SizedBox(height: 6),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 12),
            leading: Icon(Icons.check, color: Color(0xFF41d876)),
            title: Text("Nutzung auf mehreren Geräten"),
            subtitle:
                Text("Daten werden zwischen mehreren Geräten synchronisiert"),
          ),
          const SizedBox(height: 16),
          _SignInMethods(),
          const SizedBox(height: 8),
          Text(
            "Melde dich jetzt an und übertrage deine Daten! Die Anmeldung ist aus datenschutzrechtlichen Gründen erst ab 16 Jahren erlaubt.",
            style: TextStyle(
                color: isDarkThemeEnabled(context)
                    ? Colors.grey
                    : Colors.grey[600],
                fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SignInMethods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future: AppleSignInLogic.isSignInGetCredentailsAvailable(),
      builder: (context, snapshot) {
        final isAppleSignInAvailable = snapshot.data ?? false;
        if (isAppleSignInAvailable) {
          if (width < 550)
            return Column(
              children: <Widget>[
                _AppleButton.long(),
                const SizedBox(height: 8),
                _GoogleButton.long(),
                const SizedBox(height: 8),
                _EmailButton.long(),
              ],
            );

          return Row(
            children: <Widget>[
              Expanded(child: _EmailButton.short()),
              const SizedBox(width: 8),
              Expanded(child: _AppleButton.short()),
              const SizedBox(width: 8),
              Expanded(child: _GoogleButton.short()),
            ],
          );
        }

        return Row(
          children: <Widget>[
            Expanded(child: _EmailButton.short()),
            const SizedBox(width: 8),
            Expanded(child: _GoogleButton.short()),
          ],
        );
      },
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton._(this.title, {Key key}) : super(key: key);
  factory _GoogleButton.short() => _GoogleButton._('Google');
  factory _GoogleButton.long() => _GoogleButton._('Mit Google anmelden');

  final String title;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AccountPageBloc>(context);
    return _SignUpButton(
      icon: Image.asset(
        "assets/logo/google-favicon.png",
        width: 24,
        height: 24,
      ),
      name: title,
      onTap: () async {
        final result = await bloc.linkWithGoogleAndHandleExceptions();
        if (result == LinkAction.credentialAlreadyInUse)
          showCredentialAlreadyInUseDialog(context);
      },
    );
  }
}

class _AppleButton extends StatelessWidget {
  const _AppleButton._(this.title, {Key key}) : super(key: key);
  factory _AppleButton.short() => _AppleButton._('Apple');
  factory _AppleButton.long() => _AppleButton._('Mit Apple anmelden');

  final String title;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AccountPageBloc>(context);
    return _SignUpButton(
      icon: Icon(FontAwesomeIcons.apple, color: Colors.grey[700]),
      name: title,
      onTap: () async {
        final result = await bloc.linkWithAppleAndHandleExceptions();
        if (result == LinkAction.credentialAlreadyInUse)
          showCredentialAlreadyInUseDialog(context);
      },
    );
  }
}

class _EmailButton extends StatelessWidget {
  const _EmailButton._(this.title, {Key key}) : super(key: key);
  factory _EmailButton.short() => _EmailButton._('E-Mail');
  factory _EmailButton.long() => _EmailButton._('Mit E-Mail anmelden');

  final String title;

  @override
  Widget build(BuildContext context) {
    final userGateway = BlocProvider.of<SharezoneContext>(context).api.user;
    return StreamBuilder<AppUser>(
      stream: userGateway.userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return _SignUpButton(
          icon: Icon(Icons.email, color: Colors.grey[700]),
          name: title,
          onTap: () async {
            if (user != null) {
              final confirmed = await pushWithDefault<bool>(
                context,
                EmailAndPasswordLinkPage(user: user),
                defaultValue: false,
                name: EmailAndPasswordLinkPage.tag,
              );
              if (confirmed) _showConfirmationSnackBar(context);
            }
          },
        );
      },
    );
  }

  void _showConfirmationSnackBar(BuildContext context) {
    showSnackSec(
      context: context,
      text: "Dein Account mit einer E-Mail Konto verknüpft.",
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key key, this.name, this.icon, this.onTap})
      : super(key: key);

  final String name;
  final Widget icon;
  final VoidCallback onTap;

  static final _borderRadius = BorderRadius.circular(7.5);

  @override
  Widget build(BuildContext context) {
    final color =
        isDarkThemeEnabled(context) ? Colors.grey[400] : Colors.grey[800];
    return InkWell(
      borderRadius: _borderRadius,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: _borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(fontSize: 16, color: color),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

Future<void> showCredentialAlreadyInUseDialog(BuildContext context) async {
  final showInstruction = await showLeftRightAdaptiveDialog<bool>(
      context: context,
      left: AdaptiveDialogAction<bool>(
        popResult: false,
        title: "Schließen",
      ),
      right: AdaptiveDialogAction<bool>(
        popResult: true,
        title: "Anleitung zeigen",
      ),
      title: "Diese E-Mail wird schon verwendet!",
      content: Text(
          "So wie es aussieht, hast du versehentlich einen zweiten Sharezone-Account erstellt. Lösche einfach diesen Account und melde dich mit deinem richtigen Account an.\n\nFür den Fall, dass du nicht genau weißt, wie das funktioniert, haben wir für dich eine Anleitung vorbereitet :)"));

  if (showInstruction != null && showInstruction) {
    final LinkProviderAnalytics _analytics =
        LinkProviderAnalytics(Analytics(getBackend()));
    _analytics.logShowedUseMultipleDevicesInstruction();
    Navigator.pushNamed(context, UseAccountOnMultipleDevicesIntruction.tag);
  }
}
